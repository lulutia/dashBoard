
/**
 * lulutia
 * Version: 0.0.1
 * Copyright 2015 - 2015 
 */
 define(function(require,a,b){"use strict";var c,d;return d={},c=require("echarts"),d.init=function(){return d.maping(),d.getData()},d.maping=function(){return this.mapCity={SH:"上海",BJ:"北京",GZ:"广州"}},d.getData=function(){return $.ajax({type:"get",url:"./data/test.json",dataType:"json",success:function(a,b){var c,e,f,g,h,i;for(c={NAME:["SH","BJ","GZ"],SH:[],BJ:[],GZ:[],DATE:[]},i=a.Sheet1,f=e=0,h=i.length;h>e;f=++e)g=i[f],c.SH.push(parseFloat(g.上海)),c.BJ.push(parseFloat(g.北京)),c.GZ.push(parseFloat(g.广州)),c.DATE.push(g.日期);return d.initChart(c)},error:function(a,b){return console.log(b)}})},d.initChart=function(a){var b,e,f,g,h,i,j,k;for(this.airchart=c.init(document.getElementById("air_chart")),j=[],f=[],i=a.NAME,b=0,g=i.length;g>b;b++)e=i[b],k={},k.name=d.mapCity[e],k.type="line",k.smooth=!0,k.data=a[e],k.markPoint={data:[{type:"max",name:"最大值"},{type:"min",name:"最小值"}]},k.markLine={data:[{type:"average",name:"平均值"}]},f.push(d.mapCity[e]),j.push(k);return h={tooltip:{show:!0,trigger:"axis"},legend:{data:f},xAxis:[{type:"category",boundaryGap:!1,axisTick:{show:!0,interval:0},data:a.DATE}],yAxis:[{type:"value"},{type:"value"}],series:j},this.airchart.setOption(h)},b.exports=d});