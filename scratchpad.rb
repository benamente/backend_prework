require 'active_support/inflector'
require 'rubygems'
require 'verbs'

#puts "man".pluralize

p Verbs::Conjugator.conjugate(:plan, :aspect=> :progressive)
