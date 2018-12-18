<%@page import="java.util.Calendar"%>
<%@page import="connectDB.DriverBean"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR"); %>
<jsp:useBean id="dMgr" class="connectDB.DriverMgr"/>
<%
	String url = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	if(host==null) response.sendRedirect("host_board.jsp?p="+url);
		
	response.setHeader("pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.addHeader("Cache-Control","No-store");
	response.setDateHeader("Expires",1L);
%>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="대리운전 통계" name="h"/>
</jsp:include>	
<section class="section_host">

	<div class="call_month">
		<img class="call_month_prev" src="../images/icon_common/control_calendar_prev.png">
		<div><span class="call_history_year"></span>년 <span class="call_history_month"></span>월</div>
		<img class="call_month_next" src="../images/icon_common/control_calendar_next.png">
	</div>
	
	<div class="result_history">
		<div class="result_header">
			<span class="result_header_no">No.</span>
			<span class="result_header_datetime">일시</span>
			<span class="result_header_count">호출수</span>
		</div>
	</div>
</section>