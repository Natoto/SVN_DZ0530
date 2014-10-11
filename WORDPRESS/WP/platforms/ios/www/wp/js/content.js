
var pid = getQueryString('post_id'),
		comment_totalPage;//总页数
//url = address + 'status.php?action=postlist&ostype=-1&ip='+deviceid+'&post_id='+pid,


function getComment(page)
{

	if(comment_totalPage && comment_totalPage<page) //当前页已经是最后一页
	{
		return;
	}
	
	if(!$('.commentList').data('lastPage'))
	{
		// console.log(address+'status.php?action=comments&ostype=-1&pageSize=10&post_id='+pid+'&page='+page)	

	$.ajax({//评论内容 
			url:address+'status.php?action=comments&ostype=-1&pageSize=10&post_id='+pid+'&page='+page,
			type:'post',
			async:false,
			success:function(data)
			{
				var json = JSON.parse(data),
					now = $('.commentList li').length?$('.commentList li:last-child').find('.lou').children('b').text():0,//获取上一页最后页码
					values = json.comments,fragment=$('.pinlunTT').length?"":'<div class="pinlun"><div class="pinlunTT"></div><div class="commentList"><ul class="m10">';

					comment_totalPage = json.totalPage;
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
						fragment+='<li>'+
								'<div class="clearfix">'+
									'<div class="cListHd fl">'+
										'<div class="clearfix">'+ imgurl+
											'<div class="au_text fr ml10">'+
												'<p class="au_say">'+purl+'<b class="vm">说：</b></p>'+
												'<p class="f999 f12">'+getDate(val.date)+'</p>'+
											'</div>'+
										'</div>'+
									'</div>'+
									'<div class="rText fr">'+
										'<span class="goods" data-comment_id='+val.comment_ID+'>'+val.digg_count+'</span>'+
										'<a href="comment.html?post_id='+pid+'&to='+newName+'" data-comment_id="'+val.comment_ID+'">&nbsp;|&nbsp;回复</a>'+
									'</div>'+
								'</div>'+
								'<p class="mt5">'+
									'<span class="ml10 mr20 lou"><b>'+(curpage+1)+'</b>楼</span>'+val.comment_content+
								'</p>'+
							'</li>'

					});

					//给文章评论数，收藏数赋值

					$('.replies b').text(json.comments_count);
					if(!$('.pinlunTT').length && !$('.commentList ul').length)
					{
						fragment+='</ul></div></div>';
					}
					
					if(comment_totalPage && comment_totalPage==page  )
					{
						$('.commentList').data('lastPage',1);

					}

					if($('.commentList ul').length)
					{
						$('.commentList ul').append(fragment);
					}
					else
						$('#content').append(fragment);

					$('.comm').data('num',json.comments_count).attr('href','comment.html?post_id='+pid);

					//如果没有评论信息，则隐藏'全部评论'提示
					if(!$('.commentList li').length)
					{
						$('.pinlunTT').hide();
					}
			}
		})
	}
}
//entry
function getArtileComment()
{
	var url = address + 'status.php?action=postlist&ostype=-1&ip='+deviceid+'&post_id='+pid;
	$.ajax({//文章内容 

			url:url,
			type:'post',
			async:false,
			success:function(data)
			{
				var json = JSON.parse(data),
					values = json.postlist,fragment='';
					console.log(json);	
					fragment+='<div class="articleTitle">'+
						'<h3>'+values.title+'</h3>'+
						'<p>'+values.date+'</p>'+
					'</div>';

					fragment+='<article class="p10" id="artContent">'+values.content+'<div class="tc mt20"> <span class="love mr40"><b>'+(values.favorites_count?values.favorites_count:0)+'</b>人喜欢</span> <span class="replies"><b>0</b>人评论</span> </div>';

					$('#content').append(fragment);
					//设置字体大小

					if(sessionStorage.getItem('fontSize'))
						$('article,article p').css('font-size',sessionStorage.getItem('fontSize')+'!important');

					$('.stars').text(values.favorites_count?values.favorites_count:0);

					if(values.hasFavorites)
						$('.stars').addClass('on');
				
			}
		});

		getComment(1);
	

	//收藏

	//var ip = window.location.host;
	$('.stars').click(function()
	{
		var _this = $(this),
			num = _this.text()*1;

		if(_this.hasClass('on')) //取消收藏
		{
			//alert(address+'status.php?action=delfavorites&ostype=-1&aid='+pid+'&ip='+ip);
			$.ajax({ 

					url:address+'status.php?action=delfavorites&ostype=-1&aid='+pid+'&ip='+deviceid,
					type:'post',
					async:false,
					success:function(data)
					{

						var json = JSON.parse(data);
						if(json.emsg=='')
						{
							$('.love b,.stars').removeClass('on').text($('.stars').text()*1-1);
							alert('已取消收藏');
						}
							
					}
			})
			return;
		}
			
		_this.addClass('on');
		//_this.text(num+1);


		$.ajax({//评论内容 

			url:address + 'status.php?action=favorites&ostype=-1&aid='+pid+'&ip='+deviceid,
			type:'post',
			async:false,
			success:function(data)
			{
				var json = JSON.parse(data);
				var curno = $('.stars').text()*1;

				$('.love b,.stars').text(curno+1);
				
				alert('文章已收藏')
			}
		});
	})

	$('.goods').click(function()//点赞
	{
		var comment_id = $(this).data('comment_id'),_this=$(this);
		_this.addClass('on');	
		$.ajax({

			url:address + 'status.php?action=digg&ostype=-1&aid='+pid+'&fid='+comment_id,
			type:'post',
			async:false,
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

	$('.backStep').unbind('click').click(function()
	{
		if($('#setMenu').css('display')=='block')
		{
			$('.maskLayer').hide();	
			$('#setMenu').hide();
			$('.pmenu').removeClass('on');
		}
		else
			history.back();
	})


	//回复别人评论
	$('.rText a').click(function()
	{
		var _this = $(this);

	})
}