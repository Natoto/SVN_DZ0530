var listPageScroll,listHorizenScroll;
var deviceid;
var  address = (function()
	{
		if (hy && hy==1) {
			return dataUrl;
		}
		else {
			return "../";
		}
	}())



var ip = window.location.host;

$(function() 
{
	$('.backStep,.back,.cancel').length && (function()
	{
		$('.backStep,.back,.cancel').click(function()
		{
			history.back();
		})
	}());

	$('.homeTitle').length && $('.homeTitle').text(appName);
	$('#leftMenu_wrap dt').length && $('#leftMenu_wrap dt').eq(0).text(appName);

// $('.list_item').length && (function()
// {
// 	$('.list_item').click(function()
// 	{
// 		var _this = $(this);
// 		_this.css('background','#000');
// 	})
	
// }())

$('#rightMenu').length && (function()
{
	$('.refreshIcon').click(function()
	{
		location.reload();
	})
	

}())

});




 //取列表数据
 function getHomeArticle(type,url,page,key,callback,container,pagination)
{
	type = type || 1;
	page=page || 1;

	if(url.charAt(url.length - 1)=='=')
		url+=type;
	
	$.ajax({ 

			url:url,
			type:'post',
			async:false,
			success:function(data)
			{

				var json = JSON.parse(data),
					values = json[key],fragment='';
					
					sessionStorage.setItem('isEnd',0);
					if(json.isEnd && json.isEnd==1)
					{
						sessionStorage.setItem('isEnd',1);
						// console.log('do');
					}
					

					if(json.totalPage && json.totalPage<page)
					{

						setTimeout(function()
						{
							$('.loadingDiv').hide();
						},300)
						//最后一页
						if(pagination)
						{
							// console.log(pagination);
							if(!$('.nothing',container).length)
							{
								container.append('<div class="nothing">已经到最后一页</div>');
							}
							else
							{
								container.children().find('.nothing').show();
							}
						}

						if(listHorizenScroll)
						listHorizenScroll.scrollers[type-1].refresh();

						return;
					}
						


				if(values)
				{
					// console.log(values);
					$.each(values,function(i,val)
					{

						var img1 = val.img1,
							img2 = val.img2,
							img3 = val.img3,
							pdate = val.date.toString().indexOf('年')>0?val.date:getDate(val.date);



						if(img1 && !img2)
						{
							fragment+='<div class="list_item clearfix ">'+
									'<a href="'+'content.html?post_id='+(val.ID?val.ID:val.aid)+'">'+
										'<div class="list_item_left">'+
											'<h3>'+val.title+'</h3>'+
											'<p class="clearfix f666 f12 mt5">'+
												'<span class="fl ainfo">'+
													'<span class="stores">'+val.favorite_count+'</span>'+
													'<span class="comments">'+val.comment_count+'</span>'+
												'</span>'+	
												'<span class="fr pdate">'+pdate+'</span>'+
											'</p>'+
										'</div>'+
										'<div class="imgdiv">'+
											'<img src="'+img1+'" alt="" width="90">'+
										'</div>'+
									'</a>'+
								'</div>';
						}
						else if(!img1)
						{
							fragment+='<div class="list_item clearfix ">'+
									'<a href="'+'content.html?post_id='+(val.ID?val.ID:val.aid)+'">'+
										'<div class="list_item_left">'+
											'<h3>'+val.title+'</h3>'+
											'<p class="clearfix f666 f12 mt5">'+
												'<span class="fl ainfo">'+
													'<span class="stores">'+val.favorite_count+'</span>'+
													'<span class="comments">'+val.comment_count+'</span>'+
												'</span>'+	
												'<span class="fr pdate">'+pdate+'</span>'+
											'</p>'+
										'</div>'+
									'</a>'+
								'</div>';
						}
						else
						{
							fragment+='<div class="list_item clearfix ">'+
										'<a href="'+'content.html?post_id='+(val.ID?val.ID:val.aid)+'">'+
											'<div class="list_item_left">'+
												'<h3>'+val.title+'</h3>'+
												'<div class="imgs">'+
													'<li><img src="'+img1+'" alt="" width="85"></li>'+
													'<li><img src="'+img2+'" alt="" width="85"></li>'+
													(img3?'<li><img src="'+img3+'" alt="" width="85"></li>':'')+
												'</div>'+
												'<p class="clearfix f666 f12 mt5">'+
													'<span class="fl ainfo">'+
													'<span class="stores">'+val.favorite_count+'</span>'+
													'<span class="comments">'+val.comment_count+'</span>'+
													'</span>'+	
													'<span class="fr pdate">'+pdate+'</span>'+
												'</p>'+
											'</div>'+
										'</a>'+
									'</div>'
						}
					})
					

					if(!container)
						$('.aList').eq(type-1).find('.innerScroll').append(fragment);

					else
						container.append(fragment);


					$('.list_item a').click(function()
					{
						var _this = $(this);
						_this.addClass('hover');
					})
				



					if(listHorizenScroll)
						listHorizenScroll.scrollers[type-1].refresh();

					setTimeout(function()
					{
						$('.loadingDiv').hide();
					},300)

				}

				if($('#mystore').length)
				{
					if(!$('.list_item',$('#mystore')).length)
					{
						$('#mystore .retult').append('<div class="tc" style="color:#666;">暂时没有文章收藏</div>')
					}
				}

			},
			error:function(e)
			{
				if(!$('.nothing',container).length)
				{
					//container.append('<div class="nothing">已经到最后一页</div>');
				}
				else
				{
					//container.children().find('.nothing').show();
				}	
			}
		});


	if(callback)
	{
		callback();	
	}

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


function getQueryString(name) { //抓地址栏参数
   
	   var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	   var r = window.location.search.substr(1).match(reg);
	   if (r != null) return unescape(r[2]); return null;
	  }


//滚动条
function getScrollTop(){
		var scrollTop = 0, bodyScrollTop = 0, documentScrollTop = 0;
		if(document.body){
		bodyScrollTop = document.body.scrollTop;
		}
		if(document.documentElement){
		documentScrollTop = document.documentElement.scrollTop;
		}
		scrollTop = (bodyScrollTop - documentScrollTop > 0) ? bodyScrollTop : documentScrollTop;
		return scrollTop;
	}


	function getScrollHeight(){
		var scrollHeight = 0, bodyScrollHeight = 0, documentScrollHeight = 0;
		if(document.body){
		bodyScrollHeight = document.body.scrollHeight;
		}
		if(document.documentElement){
		documentScrollHeight = document.documentElement.scrollHeight;
		}
		scrollHeight = (bodyScrollHeight - documentScrollHeight > 0) ? bodyScrollHeight : documentScrollHeight;
		return scrollHeight;
	}
		
		

	function getWindowHeight(){
		var windowHeight = 0;
		if(document.compatMode == "CSS1Compat"){
		windowHeight = document.documentElement.clientHeight;
		}else{
		windowHeight = document.body.clientHeight;
		}
		return windowHeight;
	}

	window.onscroll = function(){
		if(getScrollTop() + getWindowHeight() == getScrollHeight()){ //滚动条到底部,加载更多					
			$('.loadingDiv').show();	
			if($('#searchV').length)//搜索分页
			{
				var items = Math.ceil($('.list_item').length/10)+1;
				var container=$('.retult');
				var s=escape(getQueryString('s'));
				var url = '../status.php?action=search&ostype=-1&paged='+items+'&pageSize=10&s='+s;
				getHomeArticle(1,url,items,'search',function(){//回调函数

					$('.ainfo').hide();
					$('.pdate').attr('class','fl');
					$('.resultText span').text($('.list_item').length);
					setTimeout(function()
					{
						$('.loadingDiv').hide();
					},300)

				},container)
			}	

			if($('.pinlun').length) //评论分页
			{
				var pinlun_nums = $('.commentList li').length,
					page = Math.ceil(pinlun_nums/10)+1;
				getComment(page);
			}
			//收藏分页
			if($('#mystore').length)
			{
				var nums = $('.list_item').length,
					page = Math.ceil(nums/10)+1;

					getHomeArticle(1,address + 'status.php?action=myfavorites&ostype=-1&ip='+ip,page,'myfavorites',function()
					{
						$('.ainfo').hide();
						$('.pdate').attr('class','fl');
					},$('.retult'),1);

			}
				
		}
	}



