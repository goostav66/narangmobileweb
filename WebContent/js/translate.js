//�ؽ�Ʈ �����ϱ� - ����
function getTranslate(flag_lang){
	var $frame = $('.goog-te-menu-frame:first');

	switch(flag_lang){
		case 'en':
			$frame.contents().find('.goog-te-menu2-item span.text:contains("영어")').get(0).click();
			break;
		case 'ja':
			$frame.contents().find('.goog-te-menu2-item span.text:contains("일본어")').get(0).click();			
			break;
		case 'zh':
			$frame.contents().find('.goog-te-menu2-item span.text:contains("중국어(간체)")').get(0).click();
			break;
		default:
			var $frame_cancle = $('.goog-te-menu-frame:eq(2)'); 
			$frame_cancle.contents().find('.goog-te-menu2-item:eq(0) div span.text').get(0).click();
			break;
	}
}

function googleTranslateElementInit() {
  new google.translate.TranslateElement(
		{pageLanguage: 'ko', 
		includedLanguages: 'en,ja,zh-CN', 
		layout: google.translate.TranslateElement.InlineLayout.SIMPLE}, 
		'google_translate_element');
}

function getCurrentLan(){
	
	var lang = $(".goog-te-menu-value span:first").text();
	
     if(lang != "" && lang != '��� ����'){
    	 initIndexPage(lang);
     }else{
    	 setTimeout(getCurrentLan, 500);
     }
}

function initIndexPage(lang){
	$(".languages img").each(function(){
		$(this).hide();
	});
	$(".menu_panel").each(function(){
		$(this).hide();
	});
	switch(lang){
	case '영어':
		$("#flag_k").show();
		$("#panel_english").show();
		break;
	case '일본어':
		$("#flag_k").show();
		$("#panel_japanese").show();
		break;
	case '중국어(간체)':
		$("#flag_k").show();
		$("#panel_chinese").show();
		break;	
	default:
		$("#flag_e").show(); $("#flag_j").show(); $("#flag_c").show();
		$("#panel_domestic").show();
		break;
	}
}

function getQuerystring(paramName){ 
	var _tempUrl = window.location.search.substring(1); 
	var _tempArray = _tempUrl.split('&');
	for(var i = 0; i < _tempArray.length; i++) { 
		if(_tempArray[i].length > 0){
			var _keyValuePair = _tempArray[i].split('='); 
			if(_keyValuePair[0] == paramName){ 
				return _keyValuePair[1]; 
				// _keyValuePair[0] : �Ķ���� �� 
				// _keyValuePair[1] : �Ķ���� ��
			}
		}
	}
}