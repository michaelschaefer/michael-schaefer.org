---
layout: post
title: jekyll - the engine behind this blog
date: 2014-05-26 15:02:00
description: "Today you will get some insight in the infrastructure of this blog: I will introduce to you jekyll, a software tool for easy management of (more or less) static web pages."
tags: [jekyll, programming]
---

Some time ago I decided to start blogging again. Since my old website had become outdated both technically and from the design point of view it was necessary to make a fresh start. The basic question then is whether you want to go for an existing framework like Wordpress or implement the entire stuff youself. As I consider myself very interested in programming, HTML, CSS and all this stuff, the second one as of course my method of choice.

The usual approach for a self-implemented blog-like website seemed to be a database collecting the information together with a scripting language like PHP converting the data into HTML. This way I have programmed some websites in the past. But then I thought again about this approach and one points came to my mind: Do I really need a dynamic website? I decided that the only two features I had in older websites that relied on this approach were user interaction and a search function. After all, a custom search function seems to be replaceable by a good article archive and the internal search function of the browser and for the user interaction there are external services like [disqus][disqus].

This is where [jekyll][jekyll] comes into play. Jekyll is a software written in [Ruby][ruby] that converts a collection of (among others) HTML pages, markdown files and layouts into a static website. The philosophy behind jekyll is that once the website is set up, you just have to provide new content in the form of text files. These text files may contain HTML but they can also easily be formatted using [Markdown][markdown]. I will not write a tutorial about jekyll here, since in my opinion the jekyll website contains a perfect introduction so there is no need for an additional one. I just want to address the main features of the software to convince you that it is a good idea to use it.

## Layouts

A very important part of a website is of course its layout. In general, a layout in jekyll is a HTML file stored in a folder `_layouts`. Of course these layout files can be styles via CSS and may contain Javascript. They are just ordinary HTML files. To use a layout is pretty simple. Let's assume you have a layout `default.html` and another file `about.html`. You just have to start this file with front matter in the [YAML][yaml] format looking like this:

{% highlight yaml %}
---
layout: default
---
{% endhighlight %}

This will put `about.html` as content into the layout file `default.html`. You can also stack different layouts, i.e. you can have one file that uses a layout named `post` which itself uses `default`. This way you can nicely separate content from layout.

## Posts

The most importent thing are blog posts. In jekyll a post is a file that is placed a folder named `_posts`. A post must also start with a YAML front matter that may contain different information like layout, title and date of publication. For the formatting of the post itself jekyll supports both [Markdown][markdown] and [Textile][textile].

## Tagging

Most blogs use tags for their articles in order to group them and to give access to related content. Tagging in jekyll is particularly easy. You just have to include a list of them in the front matter of your post. For example, this is the front matter of the current post:

{% highlight yaml %}
---
layout: post
title: jekyll - the engine behind this blog
date: 2014-05-26 15:02:00
description: "Today you will get some insight in the infrastructure of this blog: I will introduce to you jekyll, a software tool for easy management of (more or less) static web pages."
tags: [jekyll, programming]
---
{% endhighlight %}

This way you have equipped that post with the two tags jekyll and programming.

## Liquid templating

There remains one big question: How does jekyll compile together all the different pieces? The basic answere is [Liquid][liquid]. Liquid is a templating engine that allows you to use all kind of information in the different files of your website. The Liquid mechanism e.g. provides a list of all posts, and for each posts it gives you access to the information in the front matter. On the other hand, Liquid provides a list of the tags you used and many other information. So Liquid is more or less the glue that allows you to put together layout and content.



[disqus]: http://www.disqus.net
[jekyll]: http://jekyllrb.com
[liquid]: http://wiki.shopify.com/Liquid
[markdown]: http://en.wikipedia.org/wiki/Markdown
[ruby]: http://en.wikipedia.org/wiki/Ruby_(programming_language)
[textile]: http://textile.sitemonks.com/
[yaml]: http://en.wikipedia.org/wiki/YAML
