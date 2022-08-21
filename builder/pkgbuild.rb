# frozen_string_literal: true

module Builder
  class Pkgbuild
    ARCH_RE = /^arch=\((.+)\)$/

    attr_reader :content, :lines

    def initialize(content)
      @content = content
      @lines = content.split("\n")
    end

    def arch = @lines.map { ARCH_RE.match(_1.strip)&.[](1) }
                     .compact
                     .first
                     .split
                     .map{ _1.gsub("'", "") }
  end
end
