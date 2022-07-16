#!/usr/bin/env ruby
# frozen_string_literal: true

require "English"
PIKAUR_CACHE_PATH = "/home/user/.cache/pikaur/pkg/"

ENV["MAKEFLAGS"] = "-j#{`nproc`.strip}"

PACKAGE = ARGV.first

raise "error" if PACKAGE.nil?

puts("Building #{PACKAGE}...")

exit($CHILD_STATUS.exitstatus) unless system("pikaur -Sy --noconfirm")

if system("pikaur -Swa #{PACKAGE} --noconfirm")
  puts("#{PACKAGE} is built.")
else
  exit($CHILD_STATUS.exitstatus)
end
