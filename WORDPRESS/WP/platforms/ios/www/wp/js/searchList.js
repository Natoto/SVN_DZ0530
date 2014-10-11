var target;

$(function()
{
	
	$(document).on('ajaxStart',function()
	{
		if(!$("#lodingIcon").length)
			$('#content').append('<img src="images/loading1.gif" width="70" id="lodingIcon" style="position:fixed;left:50%;top:50%;margin-left:-35px;margin-top:-35px;"/>')
		else
			$("#lodingIcon").show();
	});

	$(document).on('ajaxComplete',function()
	{
		setTimeout(function()
		{
			$('#lodingIcon').hide();
		},300)
	});


	getSearch(address + 'status.php?action=tagcloud&ostype=-1',$('#sign ul'),'tagcloud','term_id','tag')//标签云
	getSearch(address + 'status.php?action=archive&ostype=-1&pageSize=1',$('#storeDate ul'),'archive','m','text')//归档日期

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
			search(address + 'status.php?action=search&ostype=-1&paged=1&pageSize=10&m='+target.data('m'),'search',target.next(),1,'m',target.data('m'));
		})
		return false;
	})	

	//标签下的文章
	$('#sign li a').click(function()
	{

		if(!$(this).data('hasClick'))
		{
			target = $(this);
			search(address + 'status.php?action=search&ostype=-1&paged=1&pageSize=10&tag='+$(this).text(),'search',$(this).next(),1,'tag',$(this).text());
			$(this).data('hasClick',1)
		}
		else
		{
			$(this).parent().find('.resultOpt').toggle();
			$(this).toggleClass('checkOn');
		}
		return false;
	})


	//关键字

	$('.seaInput').click(function()
	{
		var _this = $(this);
		if(!this.val())
		{
			alert('请输入关键字');
			return;				
		}

		// console.log(address+'/status.php?action=search&ostype=-1&paged=1&m='+$(this).data('m'));
		search(address + 'status.php?action=search&ostype=-1&paged=1&m='+$(this).data('m'),'search',$(this).next());

	})
})

var isEnd=0;
var page ;
function search(url,fieldName,container,page,keytype,keyval)
{

	container.parent().find('.list_item').remove();
	var dataCon = target.next('.resultOpt');
	 page = Math.ceil(dataCon.find('.list_item').length/10)+1;//计算页数
	if(isEnd)
		return;

	isEnd=getHomeArticle(1,url,page,fieldName,function(){//回调函数

		$('.ainfo').hide();
		$('.pdate').attr('class','fl');
		var len = $('.list_item',target.parent('li')).length;
		dataCon = target.next('.resultOpt');

		target.addClass('checkOn');
		target.parent().find('.resulttext').show().find('span').text(len);

		if(sessionStorage.getItem('isEnd')!=1 && !dataCon.find('.loadMore').length)
		{
			dataCon.append('<span class="loadMore" data-keytype='+keytype+' data-keyval='+keyval+'>加载更多</span>')
		}
		
		else if(sessionStorage.getItem('isEnd')!=1 && dataCon.find('.loadMore').length)
		{
			var ss = dataCon.find('.loadMore');
			
			ss.data('keyval',keyval).data('keytype',keytype);
			
			ss.appendTo(dataCon).show();
		}
		else
		{
			dataCon.find('.loadMore').hide();
		}

		$('.loadMore').click(function() //加载更多
		{
			page+=page;
			var _this = $(this);
		
			if(sessionStorage.getItem('isEnd')==1)
			{
				return;
			}

			var newUrl = address + 'status.php?action=search&ostype=-1&paged='+page+'&pageSize=10&'+_this.data('keytype')+'='+_this.data('keyval');
			// alert(newUrl);
			getHomeArticle(1,newUrl,page,fieldName,function(){

				$('.ainfo').hide();
				$('.pdate').attr('class','fl');
				var len = $('.list_item',target.parent('li')).length;
				target.parent().find('.resulttext').show().find('span').text(len);
				_this.appendTo(dataCon);

				if(sessionStorage.getItem('isEnd')==1)
				{
					$('.loadMore',dataCon).hide();
				}
					


			},container);



		})
	},container)

}

function getSearch(url,container,fieldName,key1,key2)
{
	$.ajax({ //获取归档日期

			url:url,
			type:'post',
			async:false,
			success:function(data)
			{
				var json = JSON.parse(data);
					values = json[fieldName],fragment='';
					if(container.parent().attr('id')=='storeDate')	
					{
						var datas = values[0];
						fragment+='<li><a href="#" data-m'+'='+datas['m']+'>'+datas['text']+'</a><div class="resultOpt"><p class="resulttext tc mt5" style="display:none;">共<span></span>条搜索结果</p></div></li>';
						
					}
					else
						$.each(values,function(i,val)
						{
							fragment+='<li><a href="#" data-'+key1+'='+val[key1]+'>'+val[key2]+'</a><div class="resultOpt"><p class="resulttext tc mt5" style="display:none;">共<span></span>条搜索结果</p></div></li>';
						})

					container.append(fragment);
					
			}	
		})
}
