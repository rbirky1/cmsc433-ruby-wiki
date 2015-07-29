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
$topic = ARGV[0].dup #.gsub!(" ","_")

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
	$url = ARGV[3].dup
else
	$url = "http://en.wikipedia.org"
end

# Form URL with topic
$full_url = $url+"/wiki/"+$topic

# Open page and store contents
open($full_url) { |data| 
	$url_string = data.read
}

# Remove "not to be confused with" links
hatnote_regex = /<div class="hatnote">.*?<\/div>/m
$html_string = $url_string.gsub(hatnote_regex,"")

# Remove HTML and scripts
html_regex = /<head>.*?<\/head>|<script>.*?<\/script>|<noscript>.*?<\/noscript>/m
$text_string = $html_string.gsub(html_regex,"")

# Remove tags
tag_regex = /<[^<>]*?>/m
$text_string.gsub!(tag_regex,"")

# Replace multiple spaces with one
$text_string.gsub!(/\s{2,}/m," ")

# Remove STX
$text_string.gsub!(/\^B/,"")

# Get links from HTML content
links={}
link_regex = /<a href="\/wiki[^>]*?>/
$html_string.each_line { |line|
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
					if !links.has_key?(link)
						links[link] = 0
					end
				end
			end
		end
	}
}

# In degree in length of this hash
in_degree = links.length

# Out degree sound on special wiki page
out_degree_url = "#{$url}/wiki/Special:WhatLinksHere/#{$topic}?limit=5000"
puts out_degree_url
open(out_degree_url) { |data| 
	$out_degree_string = data.read
}
