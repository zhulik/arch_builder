#!/usr/bin/env ruby

PIKAUR_CACHE_PATH = "/home/user/.cache/pikaur/pkg/"

ENV['MAKEFLAGS'] = "-j#{`nproc`.strip}"

PACKAGE = ARGV.first

raise "error" if PACKAGE.nil?

puts("Building #{PACKAGE}...")

exit($?.exitstatus) unless system("pikaur -Sy --noconfirm")

if system("pikaur -Swa #{PACKAGE} --noconfirm")
  puts("#{PACKAGE} is built.")
else
  exit($?.exitstatus)
end
