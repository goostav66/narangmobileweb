<%@page import="java.util.Vector"%>
<%@page import="connectDB.ManagerInfoBean"%>
<%@page import="connectDB.FranchiseBean"%>
<%@page import="connectDB.FranchiseMgr"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="shop" class="connectDB.FranchiseBean"/>
<%
	String url = request.getParameter("p");
	
	String host = (String) session.getAttribute("HOST");
	if( host == null || !host.equals(url) ) response.sendRedirect("host_board.jsp?p="+url);
	
	shop = fMgr.getFranchInfo(url);
	if( shop.getShop_name() == null )
		response.sendRedirect("host_infor.jsp?p="+url);
	
	int shop_idx = shop.getIdx();
	
	//관할 대리점 정보
	ManagerInfoBean manager = fMgr.getManagerInfo(url);
	String manager_name = "";
	String manager_phone = "";
	if( manager.getAgent_name() != null ){ 
		manager_name = manager.getAgent_name();
		manager_phone = manager.getAgent_manager_phone();
	}else{
		out.write(manager.getBranch_name());
		manager_name = manager.getBranch_name();
		manager_phone = manager.getBranch_manager_phone();
	}
	
	//1: 업소정보, 2: 영업정보
	int info_reading_type = Integer.parseInt(request.getParameter("r_type"));
%>
	<input type="hidden" name="p" value="<%=url%>">
	<input type="hidden" name="r_type" value="<%=info_reading_type%>">
<%
	if( info_reading_type == 1 ){%>
	<div class="host_infor_content content_shop_profile">
		<div class="content_table_cell">
			<div class="table_cell_header">업소명</div>
			<div class="table_cell_row">
				<input type="text" name="shop_name" value="<%=shop.getShop_name()%>" maxlength="100">
			</div>
		</div>
		<div class="content_table_cell">
			<div class="table_cell_header">전화번호</div>
			<div class="table_cell_row">
				<input type="text" name="shop_phone" value="<%=shop.getShop_phone()%>" maxlength="100">
			</div>
		</div>
		<div class="content_table_cell">
			<div class="table_cell_header">관할 지점</div>
			<div class="table_cell_row" style="display: flex; align-items: center;">
				<div style="padding: 2vmin;">
					<%=manager_name%>
				</div>
				<div>
					<img class="manager_call" src="../images/icon_common/btn_call.jpg">
					<input type="hidden" name="manager_phone_number" value="<%=manager_phone%>">
				</div>
			</div>
		</div>
		
		<div class="content_table_cell">
			<div class="table_cell_header">주소</div>
			<div class="table_cell_row">
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
			</div>
			<div class="table_cell_row">
				<div style="position: relative">		
					<textarea name="shop_addr" placeholder="<%=fMgr.getLocationPlace(shop.getLocation_code())%> 이후의 주소부터 입력해주세요."><%=shop.getShop_addr()%></textarea>
					<span class="marker_length_textarea"></span>
				</div>
				<input type="hidden" name="lat" id="shop_lat" value="<%=shop.getLat()%>">
				<input type="hidden" name="lng" id="shop_lng" value="<%=shop.getLng()%>">
			</div>
		</div>
	</div>
<%} else if( info_reading_type == 2 ) {%>
	<div class="host_infor_content content_sales_infor">
		<div class="content_table_cell">
			<div class="table_cell_header">영업시간</div>
			<div class="table_cell_row">
				<span>평일</span>
				<input type="time" name="open_weekDay" value="<%=shop.getOpen_weekDay()%>"> - <input type="time" name="close_weekDay" value="<%=shop.getClose_weekDay()%>"></div>
			<div class="table_cell_row">
				<span>주말</span>
				<input type="time" name="open_weekEnd" value="<%=shop.getOpen_weekEnd()%>"> - <input type="time" name="close_weekEnd" value="<%=shop.getClose_weekEnd()%>"></div>
			<div class="table_cell_row">
				<span>휴무</span>
				<input type="text" name="offday" value="<%=shop.getOffday()%>" style="width: 84%">
			</div>	
		</div>		
		
		<div class="content_table_cell">
			<div class="table_cell_header">추천메뉴</div>
			<div class="table_cell_row">
				<div style="position: relative">
					<textarea name="recom_menu"><%=shop.getRecom_menu()%></textarea>
					<span class="marker_length_textarea"></span>
				</div>	
			</div>
		</div>
		
		<div class="content_table_cell">
			<div class="table_cell_header">한줄소개</div>
			<div class="table_cell_row">
				<div style="position: relative">
					<textarea name="intro_text"><%=shop.getIntro_text()%></textarea>
					<span class="marker_length_textarea"></span>
				</div>		
			</div>
		</div>
		
		<div class="content_table_cell">
			<div class="table_cell_header">부가정보</div>
			<div class="table_cell_row" style="display: -webkit-box">
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
			</div>	
			<div class="table_cell_row" style="font-size: 0.8rem;">	
				<span>아이콘을 터치하면 부가정보 설정을 변경할 수 있습니다.</span>
			</div>
		</div>
	</div>
<%} %>