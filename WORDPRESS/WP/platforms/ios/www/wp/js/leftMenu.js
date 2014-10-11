$(function()
{


	//我的收藏数

	$.ajax({ 

				url:address + 'status.php?action=myfavorites&ostype=-1&ip='+ip,
				type:'post',
				async:false,
				success:function(data)
				{
					var json = JSON.parse(data),ind=0,
						values = json['myfavorites'];

						
						$('.ii2 b').text('('+(json.favorite_count?json.favorite_count:0)+')');
				}
			});


	$.ajax({

			url:address + 'status.php?action=categories&ostype=-1',
			type:'post',
			async:false,
			success:function(data)
			{
				var json = JSON.parse(data),
					values = json.categories,fragment='';
					// console.log(values);
				$.each(values,function(i,val)
				{

					fragment+='<li><a href="'+'articleList.html?cat_id='+val.cat_ID+'&title='+val.name+'">'+val.name+'</a></li>';
				})

				$('.articleDl ul').append(fragment);

				// console.log(sessionStorage.getItem('pos')!=null)
				if(sessionStorage.getItem('pos')!=null)
				{
					var val = sessionStorage.getItem('pos');
					console.log(val);
					var pid = '#'+val.split(' ')[0],
						index = val.split(' ')[1];
						// console.log($(pid).children().eq(index));
						$(pid).children().eq(index).addClass('on').siblings('li').removeClass('on');
				}

				//添加当前样式
				$('#leftMenu_wrap li').click(function()
				{
					var index = $(this).index();
					var pid = $(this).parent().attr('id');
					
					sessionStorage.setItem('pos',pid+' '+index);
					$(this).addClass('on');
				})


			}
		})
})