<%@page import="java.util.Vector"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="connectDB.GuestMgr"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="gBean" class="connectDB.GuestBean"/>
<jsp:useBean id="gMgr" class="connectDB.GuestMgr"/>
<%
	String url = request.getParameter("p");

	StringBuffer requestUrl = request.getRequestURL();
	String requestUri = request.getRequestURI();
	int tmp_idx = requestUrl.indexOf(requestUri);
	String db_photo_url = requestUrl.substring(0, tmp_idx)+request.getContextPath()+"/images/reply/";

	String path = getServletContext().getRealPath("images/reply");
	MultipartRequest multi = new MultipartRequest(request, path, 10*1024*1024, "EUC-KR", new DefaultFileRenamePolicy());
	Enumeration en = multi.getFileNames(); 
	Vector<String> files = new Vector<String>();
	while(en.hasMoreElements()){
		String filenames = (String)en.nextElement();
		String filename = multi.getFilesystemName(filenames);
		if(filename != null && !filename.equals(""))
			files.add(filename);
	}

	String sEmoticon = multi.getParameter("emoticon");
	
	int emoticon = 0;
	if(sEmoticon!=null)
		emoticon = Integer.parseInt(sEmoticon);

	gBean.setUrl(url);
	gBean.setMsg(multi.getParameter("msg"));
	gBean.setEmoticon(emoticon);
	gBean.setPhone(multi.getParameter("phone"));
	
	gMgr.insertComment(gBean, files, db_photo_url);
%>

<script>
	alert("댓글이 등록되었습니다.");
	location.href="guest_story.jsp?p=<%=url%>";
</script>