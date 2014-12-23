// JavaScript Document
var aid; //文章id

//雨银
function getTopList(type, page, onNetResult){
	page=page || 1;
	var cid = type || 1;
	var url = pluginURL + 'status.php?action=home&ostype=-1'+'&page='+page+'&pageSize='+pageSize +'&type=' + cid ;
	var topList='';	

	var ajaxTimeoutTest=$.ajax({ 
			url:url,
			type:'post',
			timeout:timeoutAjax,
			contentType:"application/json",
			success:function(data){
					var json = $.parseJSON(data);
					var jsondata = json["home"],fragment='';
					var errCode = ecode_parse;
					var totalPage = 0;
					var isEnd = 0;
				if(json.isEnd && json.isEnd==1){
						isEnd = 1;
						//$('#infinite1').html('最后一页');
						//setTimeout(function()
						//{
					//		$('#infinite1').hide();
					//	},2000);

				}
				totalPage = json.totalPage;
				if(json.totalPage && json.totalPage>page){
					if(jsondata){
											
					for(var i=0;i<jsondata.length;i++){	
							fragment+=getArticleListHtml(jsondata[i]);						
						}		
								
						if (page == 1) {
							setItem("topList"+cid,fragment);
							setItem("topList"+cid+'_time',getTimestamp());				
							setItem("topList"+cid+'_length',jsondata.length)
						}

						//$("#main_panelLoading").hide();  //隐藏loading	
						
						errCode=ecode_no;
						
					}
				}
				if (onNetResult) {
						onNetResult(errCode, page, fragment, totalPage, isEnd);
				}
			},
			error : function(XMLHttpRequest,status){ 
		　　　　if(status=='error'){
		　　　　　 onNetResult(ecode_net, page, "", 0, 0);
		　　　　}
						else if (status=='timeout'){
								onNetResult(ecode_timeout, page, "", 0, 0);
		 　　　　　 ajaxTimeoutTest.abort();	　　　　　 	
		　　　　}
					}		
		});
}
function getTopListMore(type, slector, cbUISucess){	

	var nums = $(slector).length;
	var page = Math.ceil(nums/pageSize)+1;
	
	getTopList(type, page,cbUISucess);
}
function R_NetPageResult(slector, selLoading, callback) {
		var thatSlector = slector;
		var thatSelLoading = selLoading;
		this.onNetResult = function(errCode, page,fragment){
				var container = $(thatSlector);
			  if (errCode == 0 && container) {
					if (page == 1) {
						container.html(fragment);
					}
					else  {
						container.append(fragment);
					}		
				}
				if (thatSelLoading) {
					$(thatSelLoading).hide();
				}
				if (callback) {
					callback();
				}
		};
}

function getTopListFirst(type, firstFromCache, slector,cbUICallBack,selLoding){
	var cid=type || 1;
	
	setItem('topList_cid',cid);   //写入localstorage
	//$(slector).html('');	//清空html	
	if (selLoding) {
		$(selLoding).show();	  //显示加载框
	}
	if(firstFromCache &&getItem("topList"+cid)&&getItem("topList"+cid+'_time')&&(getTimestamp()-getItem("topList"+cid+'_time'))<cacheExpireTime){
		$(slector).html(getItem("topList"+cid));
		if (selLoding) {
			$(selLoding).hide();  //隐藏loading
		}
		if (cbUICallBack)cbUICallBack();
	}else{
		var cb = cbUICallBack;
		if (selLoding) {
			cb = new R_NetPageResult(slector,selLoding,cbUICallBack).onNetResult;
		}
		getTopList(cid, 1, cb);	
	}
}

//获取文章左侧的分类数据
function getPortalCate(){	

	if(getItem('sidePortalCate')&&getItem('getPortalCate_time')&&(getTimestamp()-getItem('getPortalCate_time'))<cacheExpireTime){
		var sidePortalCateStr=getItem('sidePortalCate');		
		$('#sidePortalCate').append(sidePortalCateStr);

		if(getItem('storeCount'))
		{
			$('.ii2 b').html('('+getItem('storeCount')+')');
		}

	}else{

		$.ajax({ 
			url:pluginURL+'status.php?action=categories&ostype=-1',
			type:'post',
			timeout:timeoutAjax,
			contentType:"application/json",
			success:function(data){
		
				data = JSON.parse(data);
				var sidePortalCateStr='';
				var jsondata=data['categories'];
				//侧边栏
				for(var i=0;i<jsondata.length;i++){				
					sidePortalCateStr+="<li onclick=\"navPortalListGet('"+jsondata[i].cat_ID+"')\">";	
					sidePortalCateStr+="<a href='#portal_panel' onclick=\"setItem('portal_title','"+jsondata[i].name+"')\">"+jsondata[i].name+'</a></li>';			
				}	
				
				$('#sidePortalCate').append(sidePortalCateStr);

				if(getItem('storeCount')) //读取我的收藏条数
				{
					$('.ii2 b').html('('+getItem('storeCount')+')');
				}
				else
				{
					mystore_List_load();
					$('.ii2 b').html('('+getItem('storeCount')+')');
				}
								
				//写入缓存
				setItem('sidePortalCate',sidePortalCateStr);				
				setItem('getPortalCate_time',getTimestamp());  //写入缓存的时候顺便写入缓存的时
			},
			error : function(XMLHttpRequest,status){ 
		　　　　if(status=='error'){
		　　　　　 onNetResult(ecode_net, page, "", 0, 0);
		　　　　}
				else if (status=='timeout'){
					onNetResult(ecode_timeout, page, "", 0, 0);
		 　　　　　 ajaxTimeoutTest.abort();	　　　　　 	
		　　　　}
			}
		});				
		
	}
}


function getArticleListHtml(jsondata,storePage)
{
	var tmp='',portalList='';
	tmp += '<p class="clearfix f666 f12 mt5">';
	if(!storePage)
	{
		tmp += '<span class="fl ainfo">';
		tmp += '<span class="stores">'+jsondata.favorite_count+'</span>';
		tmp += '<span class="comments">'+jsondata.comment_count+'</span>';	
		tmp += '</span>';
		tmp += '<span class="fr pdate">'+getDate(jsondata.date)+'</span>';
	}
	else
		tmp += '<span class="pdate">'+getDate(jsondata.date)+'</span>';
	tmp += '</p></div>';

	/* 
		tmp的结构:<p class="clearfix f666 f12 mt5">
					<span class="fl ainfo">
						<span class="stores">0</span>
						<span class="comments">0</span>
					</span>
					<span class="fr pdate">4周前</span>
				   </p>

	*/

	portalList+="<li class='list_item clearfix' onclick=\"setItem('portal_content_aid','"+(jsondata.ID || jsondata.aid)+"')\">";					
	portalList+="<a href='#portal_content_panel'>";
	

	if(jsondata.img1 && !jsondata.img2){ //只有一张图片
			//portalList+='<div class="imgdiv"><img src="" alt="" width="90"></div>';
			portalList+='<div class="list_item_left">';
			portalList+='<h3>'+jsondata.title+'</h3>';
			portalList+= tmp ;
			portalList+='<div class="imgdiv">';
			portalList+='<img src="'+jsondata.img1+'" width="90" /></div>';
	}	
	else if(jsondata.img1 && jsondata.img2 && jsondata.img3)	//有三张图片
	{
		portalList+='<div class="list_item_div">';
		portalList+='<h3>'+jsondata.title+'</h3>';
		portalList+= '<div class="imgs">';
		portalList+= '<span class="block"><img src="'+jsondata.img1+'" width="85"/></span>';
		portalList+= '<span class="block"><img src="'+jsondata.img2+'"  width="85"/></span>';
		portalList+= '<span class="block"><img src="'+jsondata.img3+'"  width="85"/></span>';
		portalList+= '</div>';
		portalList+= tmp+'</div>' ;
	}
	else
	{
		portalList+='<div class="list_item_div">';
		portalList+='<h3>'+jsondata.title+'</h3>';
		portalList+= tmp+'</div>' ;
	}					

	return portalList;
	
}
//文章列表
function portal_list_load(){
	
	$.ui.slideSideMenu = true;

}

function portal_list_uload(){	
	portalPage=2;
	$.ui.slideSideMenu = false;
}


//获取评论列表
function getComment(page,aid,loadmore,onNetResult)
{
		$.ajax({ 
			url:pluginURL+'status.php?action=comments&ostype=-1&post_id='+aid+'&pageSize=10&page='+page,
			type:'post',
			timeout:timeoutAjax,
			contentType:"application/json",
			success:function(json){

				json = JSON.parse(json);
				var isEnd = 0,
					totalPage=0,
					errCode = ecode_parse;	

				if(json.isEnd && json.isEnd==1)
				{
					isEnd = 1;
					setItem("portal_content_aid"+aid+"_isEnd",1);
				}

				if(json.totalPage && json.totalPage>=page)
				{
						now = $('.commentList li').length?$('.commentList li:last-child').find('.lou').children('b').text():0,//获取上一页最后页码
						values = json.comments,fragment=$('.pinlunTT').length?"":'<div class="pinlun"><div class="pinlunTT"></div><div class="commentList"><ul class="m10">';
						 $('.comm_after').html(json.comments_count);

						sessionStorage.setItem('lastPage',json.isEnd);
						$.each(values,function(i,val)
						{
							var purl,imgurl,
								curpage = now?now*1+i*1:i,
								author =  val.comment_author,sayto = author.indexOf('对')>0?1:0,
								newName = val.comment_author.indexOf('对')>0?val.comment_author.substr(0,val.comment_author.indexOf('对')):val.comment_author;

							if(val.author_url) //有网址
							{
								if(sayto)//对某人回复
								{
									var au = author.substr(0,author.indexOf('对'));//回复人
									var toPerson = author.substr(author.indexOf('对')+1);//被回复人
									purl = '<a href="'+val.author_url+'" class="b10">'+au+'</a><label class="b10">对&nbsp;<b>'+toPerson+'</b></label>';
									imgurl='<a href="'+val.author_url+'">'+'<img src="'+val.avatar+'" alt="" class="au_head img_radius fl" width="36">'+'</a>'
								}
								else //对文章回复
								{
									purl = '<a href="'+val.author_url+'">'+val.comment_author+'</a>';
									imgurl='<a href="'+val.author_url+'">'+'<img src="'+val.avatar+'" alt="" class="au_head img_radius fl" width="36">'+'</a>'
								}
								
							}else //没有网址
							{

								purl = '<label class="vm">'+val.comment_author+'</label>';
								imgurl = '<img src="'+val.avatar+'" alt="" class="au_head img_radius fl" width="36">';
							}
							fragment+="<li>"+
									"<div class='clearfix'>"+
										"<div class='cListHd fl'>"+
											"<div class='clearfix'>"+ imgurl+
												"<div class='au_text fr ml10'>"+
													"<p class='au_say'>"+purl+"<b class='vm'>说：</b></p>"+
													"<p class='f999 f12'>"+getDate(val.date)+"</p>"+
												"</div>"+
											"</div>"+
										"</div>"+
										"<div class='rText fr'>"+
											"<span class='goods' data-comment_id="+val.comment_ID+">"+val.digg_count+"</span>"+
											"<a href='#comment_panel'  onclick=\"setItem('sayTo','"+newName+"')\">&nbsp;|&nbsp;回复</a>"+
										"</div>"+
									"</div>"+
									"<p class='mt5'>"+
										"<span class='ml10 mr20 lou'><b>"+(curpage+1)+"</b>楼</span>"+val.comment_content+
									"</p>"+
								"</li>"

						});
						
						//给文章评论数，收藏数赋值
						errCode=ecode_no;
						$('.replies b').text(json.comments_count);
						if(!$('.pinlunTT').length && !$('.commentList ul').length)
						{
							fragment+='</ul></div></div>';
						}

						if($('.commentList ul').length && !onNetResult)
						{
							$('.commentList ul').append(fragment);
						}
						else if(!onNetResult)
							$('#punlin').append(fragment);

						
						$('.comm').data('num',json.comments_count);

						//如果没有评论信息，则隐藏'全部评论'提示
						if(!$('.commentList li').length)
						{
							$('.pinlunTT').hide();
						}

						$('.goods').click(function()//点赞
						{
							var comment_id = $(this).data('comment_id'),_this=$(this);
							_this.addClass('on');	
							$.ajax({

								url:pluginURL + 'status.php?action=digg&ostype=-1&aid='+getItem('portal_content_aid')+'&fid='+comment_id,
								type:'post',
				
								success:function(data)
								{
									var json = JSON.parse(data);
									if(!json.emsg)
										_this.text(_this.text()*1+1)
									else
										alert(json.emsg);
								}
							});
						})

						
					}
					
					if (onNetResult) {
							// console.log('dddd')
							onNetResult(errCode, page, fragment, totalPage, isEnd);
						}	
				},
				error : function(XMLHttpRequest,status){ 
		　　　　if(status=='error'){
		　　　　　 onNetResult(ecode_net, page, "", 0, 0);
		　　　　}
				else if (status=='timeout'){
					onNetResult(ecode_timeout, page, "", 0, 0);
		 　　　　　 ajaxTimeoutTest.abort();	　　　　　 	
		　　　　}
			}
		});
}


//开启夜间模式
function setNightModel()
{
	//夜间模式
	if(getItem('night')==1)
	{
		$('<link>').attr({'href':'css/night.css','id':'nightcss','rel':'stylesheet'}).appendTo('head');
		$('.radio').addClass('on');
	}
	else
	{
		$('#content').css('background','#fff');
		$('#nightcss').remove();
		$('.radio').removeClass('on');
	}

	$('.radio').click(function()
	{
		var _this = $(this);
		_this.toggleClass('on');
		if(_this.hasClass('on'))
		{
			setItem('night',1);
			if(getItem('night')==1)
			{
				$('<link>').attr({'href':'css/night.css','id':'nightcss','rel':'stylesheet'}).appendTo('head');
				$('.radio').addClass('on');
			}
		}
		else
		{
			setItem('night',0);
			$('#nightcss').remove();
			location.reload();
		}

		$('#setMenu,.maskLayer').hide();
		$('.pmenu').removeClass('on');
			
	});

}


//设置字体大小

function setFont()
{
	//默认字体大小为'中'
	if(sessionStorage.getItem('fontSize')==null)
	{
		sessionStorage.setItem('fontSize','16px')
		$('.fontsize span').eq(1).addClass('on').siblings().removeClass('on');
	}

	if(sessionStorage.getItem('fontSize'))
	{
		if(sessionStorage.getItem('fontSize')=='16px')
		{
			$('.fontsize span').eq(1).addClass('on').siblings().removeClass('on');
			$('<link>').attr({'href':'css/middle.css','id':'middle','rel':'stylesheet'}).appendTo('head');
		}
		else if(sessionStorage.getItem('fontSize')=='18px')
		{
			$('.fontsize span').eq(2).addClass('on').siblings().removeClass('on');
			$('<link>').attr({'href':'css/large.css','id':'large','rel':'stylesheet'}).appendTo('head');
		}
	}
	$('.fontsize span').unbind('click');
	$('.fontsize span').click(function()
	{
		var _this = $(this),
			index = _this.index();
		$('.fontsize span').removeClass('on');
		_this.toggleClass('on');

		if(index==0)
			sessionStorage.setItem("fontSize", "14px")
		else if(index==1)
			sessionStorage.setItem("fontSize", "16px")
		else
			sessionStorage.setItem("fontSize", "18px")

		$('#setMenu,.maskLayer').hide();
		$('.pmenu').removeClass('on');

		location.reload();

	});

}
//弹出菜单
var target={};
	target.id='';
function popMenu(thing)
{
	var _maskLayer = $('.maskLayer');
	if(_maskLayer.css('display')=='block' && target[0].id==thing[0].id)
		_maskLayer.hide();
	else
	{
		if(_maskLayer.length)
		{
			_maskLayer.show();
		}
		else
		{
			$('#contentfooter').append('<div class="maskLayer" style="position:fixed;top:0;width:100%;background:rgba(0,0,0,.5);height:'+$(window).height()+'px;z-index:180;"></div>');

			_maskLayer = $('.maskLayer');
		}
	}

	_maskLayer.click(function()
	{
		thing.hide();
		_maskLayer.hide();
		$('.pmenu').removeClass('on')

	});	

	thing.toggle();
	target=thing;
}


//设置弹出菜单

function setPopMenu()
{
	$('.pmenu').unbind('click');
	$('.pmenu').click(function()
	{
		if($('#shareMenu').css('display')=='block')
		{
			$('#shareMenu').hide();	
			$('.share').removeClass('on');
		}
		popMenu($('#setMenu'));
		$(this).toggleClass('on');
	})

	// 分享菜单
	$('.share').click(function()
	{
		if($('#setMenu').css('display')=='block')
		{
			$('#setMenu').hide();	
			$('.pmenu').removeClass('on');
		}

		var _this = $(this);
		popMenu($('#shareMenu'));
		$(this).toggleClass('on');

	});
}

/*文章详情页面加载*/

function portal_content_load(){	
	if (articlePull2Refresh)articlePull2Refresh.reset();
	$('.stars').removeClass('on');
	$("#portalContentLoading").show();
	aid=getItem('portal_content_aid');
	setItem("portal_content_aid"+aid+"_isEnd",0);
	$.ajax({ 
			url:pluginURL+'status.php?action=postlist&ostype=-1&post_id='+aid,
			type:'post',
			timeout:timeoutAjax,
			contentType:"application/json",
			success:function(json){

			json = JSON.parse(json);
			console.log(json);
			$("#p_content_title").html(json['postlist']['title']);
			$(".articleTitle p").html(json['postlist']['date']);
			$("#p_content").html(json['postlist']['content']+'<div class="tc mt20"> <span class="love mr40"><b>'+json['postlist'].favorites_count+'</b>人喜欢</span> <span class="replies"><b>'+json['postlist'].comment_count+'</b>人评论</span>');
			$("#portalContentLoading").hide();
			$('.stars').html(json['postlist'].favorites_count);
			if(json.hasFavorites)
			{
				$('.stars').html('1').addClass('on');
			}
		}
	});

	getComment(1,aid); //评论内容
	setPopMenu(); //设置弹出菜单
	setFont();//设置字体大小
	setNightModel();//开启夜间模式

	$('.comm').click(function()
	{
		setItem('sayTo','');
	})
	$('.stars').unbind('click');
	$('.stars').click(function() //添加/取消收藏
	{
		var _this = $(this),
			num = _this.text()*1;

		if(_this.hasClass('on')) //取消收藏
		{
			$.ajax({ 
					url:pluginURL+'status.php?action=delfavorites&ostype=-1&aid='+aid+'&ip='+deviceid,	
					type:'post',
					timeout:timeoutAjax,
					contentType:"application/json",
					success:function(json){

					json = JSON.parse(json);
					if(json.emsg=='')
					{
						$('.love b,.stars').removeClass('on').text($('.stars').text()*1-1);
						setItem('hasNewStore',0);
						setItem('storeCount',getItem('storeCount')*1-1)
						alert('已取消收藏');
					}
				},
				error : function(XMLHttpRequest,status){ 
		　　　　if(status=='error'){
		　　　　　 onNetResult(ecode_net, page, "", 0, 0);
		　　　　}
				else if (status=='timeout'){
						onNetResult(ecode_timeout, page, "", 0, 0);
		 　　　　　 ajaxTimeoutTest.abort();	　　　　　 	
		　　　　}
			}
			});
			return false;
		}

		_this.addClass('on');

		$.ajax({ 
				url:pluginURL+'status.php?action=favorites&ostype=-1&aid='+aid+'&ip='+deviceid,	
				type:'post',
				timeout:timeoutAjax,
				contentType:"application/json",
				success:function(json){
		
					json = JSON.parse(json);
					if(json.emsg=='')
					{
						var curno = $('.stars').text()*1;
						$('.love b,.stars').text(curno+1);
						setItem('hasNewStore',1);
						setItem('storeCount',getItem('storeCount')*1+1)
						alert('文章已收藏');
					}
					else
					{
						alert(json.emsg);
					}
				},

				error : function(XMLHttpRequest,status){ 
		　　　　if(status=='error'){
		　　　　　 onNetResult(ecode_net, page, "", 0, 0);
		　　　　}
				else if (status=='timeout'){
						onNetResult(ecode_timeout, page, "", 0, 0);
		 　　　　　 ajaxTimeoutTest.abort();	　　　　　 	
		　　　　}
			}
		});

		return false;
	});

	$('.refreshIcon').unbind('click');
	$('.refreshIcon').click(function()
	{
		$.ui.updatePanel("#contentDIV");
	})

}
 //文章详情卸载
 function portal_content_uload()
 {
 	$('#p_content_title,#p_content,#punlin').html('');
 	setItem("portal_content_aid"+aid+"_isEnd",0);
 }
  
 //我的收藏

 function mystore_List_load()
 {
 	/*
		getItem('hasNewStore') 标识是否有新的收藏，如果没有直接读取缓存
 	 */
 	if(!getItem('hasNewStore')&&getItem('myStoreCate')&&getItem('myStoreCate_time')&&(getTimestamp()-getItem('myStoreCateCate_time'))<cacheExpireTime){
		var sidePortalCateStr=getItem('sidePortalCate');		
		$('#sidePortalCate').append(sidePortalCateStr);
	}else{

		$.ajax({ 
				url:pluginURL + 'status.php?action=myfavorites&ostype=-1&ip='+deviceid,
				type:'post',
				timeout:timeoutAjax,
				contentType:"application/json",
				success:function(data){

				data = JSON.parse(data);
				var fragment='';
				var jsondata=data['myfavorites'];	

				for(var i=0;i<jsondata.length;i++){	
					fragment+=getArticleListHtml(jsondata[i],'1');						
				}	

				setItem('storeCount',jsondata.length);
				$('#mystore_ul').html(fragment);
				//写入缓存
				setItem('myStoreCate',fragment);				
				setItem('myStoreCateCate_time',getTimestamp());  //写入缓存的时候顺便写入缓存的时间	
			},
			error : function(XMLHttpRequest,status){

		　　　　if(status=='error'){
		　　　　　 onNetResult(ecode_net, page, "", 0, 0);
		　　　　}
				else if (status=='timeout'){
						onNetResult(ecode_timeout, page, "", 0, 0);
		 　　　　　 ajaxTimeoutTest.abort();	　　　　　 	
		　　　　}
		}
	})
	}
 } 


 function search(url,fieldName,container,page,keytype,keyval) //归档搜索
 {
 	var dataCon = target.parent().find('.resultOpt');
 	
 	$.ajax({ 
 			url:url+'&page='+page,
 			type:'post',
 			timeout:timeoutAjax,
 			contentType:"application/json",
 			success:function(data){
	
			data = JSON.parse(data);
			var fragment='',
			jsondata = data[fieldName];	
			if(data.isEnd)
			{
				sessionStorage.setItem('isend',1);
			}
			for(var i=0;i<jsondata.length;i++)
			{
				fragment+=getArticleListHtml(jsondata[i],1);
			}	
			dataCon.html(fragment);
			target.parent().find('.resulttext span').text(dataCon.find('li').length);
			target.parent().find('.resulttext').show();


		//加载更多
		if(!data.isEnd && !dataCon.find('.loadMore').length)
		{
			dataCon.append('<span class="loadMore" data-keytype='+keytype+' data-keyval='+keyval+'>加载更多</span>')
		}
		
		else if(!data.isEnd && dataCon.find('.loadMore').length)
		{
			var ss = dataCon.find('.loadMore');
			
			ss.data('keyval',keyval).data('keytype',keytype);
			
			ss.appendTo(dataCon).show();
		}
		else
		{
			dataCon.find('.loadMore').hide();
		}
		//点击加载更多
		$('.loadMore').click(function() //加载更多
		{
			var _this = $(this);
			var thisPage = Math.ceil(_this.parent().find('li').length/10)+1;
			var newUrl = pluginURL + 'status.php?action=search&ostype=-1&paged='+thisPage+'&'+_this.data('keytype')+'='+_this.data('keyval');

			$.ajax({ 
	 			url:newUrl,
	 			type:'post',
	 			timeout:timeoutAjax,
	 			contentType:"application/json",
	 			success:function(json){

					var searchHtm='',jData;
					json = JSON.parse(json);
					jData = json['search'];

					for(var j=0;j<jData.length;j++)
					{
						searchHtm+=getArticleListHtml(jData[j],1);
					}

					_this.appendTo(dataCon);

					dataCon.append(searchHtm);

					if(json.isEnd==1)
					{
						$('.loadMore',dataCon).hide();
					}

				}
			});

		})
	}
});
 }

 //搜索页面
function bindEvent()
{
	//归档文章
	
	$('#storeDate li a').click(function()
	{
		target = $(this);
		$('#showDate').click();
		if($('#dateInputs').data("events"))
		{
			alert('event')
		}
		$('#dateInputs').unbind('input');
		$('#dateInputs').on('input',function(e)
		{
			target.text($('#dateInputs').val());
			target.data('m',target.text());

			search(pluginURL + 'status.php?action=search&ostype=-1&m='+target.data('m'),'search',target,1,'m',target.data('m'));
		})
		return false;
	})	
}

$('.seaInput').on('keyup',function(e)
{
	if(e.keyCode==13)
	{
		$('.btnsearches').click();	
	}
})
 function search_List_load()
 {
	getSearch(pluginURL + 'status.php?action=tagcloud&ostype=-1',$('#sign ul'),'tagcloud','term_id','tag')//标签云
	getSearch(pluginURL + 'status.php?action=archive&ostype=-1&pageSize=1',$('#storeDate ul'),'archive','m','text')//归档日期	
 }

function bindTagEvent()
{
	//标签下的文章
	 $('#sign li a').click(function()
	 {
	 	if(!$(this).data('hasClick'))
	 	{
	 		target = $(this);
	 		search(pluginURL + 'status.php?action=search&ostype=-1&tag='+$(this).text(),'search',$(this),1,'tag',$(this).text());
	 		$(this).data('hasClick',1)//(url,fieldName,container,page,keytype,keyval)
	 		$(this).toggleClass('checkOn');
	 		$(this).parent().find('.resulttext').show();
	 	}
	 	else
	 	{
	 		$(this).parent().find('.resultOpt').toggle();
	 		$(this).toggleClass('checkOn');
	 		if($(this).hasClass('checkOn'))
		 		$(this).parent().find('.resulttext').show();
		 	else
		 		$(this).parent().find('.resulttext').hide();
	 	}
	 	return false;
	 })
}
 


 function getSearch(url,container,fieldName,key1,key2)
 {
 	sessionStorage.setItem('isend',0)
 	if(getItem('searchCate')&&getItem('searchCateCate_time')&&(getTimestamp()-getItem('searchCateCate_time'))<3600){
 		if(container.parent().attr('id')=='storeDate')	
 		{
 			var searchStr=getItem('searchCate');			
			container.html(searchStr);	
			bindEvent();
 		}
 		else
 		{
 			var searchStr=getItem('searchCate2');			
			container.html(searchStr);	
			bindTagEvent();
 		}
			
	}
	else
	{	
	 	$.ajax({ 
	 			url:url,
				type:'post',
				timeout:timeoutAjax,
				contentType:"application/json",
				success:function(data)
	 			{
	 				var json = JSON.parse(data);
	 					values = json[fieldName],fragment='';
	 					if(container.parent().attr('id')=='storeDate')	
	 					{
	 						var datas = values[0];
	 						fragment+='<li><a href="#" id='+""+' data-m'+'='+datas['m']+'>'+datas['text']+'</a><p class="resulttext tc mt5" style="display:none;">共<span></span>条搜索结果</p><div class="resultOpt"></div></li>';
	 						container.html(fragment);
	 						bindEvent();
	 						setItem('searchCate',fragment);		
	 						return;	
	 					}
	 					else
	 						$.each(values,function(i,val)
	 						{
	 							fragment+='<li><a href="#" data-'+key1+'='+val[key1]+'>'+val[key2]+'</a><p class="resulttext tc mt5" style="display:none;">共<span></span>条搜索结果</p><div class="resultOpt"></div></li>';
	 						})

	 					container.html(fragment);
	 					bindTagEvent();

				 		//写入缓存
						setItem('searchCate2',fragment);				
						setItem('searchCateCate_time',getTimestamp());  //写入缓存的时候顺便写入缓存的时间
	 					
	 			}	
	 		})
	 	}
 	}

 function searchValue_List_load(page,loadmore)
 {
 	page =  page || 1;
 	var url = pluginURL + 'status.php?action=search&ostype=-1&pageSize=10&s='+sessionStorage.getItem('key');

 	if(sessionStorage.getItem('hasNoMore')==1)
 	{
 		$('#searchValue_panel #infinite1').hide();
 		return;
 	}
 	$.ajax(
 	{
 		url:url+'&paged='+page,
 		type:'post',
 		timeout:timeoutAjax,
		contentType:"application/json",
 		success:function(json)
 		{
	 		var searchHtm='',jData;
	 		json = JSON.parse(json);

	 		if(json.isEnd)
	 		{
	 			sessionStorage.setItem('hasNoMore',1);
	 		}
	 		else
	 		{
	 			sessionStorage.setItem('hasNoMore',0);
	 		}
	 		jData = json['search'];
	 		console.log(json);
	 		for(var j=0;j<jData.length;j++)
	 		{
	 			searchHtm+=getArticleListHtml(jData[j],1);
	 		}

	 		if(!loadmore)
		 		$('#search_ul').html(searchHtm);
		 	else
		 		$('#search_ul').append(searchHtm);

	 		var len = $('#search_ul').find('.list_item').length;
	 		$('#resultNum').show().find('span').text(len);
	 	},
	 	error:function()
	 	{
	 		alert('error');
	 	}
 	});
 }

$('.seaInput').change(function()
{
	sessionStorage.setItem('hasNoMore',0);
})


//搜索列表

function searchData_load()
{
	var key = $('.seaInput').val();
	if(!key)
	{
		$('.seaInput')[0].setCustomValidity('请输入关键字');
	}
	else
	{
		sessionStorage.setItem('key',key);
		if($('#search_panel').css('display')=='block')
			$.ui.loadContent('#searchValue_panel',false,false,'slide');
		else
		{
			searchValue_List_load();
		}
	}
}
  


  //匿名评论
  function commentList_load()
  {
  		String.prototype.trim=function(){
  	　　    return this.replace(/(^\s*)|(\s*$)/g, "");
  	　　 } 	

  		if(localStorage.getItem('noName_uname')!=null)
  		{
  			$('[name="author2"]').val(localStorage.getItem('noName_uname'));
  			$('[name="email"]').val(localStorage.getItem('noName_uemail'));
  			$('[name="url"]').val(localStorage.getItem('noName_url'));
  		}

  		$('.btnsubmit').removeAttr('disabled');

  		var trigger15sec=0;
  		//改变url
  		$('#comment_form').attr('action',pluginURL + 'status.php?action=comments_post&ostype=-1');

  		//post_id赋值
  		$('[name="post_id"]').val(getItem('portal_content_aid'));
  		$('.btnsubmit').unbind('click');
  		$('.btnsubmit').click(function()
  		{
  			if(sessionStorage.getItem('time')!=null)
  			{
  				var now = (new Date().getTime()-sessionStorage.getItem('time'))/1000;
  				if(now<15)
  				{
  					trigger15sec=1;
  					var nowtime=0,interval;

  					$('.btnsubmit').attr('disabled','disabled');

  					if($('.tipsdiv').length)
  					{
  						$('.tipsdiv').text('请在15秒后可再次评论,谢谢').show();
  					}
  					else
  					{
  						$('body').append('<div class="tipsdiv" style="position:absolute;width:100%;text-align:center;color:#fff;top:40px;background:rgba(0,0,0,.8);">请在15秒后可再次评论,谢谢</div>');
  					}

  					interval=setInterval(function()
  					{
  						nowtime++;

  						if(nowtime>15)
  						{
  							clearInterval(interval);
  							$('.btnsubmit').removeAttr('disabled');

  							return;
  						}
  						else if(nowtime==15)
  						{
  							$('.tipsdiv').hide();
  						}
  						
  						$('.tipsdiv').text('请在'+(15-nowtime)+'秒后可再次评论,谢谢');

  					},1000);

  					return;
  				}
  				else
  				{
  					$('.btnsubmit').removeAttr('disabled');
  					$('.btnsubmit').css({'background':'#6dbfbb','border-color':'#6dbfbb'})
  				}
  					
  			}
  			
  			if(!$('#textarea').val().trim())
  			{
  				alert('请输入内容...')
  				return false;
  			}	


  			if($('#comment_form')[0].checkValidity())
  			{
  				$('.btnsubmit').css({'background':'#ccc','border-color':'#ccc'});
  				if(getItem('sayTo'))
  				{		
  					$('[name="author"]').val($('[name="author2"]').val()+'对'+getItem('sayTo'));
  				}
  				else
  				{
  					$('[name="author"]').val($('[name="author2"]').val());
  				}	
  				localStorage.setItem('noName_uname',$('[name="author2"]').val());
  				localStorage.setItem('noName_uemail',$('[name="email"]').val());
  				localStorage.setItem('noName_url',$('[name="url"]').val());
  				sessionStorage.setItem('time',new Date().getTime());
  				if($('.tipsdiv').length)
  				{
  					$('.tipsdiv').text('评论已提交，15秒后可再次评论,3秒后自动跳回详情页').show();
  				}
  				else
  					$('#comment_panel').append('<div class="tipsdiv" style="position:absolute;z-index:200;width:100%;text-align:center;color:#fff;top:0px;background:rgba(0,0,0,.8);">评论已提交，15秒后可再次评论,3秒后自动跳回详情页</div>');

  				setTimeout(function()
  				{
  					$.ui.loadContent('#portal_content_panel',false,true,'slide');
  					$('.tipsdiv').hide();
  					$('.btnsubmit').css({'background':'#6dbfbb','border-color':'#6dbfbb'})
  					$('#textarea').val('');
  				},3000)
  			}
  		})
  		
  }

  $('[name="email"]').on('input',function(o)
  {
  	var value =o.target.value;
  	var value = value.charAt(value.length - 1);
  	var offsetTop = o.target.offsetTop;

  	if(value=='@')
  	{
  		$('.emailtype').show();
  	}
  	else if($('.emailtype').css('display')=='block')
  	{
  		$('.emailtype').hide();
  	}
  })

  $('#textarea').on('input',function()
  {
  	var len = $(this).val().length;
  	$('.rest').text(280-len);
  })


  $('[name="url"]').focus(function()
  {
  	var _this=$(this);
  	if(!_this.val())
  		_this.val('http://www.')
  })	


  $('.emailtype li').click(function()
  {
  	$('[name="email"]').val($('[name="email"]').val()+$(this).text());
  	$('.emailtype').hide();
  })


  function check()
  {
  	return true;
  }

//修改用户名
function myname_load()
  {
  	if($('#usname').text()!="未设置")
  		$('[name="authors"]').val($('#usname').text());

  	if($('#myemail').text()!='未设置')
  		$('[name="email2"]').val($('#myemail').text());

  	if($('#myurl').text()!='未设置')
	  	$('[name="url2"]').val($('#myurl').text());

  	if(sessionStorage.getItem('modify_type')==1)
  	{
  		$('#mynameheaderui .topTitle').text('我的昵称')
  	}
  	else if(sessionStorage.getItem('modify_type')==2)
  	{
  		$('#mynameheaderui .topTitle').text('我的邮箱')
  	}
  	else
  	{
  		$('#mynameheaderui .topTitle').text('我的网址')
  	}
  }

//加载用户信息
function myCount_List_load()
{
	var url = pluginURL + 'status.php?action=myaccount&ostype=-1';
	$.ajax(
	{
		url : url,
		type:'post',
		timeout:timeoutAjax,
		contentType:"application/json",
		success:function(json)
		{
			json = JSON.parse(json);
			var value = json['myaccount'];
			$('.setOptRight img').attr('src',value.avatar);
			$('#usname').text(value.comment_author || '未设置');
			$('#myemail').text(value.comment_author_email || '未设置');
			$('#myurl').text(value.comment_author_url || '未设置');
		}
	})
}

function changeHeadName(type)
{
	sessionStorage.setItem('modify_type',type);
}

//修改用户名

$('.store').click(function()
{

	var author = $('[name="authors"]').val();
	var email = $('[name="email2"]').val();
	var url = $('[name="url2"]').val();
	var type=sessionStorage.getItem('modify_type');
	var purl = pluginURL + 'status.php?action=myaccount&ostype=-1';

	if(type==1)
	{
		purl+='&author='+author;
	}
	else if(type==2)
	{
		purl+='&email='+email;
	}
	else
	{
		purl+='&url='+url;
	}

	purl+='&type='+type;
	$.ajax(
	{
		url : purl,
		type:'get',
		timeout:timeoutAjax,
		contentType:"application/json",
		success:function(json)
		{
			json = JSON.parse(json);
			$.ui.loadContent('#myCount_panel',true,false,'slide');
		}
	})
})

//文章分类侧边栏
function navPortalListGet(catid,page,loadmore,firstFromCache,onNetResult){	
	
	if(!loadmore)
	{
		if (columnPull2Refresh) 
			columnPull2Refresh.reset();	
		$.ui.scrollToTop('portal_panel',0);
	}	
	page = page || 1;
	var portalList='';
	if(!catid && getItem('portal_list_catid'))
	{
		catid = setItem('portal_list_catid',getItem('portal_list_catid'))
	}

	if(!$.ui.slideSideMenu)
		$.ui.slideSideMenu = true;
	setItem('portal_list_catid',catid);	//用于加载更多
	setItem("portalList"+catid+'_isEnd',0);
	
	if(!loadmore)
		$("#portalList").html('');	
	$('#portal_panelLoading').show();
	if(!loadmore && getItem("portalList"+catid)&&getItem("portalList"+catid+'_time')&&(getTimestamp()-getItem("portalList"+catid+'_time'))<cacheExpireTime){
			
		$("#portalList").html(getItem("portalList"+catid));	
		$('#thread_headerui').html();
		//$("#threadListButton").show();	
		$('#portal_panelLoading').hide(); //隐藏loading	
		$('#thead_head').html(getItem('portal_title'));		
	}else{		
		if (!onNetResult) {
			onNetResult = new R_NetPageResult("#portalList",null,null).onNetResult;
		}
		
		var ajaxTimeoutTest = $.ajax({ 
				url:pluginURL+'status.php?action=topiclist&ostype=-1&cat_id='+catid+'&page='+page,	
				type:'post',
				timeout:timeoutAjax,
				contentType:"application/json",
				success:function(data){

				data = JSON.parse(data);		
				var jsondata=data['topiclist'],tmp='';	
				var errCode = ecode_parse;
				var totalPage = 0;
				var isEnd = 0;
				if(data.isEnd && data.isEnd==1){
					isEnd = 1;
					setItem("portalList"+catid+'_isEnd',1);
				}
				//panel
				totalPage = data.totalPage;
				if(data.totalPage && data.totalPage>=page){
					if(jsondata){				
					for(var i=0;i<jsondata.length;i++){
						portalList+=getArticleListHtml(jsondata[i]);
					}	
					setItem("portalList"+catid,portalList);
					setItem("portalList"+catid+'_time',getTimestamp());
					setItem("portalList"+catid+'_length',jsondata.length);//保存长度用来判断是否显示
					$('#thead_head').html(getItem('portal_title'));
					errCode = ecode_no;
				}
			}
			$('#portal_panelLoading').hide(); //隐藏loading		

			if (onNetResult) {
						onNetResult(errCode, page, portalList, totalPage, isEnd);
			}
				
		},error : function(XMLHttpRequest,status){ 
						$('#portal_panelLoading').hide(); //隐藏loading		
		　　　　if(status=='error'){
		　　　　　 onNetResult(ecode_net, page, "", 0, 0);
		　　　　}
				else if (status=='timeout'){
					onNetResult(ecode_timeout, page, "", 0, 0);
		 　　　　　 ajaxTimeoutTest.abort();	　　　　　 	
		　　　　}
			}
	});			
		
}
	
}