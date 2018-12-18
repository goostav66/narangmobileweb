<%@page import="connectDB.TagBean"%>
<%@page import="java.util.Vector"%>
<%@page import="connectDB.FranchiseBean"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<jsp:useBean id="tMgr" class="connectDB.TagMgr"/>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<%
	String url = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	if(host == null || !host.equals("url"))
		response.sendRedirect("host_board.jsp?p="+url);
	int shop_idx = fMgr.getFranchInfo(url).getIdx();
	
	if( request.getParameter("insert_keyword") != null ){//키워드 추가
		String keyword = request.getParameter("insert_keyword");
		tMgr.insertTag(shop_idx, keyword);
	}
	if( request.getParameter("delete_keyword_idx") != null ){
		int keyword_idx = Integer.parseInt( request.getParameter("delete_keyword_idx") );
		tMgr.deleteTag(keyword_idx);
	}
	
%>