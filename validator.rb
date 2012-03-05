#!/usr/bin/env ruby -w

class SubtitlesValidator

  def self.call args
    sv = SubtitlesValidator.new
    sv.parse_args args
    sv.validate_subtitles
    sv.display_results
  end

  attr_reader :errors

  def parse_args args
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

  def validate_subtitles
    file_data = read_file
    subtitles = parse_data(file_data)
    validate(subtitles)
  end

  def display_results
    if @errors && !@errors.empty?
      @errors.map{|e| puts e}
    else
      puts "No errors found."
    end
    puts "Done."
  end

  def parse_data file_data
    lines_grouped = by_4(file_data)

    subtitles = {}
    lines_grouped.each do |lines|
      start, stop = lines[1].split(' --> ').map(&:strip)
      subtitle = lines[2]
      subtitles[lines[0]] = {:start => start, :stop => stop, :subtitle => subtitle}
    end
    subtitles
  end

  def validate subtitles
    previous_stop = "00:00:00,000" # smallest possible value
    @errors = []

    subtitles.each do |array|
      id = array[0]
      markers = array[1]
      if markers[:start] > markers[:stop]
        @errors << "subtitle ##{id} is invalid (start > stop)"
      end
      if previous_stop > markers[:start]
        @errors << "subtitle ##{id} is overlapping with the previous one."
      end
      previous_stop = markers[:stop]
    end
  end

  private

  def read_file
    File.open(@filename).read
  end

  def by_4 file_data
    lines = file_data.split("\n")
    while lines.size != 0 do
      (by_4_lines ||= []) << lines.slice!(0,4)
    end
    by_4_lines
  end

end

########################################################################

SubtitlesValidator.call ARGV if __FILE__ == $0
