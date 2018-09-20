---
title: Re-Rebuilding My Website
mathjax: false
sidebar: toc
copyright: true
comments: true
date: 2018-09-19 21:40:01
categories:
- Notes
- Web-hosting
tags: [Web-hosting, Tutorial, Log, Diary, Mess]
---

Now the thing works. But not working well.

This is a **log-like** post for what I have done
and plan to do for my website.

# Goal

Have a really working website
\-with almost zero frontend knowledge :D

# Approach

Make use of my limited frontend knowledge to read the
code of open source projects and build mine according
to the licenses.

Not build from scratch, in a word.

# Analysis

The domain is easy to get.

The server is also not hard. But it is too much for my
needs. After all, all I need is a simple website that
displays something at minimum cost. Therefore, the
static site, such as Github Pages, is the way to go.

# Blog

It seems that the most popular way to go is a static
blog hosted on Github Pages.

And I'm also most experienced with that, too. So, let's
begin with creating a Hexo blog.

## Ready-to-use Hexo themes

The first intuition was to find some themes listed on the website of Hexo. Learn from others - that's how one improves.

(I wrote this post on Sept 14th, 2018.
Plenty of new ones are likely to be
added to [Hexo Themes](https://hexo.io/themes/index.html))

Here are the lists of some themes I found interesting while researching (links to demo):

Blog

* [Inside](https://blog.oniuo.com/)
* [Material X](https://blog.xaoxuu.com/)
* [TKL](https://go.kieran.top/)
* [NexT.Pisces](https://notes.iissnan.com/)
* [Vexo](https://yanm1ng.github.io/)
* [geekplus](https://geekplux.com/)
* [Pure](https://blog.cofess.com/)
* [gal](http://sora3.coding.me/)

Portfolio

* [edinburgh](https://sharvaridesai.github.io/hexo-theme-edinburgh-demo/)
* [standrews](https://sharvaridesai.gitlab.io/hexo-theme-standrews/)

Wiki

* [Wikitten](https://wiki.zthxxx.me/)

Doc

* [Doc](https://zalando-incubator.github.io/hexo-theme-doc/)

Themes with some good details

* [Ochuunn](http://ochukai.me/)
  * brilliant front page
* [one](https://huaji8.top/)
  * intriguing interactive element
* [random](https://hexo-theme-random.herokuapp.com/)
  * brilliant front page

The themes I decided to use (links to repo)

* [pure](https://github.com/cofess/hexo-theme-pure)
* [dawn](https://github.com/Ruffianjiang/hexo-theme-dawn)
* [typing](https://github.com/geekplux/hexo-theme-typing)

## Set up the blog

Add themes as submodule of local git...done.

Register a disqus account...done.

Create a favicon...done.

Change the config...working.

Modify the source code...working.

* code block
* inner bar
* side bar for post
* font
* icon
* bottom bar
* ...

## Details (detailed details)

The first thing I decided to do was to change
the appearance of the **code blocks**. I am not a
big fan of any additional decoration for it.

So I dived into the source code and looked for
any codes related to **"highlight"**.
The first thing I noticed was the partial
**styl** files called "highlight". I tried
to edit it but nothing happened.

I know **Stylus** is a dynamic stylesheet preprocessor language.
Maybe I need to think about how Hexo compiles it?
After trying to delete some, nothing happened to
the website displayed.

Then I noticed, the only file that it needs is the
**style.css** alone. By targeting the **highlight**
class, succeeded to remove the extra decorations.

(I was thinking about the meaning of the Stylus
files. But I gave them up considering all the cost,
such as the need to import normalize.css, which
would slow down the speed of **such a small site**
of mine. And the most important problem is, I have
no deep knowledge about things like Bootstrap)

But the one left is... **not beautiful**.

The next step I took was to revisit the list
of the Hexo blogs with theme source codes. It
seems that previously, I focused too much on the
overall "feeling". Some of them, thou having
appealing effects, are exceedingly bad at details.
One blog has light theme but dark code block.
The codes found on another one is almost
impossible to read due to the similar colors.

Those were not good.

From the ones I leafed through, the design of
[material-x](https://github.com/xaoxuu/hexo-theme-material-x)
stood out. Reading its source code, I created a
not-so-bad highlight block for my blog.

Next modification I did was to remove the **sticky bar**.
For some unknown reason, while the sticky bar of the
original blog would disappear as the user scrolls down,
the one of mine never changed. It was always there and
being distracting. This removal was not hard that hard.

One of the most heated issues of the original
theme was the its line height. I have no
idea why the author chose to make the lines
"crowded". I believe he had his reasons. But,
unfortunately, I am not clever enough to figure
out them on my own. So I decided to change both
the **font** and the **line height**.

Choices are always hard to make when they are many.
I searched again and again and even read about
the difference between serif and sans serif (like
the history and successful applications by big
companies). I went to some online Wordpress theme
stores to see what fonts they are using. But
eventually, I just gave up and chose **Open Sans**
instead.

The hardest one had not come yet. When I tried to
add my Instagram social link, I realized that
the original theme did not support its **icon**.

The icons in graphic design was a mystery to me since
I saw no image files in the code. How could the website
just draw a shape? After searching around, I came to
know about the difference between **SVG** and **iconfonts**.

"Well, the svg sprite looks cool! I wanna use that!"

I managed to find the SVG sprite from the original theme.
And hard-coding few additional SVG icons into it did not
seem very hard.

But, the theme here used the "font-class" way to do it.
To have additional icons, I need a way to change the ttf
files and maintained the original unicode. Or I need to
rewrite all the related codes and functions.

Changing all the codes was not impossible but
too much to do right now. And I also need to
debug the SVG sprite on my own without any related
frontend knowledge. The difficulty was unpredictable.
Therefore, the "font-class" way still seemed good to me.

But now I need a way to "unpack and repack" the ttf icons.
I tried to skip the "unpack" step by searching around to see
if I could find the original icons. But it was so hard to
keep the "names" of each icon identical in this way.
Should I just delete all the unnecessary icons? Could I
use some software to manage them?

It was not easy especially when I am new. After messing
around for quite a while, I suddenly found out
the online app of [icomoon](https://icomoon.io/app/#/select)
could load the SVG sprite and regenerate the font files
I needed. I doubted if it was so common and obvious that
no one would ever have written a tutorial for me to learn
this information. And it could keep all the "names" of the
icons, too!

I knew it was not a graceful way to do it. But it worked
at least. It took some time for me to make the icon truly
work. But the hard part was over, although I still spent
a long time figuring out how the side-bars worked.

The rest of the modification is all about small things,
like fixing a logical statement, adding variables and so
forth. I have written too much for a post so let's stop
here. If you are curious, you can read the "Readme.md" of
the modified theme under my Github account.

# Home

I feel like having a home page, clean and
compelling, to serve as the "www" host of
my domain, similar to the one of
[geekplus.com](https://geekplux.com/)
and my old home page.

## Reference

* my old website (local source code)
* [xrlin](https://xrlin.github.io/)
* [ochukai.me](http://ochukai.me/)
* [geekplus.com](https://geekplux.com/)

Now I need a break (´._.`).