# frozen_string_literal: true

module Builder
  module Commands
    class Check
      def initialize(**options) = @options = options

      def run(argv)
        raise ArgumentError, "Package names must be passed" if argv.empty?

        argv.each do |name|
          pkg = Package.new(name, **@options.slice(:host, :token))
          pp(pkg.built?)
        end
      end
    end
  end
end
