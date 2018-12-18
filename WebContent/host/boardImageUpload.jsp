<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page contentType="text/html;"%>
<%	//request.setCharacterEncoding("UTF-8");	

	String path = getServletContext().getRealPath("images/upload");
	
	MultipartRequest multi = new MultipartRequest(request, path, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
	
	Enumeration en = multi.getFileNames();
	
	if(en.hasMoreElements()){
		String name = (String) en.nextElement();
		String file_name = multi.getFilesystemName(name);
		out.write(file_name);
	}
%>
