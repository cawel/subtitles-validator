#!/usr/bin/env ruby -w

if ARGV.length != 1 
	$stderr.puts "Usage: validator.sh subtitles_file.srt"
	exit 1
end

if !File.exists?(ARGV[0])
	$stderr.puts "Could not find file \"#{ARGV[0]}\"."
	exit 2
end


puts "Starting..."

previous_stop = "00:00:00,000" # smallest possible value

File.open(ARGV[0]) do |file|
	while true do
		id, time, _, _ = file.gets, file.gets, file.gets, file.gets
		break if id.nil? # reached EOF

		start, stop = time.split(' --> ').map(&:strip)
		if start > stop
			puts "subtitle ##{id.strip} is invalid: #{time}"
		end

		if previous_stop > start
			puts "subtitle ##{id.strip} is overlapping with the previous one."
		end
		previous_stop = stop
	end
end

puts "Done."
