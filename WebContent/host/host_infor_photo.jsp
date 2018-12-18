<%@page import="connectDB.PhotoBean"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR"); %>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="ptMgr" class="connectDB.PhotoMgr"/>
<%
	String url = request.getParameter("p");

	String host = (String) session.getAttribute("HOST");
	if( host == null || !host.equals(url) ) response.sendRedirect("host_board.jsp?p="+url);

	int shop_idx = fMgr.getFranchInfo(url).getIdx();
	Vector<PhotoBean> ptList = ptMgr.getPhotoList(shop_idx);
%>
<html>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="업소사진 관리" name="h"/>
</jsp:include>
<div class="wrap">
	<section class="section_host">
		<input type="hidden" name="url" value="<%=url%>">
		<div class="host_photo_files"></div>
		<div class="host_photo">
		<%for (int i = 0; i < ptList.size(); i++){
			PhotoBean photo = ptList.get(i);
			int ordinal_group = i+1; %>
			<div class="layer_photo" style="-webkit-box-ordinal-group: <%=ordinal_group%>;">
				<input type="hidden" name="idx" value="<%=photo.getIdx()%>">
				<label>
					<input type="radio" name="photo_select" class="photo_selector">
					<img src="<%=photo.getPhoto_url()%>">
				</label>
			</div>
		<%} %>
		</div>
		<div class="host_photo_remote">
			<button class="top" disabled="disabled">맨위로</button>
			<button class="up" disabled="disabled">위로</button>
			<button class="down" disabled="disabled">아래로</button>
			<button class="bottom" disabled="disabled">맨아래로</button>
			<button class="append">추가</button>
			<button class="remove" disabled="disabled">삭제</button>
			<button class="save">저장</button>
			<button class="exit">종료</button>
		</div>
	</section>
</div>
</html>