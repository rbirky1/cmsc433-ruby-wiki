#!/usr/bin/env ruby

# Name: 		wiki.rb
# Author: 		Rachael Birky
# Description:  This is a webcrawler that find relationships
# 					between arbitrary topics on Wikipedia

require 'open-uri'
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Script usage message
$usage = "Usage: <topic> <distance> <branching-factor> [wiki URL]\n\ttopic — the topic of the starting wiki page\n\tdistance — how many times links should be expanded\n\tbranching-factor — the number of links to expand per page\n\twiki URL — an optional argument specifying the URL to a wiki site\n"

# Check number of parameters
if ! (ARGV.length == 3 || ARGV.length == 4)
	STDERR.puts "Error! Illegal number of parameters\n"+$usage
	exit 1
end

# Store topic
topic = ARGV[0].dup #.gsub!(" ","_")

# Check that distance and branching factor are positive integers
if !(ARGV[1] =~ /\A[^-]\d*\Z/ && ARGV[2] =~ /\A[^-]\d*\Z/)
	STDERR.puts "Error! Distance and branching factor must be a positive integer\n"+$usage
	exit 1
else
	$distance = ARGV[1].dup
	$branching = ARGV[2].dup
end

# If given, set the URl; otherwise, default to wikipedia
if ARGV.length == 4
	base_url = ARGV[3].dup
else
	base_url = "http://en.wikipedia.org"
end

def get_html_contents(url)
	url_string=""
	# Open page and store contents
	open(url) { |data| 
		url_string = data.read
	}

	# Remove "not to be confused with" links
	hatnote_regex = /<div class="hatnote">.*?<\/div>/m
	html_string = url_string.gsub(hatnote_regex,"")

	return html_string
end

def get_text_contents(html_string)
	# Remove HTML and scripts
	html_regex = /<head>.*?<\/head>|<script>.*?<\/script>|<noscript>.*?<\/noscript>/m
	text_string = html_string.gsub(html_regex,"")

	# Remove tags
	tag_regex = /<[^<>]*?>/m
	text_string.gsub!(tag_regex,"")

	# Replace multiple spaces with one
	text_string.gsub!(/\s{2,}/m," ")

	# Remove STX
	text_string.gsub!(/\^B/,"")

	return text_string
end

def filter_links(html_string)
	hash = {}
	# Get links from HTML content
	link_regex = /<a href="\/wiki[^>]*?>/
	html_string.each_line { |line|
		matches = line.scan(link_regex)
		matches.each { |link|
			# Remove special links
			if link !~ /\/wiki\/(Book|Book_talk|Category|File|Forum|Help|Portal|Portal_talk|Special|Talk|Template|Thread|User|User_blog|User_talk|Wikipedia|Wikipedia_talk):/
				# Remove ?redirect=no links
				if link !~ /\?redirect=no/
					# Remove links without title="..."
					if link =~ /title=".*?"/
						# Remove any fragments
						if link =~ /(.*)#.*?(".*)/
							link = $1 + $2
						end
						link = link.to_sym
						if !hash.has_key?(link)
							hash[link] = 0
						end
					end
				end
			end
		}
	}
	return hash
end


def sort_links(linksHash, textToSearch)
	title_regex = /title="(.*?)"/
	linksHash.each { |k,v|
		title = title_regex.match(k.to_s)
		title = $1
		
		textToSearch.each_line { |line|
			if line.include?(title)
				linksHash[k] += 1
			end
		}
	}
	return Hash[linksHash.sort_by { |k,v| v }.reverse].keys
end

def get_out_degree(url, topic)
	out_degree_url = "#{url}/wiki/Special:WhatLinksHere/#{topic}?limit=5000"
	out_degree_string=""
	open(out_degree_url) { |data| 
		out_degree_string = data.read
	}

	list_regex = /<ul id="mw-whatlinkshere-list">.*?<\/ul>View/m
	out_degree_string = list_regex.match(out_degree_string).to_s
	out_links = filter_links(out_degree_string)
	return out_links.length
end

class page
	def initialize(topic,in_degree,out_degree,depth)
		@topic = topic
		@in_degree = in_degree
		@out_degree = out_degree
		@depth = depth
	end
end

# Form URL with topic
puts "Expanding #{topic}"
full_url = base_url+"/wiki/"+topic
html = get_html_contents(full_url)
text = get_text_contents(html)
links = filter_links(html)
links = sort_links(links, text)
# In degree in length of this hash
in_degree = links.length
out_degree = get_out_degree(base_url, topic)
puts in_degree
puts out_degree

# TODO depth first search ):
puts links
# depth first seach...expand (branching factor) number of links each time
# numer of times = distance

# TODO: print what I'm expanding, then graph with in/out degrees etc