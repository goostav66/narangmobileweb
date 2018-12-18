<%@page import="connectDB.GuestMgr"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="gMgr" class="connectDB.GuestMgr"/>
<%
	String url = request.getParameter("p");
%>
<title>NFC ZONE :: 손님이야기</title>
<%@include file="../nfc_header.jsp"%>
<script src="../js/autoresize.js"></script>
<style>
	textarea{ width: 98%; font-size: 1.1rem; font-family: "Nanum Gothic"; }

</style>
<div class="wrap">
	<nav>
		<a href="../index.jsp?p=<%=url%>"><img class="icon_home" src="../images/icon_common/icon_home.png"></a>
		<span class="nav_title">손님 이야기</span>
		<img class="icon_home invisible" src="../images/icon_common/icon_home.png">	
	</nav>
	<div class="guest_main_img">
		<img src="../images/guest_story/guest_background.jpg">
	</div>
	<div class="guest_eval">
		<label>
			<input type='radio' name='emoticon' value='0'>
			<img src='../images/guest_story/reply_emo_1.png'>
		</label>
		<label>
			<input type='radio' name='emoticon' value='1'>
			<img src='../images/guest_story/reply_emo_2.png'>
		</label>
		<label>
			<input type='radio' name='emoticon' value='2'>
			<img src='../images/guest_story/reply_emo_3.png'>
		</label>
		<label>
			<input type='radio' name='emoticon' value='3'>
			<img src='../images/guest_story/reply_emo_4.png'>
		</label>
	</div>
	<div class="guest_reply">
		<textarea id="comments" placeholder="Type many lines of texts in here and you will see magic stuff" class="common"></textarea>
	</div>
</div>
<script>
	$(document).ready(function(){
		 $("#comments").autoResize();
	});
</script>
