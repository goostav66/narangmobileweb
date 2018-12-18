<%@page import="connectDB.SaleJoinBean"%>
<%@page import="connectDB.EventListBean"%>
<%@page import="connectDB.EventBean"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<jsp:useBean id="sMgr" class="connectDB.SaleMgr"/>
<jsp:useBean id="pMgr" class="connectDB.PhotoMgr"/>
<%
	String url = request.getParameter("p");

	Vector<SaleJoinBean> saleList = sMgr.getSaleListLocationally(url);
%>

<div class="section_discount">
	<div class="discount_title"><span>번개 할인</span></div>
	<div class="discount_list">
	<%for(int i = 0; i<saleList.size(); i++){
		SaleJoinBean sale = saleList.get(i);
		String main_photo = pMgr.getMainPhoto(sale.getIdx()).getPhoto_url();%>
		<div class="layout_discount">
			<input type="hidden" name="url" value="<%=sale.getUrl()%>">
			<input type="hidden" name='dc_idx' value="<%=sale.getIdx()%>">
			<div class="shop_photo">
				<img src="<%=main_photo%>">
			</div>
			<div class="shop_name">
				<span><%=sale.getShop_name()%></span>
			</div>
			<div class="shop_msg">
				<span><p><%=sale.getMenu()%> 정가할인 <%=sale.getDc_rate()%>%</p></span>
			</div>
			<div class="discount_btn" style="height: 10vmin;">
				<img class="direct" src="../images/icon_common/icon_promotion_direct_with_txt.png">
				<img class="share_pop" src="../images/icon_common/icon_promotion_share_with_txt.png">
			</div>
		</div>
	<%} %>
	</div>
	
	<div class="dialog_background"></div>
	<div class="dialog_share">
		<input type="hidden" name='dialog_url' value=''>
		<div class="dialog_close"><img src="../images/icon_common/icon_x.png"></div>
		<div class="dialog_title"></div>
		<div align="center" class="dialog_share_icon">
			<div class="share_dc_sms">
				<img src="../images/icon_common/icon_sms.png"><br>
				<span>문자메시지</span>
			</div>
			<div class="share_dc_kakao">
				<img src="../images/icon_common/icon_kakao.png"><br>
				<span>카카오톡</span>
			</div>
			<div class="share_dc_face">
				<img src="../images/icon_common/icon_fb.png"><br>
				<span>페이스북</span>
			</div>
		</div>
	</div>
	
</div>