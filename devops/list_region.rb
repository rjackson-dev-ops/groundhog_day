#!/usr/bin/env ruby

require 'aws-sdk'
require "highline/import"

selectedRegion = ''

loop do
  choose do |menu|
    Aws.partition('aws').regions.each do |region|
      menu.choice(region.description + " - " + region.name) {selectedRegion = region.name} if region.name.match('us')
    end
    menu.choice(:Quit, "Exit Program") {exit}
  end
puts "The region chosen is #{selectedRegion}"
end
