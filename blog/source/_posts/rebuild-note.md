---
title: Rebuilding My Website
comments: true
date: 2018-03-24 07:27:02
categories: 
- Notes
- Web-hosting
tags: [Web-hosting, Tutorial]
sidebar: toc
---

**Update (12/30/2019)**: This was written on 03/24/2018. Some content may be not updated or not relevant anymore.

# Background Story

It was a sad story. It has been a while since my last website (a [WordPress](https://wordpress.com/) run on VPS) "vanished". I doubt it was due to misconfiguration of Debian's crontab I used to auto refresh the ssl certificate or something like that. I think I will post something like the Nginx config of it later on my blog.

Ever since then have I had little time or energy to rebuild it, or more precisely, to maintain it. It is very tempting to use the WordPress again since it is so easy to make it run and so popular and so easy to find plugins. But the thing is, running on a VPS means it depends on some unstable services. When the VPS provider reboots the server, it is sometimes required to manually reboot Nginx service (or reload ssl keys refreshed by the bot of [Let’s Encrypt](https://letsencrypt.org/). Their bot was still beta at that time). And it is also very hard to maintain due to the cost of the VPS itself and other problems too.

So I decided to make use of Github Pages. It looks like I need to start from the scratch again: to buy a new domain since the old one was ugly and hard to remember, to configure the DNS, to reconfigure Zoho emails (I had 10 different emails for my old domain to register on different websites), to choose the theme of the blog, to decide the structure of the whole website etc. (I tried to use [Readthedocs](https://readthedocs.org/) for my wiki page, the page for all of my pure notes, and struggled to "fix" the package requirements for different versions of python of their codes ~~sad face~~)

Long story short. Let's dive into the main point of this post!

# Process of setting up hexo

Note: the following notes was written as a comprehensive tutorial.

## Setting up environment

Prerequisites:

1. Github account

   Go to [Github](https://github.com/) and sign up

2. Github Page repository

    At least one repository to store the generated website on Github is required. Just go to your Github home page and [create a new repository](https://github.com/new) following the instruction. You can either create it as a public or private repo. Other people cannot see the content of your private repo but since your Github page will be published you website will eventually be public.

    There is a little trick here. If you name your repo as "YOUR_GITHUB_USER_NAME.github.io", then your Github Page will automatically be published with that URL. Please read the [documentation](https://help.github.com/articles/using-a-custom-domain-with-github-pages/) for more details.

3. [npm](https://nodejs.org/en/)
4. [hexo](https://hexo.io/docs/index.html)

In brief, install npm, hexo and create a Github repo.

That is almost all you need to host a website on Github for free! You don't need to worry about SSL, don't need to pay the fees for renting a server. So awesome thanks to Github!

## Structure

Like I said before, previously I had different subdomains for different purposes. I had wiki, blog, me, doc, etc. And I used one simple page as the whole "site map" for all of them.

Same thing again for me.

Other choices may include:

* use one and only one website for the blog
* use hexo as a "show off" page to "show off" the frontend skills (something like a portfolio)
* use Github Pages as a website to host demo web applications
* and many many more!

## Choosing theme for hexo

Since I use hexo for most of my web sites, it's crucial to have a pretty and fit theme. You can surely create your own theme too!

Place for you to seek for [hexo themes](https://hexo.io/themes/index.html).

Potential blog theme:

1. [simple-black](https://github.com/yunfeihe/simple-black)
2. [icarus](https://github.com/zthxxx/hexo-theme-icarus)

Potential wiki theme:

1. [doc](https://github.com/zalando-incubator/hexo-theme-doc)

Potential moe theme:

1. [gal](https://github.com/ZEROKISEKI/hexo-theme-gal)

Potential "show off" theme:

1. [hollow](https://github.com/zchen9/hexo-theme-hollow)

## Initialize a local hexo folder

Please refer to the [official hexo documentation](https://hexo.io/docs/setup.html) for further details.

1. open terminal in your ideal directory

    For windows, for example, winkey + r and rum cmd. cd \d "path to directory".

2. type the following command to generate the initial hexo folder

   ``` bash
   hexo init
   ```

3. customize _config.yml to meet personal need

   For example, change the name of the site, change the theme and so on.

4. config _config.yml to use git to publish the website

   ``` yaml
    deploy:
      type: git
      repository: https://github.com/YOUR_GITHUB_USER_NAME/YOUR_REPO_FOR_THIS_SITE.git
      branch: master
   ```

5. add a post for our website to have something to show

    Hexo will give provide us with a "hello world" post. Feel free to delete it.

## Register a domain

Compare different domain name service providers.
There is a cool website called [domcomp](https://www.domcomp.com/)
Pay highly attention to the different prices of buying a new one and renewing an old one and transferring domain to another provider.
Some general tips: Search for coupons first. For instance, one can use "PRIVACYPLEASE" to have free privacy on name.com.
I don't feel like posting my personal opinion about which one is better here, however.

## Github Page domain setting

Please read the official [Github tutorial](https://help.github.com/articles/using-a-custom-domain-with-github-pages/) for further details

1. add customized subdomain to correspondent Github page settings
2. change CNAME record of DNS provider
3. don't forget to add CNAME file to your hexo "source" folder or hexo will delete the CNAME config of Github Page. Or you could try to add the following line to the "deploy" of hexo config [link to document](https://hexo.io/docs/deployment.html#Rsync): (note the grammar of yaml)

    ```yaml
        delete: false
    ```

## Publish

1. generate the website

   ``` bash
   hexo generate
   ```

   or you can also use

   ``` bash
   hexo g
   ```

2. make sure you set up the git deploy config properly
3. deploy your website generated by hexo

    ``` bash
    hexo deploy
    ```

    or you can also use

   ``` bash
   hexo d
   ```

# Process of rebuild the site

It looks like we have some website running. But where are the contents?

## Sign up for a image host to hold the pictures

I have no idea if this is necessary or not for Github Pages. For VPS, in order to have better speed to load the pictures and to save storage, it is generally preferred to not save the pictures directly on your own server but on an image host.

You can try [imgur](https://imgur.com) and follow the instructions!

## Re-upload the old posts

Edit and update old posts!

# Reference links

All the documentations mentioned above
http://chuangzaoshi.com/operate
https://www.v2ex.com/t/331613