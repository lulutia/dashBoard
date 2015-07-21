
/**
 * lulutia
 * Version: 0.0.1
 * Copyright 2015 - 2015 
 */
 define(function(require,a,b){"use strict";var c,d;return c=require("echarts"),d={},d.init=function(){return this.getData()},d.getData=function(){return $.ajax({type:"get",url:"./data/test.json",dataType:"json",success:function(a,b){return $.ajax({type:"get",url:"./data/country.json",dataType:"json",success:function(a,b){return console.log(a)}})}})},b.exports=d});