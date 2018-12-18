<%@page import="connectDB.EventBean"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="eMgr" class="connectDB.EventMgr"/>
<%
	String url = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	if(host == null || !host.equals(url)) response.sendRedirect("host_board.jsp?p="+url);

	response.setHeader("pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.addHeader("Cache-Control","No-store");
	response.setDateHeader("Expires",1L);
	
	Vector<EventBean> eList = eMgr.getPopupList(url);
%>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="이벤트 관리" name="h"/>
</jsp:include>

<section class="section_host">
	<input type="hidden" name="url" value="<%=url%>">
	<span class="event_guid">각 항목을 클릭하면 수정할 수 있습니다.</span>	
	<div class="host_new_btn_fixed" onclick="location.href='host_event_textEditor.jsp?p=<%=url%>'">
		<img src="../images/icon_common/icon_+.png">
	</div>
	<%for(int i = 0; i < eList.size(); i++){
		EventBean event = eList.get(i);%>
	<div class="layout_host_event">
		<input type="hidden" name="idx" value="<%=event.getIdx()%>">
		<div class="host_event_delete">
			<img src="../images/icon_common/icon_x.png">
		</div>
		<div class="host_event_content" style="background-image: url('../images/sample_img/<%=event.getBackground_img()%>')">
			<span class="event_content_phrase"><%=event.getMessage()%></span>
		</div>
		<div class="host_event_bottom">
			<div class="host_event_duration">
				<label>
					<span class="event_duration_start"><%=event.getDate_start()%></span>
					<input type="date" class="date_start" value="<%=event.getDate_start()%>">
				</label> ~ 
				<label>
					<span class="event_duration_end"><%=event.getDate_end()%></span>
					<input type="date" class="date_end" value="<%=event.getDate_end()%>">	
				</label>
			</div>
			<div class="host_event_floating">			
				<input type="checkbox" class="isFloating" <%if(event.getIsFloating() == 1) out.write("checked");%>>
				<span class="event_floating_text"></span>
				<div class="event_floating_border">
					<div class="event_floating_switch"></div>
				</div>
			</div>
		</div>	
	</div>
	<%} %>
</section>
</div><!-- div.wrap -->

</body>	
</html>