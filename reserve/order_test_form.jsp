<%@page import="connectDB.OrderBean"%>
<%@page import="java.util.Enumeration"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<jsp:useBean id="oMgr" class="connectDB.OrderMgr"/>
<%	//request.setCharacterEncoding("EUC-KR");	
	
	int shop_idx = Integer.parseInt(request.getParameter("shop_idx"));
	int order_table = Integer.parseInt(request.getParameter("table"));
	int order_menu = Integer.parseInt(request.getParameter("menu_idx"));
	int order_quant = Integer.parseInt(request.getParameter("quantity"));
	
	int price = Integer.parseInt(request.getParameter("menu_price"));
	
	int order_total = order_quant * price;
	
	OrderBean bean = new OrderBean();
	bean.setShop_idx(shop_idx);
	bean.setOrder_table(order_table);
	bean.setOrder_menu(order_menu);
	bean.setOrder_quant(order_quant);
	bean.setOrder_total(order_total);

	oMgr.insertOrder(bean);
%> 