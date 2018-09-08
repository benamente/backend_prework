require 'active_support/inflector'
require 'rubygems'
require 'verbs'

#puts "man".pluralize

verb = :slow
arr = []
arr << Verbs::Conjugator.conjugate(verb, :aspect=> :progressive)
arr << Verbs::Conjugator.conjugate(verb, tense: :past, aspect: :perfective)
arr << Verbs::Conjugator.conjugate(verb, tense: :past)
arr << Verbs::Conjugator.conjugate(verb, :plurality => :singular)

arr.map  do |x|
  x.slice!("usually ")
  x.slice!("is ")
end
arr.reject!{ |x| x == verb.to_s}
p arr.uniq.compact

b = "dfsd"
