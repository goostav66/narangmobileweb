<%@ page import="java.util.Date" %>
<%@page import="java.util.Vector"%>
<%@page import="connectDB.FranchiseListBean"%>
<%@page import="connectDB.FranchiseMgr"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="ptMgr" class="connectDB.PhotoMgr"/>
<% 	
	request.setCharacterEncoding("EUC-KR");
	
    String url = request.getParameter("p");//업소코드
	String lan = request.getParameter("lan");
    
    int start = 0;
    int limit = 9;
    
    String searchText = request.getParameter("search");
	if( searchText != null && (searchText.equals("한식") || searchText.equals("한정식")) ){
		response.sendRedirect("reserve_list_type.jsp?p="+url+"&lan="+lan+"&type=1");
	}else if( searchText != null && (searchText.equals("일식") || searchText.equals("일본식")) ){
		response.sendRedirect("reserve_list_type.jsp?p="+url+"&lan="+lan+"&type=2");
	}else if( searchText != null && (searchText.equals("노래방") || searchText.equals("가라오케")) ){
		response.sendRedirect("reserve_list_type.jsp?p="+url+"&lan="+lan+"&type=3");
	}else if( searchText != null && (searchText.equals("퓨전주점") || searchText.equals("퓨전")) ){
		response.sendRedirect("reserve_list_type.jsp?p="+url+"&lan="+lan+"&type=4");
	}else if( searchText != null && (searchText.equals("유흥주점") || searchText.equals("유흥")) ){
		response.sendRedirect("reserve_list_type.jsp?p="+url+"&lan="+lan+"&type=5");
	}
    //오류일 때 redirect 코드 넣기

	Date d = new Date();
	int dayOfWeek = d.getDay();
	boolean isWeekEnd = false;
	if(dayOfWeek == 0 || dayOfWeek == 6) isWeekEnd = true;
	
	Vector<FranchiseListBean> list = new Vector<FranchiseListBean>();
	
	list = fMgr.searchFranch(url, searchText, start, limit);
	
	String PATH_ICON = "../images/icon_common/";
	String ICON_HOME = "icon_home.png";
%>
<html>
<title>가맹점 리스트</title>
<%@include file="../nfc_header.jsp"%>
<div class="wrap">
	<nav id="top">
		<a href="../index.jsp?p=<%=url%>&is=<%=isShared%>&lan=<%=lan%>"><img class="icon_home" src="../images/icon_common/icon_home.png"></a>
		<span class="nav_title">가맹점 리스트</span>
		<img class="icon_home invisible" src="../images/icon_common/icon_home.png">	
	</nav>
	<style>
		.goog-text-highlight { background-color: #fff; -webkit-box-shadow: none; }
		#toTop{ position: fixed; bottom: 1%; right: 1%; }
		#btn_more{ display: none; }
		#snackbar { display: none; width: 80vmin; background-color: #333; color: #fff; text-align: center; border-radius: 2px; padding: 3vw 0; position: fixed; z-index: 1; left: 10vw; bottom: 15vmin; font-size: 17px; }	
		#snackbar.show { visibility: visible; }
		.reserve_list_filter{ display: flex; }
		.reserve_list_filter>div{ margin: 1vmin; position: relative; }
		.reserve_list_filter button { width: 15vmin; color: #fff; background-color: #45A737; border: 1px solid #45A737; outline: none; }
		.reserve_filter{ width: 15vmin; opacity: 0; }
		#discount_select, #type_select{ position: absolute; top:0; left: 0;}
		.distance{ display: none; }
		#distance_slider{ width: 70vmin;}
	</style>
	<div>
		<form method="POST" action="reserve_list_search.jsp?p=<%=url%>">
			<input type="hidden" name="search_query" value="<%=searchText%>">
			<input type="search" id="text_search_reserve" name="search" placeholder="검색" autocomplete="off">
		</form>
	</div>
	<div class="reserve_list_filter">
		<div>	
			<button id="filter_btn_type">업종</button>
			<select id="type_select" class="reserve_filter filter_input">
				<option value="0">전체</option>
				<option value="1">한식</option>
				<option value="2">일식</option>
				<option value="3">노래방</option>
				<option value="4">퓨전주점</option>
				<option value="5">유흥주점</option>
			</select>
		</div>
		<div>
			<button id="filter_btn">할인율</button>
			<select id="discount_select" class="reserve_filter filter_input">
				<option value="0">전체</option>
				<option value="5">5%</option>
				<option value="10">10%</option>
				<option value="15">15%</option>
			</select>
		</div>
		<div>
			<button id="filter_btn_distance">거리</button>
		</div>
		<div>
			<input type="checkbox" id="parking_check" class="filter_input" value="1">주차시설
		</div>
		<div>
			<input type="checkbox" id="seats_check" class="filter_input" value="1">단체석
		</div>
	</div>
	<div class="distance">
		<input type="range" min="100" max="5000" id="distance_slider" value="5000" step="100" class="filter_input" oninput="javascript:slide_distance()"> 
		<span id="distance_span">5km 이내</span>
	</div>
		
	<div id="toTop"><a href="#top"><img src="../images/icon_common/icon_totop.png" style="width: 10vmin"></a></div>	
	<div class="reserve_list" style="-webkit-overflow-scrolling: touch;">
		<%
		if(list.size() == 0 ){
			out.write(" 가맹점이 없습니다. ");		
		}else{
			for(int i = 0; i<list.size(); i++){
				FranchiseListBean bean = list.get(i);
				
				int location_code = bean.getLocation_code();
				String location_place = fMgr.getLocationPlace(location_code);
				
				String photo = ptMgr.getMainPhoto(bean.getIdx()).getPhoto_url();
				String open_weekDay = FranchiseMgr.convertTimetoString(bean.getOpen_weekDay());
				String close_weekDay = FranchiseMgr.convertTimetoString(bean.getClose_weekDay());
				String open_weekEnd = FranchiseMgr.convertTimetoString(bean.getOpen_weekEnd());
				String close_weekEnd = FranchiseMgr.convertTimetoString(bean.getClose_weekEnd());	
		%>
		<div class="layout_franch">
			<input type="hidden" name="shop_type" value="<%=bean.getType()%>">
			<div class="layout_franch_left" onclick="window.open('franch_infor.jsp?p=<%=bean.getUrl()%>&is=y')">
				<%if(photo == null || photo.trim().equals("")){%>
				<img src="../images/shop_photo/noimage.png">
				<%} else{%>
				<img src="<%=photo%>">
				<%} %>
			</div>
			<div class="layout_franch_right">
				<div>
					<span class="shop_name"><%=bean.getShop_name()%></span>
					<span class="franch_distance">
					<%
					double distance = bean.getDistance();
					if( distance>=1000 && distance<100000 ) out.write( String.format("%.2f", distance/1000 )+" km");
					else if( distance<1000 ) out.write((int)distance+" m");
					else if( distance>=100000 ) out.write("100km 이상");
					%>
					</span>
				</div>
				<div>
					<div class="franch_addr_d"><%=location_place+" "+bean.getShop_addr()%></div>
				</div>
				<div>
					<div class="franch_bh_d">
					<%if(!isWeekEnd)
						out.write(open_weekDay+" - "+close_weekDay); 
					else
						out.write(open_weekEnd+" - "+close_weekEnd);
					%>
					</div>
				</div>
				<div class="franch_ex_infor">
					<div align='center'>
						<img src="<%=PATH_ICON+FranchiseMgr.getDiscountIcon(bean.getDiscount())%>"><br>
						<span>예약 할인율</span>
					</div>
					<div align='center'>
					<%if(bean.getIsParking()==1){%>
						<img src="<%=PATH_ICON+FranchiseMgr.ICON_ISPARKING_ON%>"><br>
					<%} else{%>
						<img src="<%=PATH_ICON+FranchiseMgr.ICON_ISPARKING_OFF%>"><br>
					<%} %>
						<span>주차시설</span>
					</div>
					<div align='center'>
					<%if(bean.getIsSeats()==1){%>
						<img src="<%=PATH_ICON+FranchiseMgr.ICON_ISSEATS_ON%>"><br>
					<%} else{%>
						<img src="<%=PATH_ICON+FranchiseMgr.ICON_ISSEATS_OFF%>"><br>
					<%} %>
						<span>단체석 완비</span>
					</div>
					<div align='center' onclick="location.href='tel:<%=bean.getShop_phone()%>'">
						<img style="height: 10vmin;" src="../images/icon_common/icon_reserve_call_circle.png"><br>
						<span>예약 전화</span>
					</div>
				</div>
			</div>
		</div>
		<%		}
			}
		%>
	</div>
</div>
<script>
	var slider = document.getElementById("distance_slider");
	var distance_display = document.getElementById("distance_span");
	function slide_distance(){
		var val = slider.value;
		if(val >= 1000){
			val = val/1000;
			val += "km 이내";
		}else{
			val += "m 이내";
		}
		distance_display.innerHTML = val;
	}
	$(document).ready(function(){
		var start = <%=start%>;
		var limit = <%=limit%>;
		var page = 1;
		
		var x = $(".reserve_list").height();
		//가맹점 더 불러오기
		$(window).scroll(function(){
			var scrollEnd =	$(window).scrollTop()+ $(window).height();
			
			page = Math.round($(document).height()/x);
			if( scrollEnd >= ($(".reserve_list").height()) && scrollEnd <= $(document).height() && (page-1 == start/limit ) ){
				start += limit;
				
				var p = '<%=url%>';
				var lan = '<%=lan%>';
				var search = '<%=searchText%>';
	
				var type = $("#type_select").val(); // default : 0;
				var discount = $("#discount_select").val(); // default: 0;
				var distance = $("#distance_slider").val(); // true/false check, default: 0;

				if( slider_flag == false )
					distance = 0;
				var parking = $("#parking_check").prop("checked");
				var seats = $("#seats_check").prop("checked");

				$.ajax({
					url: 'proc_search.jsp',
					type: 'POST',
					data: { p : p, type: type, discount: discount, distance: distance, parking: parking, seats: seats, searchText : search, start : start, limit : limit },
					success: function(data){
						$(".reserve_list").append(data);
					}
				})		
			} 
		});
		
		//가맹점 검색 필터
		var slider_flag = false;
		$("#distance_slider").change(function(){
			slider_flag = true;
		});
		
		$("#filter_btn_distance").click(function(){
			$(".distance").toggle();
		});
		
		//가맹점 검색 - 조건별 필터
		$(document).on("change", ".filter_input", function(e){
			start = 0;
			var type = $("#type_select").val(); // default : 0;
			var discount = $("#discount_select").val(); // default: 0;
			
			var distance = $("#distance_slider").val(); // true/false check, default: 0;

			if( slider_flag == false )
				distance = 0;
			var parking = $("#parking_check").prop("checked");
			var seats = $("#seats_check").prop("checked");
			var searchText = $("input[name='search_query']").val();
			var url = getParameters("p");
			
			$.ajax({
				url: 'proc_search.jsp',
				type: 'POST',
				data: { p: url, type: type, discount: discount, distance: distance, parking: parking, seats: seats, searchText: searchText, start: start, limit: limit },
				success: function(data){
					$(".reserve_list").empty();
					$(".reserve_list").append(data);
				}
			})
		});
	});	
</script>
</html>