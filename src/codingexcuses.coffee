# Description:
#   Get a random excuse from Programming Excuses
#
# Dependencies:
#   "cheerio": "0.7.0"
#   "he": "0.4.1"
#
# Commands:
#   hubot excuse - Pulls a random excuse from http://programmingexcuses.com
#
# Author:
#  dkelll

cheerio = require 'cheerio'
he = require 'he'

module.exports = (robot) =>
  robot.respond /excuse/i, (message) ->
    get_excuse message, "http://programmingexcuses.com", (text) ->
      message.send text

get_excuse = (message, location, response_handler) ->
  message.http(location).get() (error, response, body) ->
    return message.send "Can't excuse you. ERROR: #{error}" if error
    return message.send "Can't excuse you. ERROR: #{response.statusCode + ':\n' + body}" if response.statusCode != 200

    $ = cheerio.load(body)
    txt = he.decode $('body a').first().text()
    response_handler "#{txt}"