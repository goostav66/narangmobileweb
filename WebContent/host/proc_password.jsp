<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="hMgr" class="connectDB.HostMgr"/>

<%
	String url = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	if(host==null) response.sendRedirect("host_board.jsp?p="+url);
	
	String pass= request.getParameter("pass");
	
	hMgr.updatePass(host, pass);
%>

<script>
	alert("��й�ȣ ������ �Ϸ�Ǿ����ϴ�");
	location.href="host_board.jsp?p=<%=url%>";
</script>