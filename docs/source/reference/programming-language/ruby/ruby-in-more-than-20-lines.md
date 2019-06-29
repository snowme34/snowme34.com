# Ruby in More Than 20 Lines

Heavily inspired by [Ruby in Twenty Minutes](https://www.ruby-lang.org/en/documentation/quickstart/)

## First 20 Minutes

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
    case
    when !@greeted
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
      greet
    else
      say_bye
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

  private
  def greet
    @greeted ||= true
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

## Arguments

* [calling_methods.rdoc Ruby 2.5.1](https://ruby-doc.org/core-2.5.1/doc/syntax/calling_methods_rdoc.html#label-Arguments), Ruby Doc about arguments
* [Mixing keyword with regular arguments in Ruby? - Stack Overflow](https://stackoverflow.com/questions/20633412/mixing-keyword-with-regular-arguments-in-ruby), has a pseudo-regex, very helpful
* [Ruby: Do not mix optional and keyword arguments](https://makandracards.com/makandra/36011-ruby-do-not-mix-optional-and-keyword-arguments), one edge case where Ruby fails to parse

```ruby
def func(a, b = "B", aa, *sp, c: "C", d:, **ksp, &callback)
end
```

## Long String Formatting

```ruby
p 'a string using '\
  'implicit concatenation'

p <<SOME_END.gsub(/\s+/," ").strip
a string using
HEREDOC syntax
priting another str: #{s}
SOME_END

p <<"SOME_END".gsub(/\s+/," ").strip
a string using
HEREDOC syntax
priting another str: #{s}
SOME_END

p <<`SOME_END`.gsub(/\s+/," ").strip
echo "a command using HEREDOC syntax"
SOME_END

p(<<"FIR", 123, <<"SEC")
This is the first str
FIR
This is the second str
SEC

p <<-SOME_INDENTED_END.gsub(/\s+/," ").strip
  this is
  indented
  SOME_INDENTED_END

p %{
SELECT * FROM     food
         GROUP BY food.type
}.gsub(/\s+/, " ").strip
```
