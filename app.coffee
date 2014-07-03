fs = require 'fs'
readline = require 'readline'
stream = require 'stream'
redis = require 'redis'

TOPIC_REGEX = /<ExternalPage about="(.*)".*>/
CATID_REGEX = /<topic>(.*)<\/topic>/
TOP_URL_REGEX = /^((https?\:\/\/(www.)?)[^\/]+\/?)$/
URL_REGEX = /^((https?\:\/\/(www.)?)[^\/]+\/?).*$/
IGNORE_CATEGORY_REGEX = /Top\/World/

count = 0
url = null
redisClient = redis.createClient()
redisClient.on 'error', (err) ->
  console.log err

parseContentLineByLine = () ->
  rl = createReadLineInterface()

  rl.on 'line', (line) ->
    if TOPIC_REGEX.test(line)
      # Line contains the URL, so save it for when we'll find the categories
      matches = line.match TOPIC_REGEX
      url = matches[1]
    if CATID_REGEX.test(line)
      # Line contains the CATEGORY, so get it and save it
      parseCategory(url, line)

  rl.on 'close', () ->
    console.log 'close'
    process.exit code=0

createReadLineInterface = ->
  instream = fs.createReadStream('rdf/content.rdf.u8')
  outstream = new stream
  return readline.createInterface(instream, outstream)

parseCategory = (url, line) ->
  matches = line.match CATID_REGEX
  category = matches[1]
  # Check if is a root url, we don't want relative ones
  if TOP_URL_REGEX.test url
    # Check if is a category from Top/World/* which are not in english
    if not IGNORE_CATEGORY_REGEX.test category
      urlMatches = url.match URL_REGEX
      domain = urlMatches[1]
      if domain
        # just save the domains: without the protocol, the 'www' part or the end slash
        domain = cleanDomain(domain, urlMatches)
        # if its already saved check if this is a shorter link that the one that we had
        saveIfBetter(domain, category)

cleanDomain = (domain, urlMatches) ->
  if domain.slice(-1) == "/" then domain = domain.slice(0, -1)
  return domain.replace(urlMatches[2], '').toLowerCase()

saveIfBetter = (domain, category) ->
  redisClient.get domain , (err, data) ->
    return if err?
    if not data or domain.length < JSON.parse(data).size
      redisClient.set domain, JSON.stringify(cat:category, size:domain.length), () ->
        count++
        if count%100000==0 then console.log "SAVED #{count/1000}k urls"

do parseContentLineByLine

