# Hotwire Tweets

An example of how to combine the Hotwire tooling at our disposal.

## How to read this repository

Read [the commit logs][the commit logs]. If you're only interested in the
implementation changes, ignore any commit prefaced by `[GENERATED]` or `[SKIP]`.

[the commit logs]: https://github.com/seanpdoyle/hotwire-tweets/commits/main

## Running the application locally

After checking out the codebase, execute the set up script:

```sh
bin/setup
```

Keep in mind that the application makes use of some bleeding edge JavaScript
features like [ECMAScript Modules][esm] and the [dialog][] element. You might
have the best experience testing it out in Chrome.

[esm]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules
[dialog]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dialog
