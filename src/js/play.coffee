define (require, exports, module) ->
    "use strict"

    # require("jquery")
    map = require("module/map")
    all = require("module/all")


    play = {}

    play.init = ->
        map.init()
        all.init()
       

    module.exports = play