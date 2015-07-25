define (require, exports, module) ->
    "use strict"


    all = {}
    gChart = require("echarts")

    all.init = ->
        all.getData()
        all.eventBind()

    all.getData = ->
        $.ajax {
            type: "get"
            url: "./data/country.json"
            dataType: "json"
            success: (data,status) ->
                all.dataHandle(data)
        }
    
    all.eventBind = ->
        $("#J-allnav li").click ->
            $(@).parent().find("li").removeClass("active")
            $(@).addClass("active")

    all.dataHandle = (data) ->
        all.allType = {}
        for item in data
            keys = Object.keys(item)
            for key in keys
                all.allType[key] = all.allType[key] || []
                all.allType[key].push item[key]
        all.dataProcess(all.allType)

    all.dataProcess = (data) ->
        value = $("#J-allnav li.active").attr("value").toString()
        series = []
        itemput = {
            name: value
            type: 'map'
            mapType: 'china'
            hoverable: false,
            roam:true,
            data: [],
            markPoint: {
                symbolSize: 5,
                itemStyle: {
                    normal: {
                        borderColor: '#87cefa',
                        borderWidth: 1,
                        label: {
                            show: false
                          }
                      },
                    emphasis: {
                        borderColor: '#1e90ff',
                        borderWidth: 5,
                        label: {
                            show: false
                        }
                      }
                  },
            data: []
            }
        }
        for dataitem, index in data[value]
            obj = {}
            obj.name = data["area"][index]
            obj.value = dataitem
            if obj.value > all.max
                all.max = obj.value
            itemput.markPoint.data.push obj
        for item in data["area"]
            all.ajaxt(item)
            all.flag = data["area"].length

        querycheck = setInterval =>
            return if all.flag isnt 0
            itemput.geoCoord = all.geocoord
            series.push itemput
            all.initChart(series)
            clearInterval(querycheck)
        , 100
        return

    all.geocoord = {}
    all.max = 0
    all.ajaxt = (item) ->
        $.ajax {
            type: "get"
            url: "http://api.map.baidu.com/geocoder/v2/"
            dataType: "jsonp"
            data:
                output: "json"
                ak: "ZXhtdkazbuOxPmG6xB0609zB"
                address: item
            success: (data,status) ->
                if data.status is 0
                    all.geocoord[item] = []
                    all.geocoord[item].push data.result.location.lng
                    all.geocoord[item].push data.result.location.lat
                else
                    all.geocoord[item].push 0
                    all.geocoord[item].push 0
                all.flag--
        }

    all.initChart = (data) ->
        # console.log data
        @airchart = gChart.init(document.getElementById('airall_chart'))
        option = {
            title : {
                text: '全国气候状况',
                subtext: '数据取自',
            },
            dataRange: {
                min : 0,
                max : all.max,
                calculable : true,
                color: ['maroon','purple','red','orange','yellow','lightgreen']
               },
            tooltip : {
                trigger: 'item'
            },
            series: data
        }
        @airchart.setOption(option)
                            

    module.exports = all