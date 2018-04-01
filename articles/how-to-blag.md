# How to Blag

This is the story of how I build my blog, what the tradeoffs are, and why I chose this system.

## In-Site Structure

The site itself categorizes the posts into a few general forms of post.
These forms are there to distinguish the reason for existence of the post.

  * Approach: advice on design methods; I try to "take my own medicine" as it were
  * Journal: design notes for a particular artifact
  * Review: where I review my life
  * Reference: notes to myself on the particular systems I've adopted
  * Curiosities: disorganized set of pointers to interesting problems &/ results

## Tooling

In my choice of tools, the important qualities were:
  * well-supported: many utilities with good documentation means less coding, less guessing, and more writing
  * remixable: each tool should be agnostic about what other tools might also be in use
  * customizable: I can be very picky about aesthetics

The choice of language you use to write articles is the choice you will most often have to live with.
At least, if you're doing it right:
if everything is going well, then most of your time blogging should be spent creating content for your blog.


### Server Side

The server-side is written in Haskell for it's type-safety.
The last thing I want is an injection attack against my site.
Haskell's types are strong enough to enforce guarantees against injection.

Any HTML templates are codes in Hamlet.
I'm not 100% sold on Hamlet, though: it's metaprogramming seems convenient, but a lack of documentation is a worse flaw.

### Client Side

The client-side blog software is programmed in HTML5, CSS3, Vanilla JS, and DOM4.

I've not yet decided between ES5 and ES6 (or TypeScript or ...).
I'm currently using ES5, since that is well-supported in browsers.
The features of ES6 are incredibly usefuly, however, so I may need to look into transpilers for it.
Unfortunately, ES6 is missing a static type system, but I'm not currently familiar with typed alternatives and how easily they can use vanilla js libraries.
If you think I'm crazy for liking types, I suggest [you learn why they exist](https://people.mpi-sws.org/~dreyer/tor/papers/reynolds.pdf).

I used npm and browserfy to compile my javascript dependencies together, but I have since lost the original package.
If I need to edit my JavaScript, or if I move to ES6, I will use webpack.

I'm not using a framework.
Frameworks, at best, are a less-well-documented version of the now-widespread[^polyfill] HTML5 standard.
I'm especially not using frameworks that require a particular architecture for the entire site.
The essential thing I want to avoid is vendor lock-in.
You might think `querySelectorAll` is a verbose method name---which it is---, but I've got a text editor with auto-complete, so I'm not worried[^qsa]

[^polyfill]: Where it isn't supported, there are always polyfills.
[^qsa]: In this particular example, I can type is `qsa` then `<tab>` to get `querySelectorAll`, and I've got a load of other options.

I'm also not using Bootstrap.
Nowadays CSS has flexbox and grid layouts, so the bootstrap grid isn't as important.
Further, the way Bootstrap uses classes is non-semantic.
Bootstrap is also verbose, requiring all sorts of specially-classed elements containing other specially-classed elements, and redundant bits of class name[^glyphicon].

[^glyphicon]: Such as `class="glyphicon glyphicon-foobar"` when a simple `class="glyphicon-foobar"` should have been sufficient.

### Blog Content

For writing content, I use a slightly-customized markdown.

My problem with WSIWYG is that it cannot be automated.
Of course, being a programmer, I am entirely comfortable with specialized syntax, but your mileage may vary.
If you're going to blog, but are thinking to learn how to code while you blog, don't;
you'd just end spending most of your time learning to program instead of blogging.
If you'd like to learn programming and are thinking a blog is a good project, it's not;
if you don't want to blog, you won't, and if you don't blog, your blog project won't help you learn to program.

The markdown is served statically, and is rendered into HTML on the client.
In particular, I'm using `markdown-it` because it has a lot of plugins available for it.
The competitors for client-side markdown just didn't have the community.

An additional benefit of using markdown as opposed to any kind of markup syntax is that it is remarkably easy to proofread.
If I had to compile my markdown into its final form every time I wanted to look for grammatical errors, I'd just stop proofreading.

I did have the choice between client-side and server-side markdown rendering.
With server-side markup, it's tempting to use something like pandoc or rst, but I want to keep my markup simple and portable.
Finally, I think the markup really is the primary source; if a user wants to use a different reader^[never gonna happen], they can always take the markdown and render it to their tastes.


## Project Structure

Blog articles are written in the `articles/` folder.
The server side is implemented in `server/`.
The client side is implemented in `client/`.

At the moment, the client side consists only of static files under `dist/`.
When I move to webpack, the `client/` folder will become a webpack project with source code under a `src/` directory.

The `server/` directory is a cabal package with source code under the `src/` directory.
I use `cabal new-build` to compile the server.
The finished server is a single binary.

## Deployment

Pull the repository onto the server; this gets the articles and static files.
After compiling the server binary, upload that to the server.
Also upload a configuration file to the server.

When first setting up the server, create a SysVinit `.service` file for the blag.
The start script should call the binary with an absolute path to the config file.
Enable the service.

Restart the blag service.
