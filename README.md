# dmoz-save-categorized-links

Save [dmoz](http://www.dmoz.org/) URL domains and categories as *key-value* pairs on a Redis database.

## Why?

In case you need to categorize a webpage. This projects uses the [dmoz](http://www.dmoz.org/) content RDF, which with a file size of 1.8GB has to be read line by line.

## How to

- Execute `npm install` to get dependencies.
- Put [content.rdf.u8](http://rdf.dmoz.org/rdf/content.rdf.u8.gz) under `*project`.
- Start your redis server.
- Execute `coffee app.coffee`.