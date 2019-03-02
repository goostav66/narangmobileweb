<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="bMgr" class="connectDB.BoardMgr"/>
<jsp:useBean id="bBean" class="connectDB.BoardBean"/>
<%
	String url = request.getParameter("p");
	
	if(session.getAttribute("HOST")==null && !session.getAttribute("HOST").equals("bshwc16")) response.sendRedirect("host_board.jsp?p="+url);
	
	String sIdx = request.getParameter("idx");
	int idx = 0;
	if(sIdx!=null){
		idx = Integer.parseInt(sIdx);
		bBean = bMgr.getBoard(idx);
	}
	
	response.setHeader("pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.addHeader("Cache-Control","No-store");
	response.setDateHeader("Expires",1L);
	
%>
<%@include file="../nfc_header.jsp"%>
<body>
<form method="post" action="insertPost.jsp?p=<%=url%>" >
	<div class="post_btn">
		<img class="host_board_reg" style="float:left" src="../images/icon_common/icon_arrow_right.png" onclick="window.history.back()">
		<span class="host_board_reg" style="float:right" id="sub"></span>
	</div>

	<div id="editor"><%if(idx!=0){%><%=bBean.getContent()%><%}%></div>
	<input type="hidden" id="content" name="content">
	<%if(idx!=0){%><input type="hidden" name="idx" value=<%=bBean.getIdx()%>><%} %>
	
</form>
</body>


<script>
	$(document).ready(function(){
		var toolbarOptions = [
			['bold', 'italic', 'underline', 'strike'],
			[{ 'color': [] }, { 'background': [] }],          // dropdown with defaults from theme
			['image']];
		
		 var quill = new Quill('#editor', {
			modules:{toolbar: toolbarOptions},
		    theme: 'snow'	 
	  	});
		
		 $("#sub").click(function(){
			 var myEditor = document.querySelector('#editor');
			 var html = myEditor.children[0].innerHTML;		 
			 $("#content").val(html);
	
			 $("form").submit();
		 });
		
	});	
</script>

</body>
</html>
