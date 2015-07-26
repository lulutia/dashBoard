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
        $("#J-circlenav li").click ->
            $(@).parent().find("li").removeClass("active")
            $(@).addClass("active")
            map.getData()


    map.initChart = (data) ->
        BJ = {
            min: 0
            ave: 0
            max: 0
        }
        GZ = {
            min: 0
            ave: 0
            max: 0
        }
        SH = {
            min: 0
            ave: 0
            max: 0
        }
        for bjitem in data.BJ
            if bjitem < 100
                BJ.min++
            else if bjitem > 100 and bjitem < 200
                BJ.ave++
            else BJ.max++
        for gzitem in data.GZ
            if gzitem < 100
                GZ.min++
            else if gzitem > 100 and gzitem < 200
                GZ.ave++
            else GZ.max++
        for shitem in data.SH
            if shitem < 100
                SH.min++
            else if shitem > 100 and shitem < 200
                SH.ave++
            else SH.max++

        @airchart = gChart.init(document.getElementById('air_chart'))
        @airpie = gChart.init(document.getElementById('airpie_chart'))
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

        option1 = {
            title : {
                text: 'AQI数据分析图',
                subtext: '数据来自PM25.in',
                x:'center'
            },
            tooltip : {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                orient : 'vertical',
                x : 'left',
                data:['AQI<100','100<AQI<200','AQI>200']
            },
            series : [
                {
                    name:'北京空气质量占比',
                    type:'pie',
                    radius : '55%',
                    center: ['17%', '60%'],
                    data:[
                        {value:BJ.min, name:'AQI<100'},
                        {value:BJ.ave, name:'100<AQI<200'},
                        {value:BJ.max, name:'AQI>200'}
                    ]
                },
                {
                    name:'上海空气质量占比',
                    type:'pie',
                    radius : '55%',
                    center: ['50%', '60%'],
                    data:[
                        {value:SH.min, name:'AQI<100'},
                        {value:SH.ave, name:'100<AQI<200'},
                        {value:SH.max, name:'AQI>200'}
                    ]
                },
                {
                    name:'广州空气质量占比',
                    type:'pie',
                    radius : '55%',
                    center: ['85%', '60%'],
                    data:[
                        {value:GZ.min, name:'AQI<100'},
                        {value:GZ.ave, name:'100<AQI<200'},
                        {value:GZ.max, name:'AQI>200'}
                    ]
                }
            ]
        }

        labelTop = {
            normal : {
                label : {
                    show : true,
                    position : 'center',
                    formatter : '{b}',
                    textStyle: {
                        baseline : 'bottom'
                    }
                },
                labelLine : {
                    show : false
                }
            }
        }
        labelFromatter = {
            normal : {
                label : {
                    formatter: (params) ->
                        return ((1 - params.value) * 100).toFixed(2) + '%'
                    textStyle: {
                        baseline : 'top'
                    }
                }
            },
        }
        labelBottom = {
            normal : {
                color: '#ccc',
                label : {
                    show : true,
                    position : 'center'
                },
                labelLine : {
                    show : false
                }
            },
            emphasis: {
                color: 'rgba(0,0,0,0)'
            }
        }
        radius = [50, 75]
        option2 = {
            title : {
                text: 'AQI数据分析图',
                subtext: '数据来自PM25.in',
                x:'center'
                    },
            series : [
                {
                    name:'北京空气质量占比',
                    type : 'pie',
                    center : ['15%', '60%'],
                    radius : radius,
                    x: '0%',
                    itemStyle : labelFromatter,
                    data : [
                        {name:'other', value:(BJ.min + BJ.ave) / data.BJ.length, itemStyle : labelBottom},
                        {name:'北京: AQI>200', value:BJ.max / data.BJ.length,itemStyle : labelTop}                    ]
                },
                {
                    name:'上海空气质量占比',
                    type : 'pie',
                    center : ['50%', '60%'],
                    radius : radius,
                    x:'20%',
                    itemStyle : labelFromatter,
                    data : [
                        {name:'other', value:(SH.min + SH.ave) / data.SH.length, itemStyle : labelBottom},
                        {name:'上海: AQI>200', value:SH.max / data.SH.length,itemStyle : labelTop}
                    ]
                },
                {
                    name:'广州空气质量占比',
                    type : 'pie',
                    center : ['85%', '60%'],
                    radius : radius,
                    x:'40%',
                    itemStyle : labelFromatter,
                    data : [
                        {name:'other', value:(GZ.min + GZ.ave) / data.GZ.length, itemStyle : labelBottom},
                        {name:'广州: AQI>200', value:GZ.max / data.GZ.length,itemStyle : labelTop}
                    ]
                }
            ]
        }
        if $("#J-circlenav li.active").attr("value") is "circle"
            @airpie.setOption(option2)
        else @airpie.setOption(option1)
                            
                            
   

    module.exports = map