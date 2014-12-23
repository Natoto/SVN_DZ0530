
var deviceid;
var cacheExpireTime = 86400;//86400
var pageSize=10;
var timeoutAjax = 20000;
var ecode_no=0;
var ecode_net=-1;
var ecode_parse = -2;
var ecode_timeout= -3;
var  pluginURL = (function()
	{
		if (hy && hy==1) {
			return dataUrl;
		}
		else {
			return "../";
		}
	}())
	
function setItem(key,data){
	localStorage.setItem(key,data);
}
function getItem(key){
	return localStorage.getItem(key);
}
function clearItem(key){
	return localStorage.removeItem(key);
}
function getDate(dateTimeStamp) //获取日期
	{
		 //JavaScript函数：
		 dateTimeStamp = dateTimeStamp*1000;
		var minute = 1000 * 60;
		var hour = minute * 60;
		var day = hour * 24;
		var halfamonth = day * 15;
		var month = day * 30;

		var now = new Date().getTime();
		var diffValue = now - dateTimeStamp;
		if(diffValue < 0){
		 //若日期不符则弹出窗口告之
		 //alert("结束日期不能小于开始日期！");
		 }
		var monthC =diffValue/month;
		var weekC =diffValue/(7*day);
		var dayC =diffValue/day;
		var hourC =diffValue/hour;
		var minC =diffValue/minute;
		if(monthC>=1){
		 result=parseInt(monthC) + "个月前";
		 }
		 else if(weekC>=1){
		 result=parseInt(weekC) + "周前";
		 }
		 else if(dayC>=1){
		 result=parseInt(dayC) +"天前";
		 }
		 else if(hourC>=1){
		 result=parseInt(hourC) +"个小时前";
		 }
		 else if(minC>=1){
		 result=parseInt(minC) +"分钟前";
		 }else
		 result="刚刚发表";
		return result;
	}


function getArticleDate(dateTimeStamp) //获取日期
	{
		 //JavaScript函数：
		 dateTimeStamp = dateTimeStamp*1000;
		var minute = 1000 * 60;
		var hour = minute * 60;
		var day = hour * 24;
		var halfamonth = day * 15;
		var month = day * 30;

		var now = new Date().getTime();
		var diffValue = now - dateTimeStamp;
		if(diffValue < 0){
		 //若日期不符则弹出窗口告之
		 //alert("结束日期不能小于开始日期！");
		 }
		var monthC =diffValue/month;
		var weekC =diffValue/(7*day);
		var dayC =diffValue/day;
		var hourC =diffValue/hour;
		var minC =diffValue/minute;
		if(monthC>=1){
		 result=parseInt(monthC) + "个月前";
		 }
		 else if(weekC>=1){
		 result=parseInt(weekC) + "周前";
		 }
		 else if(dayC>=1){
		 result=parseInt(dayC) +"天前";
		 }
		 else if(hourC>=1){
		 result=parseInt(hourC) +"个小时前";
		 }
		 else if(minC>=1){
		 result=parseInt(minC) +"分钟前";
		 }else
		 result="刚刚发表";
		return result;
	}


function getTimestamp(){
	var timestamp1 =Date.parse(new Date());
	
	return timestamp1/1000;
}

function checkConnection() {
	var networkState = navigator.network.connection.type;
	if (networkState == Connection.NONE) {
		navigator.notification.confirm('请确认网络连接已开启,并重试', showAlert, '提示',
				'确定');
		return false;
	}else{
		return true;
	}
}