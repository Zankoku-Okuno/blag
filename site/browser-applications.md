# The Architecture of Browser Applications

It is difficult to identify or describe the programmer's interface to a browser application.
It must describe HTML, CSS, Javascript, and all the relationships between these languages.
Developing and sticking to an architectural style in the absence of a way to document interfaces is even more difficult.

The key ideas behind my approach are, in no particular order:
  * a preference for standardized APIs over frameworks
  * adaptor layers isolating the DOM and HTTP
  * the HTML is the data structure

### Summary

This architecture identifies several types of code and segregates them.
How they each relate to the key ideas is given below, but is summarized here for reference.

TODO a few words on each of:

  * application data structures
  * generic data structure manipulations
  * polyfills
  * extensions to native JS and DOM APIs (use sparingly)
  * custom elements
  * pinout
  * resources
  * event handlers





## The Standard DOM API

Use the standard DOM library, a.k.a. "Vanilla JS", even though it's boring.
Avoid frameworks, even if everyone else is using them, and especially that awesome one you just heard of.


### A Challenge

Here, dear reader, is challenge, no googling allowed:

> What is the current version of the standard that defines the Javascript interface to the DOM?

It turns out that as of 12015, we are on DOM4, and you can find the living standard [here](https://dom.spec.whatwg.org/).
This is the primary source for knowledge about web development.
If you've been developing browser applications and didn't know that, are you not ashamed?
Not knowing about this stuff is about as ridiculous as trying to write machine language without knowing there's a manual for your target processor.
Nevertheless, many[^or-most] programmers seem to have no exposure to the standards.
It's a wonder the internet doesn't burst into flames more often.

[^or-most]: maybe most; it's hard to tell without polling data


### Resources

  * Snarky Homepage: [Vanilla JS](http://vanilla-js.com/)
  * Examples replicating framework code: [plainJS](https://plainjs.com/)
  * Friendly API docs: [MDN](https://developer.mozilla.org/)
  * Living Standards: [HTML5](https://html.spec.whatwg.org/multipage/), [DOM4](https://dom.spec.whatwg.org/)
  * SVG: [Examples](http://vanilla-js.blogspot.com/2014/11/javascript-svg-guide.html), [Reference](https://developer.mozilla.org/en-US/docs/Web/SVG)

TODO: places to get polyfills

TODO: There's no great place to learn the standard APIs from broad to narrow. I may have to write such a guide myself.


### Rationale

Conforming to the most widely-available library has several advantages:
  * extremely stable and well-maintained APIs
  * high availability of high quality[^documentation_quality] documentation
  * common language with all other developers (well, those that know what they're doing)
  * fast-as-possible access to standards improvements
  * faster execution, cutting out the "middle-man" we call a framework
  * debugging is easier with the smaller stack traces
  * a feeling of nearness to the "metal", if that matters to you

[^documentation_quality]: Although the standards documents can be difficult to read at first (and they are always ugly), they have had an incredible amount of work put into them to eliminate ambiguity and incompleteness. Such an effort is almost never applied to the more common form of library, which means that users of those libraries will be required to guess, experiment, or dig deeply into implementations, all of which slow down their work. In the case of web standards, Mozilla Developer Network (MDN) provides more pleasant and approachable documentation.

There are some disadvantages when doing this in the browser:
  * unweildy names
  * heavily imperative
In practive, I don't find these particularly meaningful.
For the unweildy names, I use an editor that helps me out with auto-complete:
for `querySelectorAll`, I usually only need to type `qsa<tab>`.
I'll admit that the imperativeness of the API only debatably a disadvantage, even though I have a strong preference against imperative programming.
In any case, the DOM is most naturally and widely understood as a mutable data structure, and that provides a lot of pressure to develop a mutation-based understanding.
Working with pure APIs is a huge advantage, though, and that may end up outweighing all the advantages I've so far discussed.
In particular, those who cannot accurately count how many mutable references there are in twenty SLOC of Javascript^[which is harder than you think!] should probably treat an imperative API as a serious disadvantage.
As for me, after long years of practice in Haskell, I have brought down the cost of my working with mutable state, so I'm content with the imperative model.





## DOM as Data Structure

Store application state in the DOM.
Initialize your Javascript based on information accessed from the DOM.

TODO: analyze whether custom elements is a good way to cut down on the complexity of encoding


### Rationale

One of the nice things that browsers give you is the ability to pick up where you last left off, whether that's moving through your browser history, re-opening an accidentally closed page, refreshing a page, or restarting a crashed browser.
Unfortunately, the state of the javascript interpreter cannot be restarted in this way.
Browsers store their application state in the DOM.
By taking advantage of this fact, you can achieve persistence of the user's state without coding.


### Example

Let's say you have a "spoiler" on your site --- i.e. an expandable-collapsable section that is initially closed.
Somewhere, the client's computer must store a bit representing the current state of the spoiler.

Let's say that a user visits, opens the spoiler, then reloads the page for whatever reason.
If the state of your spoiler were stored only in Javascript variable, then the user would have to manually open the spoiler again.
If, on the other hand, the state were stored in a (possibly hidden) checkbox, that state would be restored when the page reloads.
With appropriate initialization code for your spoiler implementation, the state of the spoiler could be restored automatically.

Perhaps this seems like too small a detail to be worried about.
The fact is, this example persists only a single bit of information, and so it _is_ small.
However, the benefits to the user increase as more bits are persisted.
Once there are several thousand bytes being persisted, reliable persistence will become indispensible.
Rather than change your persistence architecture as your site grows, start by persisting application state in the DOM even when the site is small.

### Techniques

Elements such as `<input>`, `<textarea>`, and `<select>` will be your good friends for storing primitive data like numbers, dates, text, enumerations, &c.
More complex data structures can be build out of lists, storable in `<ol>` elements.
All this information can be hidden from the casual user using CSS `display: hidden` appropriately.
Where the user may directly edit the stored data, then simply unhiding the appropriate elements can sometimes be enough to implement a functional user interface, if not a aesthetically pleasing one.


## Combinatorial and Sequential Logic

TODO develop this section further

In digital hardware design, a distinction is made between logic which involves feedback (sequential) and can therefore store bits as memory, and logic which is pure feed-forward (combinatorial).
Thinking about your digital circuit in these terms makes it much easier to analyze all the possible situations that might provoke a change of outputs from the circuit.

In this section, the meaning of "component" is a combination of combinatorial and sequential logic protected by an abstraction boundary.

Since the DOM is our (mutable) data structure, it constitutes the sequential logic.
The combinatorial logic is a pure function on inputs, including both external inputs and the current state of the sequential logic (DOM).
The sequential and combinatorial logic is hooked together and to other components with events.

The browser is asynchronous, so there is no clock in the design as there would (usually) be in hardware.
For the browser, we must listen on events both external and internal in order to get our logic to update.
We have to listen to internal events just in case the user can make a change directly to the DOM themselves.

To prevent infinite loops of event dispatch, when the scripting language makes changes to the calues in DOM elements, change events &co are not automatically dispatched.
TODO: I have not tested it yet, but I expect that nothing outside a component should be able to listen to that component's sequential logic.
Therefore, you should still not use the scripting langauge to dispatch any events from the sequential logic.
Instead, dispatch events from the component as a whole.


```
            /-----------------------\
 mutation   | Component             |
----------> | -\      /--------\    |
 observed   |   V---->|> Comb. |--- | ---------->
  events    |  e|     |  Logic |    |   events
            |  v| r/->|        |-\  |  dispatch
            |  e| e|  \--------/ |  |
            |  n| a|             |  |
            |  t| d|  /-------\  |  |
            |  s|  \--| Seq.  |<-/  |
            |   \-----| Logic |     |
            |         \-------/     |
            \-----------------------/
```


## Adaptor Layers

Build a "pinout" object that acts as an adaptor layer over your DOM.
The pinout is the only place^[excepting custom elements, polyfills, or other general-purpose code] where DOM access/mutation is allowed.
Remember that, as an adaptor layer, the pinout should be designed based on the domain semantics, not what the HTML easily allows.

Build a "resources" object that acts as an adaptor layer to servers.
The same design guidelines apply to the resources interface as the pinout.
In particular, all HTTP requests should be made through resources.


### Rationale

Whenever the structure of the site changes, all Javascript that interacts with that structure must also change.
It is much easier to make compensatory Javascript changes when all of the DOM-touching Javascript is together in one place.
As long as the interface of the pinout remains stable, the implementation of buisiness logic need never change to accomodate style changes.

Application servers also alter their API from time-to-time (though much less commonly).
Again, updates are made easier by keeping all access to external resources in one place.

As a result, the buisiness logic can be constrained to (a) a selection of algorithms independent of presentation and (b) a number of event handlers that navigate between the pinout, external resources, and algorithms.
Your event handlers should be no more than 1-3 SLOC; any more and you are doing something wrong.


### Colocating Event Listeners with Dispatchers

I think it's probably not a good idea to do this.
The whole point of an event-based architecture is to distance the notion of event handling from happening.
Co-locating these would probably look like an overly-complexified function call.
I may revisit this as I gain more experience.





## Browser Support

Some browsers[^bad_browsers] may not support parts of the web standards that you need.
In case you need to support an impoverished DOM API, the solution is pollyfills.
In case you need to target an impoverished scripting language, the solution is compilation.

[^bad_browsers]: Not just older browsers have poor support for modern web standards, but so do many mobile browsers at the time of writing.

I will well admit that this strategy may fall down on particularly impoverished browsers.
However, it has served me well with the browsers that I have access to.
My expectation is that once a browser supports HTML5, it will be extensible enough to support a polyfill + AOT compiler strategy.





## TODO

  * [ ] WebGL, Canvas
  * [ ] explore custom elements API & polyfills
  * [ ] storing large data (File+objectURL, local storage, IndexedDB)
  * [ ] push notifications
  * [ ] web workers
  * [ ] how to document your APIs