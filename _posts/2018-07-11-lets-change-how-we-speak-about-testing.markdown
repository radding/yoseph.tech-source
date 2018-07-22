---
layout: post
title: "From Test Driven Development to Test Driven Design"
img: tdd.jpeg # Add image post (optional)
date: 2018-07-11 18:46:44 
description: Too often when we speak about Test Driven Development, or TDD, we speak about it as if it’s an investment. I think it's time to change the conversation and talk about TDD as if it is an essential engineering step. # Add post description (optional)
tag: ['tdd', 'test driven development', 'ci/cd', 'continuous deployment', 'software design', 'continuous integration', 'engineering', 'software engineering']
---

[Test Driven Development](https://www.agilealliance.org/glossary/tdd/#q=~(filters~(postType~(~'page~'post~'aa_book~'aa_event_session~'aa_experience_report~'aa_glossary~'aa_research_paper~'aa_video)~tags~(~'tdd))~searchTerm~'~sort~false~sortDirection~'asc~page~1)){:target="__blank"} is something that I have been thinking a lot about lately. Well, I haven't really been thinking about test driven development itself, but rather about why is it that so many developers acknowledge that writing tests is something that will benefit them in the long term, but so few actually write tests. Or if they do write unit tests, they aren't very good. And how can we as developers improve how we do testing?

In order to improve how Test Driven Development is done, we need to change how we talk about doing TDD. 

## How we currently talk about TDD

All too often, TDD and investment appear in the same sentence, if not the same sentiment. I'm guilty of this, and so is almost every other developer I know. If you are a developer who is working on a side project, or have a hard business deadline coming up, what incentive do you have to focus on long term benefits. Those benefits have to be pretty large for you to want to devote time to work towards those benefits. And let’s be honest, testing doesn't really provide that big of a benefit long term, because if the benefits did outweigh the costs in time and energy, we would all be writing tests.

{%include Caption.html url="https://imgs.xkcd.com/comics/automation.png" alt="*As always, there is a relevant XKCD*" description="*As always, there is a relevant XKCD*"%}

And therein lies the problem, we talk about TDD as if it is an investment to ensure that our code works after we make changes, but testing offers much more than that. Testing allows you to explore your code design as much, if not more, as it protects your code against bugs and regressions. 

## Test Driven **Design** _Not_ Test Driven **Development**

The idea that TDD should be done as a design principle is nothing new. [This article](https://www.agilealliance.org/glossary/tdd/#q=~(filters~(postType~(~'page~'post~'aa_book~'aa_event_session~'aa_experience_report~'aa_glossary~'aa_research_paper~'aa_video)~tags~(~'tdd))~searchTerm~'~sort~false~sortDirection~'asc~page~1)){:target="__blank"}), mentioned Design as a benefit to TDD. [Here is a Dr. Dobbs article describing TDD as Test Driven _Design_ rather than Test Driven _Development_.](http://www.drdobbs.com/architecture-and-design/test-driven-design/240168102). This conversations already exists, yet the software engineering community _still_ emphasizes TDD's ability for you to comfortably make changes rather than its use as a design step. So why should the focus be on Test Driven Design, and not Test Driven Development?


## Why Design is important

There is an old adage that code is [read more than it is written](https://danieljscheufler.wordpress.com/2016/12/27/code-is-read-more-often-than-it-is-written/){:target="__blank"}. This proverb could be seen in Python's design philosophy; the first sentence in the eighth PEP (of which there are hundreds) is literally ["code is read much more often than it is written."](https://www.python.org/dev/peps/pep-0008/#a-foolish-consistency-is-the-hobgoblin-of-little-minds_{:target="__blank"}) This is one of the reasons we use design patterns: they improve readability. They allow us to organize our code in a coherent and organized fashion for other developers to understand.

{%include Caption.html url="https://i.kym-cdn.com/photos/images/newsfeed/000/548/129/538.jpg" alt="*When you look at unorganized code*" description="*When you look at unorganized code*"%}
{%include Caption.html url="https://qph.fs.quoracdn.net/main-qimg-ff68a5a9d71c3eea9ae4f9e8fed469d1" alt="*Another relevant XKCD*" description="*Another relevant XKCD*"%}

Aside from making code readable, designing our code also allows us to make our code easy to change with minimal side effects, heuristics to write code faster ("I'll just drop an observer pattern here, a strategy pattern there, and a visitor pattern here"), comfort, and make our code extensible. These are all great qualities to have in our code, but what does this have to do with TDD?

## How Testing relates to Design

Thinking about design first enables us to write good, well structured code. Thinking about testing affords us the opportunity to think about our code’s design before we actually go in and implement it. It gives us the opportunity to think about how our code would be used in a real life scenario, how our code could be extended in the future, and how our code will behave in the wild. All of this is extremely important when you are considering the architecture, design and behaviour of your code. 

On of the tenants of testing, at least on of my tenants, is that your tests should mirror how your code will be used and called in production. If you don’t treat tests as basically a client calling your code, you are not testing how that code behaves when it is actually being used. By thinking about how you would like to _test_ your code, it allows you think about how you would like to _use_ it before you implement. This allows software engineers to think about the modules they would need to implement, were that responsibility lies and who should implement what. Every developer should strive to make the most usable application possible, the unit of code that they write is no different.

Another crucial piece of thinking about how your code will be used, is also thinking about how your code will be extended. Testing is a great test of whether your code is extensible. Instead of modifying your code to operate in a test environment, you should be able to add that behaviour in the test environment. The only modifications to your code should be to match the current behaviour that your tests are, well, testing. Think about what and how test behaviour should be _injected_ into your code makes it clear what points of your code may need to be extensible and gives you a good blueprint an how that code can be extended.

And finally, _what_ your code implements, aka the behaviour of the system, is an important aspect of programming in general. Thinking of what behaviour you are testing really just reaffirms and helps you plan your code before it is actually written in stone. 

Some of my astute readers will recognize this as the underpinnings of the [SOLID Principles](https://stackify.com/solid-design-principles/){:taget=”__blank”}.

## A Word of Warning

Firstly, I am not advocating **Test First Development**, something that often gets confused with Test Driven Development. I am not saying that you necessarily write your tests firsts. I am saying that keep testing in mind when you write your code. 

Personally, the way I work is I usually just write out what I would like my code to look like, then I write my tests, and finally I fill in the implementation of the code, usually. This allows me to see how the code will look and how it will feel when I will inevitably use it in the future, before too much code is written and it becomes too smelly. If I don’t do that, I will implement a tiny bit of code and then write the tests. This allows me to get my thoughts down on how a certain piece of software will behave before I forget, and still test the look and feel before I implement too much. 

But the most important warning I can give is don't be dogmatic. There are situations where this doesn't work. Or you feel that it will make your code more complicated. It is important to be able to recognize when and where tests fail you personally and where you should skip tests. Finding the nuances in software engineering is what engineers do. 

## The Wrap Up. 

It is time that we start talking more about testing, its effects on software design, and how thinking about tests first could improve overall software design. We need to stop treating TDD as a task and start talking about it as an approach to software engineering. We need to stop writing tests for the sake of writing tests and start using tests as a way to write down and try out our thoughts before we forget about them or before it becomes too hard to change. If we are writing tests to simply make them pass at any cost, much of the value of tests diminishes and there is less of a focus on writing _SOLID_, maintainable code, causing more shitty code that somebody (probably you) will have to maintain. 

It took sometime to figure this out for myself since I was so focused on the other benefits of TDD. Every conversation about TDD was about how it delivers confidence when you refactor, gives you a working contract that you can use to reimplement behavior, catch bugs before they are released, etc. But no conversations were really about Test Driven **Design**. And while all of those benefits are not small, they give of the feeling as not really delivering immediate value to the programmers. By talking about how we can design our code to better facilitate testing, software will be better designed and the immediate value of testing will be realized. And hopefully testing will become more prevalent. 

