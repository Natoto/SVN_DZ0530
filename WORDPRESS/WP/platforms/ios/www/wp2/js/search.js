$(function()
{
	
	//改变链接地址
	// $('#searForm').attr('action',address+'/wp/searchValue.html')	

	var s=escape(getQueryString('s'));
	var zh = decodeURI(decodeURI(s));
	$('.seaInput').val(zh);
	var url = address + 'status.php?action=search&ostype=-1&paged=1&pageSize=10&s='+s;
	var container=$('.retult');

	getHomeArticle(1,url,1,'search',function(){//回调函数

		$('.ainfo').hide();
		$('.pdate').attr('class','fl');
		$('.resultText span').text($('.list_item').length);

	},container,1);


	
		
})
