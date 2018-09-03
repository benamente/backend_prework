require 'active_support/inflector'
require 'rubygems'
require 'verbs'

#puts "man".pluralize

p Verbs::Conjugator.conjugate(:be, :tense => :present, :person => :first, :plurality => :singular, :aspect=> :progressive)

puts !true
