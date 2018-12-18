<%@page import="java.util.Vector"%>
<%@page import="connectDB.FranchiseBean"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="ptMgr" class="connectDB.PhotoMgr"/>
<% 
    String url = request.getParameter("p");//업소코드
	String lan = request.getParameter("lan");
    
	Vector<FranchiseBean> re_list = fMgr.getSomeFranchList(url, 9);
%>
<html>
<title>가맹점 리스트</title>
<style>
	#toTop{ position: fixed; bottom: 1%; right: 1%; }
	#btn_more{ display: none; }
	#snackbar { display: none; width: 80vmin; background-color: #333; color: #fff; text-align: center; border-radius: 2px; padding: 3vw 0; position: fixed; z-index: 1; left: 10vw; bottom: 15vmin; font-size: 17px; }	
	#snackbar.show { visibility: visible; }
</style>
<%@include file="../nfc_header.jsp"%>
<div class="wrap">
	<nav id="top">
		<a href="../index.jsp?p=<%=url%>&is=<%=isShared%>&lan=<%=lan%>"><img class="icon_home" src="../images/icon_common/icon_home.png"></a>
		<span class="nav_title">가맹점 리스트</span>
		<img class="icon_home invisible" src="../images/icon_common/icon_home.png">	
	</nav>
	<div>	
		<form method="POST" action="reserve_list_search.jsp?p=<%=url%>">
			<input type="search" id="text_search_reserve" name="search" placeholder="검색" autocomplete="off">
		</form>
	</div>
	<div class="main_banner">
		<div>
			<img style='display:block' src='../images/sample_img/event_ongoing.gif' onclick='location.href="set_promotion.jsp?p=<%=url%>"'>
		</div>
	</div>
	<div class="shop_type">
		<div onclick="location.href='reserve_list_type.jsp?p=<%=url%>&type=1'"><img src="../images/sample_img/shop_type_1.png"></div>
		<div onclick="location.href='reserve_list_type.jsp?p=<%=url%>&type=2'"><img src="../images/sample_img/shop_type_2.png"></div>
		<div onclick="location.href='reserve_list_type.jsp?p=<%=url%>&type=3'"><img src="../images/sample_img/shop_type_3.png"></div>
		<div onclick="location.href='reserve_list_type.jsp?p=<%=url%>&type=4'"><img src="../images/sample_img/shop_type_5.png"></div>
		<div onclick="location.href='reserve_list_type.jsp?p=<%=url%>&type=5'"><img src="../images/sample_img/shop_type_4.png"></div>
	</div>
	
	<div class="banner" align="center">
	<%for(int i = 0; i<re_list.size(); i++){
		FranchiseBean bean = re_list.get(i);
		String src = ptMgr.getMainPhoto(bean.getIdx()).getPhoto_url();
		if(src != null && !src.trim().equals("")){%>
		<div onclick="location.href='franch_infor.jsp?p=<%=bean.getUrl()%>&is=y'">
			<span class="banner_title"><%=bean.getShop_name()%></span>
			<img src="<%=ptMgr.getMainPhoto(bean.getIdx()).getPhoto_url()%>">
		</div>
		
	<%	}
	}%>
	</div>
</div>
