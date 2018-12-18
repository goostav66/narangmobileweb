<%@page import="connectDB.EventListBean"%>
<%@page import="connectDB.EventBean"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<jsp:useBean id="eMgr" class="connectDB.EventMgr"/>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="ptMgr" class="connectDB.PhotoMgr"/>
<%
	String url = request.getParameter("p");
	if(fMgr.getFranchInfo(url).getShop_name() == null)
		response.sendRedirect("set_promotion.jsp?p="+url);
	Vector<EventListBean> eventList = eMgr.getPopupListAllUrl(url);
	
%>
<div class="section_event">
	<%if(eventList.size() > 0){%>
	<div class="event_title"><span>이벤트</span></div>
	<div class="event_list">
	<%for(int i = 0; i<eventList.size(); i++){
		EventListBean event = eventList.get(i);
		String message = event.getMessage();%>
		<div class="layout_event">
			<input type="hidden" name="url" value="<%=event.getUrl()%>">
			<div class="shop_photo">
				<img src="<%=ptMgr.getMainPhoto(event.getShop_idx()).getPhoto_url()%>">
			</div>
			<div class="shop_name">
				<span><%=event.getShop_name()%></span>
			</div>
			<div class="shop_msg">
				<span><%=message%></span>
			</div>
			<div class="event_btn" style="height: 10vmin;">
				<img class="direct" src="../images/icon_common/icon_promotion_direct_with_txt.png">
				<img class="share_pop" src="../images/icon_common/icon_promotion_share_with_txt.png">
			</div>
		</div>
	<%} %>
	</div>
	
	<div class="dialog_background"></div>
	<div class="dialog_share">
		<input type="hidden" name='dialog_url' value=''>
		<div class="dialog_close"><img src="../images/icon_common/icon_x.png"></div>
		<div class="dialog_title"></div>
		<div align="center" class="dialog_share_icon">
			<div class="share_event_sms">
				<img src="../images/icon_common/icon_sms.png"><br>
				<span>문자메시지</span>
			</div>
			<div class="share_event_kakao">
				<img src="../images/icon_common/icon_kakao.png"><br>
				<span>카카오톡</span>
			</div>
			<div class="share_event_face">
				<img src="../images/icon_common/icon_fb.png"><br>
				<span>페이스북</span>
			</div>
		</div>
	</div>
	<%} %>
</div>
