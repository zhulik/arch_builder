# frozen_string_literal: true

require "English"
module Builder
  module Commands
    class Build
      class ExitStatusError < StandardError
        attr_reader :command, :status

        def initialize(command, status)
          super("exit status of '#{command}' is not 0: #{status}")
          @command = command
          @status = status
        end
      end

      def initialize(**options) = @options = options

      def run(argv)
        raise ArgumentError, "exactly one package name must be passed" if argv.count != 1

        name = argv.first
        pkg = Package.new(name, **@options.slice(:host, :token))

        CLI.logger.info("Checking if #{pkg.full_name} is already built...")
        return CLI.logger.info("#{pkg.full_name} is already built. Exiting...") if pkg.built?

        CLI.logger.info("#{pkg.full_name} is not yet built. Building...")

        build!(pkg)
      end

      private

      def build!(pkg)
        execute("pikaur -Sy --noconfirm")
        execute("pikaur -Swa aur/#{pkg.name} --noconfirm")
      end

      def execute(command)
        CLI.logger.info("Executing #{command}...")
        raise ExitStatusError(command, $CHILD_STATUS.exitstatus) unless system(command)
      end
    end
  end
end
