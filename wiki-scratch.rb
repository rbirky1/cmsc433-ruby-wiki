# # wiki-scratch.rb
# if RUBY_VERSION =~ /2.0/
#   Encoding.default_external = Encoding::UTF_8
#   Encoding.default_internal = Encoding::UTF_8
# end

# infile = File.open(ARGV[0], 'r')
# outfile = File.open("result.txt", 'w')

# regex = /<[^<>]*?>/m

# str=""
# infile.each_line { |line|
# 	str+=line
# }

# # Remove "not to be confused with" links
# hatnote_regex = /<div class="hatnote">.*?<\/div>/m
# str.gsub!(hatnote_regex,"")

# # Remove HTML and scripts
# html_regex = /<head>.*?<\/head>|<script>.*?<\/script>|<noscript>.*?<\/noscript>/m
# str.gsub!(html_regex,"")

# # Remove tags
# tag_regex = /<[^<>]*?>/m
# str.gsub!(tag_regex,"")

# # Replace multiple spaces with one
# str.gsub!(/\s{2,}/m," ")

# # Repalce STX character
# stx_regex =/\^B/
# #stx_regex = /\cB]/m
# #= /\cG/
# #/[[:cntrl:]]/
# #/\cB/#/\002/
# str.gsub!(stx_regex,"")

# #puts str
# outfile.write(str)

# url_string = '<table class="infobox vevent" style="float:right;clear:right;border-spacing:2px;font-size:90%;width:315px">
# <tr>
# <th class="summary" colspan="2" style="background-color:#B0C4DE;text-align:center;vertical-align:middle;font-size:110%">Byzantine civil war of 1341–1347</th>
# </tr>
# <tr>
# <td colspan="2" style="background-color:#DCDCDC;text-align:center;vertical-align:middle">Part of the <a href="/wiki/List_of_Byzantine_revolts_and_civil_wars" title="List of Byzantine revolts and civil wars">Byzantine civil wars</a>, the Byzantine–Serbian wars and the <a href="/wiki/Byzantine%E2%80%93Ottoman_Wars" title="Byzantine–Ottoman Wars">Byzantine–Turkish wars</a></td>
# </tr>
# <tr>
# <td colspan="2">
# <table style="width:100%;margin:0;padding:0;border:0">
# <tr>
# <th style="padding-right:1em">Date</th>
# <td>September 1341 – 8 February 1347</td>
# </tr>
# <tr>
# <th style="padding-right:1em">Location</th>
# <td><span class="location"><a href="/wiki/Thessaly" title="Thessaly">Thessaly</a>, <a href="/wiki/Macedonia_(region)" title="Macedonia (region)">Macedonia</a>, <a href="/wiki/Thrace" title="Thrace">Thrace</a>, and <a href="/wiki/Constantinople" title="Constantinople">Constantinople</a></span></td>
# </tr>
# <tr>
# <th style="padding-right:1em">Result</th>
# <td>John VI Kantakouzenos defeats regents, and is recognized as senior emperor</td>
# </tr>
# <tr>
# <th style="padding-right:1em">Territorial<br />
# changes</th>
# <td>Serbs gain Macedonia (except Thessalonica) and Albania, and soon after Epirus and Thessaly, establishing the <a href="/wiki/Special:Serbian_Empire" title="Serbian Empire">Serbian Empire</a>; Bulgarians gain parts of northern Thrace</td>
# </tr>
# </table>'
# # regex = /<a href="\/wiki[^>]*?>/
# # matches = str.scan(regex)

# # puts matches[0].class

# #link = '<a href="/wiki/The_Spirit_of_Christmas_(short_film)#Jesus_vs._Santa" title="The Spirit of Christmas (short film)">Jesus vs. Santa</a>'

# links={}
# link_regex = /<a href="\/wiki[^>]*?>/
# # Get links for HTML content (url_string)
# url_string.each_line { |line|
# 	matches = line.scan(link_regex)
# 	matches.each { |link|
# 		# Remove special links
# 		if link !~ /\/wiki\/(Book|Book_talk|Category|File|Forum|Help|Portal|Portal_talk|Special|Talk|Template|Thread|User|User_blog|User_talk|Wikipedia|Wikipedia_talk):/
# 			# Remove ?redirect=no links
# 			if link !~ /\?redirect=no/
# 				# Remove links without title="..."
# 				if link =~ /title=".*?"/
# 					# Remove any fragments
# 					if link =~ /(.*)#.*?(".*)/
# 						link = $1 + $2
# 					end
# 					links[link.to_sym] = 0
# 				end
# 			end
# 		end
# 	}
# }

# links.each {|k,v| puts "#{k} : #{v}" }
# puts "\t"*3 + "hi"

# class Page
# 	include Comparable
# 	attr_accessor :topic, :in_degree, :out_degree, :depth, :children
# 	def initialize(topic,in_degree,out_degree,depth,children)
# 		@topic = topic.to_s
# 		@in_degree = in_degree.to_s
# 		@out_degree = out_degree.to_s
# 		@depth = depth.to_i
# 		@children = children
# 	end
# 	def to_s
# 		"#@topic (#@in_degree/#@out_degree)"
# 	end
# 	def <=>(other)
# 		@topic <=> other.to_str
# 	end
# end

# this = [Page.new("hi",1,2,3,[1,2,3])]
# this2 = "hi"
# puts this.class

# that = "http://en.wikipedia.org"
# puts that.class

# puts this.include?(this2)


# def print(x, objects, printed)

# 	if x.class == String
# 		topic_regex = /title="(.*?)"/
# 		topic_regex.match(x.to_s.gsub!(" ","_"))
# 		this_topic = $1
# 	else
# 		this_topic = x.topic
# 	end

# 	if !objects.include?(this_topic) || printed.include?(this_topic)
# 		puts "END: "+ this_topic
# 	else
# 		puts x
# 		printed.push(this_topic)
# 		newX = objects.index(x)
# 		newX.children.each { |child|
# 			print(child, objects, printed)
# 		}
# 	end

# end

# def print(x, objects)
# 	if !objects.include?(x)
# 		topic_regex = /title="(.*?)"/
# 		topic_regex.match(item.to_s.gsub!(" ","_"))
# 		this_topic = $1
# 		puts this_topic
# 	else
# 		x.children.each { |child|
# 			new_obj = 
# 			print(child, objects)
# 		}
# 	end
# end

puts "\t"*1 + "hi"