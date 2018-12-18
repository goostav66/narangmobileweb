<!-- 전체메뉴 페이지 -->
<%@page import="java.util.HashMap"%>
<%@page import="connectDB.MenuMgr"%>
<%@page import="connectDB.MenuBean"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="mMgr" class="connectDB.MenuMgr"/>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<%
	String url = request.getParameter("p");
	String lan = request.getParameter("lan");
	String menuType = request.getParameter("m");
	
	int type = 0; //type = 0: 전체메뉴, 1: 점심특선
	if(menuType != null)
		type = Integer.parseInt(menuType);
	
	int shop_idx = fMgr.getFranchInfo(url).getIdx();
	Vector<MenuBean> vlist = mMgr.getMenuList(shop_idx, type);
%>

<html>
<body>
<jsp:include page="franch_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="<%=lan%>" name="lan"/>
</jsp:include>	

<!-- 메뉴 1칸의 레이아웃 -->
	<%
	if(vlist.size()==0){%>
	<div style="text-align:center;"><h3>메뉴 준비 중입니다.</h3></div>
	<%}else{
		for(int i = 0; i<vlist.size(); i++){
			MenuBean mBean = vlist.get(i);
			int price = mBean.getPrice();
			int price_s = mBean.getPrice_s();
			int price_m = mBean.getPrice_m();
			int price_l = mBean.getPrice_l();%>
	
	<div class="layout_menu" id="<%=mBean.getIdx()%>">
		<div class="menu_photo">
		<%if(mBean.getMenu_photo() != null){%>
			<div style="background-image: url('<%=mBean.getMenu_photo()%>')">
			</div>
			<%-- <img src="<%=mBean.getMenu_photo()%>"> --%>
		<%}else {%>
			<img src="../images/menu/noimage.jpg">
		<%} %>
		</div> 
		<div class="menu_txt">
			<div class="menu_name">
				<span><%=mBean.getMenu_name()%></span>
			</div>
			<div class="menu_infor">
				<span><%=mBean.getMenu_infor()%></span>
			</div>
		</div>
		<div class="menu_price">
		<%if(price != 0){ //단일 메뉴%>
			<div>
				<span class="menu_price">
				<%if(price == 1)//특수 가격: 싯가(1)
					out.write("싯가");
				else
					out.write(mMgr.intToPrice(price)+"원");%>
				</span>
			</div>
		<%} else{ //price == 0 : 사이즈별 메뉴 %>
			<%if(price_l != 0){%>
			<div>
				<span class="menu_price"><%=mMgr.intToPrice(price_l)%>원</span>
				<span class="menu_size">대</span>
			</div>
			<%} %>
			<%if(price_m != 0){%>
			<div>
				<span class="menu_price"><%=mMgr.intToPrice(price_m)%>원</span>
				<span class="menu_size">중</span>
			</div>
			<%} %>
			<%if(price_s != 0){%>
			<div>
				<span class="menu_price"><%=mMgr.intToPrice(price_s)%>원</span>
				<span class="menu_size">소</span>
			</div>
			<%} %>
		<%}%>
		</div><!-- div.menu_price -->
	</div><!-- div.layout_menu -->
		
		<%} 
	}%>
	<div class="dialog_background"></div>
	<div class="dialog_menu_detail">
		<div class="dialog_close"><img src="../images/icon_common/icon_x.png"></div>
		<div id="menu_detail_name"></div>
		<div id="menu_detail_img"></div>
	</div>
</div><!-- div.wrap -->

</body>
</html>