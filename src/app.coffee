fs = require 'fs'
readline = require 'readline'
stream = require 'stream'

instream = fs.createReadStream('rdf/structure.rdf.u8')
outstream = new stream
rl = readline.createInterface(instream, outstream)

rl.on 'line', (line) ->
  console.log line

rl.on 'close', () ->
  console.log 'close'