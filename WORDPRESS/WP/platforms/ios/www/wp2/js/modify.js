$(function()
{
	var type = getQueryString('type');
	var text;


	//修改form url
	// $('form').attr('action',address+$('form').attr('action'));

	switch(type)
	{
		case '1':
			text = sessionStorage.getItem('uname');
			$('input[type="text"]').val(text);

			break;

		case '2':
				text = sessionStorage.getItem('email');
				$('input[type="email"]').val(text);
				break;

		case '3':
				text = sessionStorage.getItem('url');
				$('input[type="url"]').val(text);
				break;
		default:
	}

	$('#types').val(type);


	//提交表单3秒后返回信息页

	$('[type="submit"]').click(function()
	{
		
		if($('form')[0].checkValidity())
		{

			setTimeout(function()
			{
				location.href='myCount.html';
			},2000);
		}
			
	})



})