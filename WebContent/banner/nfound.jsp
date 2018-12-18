<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<jsp:useBean id="cMgr" class="connectDB.ContactMgr"/>
<%
	String c_param = request.getParameter("c");
	String contact_number = "01075569080";
	
	if(c_param != null)
		contact_number = cMgr.getContactNumber(c_param);
%>
<html>
<head>
<title>NA랑창업할래</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<meta name="mobile-web-app-capable" content="yes"/>
<meta name="og:type" content="website"/>
<meta name="og:image" content="../images/commerce/page5.jpg"/>
<link rel="icon" href="../images/icon_common/logo_notext.png" type="image/png" sizes='192x192'>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	
<style>
	@import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);
	body{ margin: 0; font-family: 'Nanum Gothic'; }
	.img_pages{ margin-bottom: 10vw;}
	.img_pages img{ width: 100vw; }
	.contact_us{ position: fixed; bottom: 0; width: 100vw; display: flex; color: #fff; text-align: center; font-size: 1.1rem; font-weight: bold; height: 10vw; }
	.contact_us>div{ flex: 1; display: flex; align-items: center; justify-content: center;}
	.contact_mailto{ background-color: #427de4; }
	.contact_call{ background-color: #e44242; }
</style>
</head>

<body>
	<div class="img_pages" align='center'>
		<img src="../images/commerce/page5.jpg">
		<img src="../images/commerce/page6.jpg">
		<img src="../images/commerce/page7.jpg">
		<img src="../images/commerce/page8.jpg">
		<img src="../images/commerce/page9.jpg">
		<img src="../images/commerce/page10.jpg">
	</div>
	<div class="contact_us">
		<div class="contact_mailto" onclick="location.href='sms:<%=contact_number%>?'">
			문자 문의
		</div>
		<div class="contact_call" onclick="location.href='tel:<%=contact_number%>'">
			전화 문의
		</div>
	</div>
</body>
</html>