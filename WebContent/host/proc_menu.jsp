<%@page import="connectDB.TimestampFileRenamePolicy"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="mMgr" class="connectDB.MenuMgr"/> 
<%
	String url = request.getParameter("p");
	System.out.println(url);
	String host = (String) session.getAttribute("HOST");
	if(host == null || !host.equals("url"))
		response.sendRedirect("host_board.jsp?p="+url);
	
	String path = getServletContext().getRealPath("images/menu");
	int shop_idx = fMgr.getFranchInfo(url).getIdx();

	StringBuffer requestUrl = request.getRequestURL();
	int tmp_idx = requestUrl.indexOf(request.getRequestURI());
	String db_photo_url = requestUrl.substring(0, tmp_idx)+request.getContextPath()+"/images/menu/";
	
	String contentType = request.getContentType();
	
	if(contentType.contains("multipart/form-data")){
	 	MultipartRequest multi = new MultipartRequest(request, path, 10*1024*1024, "UTF-8", new TimestampFileRenamePolicy(shop_idx) );
	 	
	 	//메뉴 수정
	 	if(multi.getParameter("idx") != null){
	 		mMgr.updateMenuAsync(multi, db_photo_url);
	 	}else{
	 	//메뉴 추가
	 		mMgr.insertMenuAsync(shop_idx, multi, db_photo_url);
	 	}
	}
	else if(contentType.contains("application/x-www-form-urlencoded")){
		//메뉴 삭제
		if( request.getParameter("del_menu_idx") != null ){
			int menu_idx = Integer.parseInt(request.getParameter("del_menu_idx"));
			mMgr.deleteMenu(menu_idx, path);
		}	
	}
%>