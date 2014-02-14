fs = require 'fs'
readline = require 'readline'
stream = require 'stream'

TOPIC_REGEX = /<Topic r:id="(.*)".*>/i
CATID_REGEX = /<catid>([0-9]+)<\/catid>/

parseStructure = () ->
  instream = fs.createReadStream('rdf/structure.rdf.u8')
  outstream = new stream
  rl = readline.createInterface(instream, outstream)

  topics = []
  topic = null

  rl.on 'line', (line) ->
    if TOPIC_REGEX.test(line)
      matches = line.match TOPIC_REGEX
      topic = {name: matches[1]}
    if CATID_REGEX.test(line)
      matches = line.match CATID_REGEX
      topic.id = matches[1]
      topics.push topic

      console.log topics.length

  rl.on 'close', () ->
    console.log 'close'
    #fs.writeFile 'out/structure.json', JSON.stringify topics, (err) ->
    #  if err then console.log err else console.log 'OK saved'
    return topics

parseContent

topics = do parseStructure

