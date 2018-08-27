## Day 5 Questions

1. What is a Hash, and how is it different from an Array in Ruby?  
A hash, like an array, is a collection of data. However, while an array is like
an ordered list, a hash is a series of key/value pairs. Arrays are indexed,
hashes aren't.  

1. In the space below, create a Hash stored to a variable named `pet_store`.  This hash should hold an inventory of items and the number of that item that you might find at a pet store.
```ruby
pet_store = {
  puppies: 112
  guppies: 241
  parrots: 6
}
```
1. given the following `states = {"CO" => "Colorado", "IA" => "Iowa", "OK" => "Oklahoma"}`, how would you access the value `"Iowa"`?  
`stats["IA"]`


1. With the same hash above, how would we get all the keys?  All the values?  
`states.keys` returns all the keys. `states.values` returns all the values.

1. What is another example of when we might use a hash?  In this case, why is a hash better than an array?
A dictionary. The words can be looked up with a something simple like `dictionary[word]` rather than `dictionary(dictionary.index(word))`.

1. What questions do you still have about hashes?
Since there's no map method, what's the easiest way to alter all the keys or all the values of a hash at once?
