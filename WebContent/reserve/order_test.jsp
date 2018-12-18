<%@page import="connectDB.MenuBean"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="mMgr" class="connectDB.MenuMgr"/>

<% 
    String url = request.getParameter("p");//업소코드

	String lan = request.getParameter("lan");
  
    int shop_idx = fMgr.getFranchInfo(url).getIdx();
     
    Vector<MenuBean> menuList = mMgr.getMenuList(shop_idx, 0);
%>
<html>
<title>주문하기(테스트)</title>
<style>
	.menu, .order { width: 50vmin; float: left; }
	.menu img { width: 50vmin;}
	
	.order input{ width: 20vmin; }
</style>
<%@include file="../nfc_header.jsp"%>
<body>
<span><%=tab%>번 테이블</span>
<div class="list_menu">
	<%for(int i = 0; i<menuList.size(); i++){
		MenuBean menu = menuList.get(i);
	%>
	<form class="form_menu">
	<div style="clear: both" class="menu_form">
		<div class="menu">
			<img src="<%=menu.getMenu_photo()%>"><br>
			<span><%=menu.getMenu_name()%></span><br>
			<%	if(menu.getPrice() == 0 && menu.getPrice_s() != 0){%>
			<span><%=menu.getPrice_s()%>원 소</span><br>
			<%	} else if(menu.getPrice() == 0 && menu.getPrice_m() != 0){%>
			<span><%=menu.getPrice_m()%>원 중</span><br>
			<%	} else if(menu.getPrice() == 0 && menu.getPrice_l() != 0){%>
			<span><%=menu.getPrice_l()%>원 대</span><br>
			<%	} else if(menu.getPrice() != 0){%>
			<span><%=menu.getPrice()%>원</span><br>
			<%	} %>
		</div>
		<div class="order">
			수량: 
			<input type="number" name="quantity" class="quantity" min="0">
			
		</div>
		<input type="hidden" name="menu_idx" value="<%=menu.getIdx()%>">
		<input type="hidden" name="menu_price" value="<%=menu.getPrice()%>">
		<input type="hidden" name="shop_idx" value="<%=shop_idx%>">
		<input type="hidden" name="table" value="<%=tab%>">
	</div>	
	</form>
	<%} %>
	<div style="clear:both"><button id="getOrder" type="button">주문하기</button></div>
</div>
<script>
	$(document).ready(function(){
		$("#getOrder").click(function(e){
			e.preventDefault();
			$(".quantity").each(function(){
				if( $(this).val() > 0){
					var form = $(this).closest(".form_menu");
				 	var params = form.serialize();
					$.ajax({
						url: 'order_test_form.jsp',
						type: 'post',
						data: params,
						contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
						dataType: 'html'
					})
				}
			});
			
			alert("주문이 완료되었습니다.");
		  
		});
	});
</script>
</body>
</html>