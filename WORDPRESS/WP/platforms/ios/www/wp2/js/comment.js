String.prototype.trim=function(){
　　    return this.replace(/(^\s*)|(\s*$)/g, "");
　　 }

function check()
{
	var to=escape(getQueryString('to'));
	var zh = decodeURI(decodeURI(to));


	if(zh && zh!='null')
	{
		
		$('[name="author"]').val($('[name="author2"]').val()+'对'+zh);
	}
	else
	{
		$('[name="author"]').val($('[name="author2"]').val());
	}
	
	return true;
}


$(function()
{
	
	//提交评论前检查合法性


	//设置之前保存过的值

	if(localStorage.getItem('noName_uname')!=null)
	{
		$('[name="author2"]').val(localStorage.getItem('noName_uname'));
		$('[name="email"]').val(localStorage.getItem('noName_uemail'));
		$('[name="url"]').val(localStorage.getItem('noName_url'));
	}


	var pid = getQueryString('post_id');
	var trigger15sec=0;
	//改变url
	$('form').attr('action',address + 'status.php?action=comments_post&ostype=-1');

	//post_id赋值
	$('[name="post_id"]').val(pid);

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
					$('.tipsdiv').text('请在15秒后可再次评论,谢谢');
					

				}
				else
				{
					$('#content').append('<div class="tipsdiv" style="position:absolute;width:100%;text-align:center;color:#fff;top:40px;background:rgba(0,0,0,.8);">请在15秒后可再次评论,谢谢</div>');
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

				},1000)

				return;
			}
			else
				$('.btnsubmit').removeAttr('disabled');
		}
		
		if(!$('#textarea').val().trim())
		{
			alert('请输入内容...')
			return false;
		}	


		if($('form')[0].checkValidity())
		{
			$('.btnsubmit').css({'background':'#ccc','border-color':'#ccc'});
			localStorage.setItem('noName_uname',$('[name="author2"]').val());
			localStorage.setItem('noName_uemail',$('[name="email"]').val());
			localStorage.setItem('noName_url',$('[name="url"]').val());
			sessionStorage.setItem('time',new Date().getTime());

			if($('.tipsdiv').length)
				$('.tipsdiv').text('评论已提交，15秒后可再次评论,2秒后自动跳回详情页').show();
			else
				$('#content').append('<div class="tipsdiv" style="position:absolute;width:100%;text-align:center;color:#fff;top:40px;background:rgba(0,0,0,.8);">评论已提交，15秒后可再次评论,2秒后自动跳回详情页</div>');

			setTimeout(function()
			{
				if(!trigger15sec)
					history.go(-1);
				else
					history.go(-2);
			},2500)
			
			

			
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

	$('.emailtype li').click(function()
	{
		$('[name="email"]').val($('[name="email"]').val()+$(this).text());
		$('.emailtype').hide();
	})

	
	

})