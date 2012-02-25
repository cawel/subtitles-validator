#!/usr/bin/env ruby -w

class SubtitlesValidator

	def self.call args
		puts "Starting..."
		sv = SubtitlesValidator.new args
		sv.read_file
		sv.group_by_4
		sv.does
		puts "Done."
	end

	def initialize args

		if args.length != 1 
			$stderr.puts "Usage: validator.sh subtitles_file.srt"
			exit 1
		end

		if !File.exists?(args[0])
			$stderr.puts "Could not find file \"#{args[0]}\"."
			exit 2
		end

		@filename = args[0]
	end

	def read_file
		@file_data = File.open(@filename).read
	end

	def group_by_4
		# @file_data.split("\n").
	end

	def does
		previous_stop = "00:00:00,000" # smallest possible value

		File.open(@filename) do |file|
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
	end

end

SubtitlesValidator.call ARGV
