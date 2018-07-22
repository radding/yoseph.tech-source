---
layout: post
title: "Completely Useless Fun Project: Building A New Programming Language"
img: programming-languages.jpg # Add image post (optional)
date: 2017-11-03 08:40:08 
description: This week, I am doing something new. Something most people will shy away from. But not me! Why? Because I am a masochist. So what am I doing? I am going to start creating a completely new language. # Add post description (optional)
tag: ['programming', 'Arbor', 'New Language', 'Functional', 'web assembly', 'arbor', 'completely useless fun project']
---

Writing a new language is often seen as magical. New languages and tools pop up from time to time seemingly from the ether. But this isn't the case, languages have to come from somewhere. [Here is Eric Lippert](https://softwareengineering.stackexchange.com/a/84361){:target="_blank"}, a former principle developer on the C# compiler, talking about the response he gets when he tells people he designs languages.

Because of this mystique around languages and their tooling, most people think building a programming language as difficult. But it doesn't have to be this way.

And to prove it, I'm going to write a series that chronicles me developing this language which I will call **Arbor**. 

## Inspiration for Arbor
The primary motivation for me to build Arbor was Web Assembly. I am fascinated with Web Assembly and primarily wanted a way to play with it. So I decided to make a programming language months ago that specifically targets Web Assembly. 

{% include Caption.html url="https://upload.wikimedia.org/wikipedia/commons/3/30/WebAssembly_Logo.png" alt="*Web assembly logo*" description="*Web assembly logo*" %}

For those who  don't know, [Web Assembly or wasm](https://en.wikipedia.org/wiki/WebAssembly){:target="_blank"} is a specification that is still in its infancy. It aims to be, well, the assembly code for the web. It promises nearly native speeds for web app front ends. The code for Wasm is a kind of stripped down javascript, making it faster to parse and hopefully faster to execute. In fact, the original demo for web assembly was the unity demo game, Angry Bots that ran in Firefox and Chrome back in 2015. The game isn't like Crysis, but it is still impressive how well it ran. While I can't find that demo, here is a new demo on [webassembly.org](http://webassembly.org/demo/){:target="_blank"}

The primary point of Wasm was to enable C++ to be compiled for the web and have really big compute intensive processes running inside your browser. Today, Wasm really only supports C/C++ and Rust. Soon though, we will add Arbor to that list ;)

However, as I said, web assembly is in its infancy. According to [caniuse.com](https://caniuse.com/#search=webassembly){:target="_blank"}, only 65.34% of all browsers support wasm as of today, November 3rd, 2017 and Safari just got support back in September. But this isn't really a problem because webassembly can fall back to [asm.js](http://asmjs.org/){:target="_blank"} if need be. And either way, it seems the support for Wasm is growing, so that 65% number will only get larger. 

Anyway, aside from wanting to use Wasm, I didn't really have any other requirements. I knew I wanted it to be easy to use and read (who wants a language that is difficult to look at. I'm looking at you perl!)

{% include Caption.html url="http://www.zoitz.com/comics/perl_small.png" alt="*Seriously though, I used Perl once and my eyes bled for weeks afterwards*" description="*Seriously though, I used Perl once and my eyes bled for weeks afterwards*" %}

But then this week I had an idea. Why not make it a pure functional language? Functional languages are all the rage right now and they have some really cool concepts that I would like to implement, like no side effects or guaranteed no crashing (I'll admit, the second one is a bit ambitious). The only problem is I looked around and functional languages have particularly alien syntax. Coming from C like languages, most functional language's syntax was a little hard to read.

{% include Caption.html url="https://i.stack.imgur.com/U83Iz.png" alt="*Haskell code. It looks foreign and weird to someone who is familiar with  C like languages*" description="*Haskell Code. It looks foreign and weird to someone who is familiar with  C like languages*"%}

But then I saw [Elm](http://elm-lang.org/){:target="_blank"}. While not particularly beautiful to read, it wasn't actually that bad. So elm became my starting point. But even then, I wanted a language that someone without any Arbor experience can jump into and pick up without much difficulty. So I decided to take some things from Python, JavaScript and C/C++. 

## Design of Arbor (First Iteration)

### Typing and Assignment
The first thing I wanted was Python like Typing; basically dynamically, but strongly typed. This means an expression like this: `'x' + 1` is invalid and will throw an error, but these two statements are valid: `x = 1; x = 'dd';`. However, to maintain safety, I will also like optional parameter type checking. If you define a functions like so: `(a:int, b:string)` then you would expect a to always be an int and string to always be a string. 

The second thing I decided on was that everything must be assigned. In order to make the language simpler to implement, I did away with any special keywords to define a function. Unlike in Python, JavaScript, or C/C++ a function is inherently anonymous, unless assigned to a variable. The way to define a function would be: `() -> <function body>`. In order to keep that function around you would need to do something like: `foo = () -> <function body>`. Of course, this runs the risk of a programmer accidentally overwriting their function.

To make the language "safer", I decided that every variable had to be declared before you use it. This prevents a programmer,especially one with atrocious spelling like me, from accidentally declaring a variable because of a spelling error in one place. For right now, the only two keywords to define a variable is `let` and `const`. I decided on `const` because it is pretty self explanatory that the variable is constant. Plus C/C++ and Javascript use the `const` keyword, so I think it would be pretty easy for most developers to pick it up. 

The choice of `let` has really nothing to do  with javascript, all though maybe it does a bit. I choose the keyword `let` to more closely align with "math speak" (i.e `let x be a value in universe`). I also chose let because it corresponds to a [lambda abstraction](https://en.wikipedia.org/wiki/Let_expression#Definition){:target="_blank"} and [lambda calculus](https://en.wikipedia.org/wiki/Lambda_calculus){:target='_blank'} is really the foundation of all pure functional languages.

I'm still torn about providing type declarations, such as `int`, `float`, `char`, and `array` because I don't see them as completely necessary. It may be nice to have if for no other reason than it makes the language easier to read. At the same time however, since the type can be inferred from what you are assigning a variable to, and function definitions provide optional type checking, I don't know if this is absolutely necessary. I am leaning towards no, but If I do add support for type declarations, it will be with the `let` keyword, not instead of. 

### Functions Definitions
I also liked the [JavaScript arrow function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions){:target="_blank"} syntax (this is part of the reason why arbor has `->` to define functions), and especially the behaviour where a single line means return and a function body means do this whole function body. But at the same time I like Python's no curly brace syntax. So what I did was do something that a lot of other languages do: I defined an end statement. So in Arbor, you would define a function two ways: 

    let foo = (a, b, c) -> a + b + c;

or 

    let foo = (a, b, c) -> 
        return a + b + c;
    done;

Another thing I like about python is the way you can implement default parameters. In arbor it will be done similarly: 

    (a = 1, b = 2) -> a + b;

One thing that a lot of people complain about in Python, and this also trips up people coming from languages such as Java or C/C++, is that you can pass in any type into a function. This could cause issue where you expect a string, but instead receive an int, causing your application to crash. All though this is something you're unit tests should catch, I also wanted to "fix" this with compile time type checking. Plus I think this makes the language that much more descriptive in my mind. If you want type checking and defaults, I think it should look like this: 

    (a:int, b:int = 2) -> a + b;

Taking another principle from Python is packing and unpacking of variables in functions. Similarly to `function(...args)` in es6, python allows you to define lift over params as such: `def foo(a, *args)`. Arbor will do something similar: `foo = (a, b, *args) -> ...`. Then you can call this function like so: `foo(1, 2, 3, 4, 5, 6)`.
And like Python, I also want Arbor to support named leftover variables: `def foo(a, b, **kwargs)`, in arbor would be: `foo = (a, b **kwargs) -> ...`. Where `kwargs` is a dictionary. 

And finally variable unpacking. Python has this really neat concept called unpacking if you have a function definition like 

    def foo(a, b, c, d, e, f, g):
        pass

you can call that function like this: 

    arr = [1, 2, 3, 4, 5, 6, 7]
    foo(*arr)

    # or

    vals = {
        "a": 1,
        "b": 2,
        "c": 3,
        "d": 4,
        "e", 5,
        "f": 6,
        "g": 7 
    }
    foo(**arr)

With default parameters, any parameter not in the dict or array will be the default. I want Arbor to support this exactly the same way:

    foo = (a, b, c, d, e, f, g) -> null;
    arr  = [1, 2, 3, 4, 5, 6, 7];
    foo(*arr)

    // and

    dict = {
        a: 1,
        b: 2,
        c: 3,
        d: 4,
        e: 5,
        f: 6, 
        g: 6,
    }
    foo(**dict)

### Control and flow
In true functional programming fasion, I decided to do away with loops. Instead all loops should be implemented using recursion constructs. Additionally, built in functions such as `forEach`, `map`, `filter`, `fold` or `reduce` will be implemented in order to make implementing loop behaviour easier. 

Additionally, as well as having traditional control flow, `if`, `else`, `else if` statements, I will also have haskell like predicates. These could be similar enough to case statements in Elm. These would look like this:

    (a, b) -> 
        : a > b -> 
            if (a != b)
                return "greater than"
        : a < b -> "less than";
        : true -> "equal to";
    done;

This should be functionally equivalent to 

    (a, b) -> 
        if (a > b): 
            return "greater than";
        else if (a < b):
            return "less than";
        else: 
            return "equal to";
        done;
    done;

And finally, ternary operators. I really like ternary operators. They are elegant and makes code easier to read for small stuff. However, I think JavaScript's and C/C++'s ternary operator leaves something to be desired. I really like Python's ternary operator and that is exactly how ternaries in Arbor should work: `value if <condition> else other value`. 

### Data and Types
The only data types I want to include in Arbor are Integers, Floats, chars, Arrays, and Dictionaries. A string keyword will be available, but, like C/C++, it is really just an array of chars. Arbor will also provide `true` and `false` keywords that is really just 1 and 0 integers. Arbor should have a typedef operator that allows developers to define their own types. This would be similar to how C defines structs:

    Person = type {
        name: string,
        age: int,
        favorites: array
    }

This defines a type so that you can do things like 

    person = instantiate(Person);
    person.name = "yoseph";
    person.age = 22;
    person.favorites = ["programming", "Arbor"]

or 
    
    person = instantiate(Person, name="yoseph", age="22", favorites);

Functions are also first order citizens so that you can pass them as functions or in new types. Types can also refer to themselves, making the type composable and building complex structures like a tree.

## Tooling and the compiler

I haven't decide much on the tooling for Arbor. I know I will implement some standard function like `instantiate` or `new` (haven't decided to be honest), `forEach`, `map`, `reduce`, `filter`, and `resize`. But these may be just standard library stuff, I'm not sure if they will be built ins. 

The one big decision I made in regards to the compiler, and I know I'm going to get shit for this, is that I will implement it in Python initially. This is an experimental language and I only really care about the end result being amazing. I don't much care for the speed of the compiler. Perhaps in the future I will try to implement it in C/C++ or some other language, but not right now. 

The other reason I chose python for my compiler is that it is easy people to set up. Lex and Bison, which every other compiler how to post uses, are frankly a pain to set up, especially for beginners. The lexing and parsing library I use is called [ply](http://www.dabeaz.com/ply/){:target="_blank"} It is a great library that is easy to install (`pip install ply`) and easy to use. Take a look at their documentation and see how easy it is to use!

I really want to make building a programming language less scary. For this, I would need to make the compiler as accessible to beginners as possible, and of course Python is an extremely easy to read and easy to pick up language. 

Another big decision I made, and I will talk about this a bit next week, is that I am going to use an LLVM web assembly backend for actually compiling down into Wasm. This decision was made because LLVM is an incredibly optimized compiler. By only creating the frontend of the compiler, I only have to worry about optimizing the frontend output code, and letting LLVM handle the final optimizations. Additionally, this will also make Arbor easier to port to a new target, such as x86 or ARM. 

The last thing I am going to do is work on the run time. While web assembly is cool, it is still missing some things like the ability to manipulate the DOM. I would have to implement an Arbor to Javascript bridge in order to fully realize the power of Wasm. 

## The wrap up. 

This post really laid out the foundations of what I want Arbor to be. Of course, I don't expect all of the requirements that I laid out here to stay the same. I'm  sure behaviour and decisions will change. A lot of syntax changes with be implemented as I decide I like some other syntax better. And If anyone has any suggestions, I would love to hear it!

I'm sure it won't be easy, but I relish the challenge! Next week, I will talk about the parts of the Arbor compiler and maybe get into some actual code behind the compiler! A GitHub repo for all of the code will come shortly. 

**UPDATE November 6, 2017: As promised, [here is the GitHub repo for Arbor](https://github.com/radding/Arbor){:target="_blank"} 

