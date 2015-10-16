module Jekyll
  module Commands
    class Draft < Command
      def self.init_with_program(prog)
        prog.command(:diary) do |c|
          c.syntax 'diary [options]'
          c.description 'Creates a new diary entry'

          options.each {|opt| c.option *opt }

          c.action { |args, options| process args, options }
        end
      end

      def self.options
        [
          ['extension', '-x EXTENSION', '--extension EXTENSION', 'Specify the file extension'],
          ['layout', '-l LAYOUT', '--layout LAYOUT', "Specify the draft layout"],
          ['force', '-f', '--force', 'Overwrite a draft if it already exists']
        ]
      end


      def self.process(args = [], options = {})
        params = Compose::ArgParser.new args, options
        params.validate!

        diary = DiaryFileInfo.new params

        Compose::FileCreator.new(diary, params.force?).create!
      end

      class DiaryFileInfo < Compose::FileInfo
        def resource_type
          'diary'
        end

        def path
          "_diary/#{file_name}"
        end
      end
    end
  end
end
