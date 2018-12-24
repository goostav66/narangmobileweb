<%@page import="java.util.Vector"%>
<%@page import="java.util.Enumeration"%>

<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="shop" class="connectDB.FranchiseBean"/>
<%
	String url = request.getParameter("p");

	String host = (String) session.getAttribute("HOST");
	if(host == null || !host.equals(url))
		response.sendRedirect("host_board.jsp?p="+url);
	
	String path = getServletContext().getRealPath("images/shop_photo");	
	
	shop.setIdx(fMgr.getFranchInfo(url).getIdx());
	shop.setShop_name(request.getParameter("shop_name"));
	shop.setShop_phone(request.getParameter("shop_phone"));
	shop.setLocation_code(Integer.parseInt(request.getParameter("location_code")));
	shop.setShop_addr(request.getParameter("shop_addr"));
	shop.setOpen_weekDay(request.getParameter("open_weekDay"));
	shop.setClose_weekDay(request.getParameter("close_weekDay"));
	shop.setOpen_weekEnd(request.getParameter("open_weekEnd"));
	shop.setClose_weekEnd(request.getParameter("close_weekEnd"));
	shop.setOffday(request.getParameter("offday"));
	shop.setRecom_menu(request.getParameter("recom_menu"));
	shop.setIntro_text(request.getParameter("intro_text"));
	shop.setDiscount(Integer.parseInt(request.getParameter("discount")));
	shop.setIsParking(Integer.parseInt(request.getParameter("isParking")));
	shop.setIsSeats(Integer.parseInt(request.getParameter("isSeats")));
	shop.setLat(Double.parseDouble(request.getParameter("lat")));
	shop.setLng(Double.parseDouble(request.getParameter("lng")));
	
	fMgr.updateShopInfor(shop);
%>

<script>
	alert("수정이 완료되었습니다.");
	location.href="host_infor.jsp?p=<%=url%>";
</script>