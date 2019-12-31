# Scale

## Complexity

Less is more.

Reduce complexity at all costs.

Over-engineering is one common sources of complexity.

* over-complicated solutions
* over-complicated designs (too many classes and objects)
* trying to predict the future
* ...

Keep scalability in mind when designing, developing, and deploying.

## Scale Cube

Go to [The Scale Cube | AKF Partners](https://akfpartners.com/growth-blog/scale-cube) for the picture

* x-axis: duplication, such as application code and database
  * easiest to achieve, just make copies
* y-axis: split by verbs and nouns
  * focus on the "final" verbs that operate on the data directly
* z-axis: split by properties of things, like hash-value of data
  * data of users from region A are stored in a database near region A

## Vertical or Horizontal Scaling

* Vertical: scale up
  * add more resources to an system
* Horizontal: scale out
  * add more machines

Prefer scale-out

Use more and cheap devices.

* Cheaper to maintain
* Easier to scale
* Less time to fix

Use more multiple data centers.

* Consider load balancing, disaster recovery, networking, speed, cost
* [What is a Data Center? | Cloudflare](https://www.cloudflare.com/learning/cdn/glossary/data-center/)
* [Backup site - Wikipedia](https://en.wikipedia.org/wiki/Backup_site#Hot_Sites)

Use cloud smartly. Easy to set up and shut down as soon as we are done.

* QA
* batch processing
* pike load