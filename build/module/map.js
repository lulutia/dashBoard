
/**
 * lulutia
 * Version: 0.0.1
 * Copyright 2015 - 2015 
 */
 define(function(require,a,b){"use strict";var c;return c={},c.init=function(){return c.getData()},c.getData=function(){return $.ajax({type:"get",url:"./data/test.json",dataType:"jsoon",success:function(a,b){return console.log("s")}})},b.exports=c});