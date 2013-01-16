This Ruby script is useful if you are an Ampkit&trade; iOS user [http://agilepartners.com/apps/ampkit/](http://agilepartners.com/apps/ampkit/). 
It automatically download all your recorded sessions to a <code>./sessions</code> subfolder. A separate "timestamped" download subfolder is created at each execution.

I found it very useful with my musical work flow: record ideas on the iPad under Ampkit&trade;, use this script to download all the recordings, 
import the best in my favourite DAW, edit them, render the result, send it to my band mates, and so on.

### Requirements

Works on Mac Os X: tested with vanilla 1.8.7 Ruby, provided natively by Lion OS X&trade; as well as with (RVM provided) 1.9.3 Ruby, on Lion OS X&trade;. 

Works on Windows: tested on a Microsoft Win7&trade; box using Ruby 1.9.3 [http://rubyinstaller.org/downloads/](http://rubyinstaller.org/downloads/).

Works on Linux: tested on a Ubuntu 12.10 server: Ruby 1.9.3.

### Usage

	ruby download_ampkit_sessions.rb <url provided by ampkit when in "share mode">

If no url is provided default ip (192.168.0.2) and port (3000) are used.

### Notice

I am not in any ways associated with Agile Partners&trade;, Microsoft&trade; or Apple&trade;.

### License

Copyright (c) 2013, Sandro Conforto

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
