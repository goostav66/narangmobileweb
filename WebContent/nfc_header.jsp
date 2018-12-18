<%@ page contentType="text/html; charset=EUC-KR"%>
<%

	String version = Long.toString(System.currentTimeMillis());


	StringBuffer requestUrl = request.getRequestURL();
	String servletPath = request.getServletPath();
	
	String path = requestUrl.substring(0, requestUrl.indexOf(servletPath)+1);
	String isShared = request.getParameter("is");
	String language = request.getParameter("lan");
	if(language != null && language.equals("null"))
		language = null;
	String s_table = request.getParameter("tab");
	int tab = 0;
	if(s_table != null) tab = Integer.parseInt(s_table);
%>
<head>
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<meta name="mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="og:type" content="website"/>
	<meta name="og:title" content="Na랑 - 편리함이 시작된다"/>
	<meta name="og:image" content="http://103.60.124.17/m/images/logo_black.png"/>
	
	<link rel="icon" href="<%=path%>images/icon_common/logo_notext.png" type="image/png" sizes='192x192'>
	<link rel="stylesheet" media="screen and (orientation: portrait)" href="<%=path%>css/style_port.css?ver=<%=version%>">
	<link rel="stylesheet" media="screen and (orientation: landscape)" href="<%=path%>css/style_land.css?ver=<%=version%>">
	
	<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
	<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=7a23ce0d0bb4796d1535c957af98c96f&libraries=services"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
	<script src="//cdn.jsdelivr.net/npm/jquery.marquee@1.5.0/jquery.marquee.min.js" type="text/javascript"></script>

	<script src="<%=path%>js/script_narang.js?ver=<%=version%>" charset="EUC-KR"></script>
	<script src="<%=path%>js/script_kakao.js?ver=<%=version%>"></script>
	<script src="<%=path%>js/translate.js?ver=<%=version%>"></script>
	<script src="<%=path%>js/autoresize.js"></script>
	
	<script src="<%=path%>js/quill/quill.min.js"></script>
	<link rel="stylesheet" href="<%=path%>js/quill/quill.snow.css">
<style>
	@import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);
	@font-face{ 
		font-family: '스냅스 쾌남열차'; src: url(<%=path%>css/SNAPS_COOLGUYTRAIN.TTF) format('truetype'); 
	}
	
	@media only screen and (orientation: portrait){
		.logo{ width: 50vmin; position:absolute; left: 25vmin; top: 25%; z-index: 0; }
	}
	 
	@media only screen and (orientation: landscape){
		.logo{ display: none }
	}
	
	<!-- 구글 번역 -->
	#google_translate_element { display: none; !important; }
	.skiptranslate { display: none; } 
	.goog-te-banner-frame,.goog-te-balloon-frame{  display:none !important;  }
	font{ background: transparent !important; color: inherit !important; }
</style>	
</head>