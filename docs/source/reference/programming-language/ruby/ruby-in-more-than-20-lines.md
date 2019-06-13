# Ruby in More Than 20 Lines

Heavily inspired by [Ruby in Twenty Minutes](https://www.ruby-lang.org/en/documentation/quickstart/)

```ruby
class Greeter
def initialize(name = "World")
     @name = name.capitalize
   end
   def say_hi
     puts "Hello #{@name}!"
   end
   def give_num
     puts "Give me #{Math.sqrt(9)} years"
   end
 end
g = Greeter.new
g.say_hi
Greeter.instance_methods
Greeter.instance_methods(false)
g.respond_to?("name")
g.respond_to?("to_S")

class Greeter
  attr_accessor :name # def 2 methods: `name` get, `name=` set
end
```

```ruby
#!/usr/bin/env ruby

class MegaGreeter
  attr_accessor :names

  # Create the object
  def initialize(names = "World")
    @names = names
  end

  # Say hi to everybody
  def say_hi
    if @names.nil?
      puts "You Are Nameless"
    elsif @names.respond_to?("each")
      # @names is a list of some kind, iterate!
      # between do…end is a block of code to run, like a lambda
      # |parameter|
      @names.each do |name|
        puts "Hello #{name}!"
      end
    else
      puts "Hello #{@names}!"
    end
  end

  # Say bye to everybody
  def say_bye
    if @names.nil?
      puts "No one exists"
    elsif @names.respond_to?("join")
      # Join the list elements with commas
      puts "Goodbye #{@names.join(", ")}.  Come back soon!"
    else
      puts "Goodbye #{@names}.  Come back soon!"
    end
  end
end

if __FILE__ == $0 # allow this file to be a library, not the main
  mg = MegaGreeter.new
  mg.say_hi
  mg.say_bye

  # Change name to be "Zeke"
  mg.names = "Zeke"
  mg.say_hi
  mg.say_bye

  # Change the name to an array of names
  mg.names = ["A", "B", "C",
              "D", "E"]
  mg.say_hi
  mg.say_bye

  # Change to nil
  mg.names = nil
  mg.say_hi
  mg.say_bye
end
```

## Different Outputting

`puts`

* `to_s`
* newline
* white space for `nil`
* prints array element line by line
* always return `nil`
* [doc](https://ruby-doc.org/core-2.6.3/IO.html#method-i-puts)

`print`

* `to_s`
* no newline
* prints nothing for `nil`
* prints array as a whole thing
* always return `nil`
* behavior are affected by variables
* [doc](https://ruby-doc.org/core-2.6.3/Kernel.html#method-i-print)

`p`

* `inspect`
* newline
* debugging
* [doc](https://ruby-doc.org/core-2.6.3/Kernel.html#method-i-p)
