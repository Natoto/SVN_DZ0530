$(function()
{
	
	
	//改变url地址

	$.ajax({

			url:address+'status.php?action=myaccount&ostype=-1',
			type:'post',
			async:false,
			success:function(data)
			{
				var json = JSON.parse(data),
					values = json.myaccount,fragment='';

					$('#headP img').attr('src',values.avatar);

					if(values.comment_author)
					{

						$('#usname').html(values.comment_author);
					}

					if(values.comment_author_email)
					{
						$('#myemail').text(values.comment_author_email);
					}

					if(values.comment_author_url)
					{
						$('#myurl').text(values.comment_author_url);
					}


					sessionStorage.setItem('uname',values.comment_author);
					sessionStorage.setItem('email',values.comment_author_email);
					sessionStorage.setItem('url',values.comment_author_url);
			}	
		})
		
})
