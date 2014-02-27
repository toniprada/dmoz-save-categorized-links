fs = require 'fs'
readline = require 'readline'
stream = require 'stream'
redis = require 'redis'

TOPIC_REGEX = /<ExternalPage about="(.*)".*>/
CATID_REGEX = /<topic>(.*)<\/topic>/
TOP_URL_REGEX = /^((https?\:\/\/(www.)?)[^\/]+\/?)$/
URL_REGEX = /^((https?\:\/\/(www.)?)[^\/]+\/?).*$/
IGNORE_CATEGORY_REGEX = /Top\/World/

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
      category = matches[1]
      #just save root urls
      if TOP_URL_REGEX.test url
        #ignore Top/World/* categories
        unless IGNORE_CATEGORY_REGEX.test category
          matchesUrl = url.match URL_REGEX
          host = matchesUrl[1]
          if host
            # just save domains without the protocol, www or the end bar
            if host.slice(-1) == "/" then host = host.slice(0, -1)
            host = host.replace(matchesUrl[2], '').toLowerCase()
            # if its already saved check if this is a shorter link
            client.get host , (err, data) ->
              if !err and (!data or JSON.parse(data).size>url.size)
                client.set host, JSON.stringify(cat:category, size:url.length), () ->
                  count++
                  if count%100000==0 then console.log "SAVED #{count/1000}k urls"

  rl.on 'close', () ->
    console.log 'close'
    process.exit code=0

do parseContent
