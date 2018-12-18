<%@page import="connectDB.FranchiseBean"%>
<%@page import="connectDB.BoardMgr"%>
<%@page import="connectDB.BoardBean"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="bMgr" class="connectDB.BoardMgr"  scope="session"/>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="ptMgr" class="connectDB.PhotoMgr"/>
<%
	String url = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	int shop_idx = fMgr.getFranchInfo(url).getIdx();
	
	FranchiseBean fBean = fMgr.getFranchInfo(url);
	String shop_name = fBean.getShop_name();
%>	
<html>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="<%=shop_name%>" name="h"/>
</jsp:include>

<section class="section_host">
	<input type="hidden" name="url" value="<%=url%>">
	<input type="hidden" name="shop_name" value="<%=shop_name%>">
	<input type="hidden" name="photo_url" value="<%=ptMgr.getMainPhoto(shop_idx).getPhoto_url()%>">
	<%if(host!=null && url.equals(host)){%>
	<div class="host_board_add">
		<img src="../images/icon_common/icon_write_board.png" onclick="location.href='newPost.jsp?p=<%=url%>'">
	</div>
	<%} %>
	<%
	Vector<BoardBean> vlist = bMgr.getBoardList(url);
	if(vlist.size()==0){%>
	<div align='center'>
		<img class="board_no_img" src="../images/icon_common/illust_no_post.png">
		<h3 style="color: #6e6e6e;">등록된 글이 없습니다.</h3>
	</div>	
	<%}else{
	for(int i=0; i<vlist.size(); i++){
		BoardBean bean = vlist.get(i);
	%>
	<article class="board_article">
		<input type="hidden" name="board_idx" value="<%=bean.getIdx()%>">
		<div class="article_upper">
			<div class="board_regtime">
				<span><%=BoardMgr.TIME_TO_POST.format(bean.getRegdate())%></span>
			</div>
			<div class="board_control">
			<%if(host != null && url.equals(host) ){ %>
				<span onclick="location.href='newPost.jsp?p=<%=url%>&idx=<%=bean.getIdx()%>'">수정</span>
				<span onclick="location.href='deletePost.jsp?p=<%=url%>&idx=<%=bean.getIdx()%>'">삭제</span>
			<%} %>
			</div>
		</div>		
		<span class="board_content"><%=bean.getContent()%></span>	
		<div class="share_board">
			<img src="../images/sample_img/narang_pic_6.png">
		</div>
	</article>	
	<%} }%>
	<div class="dialog_background"></div>
	<div class="dialog_share">
		<input type="hidden" name="dialog_bIdx" value="">
		<div class="dialog_close"><img src="../images/icon_common/icon_x.png"></div>
		<div class="dialog_title"></div>
		<div align="center" class="dialog_share_icon">
			<div class="share_board_sms" align='center'>
				<img src="../images/icon_common/icon_sms.png"><br>
				<span>문자메시지</span>
			</div>
			<div class="share_board_kakao" align='center'>
				<img src="../images/icon_common/icon_kakao.png"><br>
				<span>카카오톡</span>
			</div>
			<div class="share_board_face" align='center'>
				<img src="../images/icon_common/icon_fb.png"><br>
				<span>페이스북</span>
			</div>
		</div>
	</div>
</section>
</div><!-- div.wrap -->
</body>
</html>

