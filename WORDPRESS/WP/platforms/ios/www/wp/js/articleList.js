
var cat_id = getQueryString('cat_id');
var cat_title = decodeURI(decodeURI(escape(getQueryString('title'))));

$(function()
{

	$('.topTitle').text(cat_title);
	//更改地址

	

	// $('#iconSearch').attr('href',address+$('#iconSearch').attr('href'));

	if(cat_id)
	{

		var page = $('.list_item').length>0?Math.ceil($('.list_item').length/10)+1:1;

		var url = address + 'status.php?action=topiclist&ostype=-1'+'&page='+page+'&cat_id='+cat_id+'&pageSize=10&type=';
			
		getHomeArticle(1,url,page,'topiclist'); //getHomeArticle(type,url,page,key)	
		
	}
		
	
})


