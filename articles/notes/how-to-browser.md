# How to Browser

I'm a big fan of Vanilla JS wherever possible.
[Here](https://plainjs.com/)'s a good reference for fancy things you can do with it.


## Custom Elements

Once you turn on the appropriate flags in firefox, all the major browsers save IE support Custom Elements.
  * `dom.webcomponents.customelements.enabled`
  * `dom.webcomponents.shadowdom.enabled`

In fact, all the major browsers support almost the entire ES6 syntax.
You can see this on [Kangax](https://kangax.github.io/compat-table/es6/).

Polyfilling custom elements is very strange however.
Native custom elements will only accept true classes, but transpilation eliminates these.
I don't want to browser-detect before shipping out ES5 vs. ES6 code.
Therefore, every browser would need polyfills, which for custom elements is quite expensive.


I'm comfortable turning these features on in my firefox.
Also, it seems I'm the only one using this tool.
Therefore, I'm okay with writing in ES6 without transpilation.
