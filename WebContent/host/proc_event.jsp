<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.util.Enumeration"%>
<%@page import="connectDB.EventBean"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	//request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="eMgr" class="connectDB.EventMgr"/>
<%
	if(request.getParameter("del_event_idx") != null){//�̺�Ʈ ����
		eMgr.deleteEvent(Integer.parseInt(request.getParameter("del_event_idx")));
	}else if(request.getParameter("event_duration_idx") != null){//�̺�Ʈ �Ⱓ ����
		int idx = Integer.parseInt(request.getParameter("event_duration_idx"));
		String parameter = request.getParameter("parameter");
		String date = request.getParameter("date");
		if( parameter.equals("date_start") ) eMgr.updateDateStart(idx, date);
		else if ( parameter.equals("date_end") ) eMgr.updateDateEnd(idx, date);
	}else if(request.getParameter("event_message_idx") != null){//�̺�Ʈ ���� ����
		int idx = Integer.parseInt( request.getParameter("event_message_idx"));
		eMgr.updateMessage(idx, request.getParameter("message"), request.getParameter("background_img"));	
	}else if(request.getParameter("event_message_url") != null){//�̺�Ʈ ���� �߰�
		EventBean bean = new EventBean();
		bean.setUrl(request.getParameter("event_message_url"));
		bean.setBackground_img(request.getParameter("background_img"));
		bean.setMessage(request.getParameter("message"));
		bean.setDate_start(request.getParameter("date_start"));
		bean.setDate_end(request.getParameter("date_end"));
		eMgr.insertEvent(bean);
	}else if(request.getParameter("event_floating_idx") != null){//�̺�Ʈ ǥ��/���� ���
		int idx = Integer.parseInt( request.getParameter("event_floating_idx") );
		eMgr.toggleFloating(idx);
	}
%>