<%@page import="connectDB.CallHistoryBean"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="connectDB.DriverBean"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<jsp:useBean id="dMgr" class="connectDB.DriverMgr"/>
<%
	String url = request.getParameter("call_url");

	String host = (String) session.getAttribute("HOST");
	//if(host == null || !host.equals(url)) response.sendRedirect("host_board.jsp?p="+url);
	
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	
	Vector<CallHistoryBean> chList = null;
	
	if(year != null && month != null)
		chList = dMgr.getCallListBrief(url, Integer.parseInt(year), Integer.parseInt(month));
	
	SimpleDateFormat sdf_src = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	SimpleDateFormat sdf_adj = new SimpleDateFormat("hh시 mm분");
	
	if(chList.size() == 0){
		out.write("<div class='result_data'><span>데이터가 없습니다.</span></div>");
	}else{
		for(int i = 0; i<chList.size(); i++){
			CallHistoryBean bean = chList.get(i);
			out.write("<div>" 
					+ "		<div class='result_data'>"
					+ "			<span class='result_data_no'>"+(i+1)+"</span>"
					+ "			<span class='result_data_datetime'>"+bean.getMonth()+"월 "+bean.getDay()+"일</span>"
					+ "			<span class='result_data_count'>"+bean.getCnt()+"</span>"
					+ "		</div>");
			Vector<DriverBean> dList = dMgr.getCallListDetail(url, Integer.parseInt(year), bean.getMonth(), bean.getDay());
			for(int j = 0; j<dList.size(); j++){
				DriverBean dBean = dList.get(j);
				Date date_src = sdf_src.parse(dBean.getD_datetime());
				out.write("<div class='result_data_detail'>"
						+ "		<span>"+sdf_adj.format(date_src)+"</span>"
						+ "</div>");
			}
			out.write("</div>");
		}
	}
	int count_thisMonth = dMgr.getTotalCountMonthly(url, Integer.parseInt(year), Integer.parseInt(month));
	int	count_carried = dMgr.getCarriedCount(url, Integer.parseInt(year), Integer.parseInt(month));
	int count_carriedNext = count_thisMonth+count_carried-15;
	if(count_carriedNext<0) count_carriedNext=0;
	out.write("<div class='result_data result_count' style='margin-top: 10vmin; border-top: 1px solid #45A737'><span class='result_data_total'>이번달 호출 횟수</span><span class='result_data_count'>"+count_thisMonth+"</span></div>");
	out.write("<div class='result_data result_count'><span class='result_data_total'>이월된 호출 횟수</span><span class='result_data_count'>"+count_carried+"</span></div>");
	out.write("<div class='result_data result_last'><span class='result_data_total'>총합</span><span class='result_data_count'>"+(count_thisMonth+count_carried)+"</span></div>");
	out.write("<div class='result_data result_last'><span class='result_data_total'>다음달 이월 횟수</span><span class='result_data_count'>"+count_carriedNext+"</span></div>");
	
%>