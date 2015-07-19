define (require, exports, module) ->
    "use strict"

    require("jquery")
    map = require("module/map")


    play = {}

    play.init = ->
        map.init()
       

    module.exports = play