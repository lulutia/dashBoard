define (require, exports, module) ->
    "use strict"

    gChart = require("echarts")
    indicator = {}

    indicator.init = ->
        @getData()

    indicator.getData = () ->
        $.ajax {
            type: "get"
            url: "./data/test.json"
            dataType: "json"
            success: (data, status) ->
                $.ajax {
                    type: "get"
                    url: "./data/country.json"
                    dataType: "json"
                    success: (data, status) ->
                        

                }
        }


    module.exports = indicator