
/**
 * lulutia
 * Version: 0.0.1
 * Copyright 2015 - 2015 
 */
 require.config({baseUrl:"./",waitSeconds:0,paths:{jquery:"vendor/jquery/dist/jquery",echarts:"vendor/echarts/build/dist/echarts-all"},shim:{echarts:{exports:"echarts"}}}),require(["jquery","./js/play"],function(a,b){return b.init()});