<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="connectDB.GuestPhotoBean"%>
<%@page import="connectDB.GuestMgr"%>
<%@page import="connectDB.GuestBean"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="gMgr" class="connectDB.GuestMgr"/>
<%
	String url = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	if(host == null || !host.equals(url)) response.sendRedirect("host_board.jsp?p="+url);

	String filePath = getServletContext().getRealPath("images/reply");
	gMgr.trimReplyPhoto(filePath);
	
	SimpleDateFormat sdf_src = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf_adj = new SimpleDateFormat("yy/MM/dd HH:mm");
	
	response.setHeader("pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.addHeader("Cache-Control","No-store");
	response.setDateHeader("Expires",1L);
%>
<html>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="손님이야기" name="h"/>
</jsp:include>
		
<section class="section_host">
	<span style="color: #aaa; font-size: 0.7rem;">&nbsp;문자메시지 아이콘을 클릭하면 피드백을 전달할 수 있습니다.</span>
	<%Vector<GuestBean> gList = gMgr.getCommentList(url);
	for(int i = 0; i<gList.size(); i++){
		GuestBean bean = gList.get(i);
	
		Date credate = sdf_src.parse(bean.getCredate().toString());
		String date = sdf_adj.format(credate);
		
		int emoticon_idx = bean.getEmoticon()+1;
		
		Vector<GuestPhotoBean> gpList = gMgr.getPhotoList(bean.getIdx()); 
	%>
	<div class="layout_host_review">
		<input type="hidden" name="photo_size" value="<%=gpList.size()%>">
		<input type="hidden" name="phone" value="<%=bean.getPhone()%>">
		<div class="host_review_infor">
			<div class="review_infor_contact">익명</div>
			<div class="review_infor_date"><%=date%></div>
			<div class="review_delete"><img src="../images/icon_common/icon_x.png" id="<%=bean.getIdx()%>"></div>
		</div>
		<div class="host_review_photo">
			<div>
		<%for(int j = 0; j < gpList.size(); j++){
			GuestPhotoBean photo = gpList.get(j); %>
				<div class="review_photo_take" style="background-image: url('<%=photo.getPhoto_url()%>')">
					<%-- <img class="review_photo_take" src="<%=photo.getPhoto_url()%>"> --%>
				</div>
		<%} %>
				<img class="review_photo_more" src="../images/icon_common/+.png">
				
			</div>
		</div>
		<div class="host_review_comment limitedHeight">
			<div class="review_emoticon">
				<img src="../images/guest_story/reply_emo_<%=emoticon_idx%>.png">
			</div>
			<div class="review_message">
				<span><%=bean.getMsg()%></span>
			</div>
		</div>
	</div>
	
	<%} %>
</section>
<div class="dialog_review_photo">
	<img class="photo_slide_close" src="../images/icon_common/icon_x_r.png">
	<div class="photo_slide_select"></div>
	<div class="photo_slides"></div>
</div>
</div><!-- div.wrap -->
<script>
	$(document).ready(function(){
		initReviewLayout();
	});
</script>
</body>
</html>