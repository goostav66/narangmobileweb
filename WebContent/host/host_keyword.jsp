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
	<jsp:param value="�˻��� ����" name="h"/>
</jsp:include>
<section class="section_host">
	<div class="keyword_guid">
		<span>���� ���񽺿��� ������ �˻��� ����Ǵ� �ܾ ������ �� �ֽ��ϴ�.</span><br>
		<span>��������, �ּ�, ����, �޴����� �˻��� ��Ͽ� �Է����� �ʾƵ� �˻�Ǯ�� ���Ե˴ϴ�.</span>
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
		<span>Ű���� �߰�: ���� �Է�</span><br>
		<span>Ű���� ����: ������ Ű���� Ŭ��</span>
		
	</div>
</section>