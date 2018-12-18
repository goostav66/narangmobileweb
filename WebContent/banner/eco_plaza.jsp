<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<html>
<head>
<title>에코플라자</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="mobile-web-app-capable" content="yes">
<style>
	@import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);
	body{ margin: 0; }
	.iframe_banner{ border: none; width: 100vw; height: 100vh; }
	
	.btn_fixed_banner_call{ position: fixed; bottom:0; left:0; }
	.btn_fixed_banner_call button{ width: 100vw; padding: 15px 0;
	background-color: #45A737; color: #fff; font-size: 1.3rem; font-family: 'Nanum Gothic'; border: none; }
	.btn_fixed_banner_call button:hover{ background-color: #398c2d;}
</style>
</head>
<body>
	<iframe class="iframe_banner" src="http://eco-plaza.co.kr/"></iframe>
	<div class="btn_fixed_banner_call">
		<button onclick="location.href='tel:010-8585-6855'">전화 문의</button>
	</div>
</body>
</html>
