



$(function()
{
	

	// $('#iconSearch').attr('href',address+$('#iconSearch').attr('href'));
	

//左侧栏目列表


	//正文
		
	
		cat_id = getQueryString('cat_id');
	
		var url = address + 'status.php?action=home&ostype=-1'+'&page='+1+'&pageSize=10&type=';

		getHomeArticle(1,url,1,'home');	//最新
		getHomeArticle(2,url,1,'home');	//最热
		
	
})

