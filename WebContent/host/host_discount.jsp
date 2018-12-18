
<%@page import="connectDB.SaleBean"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="sMgr" class="connectDB.SaleMgr"/>
<%
	String url = request.getParameter("p");

	String host = (String) session.getAttribute("HOST");
	if(host == null || !host.equals(url)) response.sendRedirect("host_board.jsp?p="+url);

	response.setHeader("pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.addHeader("Cache-Control","No-store");
	response.setDateHeader("Expires",1L);
	
	sMgr.deleteExpiredSale();
	
	SaleBean sale = sMgr.getSale(url);
%>
<html>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="번개할인 관리" name="h"/>
</jsp:include>	
	
<section class="section_host">
	<div class="discount_guid"><span>종료시간이 지난 할인은 자동으로 삭제됩니다.</span></div>
	<form class="form_discount">
		<%if(sale.getIdx() != 0) out.write("<input type='hidden' name='idx' value='"+sale.getIdx()+"'>");%>
		<input type="hidden" name="url" value="<%=url%>">
		<div class="layout_host_discount">
			<div>
				<div class="host_discount_left">날짜</div>
				<div class="host_discount_right"><input type="date" name="date" <%if(sale.getIdx() != 0) out.write("value='"+sale.getDate_start().substring(0, 10)+"'");%>></div>
			</div>
			<div>
				<div class="host_discount_left">시간</div>
				<div class="host_discount_right">
					<input type="time" name="time_start" <%if(sale.getIdx() != 0) out.write("value='"+sale.getDate_start().substring(11, 16)+"'");%> > -
					<input type="time" name="time_end" <%if(sale.getIdx() != 0) out.write("value='"+sale.getDate_end().substring(11, 16)+"'");%> >
				</div>
			</div>
			<div>
				<div class="host_discount_left" >할인메뉴</div>
				<div class="host_discount_right">
					<input type="text" name="menu" maxlength=20 <%if(sale.getIdx() != 0) out.write("value='"+sale.getMenu()+"'");%>>
					<span></span>
				</div>
			</div>
			<div>
				<div class="host_discount_left">가격</div>
				<div class="host_discount_right">
					정가할인&nbsp;<input type="number" name="dc_rate" <%if(sale.getIdx() != 0) out.write("value='"+sale.getDc_rate()+"'"); %>>&nbsp;%
				</div>
			</div>
			<div>
				<div class="host_discount_left">비고</div>
				<div class="host_discount_right">
					<textarea name="etc" maxlength=100 placeholder="할인과 관련한 부가내용을 입력합니다(선택 입력)"><%if(sale.getIdx() != 0 && sale.getEtc() != null) out.write(sale.getEtc());%></textarea>
					<span></span>
				</div>
			</div>
			<div>
				<button class="host_discount_save">저장</button>
				<button class="host_discount_delete">삭제</button>
			</div>
		</div>
	</form>
</section>
</div><!-- div.wrap -->
</body>
</html>