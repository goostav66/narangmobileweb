<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<%
	String url = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	String h = request.getParameter("h");	

	final String PATH_ICON = "../images/icon_common/";
	final String ICON_HOME ="icon_home.png";
	final String ICON_LOGIN = "icon_setting.png";
	final String ICON_MENU = "icon_menu.png";
%>
<%@include file="../nfc_header.jsp"%>
<title>NFC ZONE :: <%=h%></title>
<style>
	nav{ position: fixed; top: 0; z-index: 1; }
</style>
<body>
<div class="wrap">
	<nav>
		<img onclick="location.href='../index.jsp?p=<%=url%>&is=<%=isShared%>'" class="icon_home" src="../images/icon_common/icon_home.png">
		<span class="nav_title"><%=h%></span>
		<% 	if( host!=null && url.equals(host) ){ %>
		<img class="icon_sideNav" src="../images/icon_common/icon_host_menu.png">
		<% } else if( !h.equals("�α���") ){%>
		<img onclick="location.href='../host/host_login.jsp?p=<%=url%>'" class="icon_login" src="../images/icon_common/icon_host_login.png">			
		<% } else{%>
		<img class="icon_home invisible" src="../images/icon_common/icon_home.png">	
		<% }%>
	</nav>
	<div class="sideNav_background"></div>
	<div class="sideNav">
		<div class="close_sideNav">�ݱ�</div>
		<div onclick="location.href='host_board.jsp?p=<%=url%>'">������ �̾߱�</div>
		<div onclick="location.href='host_menu.jsp?p=<%=url%>'">�޴��� ����</div>
		<div onclick="location.href='host_infor.jsp?p=<%=url%>'">�������� ����</div>
		<div onclick="location.href='host_keyword.jsp?p=<%=url%>'">�˻��� ����</div>
		<div onclick="location.href='host_discount.jsp?p=<%=url%>'">�������� ����</div>
		<div onclick="location.href='host_event.jsp?p=<%=url%>'">�̺�Ʈ ����</div>
		<div onclick="location.href='host_review.jsp?p=<%=url%>'">�մ��̾߱�</div>
		<div onclick="location.href='host_call.jsp?p=<%=url%>'">�븮���� ���</div>
		<div onclick="location.href='host_password.jsp?p=<%=url%>'">��й�ȣ ����</div>
		<div onclick="location.href='logoutProc.jsp?p=<%=url%>'">�α׾ƿ�</div>
	</div>