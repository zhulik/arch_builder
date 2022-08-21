# frozen_string_literal: true

module Builder
  class Package
    include HTTP
    extend Forwardable

    PACKAGE_EXTENSION = ".pkg.tar.zst"

    AUR_INFO_URL = "https://aur.archlinux.org/rpc/?v=5&type=info&arg[]="
    AUR_PKGBUILD_URL = "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h="

    class NotFoundError < StandardError; end

    attr_reader :name

    def initialize(name, host:, token:)
      @name = name
      @host = host
      @token = token
    end

    def_delegator :pkgbuild, :arch

    def pkgbuild = @pkgbuild ||= Pkgbuild.new(http_get(AUR_PKGBUILD_URL + @name))

    def filenames = @filenames ||= arch.map { "#{full_name}-#{_1}#{PACKAGE_EXTENSION}" }

    def full_name = "#{@name}-#{version}"

    def version = info[:Version]

    def built? = exists_urls.any? { http_head(_1).status == 200 }

    def info
      @info ||= begin
        response = http_json_get(AUR_INFO_URL + @name)

        raise NotFoundError, "package #{@name} is not found in AUR" if (response[:resultcount]).zero?

        response.dig(:results, 0)
      end
    end

    private

    def exists_urls
      filenames.map do |name|
        URI::HTTPS.build(host: @host, path: "/files/#{name}", query: URI.encode_www_form(token: @token))
      end
    end
  end
end
