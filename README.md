# dmoz-save-categorized-links

Save [dmoz](http://www.dmoz.org/) *url-category* pairs to redis. It only saves root urls with categories outside of *Top/World/* (more than 1.5M urls).

## How to

- Execute `npm install` to get dependencies.
- Execute `grunt` to compile to js.
- Put [content.rdf.u8](http://rdf.dmoz.org/rdf/content.rdf.u8.gz) under `rdf/.
- Execute `node target/app.js`.