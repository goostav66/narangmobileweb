<!-- 업소정보 관리 페이지 -->
<%@page import="connectDB.AgentBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="connectDB.FranchiseBean"%>
<%@page import="connectDB.PhotoBean"%>
<%@page import="java.util.Vector"%>
<%@page import="connectDB.FranchiseMgr"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>

<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="ptMgr" class="connectDB.PhotoMgr"/>
<%
	String url = request.getParameter("p");
	
	String host = (String) session.getAttribute("HOST");
	if( host == null || !host.equals(url) ) response.sendRedirect("host_board.jsp?p="+url);
	
	FranchiseBean shop = fMgr.getFranchInfo(url);
	if( shop.getShop_name() == null )
		response.sendRedirect("host_infor.jsp?p="+url);
	
	int shop_idx = shop.getIdx();
	
	Vector<PhotoBean> ptList = ptMgr.getPhotoList(shop_idx);
	
	AgentBean agent = fMgr.getManagerInfo(url);
	
	response.setHeader("pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.addHeader("Cache-Control","No-store");
	response.setDateHeader("Expires",1L);
	
	String realPath = getServletContext().getRealPath("images/shop_photo");
	ptMgr.trimShopFile(realPath);
%>
<html>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="업소정보 관리" name="h"/>
</jsp:include>	
	
<section class="section_host">
	<form class="form_host_infor" method="POST" action="proc_infor.jsp?p=<%=url%>">
	<input type="hidden" name="url" value="<%=url%>">
	<div>
		<div class="host_infor_left">업소명</div>
		<div class="host_infor_right"><input type="text" name="shop_name" value="<%=shop.getShop_name()%>"></div>
	</div>
	<div>
		<div class="host_infor_left">전화번호</div>
		<div class="host_infor_right"><input type="text" name="shop_phone" value="<%=shop.getShop_phone()%>"></div>
	</div>

	<div>
		<div class="host_infor_left">관할 대리점</div>
		<div class="host_infor_right"><span><%=agent.getAgent_name()%></span></div>
	</div>
	<div>
		<div class="host_infor_left">주소</div>
		<div class="host_infor_right">
			<select class="list_location_city" name="location_code">
			<%
			List<Integer> cityList = fMgr.getLocationCityList(shop.getLocation_code());
			for(int i = 0; i<cityList.size(); i++){
				int location_code = cityList.get(i);
				String city = fMgr.getLocationPlace(location_code);%>
				<option value="<%=location_code%>" <%if(location_code == shop.getLocation_code()) out.write("selected");%>><%=city%></option>
			<% }
			%>
			</select>
			
			<textarea name="shop_addr" placeholder="<%=fMgr.getLocationPlace(shop.getLocation_code())%> 이후의 주소부터 입력해주세요."><%=shop.getShop_addr()%></textarea>
			<span></span>
			<input type="hidden" name="lat" id="shop_lat" value="<%=shop.getLat()%>">
			<input type="hidden" name="lng" id="shop_lng" value="<%=shop.getLng()%>">
		</div>
	</div>
	<div>
		<div class="host_infor_left">영업시간</div>
		<div class="host_infor_right">
			<div class="host_infor_time"><span>평일 </span><input type="time" name="open_weekDay" value="<%=shop.getOpen_weekDay()%>"> - <input type="time" name="close_weekDay" value="<%=shop.getClose_weekDay()%>"></div>
			<div class="host_infor_time"><span>주말 </span><input type="time" name="open_weekEnd" value="<%=shop.getOpen_weekEnd()%>"> - <input type="time" name="close_weekEnd" value="<%=shop.getClose_weekEnd()%>"></div>
			<div class="host_infor_time"><span>휴무 </span><input type="text" name="offday" value="<%=shop.getOffday()%>"></div>
		</div>
	</div>
	<div>
		<div class="host_infor_left">추천메뉴</div>
		<div class="host_infor_right">
			<textarea name="recom_menu"><%=shop.getRecom_menu()%></textarea>
			<span></span>
		</div>
	</div>
	<div>
		<div class="host_infor_left">한줄소개</div>
		<div class="host_infor_right">
			<textarea name="intro_text"><%=shop.getIntro_text()%></textarea>
			<span></span>
		</div>
	</div>
	<div>
		<div class="host_infor_left">부가정보</div>
		<div class="host_infor_right">
			<div class="host_infor_extra" id="extra_dc_rate" align="center">
				<input type="hidden" name="discount" value="<%=shop.getDiscount()%>">
				<img src="../images/icon_common/icon_discount_0.png">
				<img src="../images/icon_common/icon_discount_5.png">
				<img src="../images/icon_common/icon_discount_10.png">
				<img src="../images/icon_common/icon_discount_15.png">
				<span>예약 할인율</span>
			</div>
			<div class="host_infor_extra" id="extra_is_parking" align="center">
				<input type="hidden" name="isParking" value="<%=shop.getIsParking()%>">
				<img src="../images/icon_common/icon4_off.png">
				<img src="../images/icon_common/icon4_on.png">
				<span>주차시설</span>
			</div>
			<div class="host_infor_extra" id="extra_is_seats" align="center">
				<input type="hidden" name="isSeats" value="<%=shop.getIsSeats()%>">
				<img src="../images/icon_common/icon5_off.png">	
				<img src="../images/icon_common/icon5_on.png">
				<span>단체석 완비</span>
			</div>
			<span>아이콘을 터치하면 부가정보 설정을 변경할 수 있습니다.</span>
		</div>
			
	</div>
	<div>
		<div class="host_infor_left">사진</div>
		<div class="host_infor_right">
			<button class="host_photo_mgr">관리</button>
		</div>
		<div class="host_infor_photo">
			<%for(int i = 0; i < ptList.size(); i++){
				PhotoBean photo = ptList.get(i);%>
			<img src="<%=photo.getPhoto_url()%>">
			<%} %>
		</div>
		<span>각 사진을 클릭하면 확대하여 볼 수 있습니다.</span>
	</div>
	<div>
		<button class="host_infor_save">저장</button>
		<button class="host_infor_cancel">취소</button>
	</div>
	</form>
</section>	
<div class="dialog_shop_photo">
	<img src="">
</div>
</div><!-- div.wrap -->
<script>
	$(document).ready(function(){
		initIconDcRate($("input[name='discount']").val());
		initIconIsParking($("input[name='isParking']").val());
		initIconIsSeats($("input[name='isSeats']").val());
	});
</script>
</body>
</html>