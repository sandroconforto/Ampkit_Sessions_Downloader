# Copyright (c) 2013, Sandro Conforto
# All rights reserved.

# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

# Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This Ruby script is useful if you are an Ampkit&trade; iOS user [http://agilepartners.com/apps/ampkit/](http://agilepartners.com/apps/ampkit/). 
# It automatically download all your recorded sessions to a <code>./sessions</code> subfolder. A separate "timestamped" download subfolder is created at each execution.

# I found it very useful with my musical work flow: record ideas on the iPad under Ampkit&trade;, use this script to download all the recordings, 
# import the best in my favourite DAW, edit them, render the result, send it to my band mates, and so on.

# Requirements
# Works on Mac Os X: tested with vanilla 1.8.7 Ruby, provided natively by Lion OS X&trade; as well as with (RVM provided) 1.9.3 Ruby, on Lion OS X&trade;. 
# Works on Windows: tested on a Microsoft Win7&trade; box using Ruby 1.9.3 [http://rubyinstaller.org/downloads/](http://rubyinstaller.org/downloads/).
# Works on Linux: tested on a Ubuntu 12.10 server: Ruby 1.9.3.

# Usage

# 	ruby download_ampkit_sessions.rb <url provided by ampkit when in "share mode">

# If no url is provided default ip (192.168.0.2) and port (3000) are used.

require 'rexml/document'
include REXML
require 'net/http'
require 'open-uri'


DEFAULT_PORT = '3000'
DEFAULT_IP = '192.168.0.2'

PROGRESS_CHUNK = 100  # Progress is shown only after each <PROGRESS_CHUNK> iterations

download_directory = 'sessions'
dry_directory = 'dry'
wet_directory = 'wet'

chars = %w{ | / - \\ }
i=0
file_size=nil

progress_lamda = lambda {|size| i=i+1; 
					if(i % PROGRESS_CHUNK == 0) 
						perc = file_size>0 ? (100*(size.to_f/file_size)).to_i : nil ; 
						perc_s = perc < 10 ? "0#{perc}" : perc.to_s ;  
						print "\b\b\b\b\b\b #{chars[0]} #{perc_s}%";  
						STDOUT.flush
						chars.push chars.shift;
					end 
 				 }

if(ARGV[0])
	input_url = ARGV[0]
else
    input_url = DEFAULT_IP
end


if(input_url.split('http://').length == 2)
	input_url = input_url.split('http://')[1]
end

address = input_url.split(':')
ip = address[0] 

if address.count == 2
	port = address[1] 
else
	port = DEFAULT_PORT
end 

url = "http://#{ip}:#{port}"

puts "============================================================="
puts "Getting Ampkit sessions from: #{url}"
puts "============================================================="

begin

	xml_data = Net::HTTP.get_response(URI.parse(url)).body
	doc = REXML::Document.new(xml_data)
	root = doc.root

rescue Exception => msg  
   puts "-----------------------------------------------------------------------------------------------------------------"		
   puts "Error: #{msg}"	
   puts "Unable to get data from url:#{url}: please check ip and port, and that ampkit server is running."
   puts "The process has terminated incorrectly"
   puts "-----------------------------------------------------------------------------------------------------------------"
   exit
end



title = root.elements["head/title"].first

if(title != 'AmpKit by Agile Partners')
	puts "AmpKit server not available at url #{url}: please correct url, or make sure server is running"
	exit
end

now = Time.now.strftime "%Y-%m-%d %H:%M:%S %z"

dir_name = now.split(' ')[0..1].join('_').gsub(':','_')

Dir.mkdir "./#{download_directory}" if ! File.directory? "./#{download_directory}"

Dir.mkdir "./#{download_directory}/#{dir_name}"
Dir.mkdir "./#{download_directory}/#{dir_name}/#{dry_directory}"
Dir.mkdir "./#{download_directory}/#{dir_name}/#{wet_directory}"

base_dir = Dir.pwd
base_dir = base_dir.gsub(/[\n\r]/,'')

if(root.elements["body/div/div"].length != 7)
	puts "User sessions not available: exiting"
	exit
end

# keeping a single instance of request, to be reused across iterations
req = Net::HTTP.new("#{ip}", port)

# user sessions
sessions = root.elements["body/div/div"][4].elements["table"]

sessions.each do |session|

	name = session.elements.first.first.first.to_s.gsub(" ", "_")

	puts "\nDownloading: " + name.to_s
	
	# extracting dry recording file name
	dry_href = session.elements[2].first.attributes['href']
	if(dry_href)
		dry_href_name = dry_href # used for downloading
		dry_file_name = name + "-" + dry_href.to_s.gsub('/','_').gsub(':','.') # used for saving to local file system
	end

	# extracting wet recording file names
	wet_href = session.elements[3].first.attributes['href']
	if(wet_href)
		wet_href_name = wet_href
		wet_file_name = name + "-" + wet_href.to_s.gsub('/','_').gsub(':','.')
	end

	dry_dir = "#{base_dir}/#{download_directory}/#{dir_name}/#{dry_directory}"		

	print "#{dry_dir}/#{dry_file_name}:"
	
	# getting file size from header
	file_size = req.request_head("#{dry_href_name}")['content-length'].to_i
	
	print '     '  # this spaces will be deleted in progress_lambda

	File.open("#{dry_dir}/#{dry_file_name}", "wb") do |saved_file|
	  	open("#{url}/#{dry_href_name}", 'rb', :progress_proc => progress_lamda ) do |read_file|
		    saved_file.write(read_file.read)
	  	end
	end
	STDOUT.flush
	print "\b\b\b\b\bsaved OK\n"
	STDOUT.flush

	wet_dir = "#{base_dir}/#{download_directory}/#{dir_name}/#{wet_directory}"

	print "#{wet_dir}/#{wet_file_name}:"
	
	file_size = req.request_head("#{wet_href_name}")['content-length'].to_i

	print '     '
	File.open("#{wet_dir}/#{wet_file_name}", "wb") do |saved_file|
	  	open("#{url}/#{wet_href_name}", 'rb', :progress_proc => progress_lamda ) do |read_file|
	    	saved_file.write(read_file.read)
	  	end
	end
	STDOUT.flush		
	print "\b\b\b\b\bsaved OK\n"		
	STDOUT.flush
end

puts "============================================================="
puts "The process has terminated correctly"
puts "============================================================="