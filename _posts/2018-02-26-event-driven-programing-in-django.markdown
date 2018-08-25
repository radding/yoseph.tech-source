---
layout: post
title: "Event Driven Programing In Django"
img: events-icon.gif # Add image post (optional)
date: 2018-02-26 08:53:41 
description: Event driven programming is an extremely powerful paradigm that allows you to perform some action because something else happened (the event). Django already has a rudimentary event system in its core, but it left things to be desired. Learn more about event driven programming in django and the inspiration behind django-event-system # Add post description (optional)
tag: ['event,', 'event', 'driven,', 'django,', 'django-event-system']
---

I have been doing a lot of professional work in [laravel](https://laravel.com/){:target="__blank"} recently for [SPLT](http://splt.io/){:target="__blank"}, but recently I went back to django for a project I am currently working on in my spare time. I love django, but there are some great things that laravel has that Django doesn't, like supporting the [observer pattern](https://en.wikipedia.org/wiki/Observer_pattern){:target='__blank'} on models.

That Observer pattern is what inspired me to implement a string based event system in django. 

## The Problem
Have you ever wanted to perform some action when something else happens? For example, when you create a new user you usually want to send them a "verify your email" email? That is really what the observer pattern is about; you tell some object (the subject) about these other objects (the observers) and then when something happens to the subject, it will call some method on the observers. 

{% include Caption.html url="/assets/img/observers.png" alt="*Observers are basically like shouting from the roof tops; One object shouts and the observers will do whatever it needs to do*" description="*Observers are basically like shouting from the roof tops; One object shouts and the observers will do whatever it needs to do*" %}

Laravel has great support for [model observers](https://laravel.com/docs/5.6/eloquent#observers){:target='__blank'}; you need to simply create an observer class that implements certian functions, and then you tell the model class that this observer is observing you like so: `User::observe(UserObserver::class);`

I wanted this behaviour in my latest project, where when you create a service object in my database, it also creates a service object in AWS. Django implements this behaviour by using [Signals](https://docs.djangoproject.com/en/2.0/topics/signals/){:target='__blank'}. But it's not so easy to know if the object is in the process of creating, already created, updating, already updated, deleting, or already deleted. 

At first, I thought I would just define an Observerable model. But then I realized, I could implement a better event system and have great Model observers!

## The thinking
I think django signals are great! But they're not so great when you want to listen to multiple signals. Using laravel as my inspiration, I wanted to be able to define a regular expression string in order to respond to every event that matches that string. For example, if I had multiple classes of assets all of which needed to send out an email when they got updated, I would like to listen to `event::assets::updated::(.*)` to listen for every updated event. Using django signal, you would have to register the same callback over and over again. 

Then, in order to implement observers for Models, all I would really have to do is to map the models built in signal to events and define listeners for those events. 

## The Solution
The final solution I came up with is already on [github](https://github.com/radding/django-event-system){:target='__blank'} and PyPi(https://pypi.python.org/pypi/django-event-system){:target='__blank'}, so you can skip ahead and look at those if you would like. 

I wanted this system to be simple to use and extensible. In the future, I would like this library to support multi-server deployments and evolve into using django channels. And in order to not impact performance, I decided to use [gevent]('http://www.gevent.org/'){:target='__blank'} to not block execution. I won't go into great details, because you can read the `README.md` in the github repo, but I'll explain some of the decisions I made.

### Metaclasses
I chose to make use of metaclasses for the seemingly black magic. I like when things just work with out having to call start up methods, so I decided to use metaclasses to handle getting everything set up. These metaclasses do everything from starting a Greenlet for background tasks, to registering handlers for the various events, to mapping signals for Models to events.

When the classes are loaded into memory, the behaviour in the metaclass is executed, causeing the class to be ready to use with out any additional code. Just inherit from the class you want to implement and be on your way.

### Gevent
I use Gevent in order to make this event system non-blocking. The dispatch handler is put in the background if there is nothing in the event queue, and not woken up until execution is passed back to it using something like `gevent.sleep()`. While this makes the events less predictable as to when exactly they will be handled, it stops your application from slowing down or breaking if there is an error in your event handlers. 

### Helper methods
Finally, I implemented some helper methods, namely `SignalToEvent` and `RegisterSignalsFor`, in order to aid moving away from django signals and into django-event-system.

## The wrap up
This library was a lot of fun to build, and I would love to see it grow. There are a few things I am planning in the near team, such as implementing a decorator that you can use on a function to handle events to register it, a django command to make it easier to generate events, listeners, and observers, and implement priority for events. In the longer term, I want to see django channels suppport, multi-server support (all though I'm not sure about the feasibilty of this, because of locking), and maybe even seperating the base event system into its own library for events.

You can checkout the [repo for this project here](https://github.com/radding/django-event-system){:target="__blank"}. If you have any comments, questions or concerns, let me know either below or via email! Thanks for reading!
