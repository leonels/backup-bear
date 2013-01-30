#! /usr/bin/env ruby

# Bring OptionParser into the namespace
require 'optparse'

options = {}
option_parser = OptionParser.new do |opts|

  executable_name = File.basename($PROGRAM_NAME)
  opts.banner = "Usage: #{executable_name} [options] database_name"

	# Create a switch
	opts.on("-i", "--iteration", 'Indicate that this backup is an "iteration" backup') do
		options[:iteration] = true
	end

	# Create a flag
	opts.on("-u USER", /^.+\..+$/, 'Database username, in first.last format') do |user|
		options[:user] = user
	end

	opts.on("-p PASSWORD", 'Database password') do |password|
		options[:password] = password
	end

end

option_parser.parse!
puts options.inspect

database = ARGV.shift
username = ARGV.shift
password = ARGV.shift
end_of_iter = ARGV.shift

if end_of_iter.nil?
  backup_file = database + Time.now.strftime("%Y%m%d")
else
  backup_file = database + end_of_iter
end

`mysqldump -u#{username} -p#{password} #{database} > #{backup_file}.sql`
`gzip #{backup_file}.sql`

