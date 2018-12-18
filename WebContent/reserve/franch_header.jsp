<%@ page import="connectDB.FranchiseMgr"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	//request.setCharacterEncoding("UTF-8");	%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="mMgr" class="connectDB.MenuMgr"/>
<%
	String url = request.getParameter("p");
	String lan = request.getParameter("lan");
	
	String shop_name = fMgr.getFranchInfo(url).getShop_name();
 	
	int shop_type = fMgr.getFranchInfo(url).getType();
	int shop_idx = fMgr.getFranchInfo(url).getIdx();

%>
<html>
<title>NFC ZONE :: <%=shop_name%></title>
<%@include file="../nfc_header.jsp"%> 
<body>
<div class="wrap">
	<nav>
		<img class="icon_home" src="../images/icon_common/icon_home.png" onclick="location.href='../index.jsp?p=<%=url%>&is=<%=isShared%>&lan=<%=lan%>'">
		<span class="nav_title" <%if(lan!=null&&lan.equals("en")){%>style="font-size:1.5rem"<%}%>>전자메뉴판</span>
		<img class="icon_home invisible" src="../images/icon_common/icon_home.png">
	</nav>
	<div id="google_translate_element"></div>
	<div class="franch_header_labels">
		<div class="label">업소정보</div>
		<div class="label">전체메뉴</div>
		<div class="label">점심특선</div>
	</div>
	
<script>
$(document).ready(function(){
	
	initFranchInforLabel(<%=shop_type%>, '<%=shop_name%>', <%=mMgr.getMenuList(shop_idx).size()%>);
	
	setTimeout(google_style, 300);

	resize_title();
	
	function google_style(){	
		var lang = '<%=lan%>';
		var $frame = $('.goog-te-menu-frame:first');
		
		var context ='한국어';
		if(lang == 'en') context = '영어';
		else if(lang == 'ja') context = '일본어';
		else if(lang == 'zh') context = '중국어(간체)';
		
		if(context != '한국어') {
			$frame.contents().find('.goog-te-menu2-item span.text:contains('+context+')').get(0).click();
		} else { 
			var $frame_cancle = $('.goog-te-menu-frame:eq(2)'); 
			$frame_cancle.contents().find('.goog-te-menu2-item:eq(0) div span.text').get(0).click(); 
		}
	}

	$(".label").click(function(){
		var label = $(this).index();
		switch(label){
		case 0 :  
			location.href="franch_infor.jsp?p=<%=url%>&is=<%=isShared%>&lan=<%=lan%>";
			break;
		case 1 :
			location.href="franch_menu.jsp?p=<%=url%>&is=<%=isShared%>&lan=<%=lan%>&m=0";
			break;
		case 2 :
			location.href="franch_menu.jsp?p=<%=url%>&is=<%=isShared%>&lan=<%=lan%>&m=1";
			break;
		}
	});
});
</script>
</html>
