<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="bMgr" class="connectDB.BoardMgr"/>
<jsp:useBean id="bBean" class="connectDB.BoardBean"/>
<jsp:setProperty name="bBean" property="*"/>
<%
	String url = request.getParameter("p");
	bBean.setUrl(url);
	int idx = bBean.getIdx();

	if(idx == 0){//새글 쓰기
		bMgr.insertBoard(bBean);
	}else{	
		bMgr.updateBoard(bBean);
	}
	response.sendRedirect("host_board.jsp?p="+url);
%>
