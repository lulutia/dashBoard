define (require, exports, module) ->
    "use strict"

    map = {}
    gChart = require("echarts")

    map.init = ->
        map.maping()
        map.getData()
        map.eventBind()
    map.maping = ->
        @mapCity = {
            "SH": "上海"
            "BJ": "北京"
            "GZ": "广州"
        }

    map.getData = ->
        $.ajax {
            type: "get"
            url: "./data/test.json"
            dataType: "json"
            success: (data,status) ->
                chart = {
                    "NAME": ["SH", "BJ", "GZ"]
                    "SH": []
                    "BJ": []
                    "GZ": []
                    "DATE": []
                }
                for item, index in data.Sheet1
                    chart.SH.push(parseFloat(item.上海))
                    chart.BJ.push(parseFloat(item.北京))
                    chart.GZ.push(parseFloat(item.广州))
                    chart.DATE.push(item.日期)
                map.initChart(chart)

            error: (data,status) ->
                console.log status
        }

    map.eventBind = ->
        $("#J-nav li").click ->
            $(@).parent().find("li").removeClass("active")
            $(@).addClass("active")
            map.getData()

    map.initChart = (data) ->
        @airchart = gChart.init(document.getElementById('air_chart'))
        series = []
        legendData = []
        for item in data.NAME
            seriesitem = {}
            seriesitem.name = map.mapCity[item]
            seriesitem.type = $("#J-nav li.active").attr("value").toString()
            seriesitem.smooth = true
            seriesitem.data = data[item]
            seriesitem.markPoint = {
                data: [
                    {type:'max', name: '最大值'}
                    {type: 'min', name: '最小值'}
                ]
            }
            seriesitem.markLine = {
                data: [
                    {type:'average', name: '平均值'}
                ]
            }
            legendData.push(map.mapCity[item])
            series.push seriesitem
        option = {
            title: {
                text: '北京，上海，广州三城市空气质量图'
                subtext: '部分数据'
               },
            tooltip: {
                show: true
                trigger: "axis"
            },
            legend: {
                data:legendData
            },
            xAxis : [
                {
                    type : 'category',
                    boundaryGap: false,
                    axisTick: {
                        show: true
                        interval: 0
                    }
                    data : data.DATE
                }
            ],
            yAxis : [
                {
                    type : 'value'
                }
                {
                    type: 'value'
                }
            ],
            series : series
        }
        @airchart.setOption(option)
   

    module.exports = map