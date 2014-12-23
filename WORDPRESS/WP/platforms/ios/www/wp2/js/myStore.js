$(function()
{
	getHomeArticle(1,address + 'status.php?action=myfavorites&ostype=-1&ip='+ip,1,'myfavorites',function()
	{
		$('.ainfo').hide();
		$('.pdate').attr('class','fl');
	});
	
		
})
