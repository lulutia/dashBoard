define (require, exports, module) ->
    "use strict"

    require("jquery")
    map = require("module/map")
    indicator = require("module/indicator")


    play = {}

    play.init = ->
        map.init()
        indicator.init()
       

    module.exports = play