<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="sMgr" class="connectDB.SaleMgr"/>
<jsp:useBean id="sale" class="connectDB.SaleBean"/>
<%
	SimpleDateFormat sdf_adj = new SimpleDateFormat("yyyy-MM-dd HH:mm");

	if(request.getParameter("del_sale_idx") != null){//번개할인 삭제
		int idx = Integer.parseInt(request.getParameter("del_sale_idx"));
		sMgr.deleteSale(idx);
	}else{
		String date = request.getParameter("date");
		String time_start = request.getParameter("time_start");
		String time_end = request.getParameter("time_end");
		String date_start, date_end;
		date_start = date + " " + time_start;
		if( Integer.parseInt(time_start.split(":")[0]) >= Integer.parseInt(time_end.split(":")[0]) ){
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(sdf_adj.parse(date.concat(" "+time_end)));
			calendar.add(Calendar.DATE, 1);
			
			date_end = sdf_adj.format(calendar.getTime());
		}else{
			date_end = date.concat(" "+time_end);
		}
		
		sale.setUrl(request.getParameter("url"));
		sale.setDate_start(date_start);
		sale.setDate_end(date_end);
		sale.setMenu(request.getParameter("menu"));
		sale.setDc_rate(Integer.parseInt(request.getParameter("dc_rate")));
		sale.setEtc(request.getParameter("etc"));
		
		if(request.getParameter("idx") == null)//번개할인 등록
			sMgr.insertSale(sale);
		else{//번개할인 수정
			int idx = Integer.parseInt(request.getParameter("idx"));
			sale.setIdx(idx);
			sMgr.updateSale(sale);
		}
	}
%>