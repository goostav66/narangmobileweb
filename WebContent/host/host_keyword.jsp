<%@page import="connectDB.TagBean"%>
<%@page import="java.util.Vector"%>
<%@page import="connectDB.FranchiseBean"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="tMgr" class="connectDB.TagMgr"/>
<%
	String url = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	if( host == null || !host.equals(url) ) response.sendRedirect("host_board.jsp?p="+url);
	
	int shop_idx = fMgr.getFranchInfo(url).getIdx();
	
	response.setHeader("pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.addHeader("Cache-Control","No-store");
	response.setDateHeader("Expires",1L);
	
	Vector<TagBean> tagList = tMgr.getTagList(shop_idx);
%>	

<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="검색어 관리" name="h"/>
</jsp:include>
<section class="section_host">
	<div class="keyword_guid">
		<span>예약 서비스에서 가맹점 검색에 노출되는 단어를 설정할 수 있습니다.</span><br>
		<span>가맹점명, 주소, 업종, 메뉴명은 검색어 목록에 입력하지 않아도 검색풀에 포함됩니다.</span>
	</div>
	<div class="keyword_list">
	<%for(int i = 0; i < tagList.size(); i++){
		TagBean tag = tagList.get(i);%>
		<div id="<%=tag.getIdx()%>"><%=tag.getTag()%></div>
	<%} %>
	</div>
	<div class="keyword_input">
		<input type="text" maxlength="10">
		<span></span>
	</div>
	<div class="keyword_guid" align="center">
		<span>키워드 추가: 엔터 입력</span><br>
		<span>키워드 삭제: 삭제할 키워드 클릭</span>
		
	</div>
</section>