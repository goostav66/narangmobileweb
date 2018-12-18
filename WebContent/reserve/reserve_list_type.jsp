<%@ page import="java.util.Date" %>
<%@page import="java.util.Vector"%>
<%@page import="connectDB.FranchiseListBean"%>
<%@page import="connectDB.FranchiseMgr"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="ptMgr" class="connectDB.PhotoMgr"/>
<% 
    String url = request.getParameter("p");//업소코드
	String lan = request.getParameter("lan");
    String type = request.getParameter("type");
	
    int start = 0;
    int limit = 9;
    
    if( fMgr.getFranchInfo(url).getShop_name() == null )
    	response.sendRedirect("reserve_list_type.jsp?p="+url+"&type="+type);

	Date d = new Date();
	int dayOfWeek = d.getDay();
	boolean isWeekEnd = false;
	if(dayOfWeek == 0 || dayOfWeek == 6) isWeekEnd = true;
	Vector<FranchiseListBean> list = new Vector<FranchiseListBean>();

	list = fMgr.getShopListByType(Integer.parseInt(type), url, start, limit);	
	
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
	</style>
	<div>
		<form method="POST" action="reserve_list_search.jsp?p=<%=url%>">
			<input type="search" id="text_search_reserve" name="search" placeholder="검색" autocomplete="off">
		</form>
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
	$(document).ready(function(){
		var start = <%=start%>;
		var limit = <%=limit%>;
		var page = 1;
		
		var x = $(".reserve_list").height();
		 $(window).scroll(function(){
			var scrollEnd =	$(window).scrollTop() + $(window).height();
		
			page = Math.round($(document).height()/x);
	
			if( scrollEnd >= ($(".reserve_list").height()) && scrollEnd <= $(document).height() && (page-1 == start/limit ) ){
		start += limit;
		
				var p = '<%=url%>';
				var type = '<%=type%>';
				
				$.ajax({
					url: 'reserve_list_reload_type.jsp',
					type: 'POST',
					data: { p : p, type : type, start : start, limit : limit },
					success: function(data){
						$(".reserve_list").append(data);
					}
				})	 			
		 	}			
		});
	}); 	
</script>