<%@ page contentType="text/html; charset=utf-8"%>
<jsp:useBean id="hMgr" class="connectDB.HostMgr"/>
<%
	String url = request.getParameter("p");	
	String password = request.getParameter("password");

	boolean login = hMgr.login(url, password); 
	String msg = "비밀번호를 확인해주세요.";
	String location = "host_login.jsp?p="+url;
	
	if(login){
		msg = "로그인 되었습니다.";
		location = "host_board.jsp?p="+url;
		session.setAttribute("HOST", url);
	}
	
%>
<script>
	alert("<%=msg%>");
	location.href="<%=location%>";
</script>