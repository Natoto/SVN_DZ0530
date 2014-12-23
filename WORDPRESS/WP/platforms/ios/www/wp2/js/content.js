/*帖子详情页面加载*/
//getArtileComment
function content_load(){
	
//$('#forumheaderui').html('<a class="button" id="backButton" style="visibility: visible;">返回</a><h1 id="pageTitle" class="">帖子详细页</h1><a style="float:right; padding:8px 5px 0px 0px; color:#fff; border:none; text-decoration:none;" class="icon pencil" href="javascript:showPopupPost();">回帖</a>');

	$("#contentLoading").show();
	var pid=getItem('pid');
		$.ajax({ 
			url:pluginURL + 'status.php?action=postlist&ostype=-1&ip='+deviceid+'&post_id='+pid,
			type:'post',
		
			timeout:timeoutAjax,
			contentType:"application/json",
			success:function(data){
					var json = $.parseJSON(data),
					values = json.postlist,fragment='';
					fragment+='<div class="articleTitle">'+
						'<h3>'+values.title+'</h3>'+
						'<p>'+values.date+'</p>'+
					'</div>';

					fragment+='<article class="p10" id="artContent">'+values.content+'<div class="tc mt20"> <span class="love mr40"><b>'+(values.favorites_count?values.favorites_count:0)+'</b>人喜欢</span> <span class="replies"><b>0</b>人评论</span> </div>';

					$('#contentDiv').html(fragment);
					$("#contentLoading").hide();
			
					//设置字体大小
					/**
					if(getItem('fontSize'))
						$('article,article p').css('font-size',sessionStorage.getItem('fontSize')+'!important');

					$('.stars').text(values.favorites_count?values.favorites_count:0);
					console.log(values.hasFavorites)
					if(values.hasFavorites)
						$('.stars').addClass('on');
						**/
			},
		});
		
		
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

}