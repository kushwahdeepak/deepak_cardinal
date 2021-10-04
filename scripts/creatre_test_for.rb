#!/usr/bin/ruby

path = ARGV[0]
test_path = path.gsub('/app/', '/spec/').gsub('.rb','_spec.rb')
fname = test_path.split('/').last
dirname = test_path.gsub(fname, '')
`mkdir -p #{dirname}`
`touch #{test_path}`
puts test_path





