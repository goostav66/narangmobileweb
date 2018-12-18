
<%@page import="connectDB.EventListBean"%>
<%@page import="connectDB.EventBean"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%String url = request.getParameter("p"); %>
<jsp:useBean id="sMgr" class="connectDB.SaleMgr"/>

<style>
	body{ background-color: rgba(69, 167, 55, 0.5); }
</style>
<%@include file="../nfc_header.jsp"%>
<jsp:include page="set_promotion_event.jsp">
	<jsp:param value="<%=url%>" name="p"/>
</jsp:include>
<jsp:include page="set_promotion_discount.jsp">
	<jsp:param value="<%=url%>" name="p"/>
</jsp:include>

	