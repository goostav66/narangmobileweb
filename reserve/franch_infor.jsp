<!-- 업소 정보 페이지  -->
<%@page import="java.util.Date"%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="connectDB.SaleBean"%>
<%@page import="connectDB.PhotoMgr"%>
<%@page import="connectDB.PhotoBean"%>
<%@page import="java.util.Vector"%>
<%@page import="connectDB.FranchiseMgr"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>

<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="fBean" class="connectDB.FranchiseBean"/>
<jsp:useBean id="sMgr" class="connectDB.SaleMgr"/>
<jsp:useBean id="ptMgr" class="connectDB.PhotoMgr"/>
<%

	String url = request.getParameter("p");
	String lan = request.getParameter("lan");
	String sIdx = request.getParameter("idx");
	int idx = 0;
	if(sIdx != null)
		idx = Integer.parseInt(sIdx);
	
	final String PATH_ICON = "../images/icon_common/";
	final String PATH_SHOP = "../images/shop_photo/";
	
	String pageName="franch_infor"; 
	
	fBean = fMgr.getFranchInfo(url);
	
	String shop_name = fBean.getShop_name();
	if(shop_name==null){
		response.sendRedirect("franch_infor.jsp?p="+url);
	}
	String shop_tel = fBean.getShop_phone();
	
	int location_code = fBean.getLocation_code();
	String location_place = fMgr.getLocationPlace(location_code);
	String shop_addr = fBean.getShop_addr();
	
	String open_weekday = FranchiseMgr.convertTimetoString(fBean.getOpen_weekDay()); 
	String close_weekday = FranchiseMgr.convertTimetoString(fBean.getClose_weekDay());
	String open_weekend = FranchiseMgr.convertTimetoString(fBean.getOpen_weekEnd());
	String close_weekend =  FranchiseMgr.convertTimetoString(fBean.getClose_weekEnd());
	String offday = fBean.getOffday();
	
	String recom_menu = fBean.getRecom_menu();
	String intro_text = fBean.getIntro_text();
	
	int discount = fBean.getDiscount();
	String discount_icon;
	switch(discount){
		case 5:
			discount_icon = FranchiseMgr.ICON_DC_RATE_5;
			break;
		case 10:
			discount_icon = FranchiseMgr.ICON_DC_RATE_10;
			break;
		case 15:
			discount_icon = FranchiseMgr.ICON_DC_RATE_15;
			break;
		default:
			discount_icon = FranchiseMgr.ICON_DC_RATE_0;
			break;
	}
	
	int isParking = fBean.getIsParking();
	String park_icon = FranchiseMgr.ICON_ISPARKING_OFF;
	if(isParking==1){
		park_icon = FranchiseMgr.ICON_ISPARKING_ON;
	}
	
	int isSeats = fBean.getIsSeats();
	String seat_icon = FranchiseMgr.ICON_ISSEATS_OFF;
	if(isSeats==1){
		seat_icon = FranchiseMgr.ICON_ISSEATS_ON;
	}
%>

<html>
<style>
	.layer_map_menu{ display: flex;}
	.layer_map_menu>div{ display: flex; flex-flow: column; padding: 2vmin; }
	.layer_map_menu>div img{ width: 15vmin; }
	.layer_map_menu>div span{text-align: center;} 
</style>
<jsp:include page="franch_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="<%=pageName%>" name="pageName"/>
	<jsp:param value="<%=lan %>" name="lan"/>
</jsp:include>
	<div id="shop_photo" class="layer_map">
		<div class="slide"></div>
	</div>	
	<div id="map_photo" class="layer_map">
		<div id="map"></div>
		
		<div class="loc layer_icon">
			<img src="../images/icon_common/icon_photo_on.png">
		</div>
		<div class="layer_navi">
			<!-- <img src="../images/icon_common/navi.png"> -->
		</div>
	
		<div class="layer_expand" style="position: absolute; bottom: 0; z-index: 1; width: 100%;" align='center'>
			크게 보기
		</div>
		<div class="layer_contract" style="position: absolute; bottom: 0; z-index: 1; width: 100%; display:none;" align='center'>
			작게 보기
		</div> 
	</div>
	<div class="franch_infor">
		<div>
			<table class="table_franch_infor">
				<tr><th>업체명</th><td><%=shop_name%></td></tr>
				<tr><th>전화번호</th><td><%=shop_tel%></td></tr>
				<tr><th>주소</th><td><%=location_place+" "+shop_addr%></td></tr>
				<tr><th>영업시간</th><td>평일 <%=open_weekday%> ~ <%=close_weekday%>(주말 <%=open_weekend%> ~ <%=close_weekend%>) / <%=offday%></td></tr>
				<tr><th>추천메뉴</th><td><%=recom_menu%></td></tr>
				<tr><th>한줄소개</th><td><%=intro_text%></td></tr>
			</table>
		</div>
		<hr style="width: 80%; margin-bottom: 3px;">
		<div>
			<table class="table_franch_extra">
				<tr>
					<td><img src="../images/icon_common/icon_loc_on.png" class="loc"></td>
					<td><img src="<%=PATH_ICON+discount_icon%>" alt="예약 할인율"></td>
					<td><img src="<%=PATH_ICON+park_icon%>" alt="주차시설"></td>
					<td><img src="<%=PATH_ICON+seat_icon%>" alt="단체석 완비"></td>
					<td><img style="width: 12vmin" src="../images/icon_common/icon_reserve_call_circle.png" alt="예약하기" onclick="javascript:callShop('<%=shop_tel%>')"></td>
				</tr>
				<tr>	
					<td>지도</td>
					<td>예약<br>할인율</td>
					<td>주차시설</td>
					<td>단체석<br>완비</td>
					<td>예약</td>
				</tr>
			</table>			
		</div>
	<%if( idx != 0 ) {
		if( idx == sMgr.getSale(idx).getIdx() ){
		SaleBean sale = sMgr.getSale(idx);
	
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
		
		String string_ds = sale.getDate_start();			
		Date date_ds = sdf.parse(string_ds);
		String string_de = sale.getDate_end();
		Date date_de = sdf.parse(string_de);
		
	%>
	<div class="layout_sale" align="center">
		<div class="layout_sale_txt">
			<div>
				<div class="sale_column">
					<span>날짜</span>
				</div>
				<div class="sale_record">
					<span><%=date_ds.getMonth()+1%>월 <%=date_ds.getDate()%>일</span>
				</div>
			</div>
			<div>
				<div class="sale_column">
					<span>시간</span>
				</div>
				<div class="sale_record">
					<span><%=date_ds.getHours()%>시 <%=date_ds.getMinutes()%>분</span>~<span><%=date_de.getHours()%>시 <%=date_de.getMinutes()%>분</span>
				</div>
			</div>
			<div>
				<div class="sale_column">
					<span>가격</span>
				</div>
				<div class="sale_record">
					정가 할인 <%=sale.getDc_rate()%>%
				</div>
			</div>
			<div>
				<div class="sale_column">
					<span>할인메뉴</span>
				</div>
				<div class="sale_record">
					<span><%=sale.getMenu()%></span>
				</div>
			</div>
			<%if(sale.getEtc()!=null){%>	
			<div>
				<div class="sale_column">
					<span>비고</span>
				</div>
				<div class="sale_record">
					<span><%=sale.getEtc()%></span>
				</div>
			</div>
			<%} %>
		</div>	
		<input type="hidden" name="flag" value="ins">
		<input type="hidden" name="date_start">
		<input type="hidden" name="date_end">
	
	</div>
	<%} else {
			out.write("<script> alert('해당 번개할인은 종료되었습니다.'); </script>");
		} 
	}%>
	</div>
	<div class="layer_map_menu" style="display: none;">
		<div class="map_menu_street"><img src="../images/icon_common/icon_kakaonavi.png"><span>길찾기</span></div>
		<div class="map_menu_tmap"><img src="../images/icon_common/icon_tmap.png"><span>티맵</span></div>
		<div class="map_menu_onenavi"><img src="../images/icon_common/icon_ktlgnavi.png"><span>원내비</span></div>
	</div>
			
</div><!-- div.wrap -->
<script>
	var PLANET = {};
	
	window.PLANET = window.PLANET || PLANET;
	
	var userAgent = navigator.userAgent.toLocaleLowerCase();
	if (userAgent.search("android") > -1) {
	    PLANET.os = "android";
	} else if (userAgent.search("iphone") > -1 || userAgent.search("ipod") > -1 || userAgent.search("ipad") > -1) {
	    PLANET.os = "ios";
	} else {
	    PLANET.os = "etc";	
	}

	var lat = <%=fBean.getLat()%>;
	var lng = <%=fBean.getLng()%>;

	var position = '<%=fBean.getShop_addr()%>';
	
	var container = document.getElementById('map');
	var options = { 
		center: new daum.maps.LatLng(lat, lng),
		level: 3 
	};
	
	var map = new daum.maps.Map(container, options); 
	var geocoder = new daum.maps.services.Geocoder();
	var mapTypeControl = new daum.maps.MapTypeControl();
	map.addControl(mapTypeControl, daum.maps.ControlPosition.BOTTOMRIGHT);
	
	var latlng = [];
	geocoder.addressSearch(position, function(result, status) {
	     if (status === daum.maps.services.Status.OK) {
	        var coords = new daum.maps.LatLng(result[0].y, result[0].x);	       
	        var marker = new daum.maps.Marker({
	            map: map,
	            position: coords
	        });
	        map.setCenter(coords);
	        latlng[0] = result[0].y;
	        latlng[1] = result[0].x;
	    } 
	}); 
	
	var slides = [];
	<% Vector<PhotoBean> ptList = ptMgr.getPhotoList(fBean.getIdx());
  	for(int i=0; i<ptList.size(); i++){
  		PhotoBean pBean = ptList.get(i);
  		String photo_url = pBean.getPhoto_url();%>
		slides.push('<%=photo_url%>');
	<%}
  	if(ptList.size()==0){%>
  		slides.push('../images/shop_photo/noimage.png');
  	<%}%>
	$(document).ready(function(){
		
		$("#map_photo").hide();
		
		$(".map_menu_street").click(function(e){
			var addr = '<%=location_place+" "+shop_addr%>';
			var pos = addr.indexOf('(');
			if(pos>0)
				addr = addr.substr(0, pos);
			var locat = 'http://map.daum.net/link/to/'+addr+','+lat+','+lng;
			
			//if(e.target.nodeName=='svg')
				location.href=locat; 	
		});
			
		$(".layer_navi").click(function(){
			var addr = '<%=location_place+" "+shop_addr%>%>';
			var pos = addr.indexOf('(');
			if(pos>0)
				addr = addr.substr(0, pos);
			var locat = 'http://map.daum.net/link/to/'+addr+','+lat+','+lng;
			location.href=locat;
		});
		$(".slide").css("background-image", "url("+slides[0]+")");
		
		$(".layer_expand").click(function(){
			$(this).hide();
			$("nav").hide();
			$(".franch_header_labels").hide();
			$(".franch_infor").hide();
			$(".layer_map_menu").show();
			$("#map").css({'height': '80vmax'});
			map.relayout();
			map.setCenter(new daum.maps.LatLng(lat, lng));
			$(".layer_contract").show();
		});
		$(".layer_contract").click(function(){
			$(this).hide();
			$("nav").show();
			$(".franch_header_labels").show();
			$(".franch_infor").show();
			$(".layer_map_menu").hide();
			$("#map").css({'height': '62vmin'});
			map.relayout();
			map.setCenter(new daum.maps.LatLng(lat, lng));
			$(".layer_expand").show();
		});
		
		
		$(".map_menu_tmap").click(function(){
			if(PLANET.os == "etc"){
				alert("모바일 환경에서만 작동됩니다.");
			}else{
				var app = {
					baseUrl : {
						ios : "tmap://",
						android : "tmap://A1",
						etc : "tmap://"
					},
					searchUrl : {
						ios : "tmap://?search="+position,
						android : "tmap://search?name="+position,
						etc : "tmap://"
					},
					store : {
						android : "market://details?id=com.skt.tmap.ku",
						ios : "https://itunes.apple.com/kr/app/id431589174",
					}
				};

				var url = (typeof position == "undefined")? app.baseUrl[PLANET.os] : app.searchUrl[PLANET.os];
				
				setTimeout( function() {
					var hidden_div = $('#hidden_div');
					hidden_div.innerHTML = "<iframe src="+app.store[PLANET.os]+"onload="+goMarket()+"></iframe>";
				}, 2000);
		 
				location.href = url;

				// 마켓 이동
				function goMarket() {
					document.location.href = app.store[PLANET.os];
				}
			}
		});
		
		$(".map_menu_onenavi").click(function(){
			if(PLANET.os == "etc"){
				alert("모바일 환경에서만 작동됩니다.");
			}else{

				var app = {
					baseUrl : {
						ios : "ollehnavi://",
						android : "ollehnavi://",
						etc : "ollehnavi://"
					},
					searchUrl : {
						ios : "ollehnavi://",
						android : "ollehnavi://",
						etc : "ollehnavi://"
					},
					store : {
						android : "market://details?id=kt.navi",
						ios : "https://itunes.apple.com/kr/app/id390369834",
					}
				};

				var url = (typeof position == "undefined")? app.baseUrl[PLANET.os] : app.searchUrl[PLANET.os];
				
				setTimeout( function() {
					var hidden_div = $('#hidden_div');
					hidden_div.innerHTML = "<iframe src="+app.store[PLANET.os]+"onload="+goMarket()+"></iframe>";
				}, 2000);
		 
				location.href = url;

				// 마켓 이동
				function goMarket() {
					document.location.href = app.store[PLANET.os];
				}
			}
		});
	});
	
</script>
</body>
</html>

