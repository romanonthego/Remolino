// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.pjax
//= require_directory .
//= require twitter/bootstrap
//= require rails.validations

clientSideValidations.callbacks.element.fail = function(element, message, callback) {
  callback();
  if (element.data('valid') !== false) {
  	console.log(element.parent().find('.error-tooltip'));
  	element.parent().find('.error-tooltip').remove();
  	element.parent().append('<span class="error-tooltip"><i class="icon-exclamation-sign icon-white" rel="tooltip" data-placement="left"></i></span>');
  	element.parent().find('.error-tooltip').tooltip({title:message});
    // element.parent().find('.error-tooltip').hide();
  	console.log(message);
	}
};

clientSideValidations.callbacks.element.pass = function(element, callback) {
	callback();
  element.parent().find('.error-tooltip').remove();
};


// simple translitirate from russian to eng plugin
var ru2en = { 
  ru_str : "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя", 
  en_str : ['A','B','V','G','D','E','JO','ZH','Z','I','J','K','L','M','N','O','P','R','S','T',
    'U','F','H','C','CH','SH','SHH',String.fromCharCode(35),'I',String.fromCharCode(39),'JE','JU',
    'JA','a','b','v','g','d','e','jo','zh','z','i','j','k','l','m','n','o','p','r','s','t','u','f',
    'h','c','ch','sh','shh',String.fromCharCode(35),'i',String.fromCharCode(39),'je','ju','ja'], 
  translit : function(org_str) { 
    var tmp_str = ""; 
    for(var i = 0, l = org_str.length; i < l; i++) { 
      var s = org_str.charAt(i), n = this.ru_str.indexOf(s); 
      if(n >= 0) { tmp_str += this.en_str[n]; } 
      else { tmp_str += s; } 
    } 
    return tmp_str; 
  } 
}

$(document).ready(function(){

  $('a[data-pjax="true"]').pjax('[data-pjax-container]');


  $('[rel=\'tooltip\']').tooltip();
  generateLoginForNewUser();

  $(document).on('pjax:end', function(event, xhr, options) {
    $('form[data-validate]').validate();
    $('[rel=\'tooltip\']').tooltip();
    console.log('pjax complete callback');
    console.log($('[rel=\'tooltip\']'));
    // console.log($('form[data-validate="true"]'));
  });

});