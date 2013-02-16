#!/usr/bin/ruby 
require 'irb/completion'
require 'rubygems'
require 'wirble'

if ENV['OS'] == 'Windows_NT'
	require 'win32console'
end
Wirble.init
Wirble.colorize

