module Jekyll
  module Commands
    class Draft < Command
      def self.init_with_program(prog)
        prog.command(:diary) do |c|
          c.syntax 'diary [options]'
          c.description 'Creates a new diary entry'

          options.each {|opt| c.option *opt }

          c.action do |args, options| 
             options['date'] = Time.now.strftime('%Y-%m-%d %H:%M')
             args << "'* * *'"
	     process args, options 
          end
        end
      end

      def self.options
        [
          ['extension', '-x EXTENSION', '--extension EXTENSION', 'Specify the file extension'],
          ['layout', '-l LAYOUT', '--layout LAYOUT', "Specify the diary layout"],
        ]
      end


      def self.process(args = [], options = {})
        params = DiaryArgParser.new args, options
        params.validate!

        diary = DiaryFileInfo.new params

        Compose::FileCreator.new(diary, false).create!
      end

      class DiaryArgParser < Compose::ArgParser
        def date
          options["date"].nil? ? Time.now.strftime('%Y-%m-%d %H:%M') : options["date"]
        end
      end


      class DiaryFileInfo < Compose::FileInfo
        def resource_type
          'diary'
        end

        def path
          "_diary/#{file_name}"
        end

        def file_name
          Time.now.strftime '%Y-%m-%d.md'
        end
      end
    end
  end
end
