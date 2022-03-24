#!/usr/bin/env ruby

PIKAUR_CACHE_PATH = "/home/user/.cache/pikaur/pkg/"

ENV['MAKEFLAGS'] = "-j#{`nproc`.strip}"

PACKAGE = ARGV.first

raise "error" if PACKAGE.nil?

puts("Building #{PACKAGE}...")

if system("pikaur -Swa #{PACKAGE} --noconfirm")
  puts("#{PACKAGE} is built.")
else
  exit($?.exitstatus)
end
