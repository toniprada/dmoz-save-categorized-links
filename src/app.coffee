fs = require 'fs'
readline = require 'readline'
stream = require 'stream'
redis = require 'redis'

TOPIC_REGEX = /<ExternalPage about="(.*)".*>/
CATID_REGEX = /<topic>(.*)<\/topic>/

client = redis.createClient()
client.on 'error', (err) ->
  console.log err

parseContent = () ->
  instream = fs.createReadStream('rdf/content.rdf.u8')
  outstream = new stream
  rl = readline.createInterface(instream, outstream)

  url = null
  count = 0

  rl.on 'line', (line) ->
    if TOPIC_REGEX.test(line)
      matches = line.match TOPIC_REGEX
      url = matches[1]
    if CATID_REGEX.test(line)
      matches = line.match CATID_REGEX
      client.set url, matches[1], () ->
        count++
        if count%100000==0 then console.log "SAVED #{count/1000}k urls"

  rl.on 'close', () ->
    console.log 'close'
    process.exit code=0

do parseContent
