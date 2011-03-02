require 'optparse'
require 'date'
require 'rbgen/codegen'

module Rbgen
  class CLI
    NEWSCRIPT_USAGE = "Usage: #{File.basename $PROGRAM_NAME} [global-options] newscript [-h] scriptname[.rb]"
    USAGE = "Usage: #{File.basename($0)} [global-options] subcommand [args...]"
    def self.newscript(stdout, arguments)
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = NEWSCRIPT_USAGE
      end
      parser.parse!(arguments)
      filename = arguments[0]
      if filename.nil?
        $stderr.puts "error: Not enough arguments"
        $stderr.puts NEWSCRIPT_USAGE
        exit 1
      end
      if File.exists? filename
        $stderr.puts "error: The file #{filename} already exists."
        exit 2
      end
      options[:outfile] = File.open(filename, 'w')

      script = CodeGen.new(options[:outfile])
      script.puts "#! /usr/bin/env ruby"
      script.puts
      script.puts "=begin"
      script.puts "TODO: Short description of script here"
      script.puts "(c) #{Date.today.year}, Your Name   TODO: Substitute your name"
      script.puts
      script.puts "TODO: More detailed description of your script here"
      script.puts "=end"
      script.puts
      script.puts "require 'optparse'"
      script.puts
      script.puts "# Define mnemonics for exit codes."
      script.puts "EXIT_SUCCESS = 0"
      script.puts "# ..."
      script.puts
      script.puts "# TODO: Customise usage string"
      script.puts 'USAGE = "Usage: #{File.basename $PROGRAM_NAME} [options] args..."'
      script.puts
      script.puts "# Parse the arguments, and return the options Hash"
      script.block "def parse_args", :end => "end" do
        script.block "options = {", :end => "}" do
          script.puts "# TODO: Define your options' defaults here.  Example follows."
          script.puts "# :verbose => false"
        end
        script.block "parser = OptionParser.new do |opts|", :end => "end" do
          script.puts "opts.banner = USAGE"
          script.puts "# TODO: Define your options here.  Example follows."
          script.puts "# opts.on('-v', '--verbose') { options[:verbose] = true }"
        end
        script.puts "parser.parse!" 
        script.puts "# TODO: Validate and process ARGV into options hash"
        script.puts "return options"
      end
      script.puts
      script.puts "# The main program"
      script.block "def main", :end => "end" do
        script.puts "options = parse_args"
        script.puts "# TODO: Your code here"
        script.puts "exit EXIT_SUCCESS"
      end
      script.puts
      script.block "if $PROGRAM_NAME == __FILE__ then", :end => "end" do
        script.puts "main"
      end
      exit 0
    end

    def self.execute(stdout, arguments=[])

      # NOTE: the option -p/--path= is given as an example, and should be replaced in your application.

      options = {
        :path     => '~'
      }
      mandatory_options = %w(  )

      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          This application is wonderful because...

          #{USAGE}

          Subcommands are:
           newscript : Generate a new standalone script.
           ns        : Alias to newscript

          Options are:
        BANNER
        opts.separator ""
        #opts.on("-p", "--path PATH", String,
        #        "This is a sample message.",
        #        "For multiple lines, add more strings.",
        #        "Default: ~") { |arg| options[:path] = arg }
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; exit }
        opts.order!(arguments)

        if mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }
          stdout.puts opts; exit
        end
      end

      #path = options[:path]

      subcommand = arguments.shift
      case subcommand
        when 'newscript'
          newscript(stdout, arguments)
        when 'ns'
          newscript(stdout, arguments)
        else
          $stderr.puts "error: Invalid subcommand"
          puts USAGE
          exit 1
      end
    end
  end
end
