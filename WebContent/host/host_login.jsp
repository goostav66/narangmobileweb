<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<%
	String url = request.getParameter("p");

	String shop_name = fMgr.getFranchInfo(url).getShop_name();
	if(shop_name==null) response.sendRedirect("host_login.jsp?p="+url);
%>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="�α���" name="h"/>
</jsp:include>
<section class="section_host">
	<div class="host_login_guid">
		<span><%=shop_name%></span><span> ���ִ� ȯ���մϴ�.</span><br>
		<span>��й�ȣ�� �Է����ּ���.</span>
	</div>
	<form method="POST" action="proc_login.jsp?p=<%=url%>">
	<div class="host_login_password">
	<%if( url != null && url.equals("djs1a0122")){%>
		<input type="number" name="password" placeholder="��й�ȣ"><%}
	else{%>
		<input type="password" name="password" placeholder="��й�ȣ">
	<%} %>
		<button type="submit">�α���</button>	
	</div></form>
</section>
</html>