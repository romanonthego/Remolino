// try to convert in into User spine entity.

function generateLoginForNewUser() {
	var form = $('form#new_user');
	if (form.length !== 0) {
		var last_name_field = form.find('#user_last_name');
		var login_field = form.find('#user_login');
		console.log(login_field);
		last_name_field.on('keyup', function(){
			
				var value = $(this).val();
				trans = ru2en.translit(value).toLowerCase(); 
				login_field.val(trans);
				
		});
	}
};