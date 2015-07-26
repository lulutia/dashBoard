define (require, exports, module) ->
    "use strict"


    all = {}
    gChart = require("echarts")

    all.init = ->
        all.getData()
        

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
            $(".J-info").addClass("hidden")
            value = $("#J-allnav li.active").attr("value")
            $("#" + value).removeClass("hidden").addClass("block")
            all.airbarchart.clear()
            all.itemall = []
            all.itemallname = []
            all.itemradio = []
            all.dataProcess(all.allType)
        @airchart.on "click", (param) ->
            all.airbarinit(param)

        

    all.airbarinit = (param) ->
        if param?
            index = all.allType.area.indexOf(param.name)
        else index = 309
        all.itemall = all.itemall || []
        all.itemradio = all.itemradio || []
        if all.itemall.length < 5
            all.itemallname = all.itemallname || []
            all.itemallname.push all.allType.area[index]
            item = {
                name: all.allType.area[index]
                type: 'bar'
                data: [all.allType.aqi[index],all.allType.pm2_5[index],all.allType.pm10[index],all.allType.co[index],all.allType.no2[index],all.allType.o3[index],all.allType.so2[index]]
            }
            all.itemall.push item

            itemradiodata = {
                value: [all.allType.aqi[index],all.allType.pm2_5[index],all.allType.pm10[index],all.allType.co[index],all.allType.no2[index],all.allType.o3[index],all.allType.so2[index]]
                name: all.allType.area[index]
            }
            all.itemradio.push itemradiodata

            @airbarchart = gChart.init(document.getElementById('airbar_chart'))
            option = {
                title : {
                    text: '所选地区情况',
                    subtext: '数据取自PM25.in,此处最多选择五个',
                },
                tooltip: {
                    trigger: 'axis'
                   },
                legend: {
                    data: all.itemallname
                   },
                xAxis : [
                    {
                    type : 'category',
                    data : ['aqi','PM2.5','PM10','CO','NO2','O3','SO2']
                    }
                   ],
                yAxis : [
                   {
                    type : 'value'
                   }
                   ],
                series: all.itemall
            }
            @airbarchart.setOption(option)

            @airradiochart = gChart.init(document.getElementById('airradio_chart'))
            option1 = {
                title : {
                    text: '所选地区情况',
                    subtext: '数据取自PM25.in,此处最多选择五个',
                },
                tooltip : {
                    trigger: 'axis'
                },
                legend: {
                    orient : 'vertical',
                    x : 'right',
                    y : 'bottom',
                    data: all.itemallname
                },
                polar : [
                   {
                       indicator : [
                           { text: '空气质量（AQI）', max: 309},
                           { text: '细颗粒物（PM2.5）', max: 258},
                           { text: '可吸入颗粒物（PM10）', max: 267},
                           { text: '一氧化碳（CO）', max: 3},
                           { text: '二氧化氮（NO2）', max: 101},
                           { text: '臭氧（O3）', max: 174},
                           { text: '二氧化硫（SO2）', max: 169}
                        ]
                    }
                ],
                calculable : true,
                series : [{
                    name: "所选地区情况",
                    type: 'radar',
                    data: all.itemradio
                    }]
            }
            @airradiochart.setOption(option1)
                                

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
        all.max = 0
        for dataitem, index in data[value]
            obj = {}
            obj.name = data["area"][index]
            obj.value = dataitem
            if obj.value > all.max
                all.max = obj.value
            itemput.markPoint.data.push obj
  
        if not all.geocoord?
            all.geocoord = {}
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
        else
            itemput.geoCoord = all.geocoord
            series.push itemput
            all.initChart(series)


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
                text: '全国空气质量(' + $("#J-allnav li.active").find("a").html() + ")",
                subtext: '数据取自PM25.in',
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
        all.airbarinit()
        all.eventBind()
        



    module.exports = all