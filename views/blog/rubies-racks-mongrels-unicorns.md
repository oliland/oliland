# Rubies, Racks, Mongrels & Unicorns
### First published 28<sup>th</sup> March 2011.

Ruby has matured at an extraordinary pace. Ruby developers, on the other hand, have not matured at all; opting instead to give vital components silly names.

But I digress. This article will attempt to de-mystify the options you have when it comes to deploying Ruby or rails applications, with examples of some simple and elaborate stacks you can create.

## Some terms

A common point of confusion is understanding the roles of web servers, application servers, and Rack. They all stack on top of each other like this:

![Web servers: nginx, lighttpd, Apache](/images/2/webservers.png)

These are the forefront of your application. They take HTTP requests and either forward them to an application or serve a static file based on the URI.

![Application servers: Mongrel, Thin, Unicorn](/images/2/appservers.png)

Application servers are web servers too, but they take HTTP requests and pass them on to your Ruby application through Rack. They can serve static files, but not as quickly. We'll explain more about them below.

![Rack](/images/2/rack.png)

What's _Rack_? Think of it as an interpreter between an application server and your Ruby application. It takes that HTTP data and transforms it into a ruby `request` object, containing all that juicy HTTP data in a format that your application can deal with, just like Python's WSGI.

![Your application](/images/2/yourapp.png)

Finally, your application takes this Rack `request` object, examines the URI and shows a page about kittens.

## The Development Environment

You should have experienced the simplest variation of the stack already - the development stack.

![A typical development stack with WEBrick](/images/2/webrick.png)

WEBrick is an application server. It has it's advantages during development, namely that it reloads changes to your code as you make them.

But this is not what you want in a live environment. Why?

* Monitoring for code changes means no cache, which is slow.
* It can't serve static files and process your Ruby application at the same time, making loading pages with lots of external files extremely slow.
* It doesn't scale with size. It stands no chance against the horde of your kitten loving audience.

## The Live environment

Let's dive right in to a more complicated set up.

![A typical development stack with WEBrick](/images/2/advanced.png)

Here the distinction between a web server and an application server becomes important. You see, the Ruby stack isn't designed to serve static files efficiently; that's a web servers job.

In this example, the web server forwards all requests for Ruby pages through to the application servers, and handles all requests for static files without going through the ruby stack. Web servers were designed to serve static files; they can be compressed or cached in memory making serving them super fast!

## Getting technical

Let's look at my `lighttpd` configuration for this site:

    $HTTP["host"] =~ "(www\.)?oliver.kingshott.com" {
        server.document-root = "/projects/blog/public/"

        $HTTP["url"] !~ "\.(css|js|png|jpg|gif|ico|txt)" {
            proxy.balance = "fair"
            proxy.server  = ( "" => (
                    ( "host" => "127.0.0.1", "port" => 3000 )
                    ( "host" => "127.0.0.1", "port" => 3001 )
                )
            )
        }
    }

The method for passing requests from a web server to an application server is called *reverse proxying*, and you can see it in action here. I have two application servers running on ports 3000 and 3001 on the same machine, but as the regex implies, they are only called when the client has not requested a static file.

Notice the `proxy.balance` command for load balancing between the application servers.

As for the application servers? They just need to be pointed at my application to run:

    $ thin -s 2 -R config.ru start
    Starting server on 0.0.0.0:3000 ... 
    Starting server on 0.0.0.0:3001 ...

People take great pride in benchmarking the optimum number of ‘workers’ per system, so I'll let you discover what's best for you.

This is just my configuration - you can swap lighttpd for nginx or Apache and Thin for Mongrel or Unicorn and the configurations will look very similar. Just read their documentation.

## Bringing it all together

By this point, you should be wondering how the hell you're going to look after all of these processes and configurations. Fortunately there's a Gem for that, and it has a silly name. It's called [God](http://god.Rubyforge.org/).

## What's the alternative? 
You'll notice that all this setting up isn't very rails-like. There are two very good alternatives you should explore before deploying your own web stack:

1. [Phusion Passenger](http://modrails.com/) is a commercially supported application server that automatically hooks into Apache or Nginx through modules.
2. [Heroku](http://heroku.com/) is a git based cloud platform that makes deploying as easy as `git push heroku master`. Really.

But if you're like me, you don't want to use 1) because it's not modular enough, and 2) gets suspiciously expensive once you start needing more workers.

The great thing about this setup is that you can mix and match. There's no reason you can't have a python stack and a Ruby stack being controlled by different virtualhosts under the same web server. You add caches, more advanced load balancers, firewalls, whatever you like, and it won't cost you a penny. Don't you love open source?
