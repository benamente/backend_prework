require ('pp')

class Book
  attr_reader :author, :title

  def initialize(author, title)
    @author = author
    @title = title
  end

  def ==(other)
    self.class === other and
      other.author == @author and
      other.title == @title
  end

  alias eql? ==

  def hash
    @author.hash ^ @title.hash # XOR
  end
end

book1 = Book.new 'matz', 'Ruby in a Nutshell'
book2 = Book.new 'matz', 'Ruby in a Nutshell'

reviews = {}

reviews[book1] = 'Great reference!'
reviews[book2] = 'Nice and compact!'

puts reviews.length #=> 1 ... Why?

pp reviews #=> {#<Book:0x007fb306832fc8 @author="matz", @title="Ruby in a Nutshell">=> "Nice and compact!"}

#now running without line 30:reviews[book2] = 'Nice and compact!'

#pp reviews now prints out: {#<Book:0x007ffcf202ef58 @author="matz", @title="Ruby in a Nutshell">=> "Great reference!"}

#Still confused. Why isn't reviews only containing one book at a time?
#It seems to have something to do with using the object as the key, because
#when I used a string as the key, it added both reviews. Is this a feature or a bug?

#Ah, I think I get it now. This is what they're trying to show with this code.
#The == function has been overridden such that though book1 and book2 are
#different objects with different hex values, as long as their author and
#title are the same, ruby treats them as different variable names each referring
#to the exact same object.

#Seems obvious in retrospect (as usual) but also satisfying to know what was
#going on and having been confused.
