# frozen_string_literal: true

module Builder
  module Commands
    class Info
      def initialize(**options) = @options = options

      def run(argv)
        raise ArgumentError, "exactly one package name must be passed" if argv.count != 1

        name = argv.first
        pkg = Package.new(name, **@options.slice(:host, :token))
        puts(JSON.pretty_generate({
                                    name: name,
                                    version: pkg.version,
                                    built: pkg.built?,
                                    arch: pkg.arch,
                                    info: pkg.info
                                  }, pretty: true))
      end
    end
  end
end
