<%@page import="connectDB.TimestampFileRenamePolicy"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="ptMgr" class="connectDB.PhotoMgr"/>
<%
	String url = request.getParameter("p");
	
	String host = (String) session.getAttribute("HOST");
	if(host == null || !host.equals("url"))
		response.sendRedirect("host_board.jsp?p="+url);

	int shop_idx = fMgr.getFranchInfo(url).getIdx();
	String path = getServletContext().getRealPath("images/shop_photo");
	
	StringBuffer requestUrl = request.getRequestURL();
	int tmp_idx = requestUrl.indexOf(request.getRequestURI());
	String db_photo_url = requestUrl.substring(0, tmp_idx)+request.getContextPath()+"/images/shop_photo/";
	
	String contentType = request.getContentType();
	
	if(contentType.contains("multipart/form-data")){//사진 추가
	 	MultipartRequest multi = new MultipartRequest(request, path, 10*1024*1024, "UTF-8", new TimestampFileRenamePolicy(shop_idx) );
		ptMgr.insertPhoto(shop_idx, multi, db_photo_url);
	}
	else if(contentType.contains("application/x-www-form-urlencoded") && request.getParameter("del_idx") == null){//순서 변경
		int shop_photo_idx = Integer.parseInt(request.getParameter("shop_photo_idx"));
		int bog = Integer.parseInt(request.getParameter("bog"));		
		ptMgr.orderingPhoto(shop_photo_idx, bog);
	}else{//삭제
		int del_idx = Integer.parseInt(request.getParameter("del_idx"));
		ptMgr.deletePhoto(del_idx, path);
	}
%>