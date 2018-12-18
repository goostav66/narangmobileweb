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
    
    int start = Integer.parseInt(request.getParameter("start"));
    int limit = Integer.parseInt(request.getParameter("limit"));
    
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

	Date d = new Date();
	int dayOfWeek = d.getDay();
	boolean isWeekEnd = false;
	if(dayOfWeek == 0 || dayOfWeek == 6) isWeekEnd = true;
	
	Vector<FranchiseListBean> list = new Vector<FranchiseListBean>();
	
	list = fMgr.searchFranch(url, searchText, start, limit);
	
	String PATH_ICON = "../images/icon_common/";
	String ICON_HOME = "icon_home.png";
%>
<%
	if(list.size() == 0 ){
		out.write("");		
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