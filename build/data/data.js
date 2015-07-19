var fs = require('fs')
if(typeof require !== 'undefined') 
	XLSX = require('xlsx');
var workbook = XLSX.readFile('aqidata.xlsx');
var result = {};  
workbook.SheetNames.forEach(function(sheetName) {  
   var roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);  
   if(roa.length > 0){  
       result[sheetName] = roa;  
   }  
});
fs.writeFile("test.json",JSON.stringify(result))  

//@下面这种方法取值的方式和grunt的比较像，很奇怪时间那个值会错掉，总体来说还是上面这种比较方便
// var xlsx = require('node-xlsx');
// var obj = xlsx.parse(""+ 'aqidata.xlsx');
// fs.writeFile("test1.json",JSON.stringify(obj)) 