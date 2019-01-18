<!-- 업소정보 관리 페이지 -->
<%@page import="connectDB.ManagerInfoBean"%>
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
<style>
	.host_infor_junction{ margin: 2vmin; }
	.host_infor_subject{ border: 1px solid #aaa; border-radius: 5px; padding: 5vmin; margin: 2vmin 0; display: flex; align-items: center; }
	.host_infor_subject .infor_subject_char{ flex: 6; }
	.guid_host_infor, .subject_char_footer{ font-size: 0.9rem; }
	.host_infor_subject .infor_subject_imgs{ flex: 1; }
	.infor_subject_imgs img{ width: 100%; }
	
	.host_infor_content{ display: table; }
	.content_table_cell{ width: 100vmin; box-sizing: border-box; padding: 2vmin; }
	.table_cell_header{ padding: 2vmin 0; }
	.table_cell_row{ margin: 1vmin 0; }
	.table_cell_row>div{  }
	.table_cell_row input, .table_cell_row textarea, .table_cell_row span:not(.marker_length_textarea){ width: 100%; padding: 2vmin; border-radius: 5px; }
	.marker_length_textarea{ position: absolute; right: 1%; bottom: 0; font-size: 0.7rem; color: #aaa; }
	.table_cell_row input[type='time']{ width: 40%; }
	.table_cell_row img{ height: 1.5rem; }
	.table_cell_row select{ border-radius: 5px; padding: 1vmin; }
	
	.host_infor_back{ display: flex; align-items: center;}
	.host_infor_back img{ height: 1.5rem; }
	.host_infor_back .alert_modified{ color: #F00; font-size: 0.9rem; display: none; }
	
	.btn_infor_save{ padding: 3vmin 15vmin; border-radius: 5px; }
</style>
<section class="section_host">
	<div class="host_infor_junction">
		<div class="guid_host_infor">변경할 정보를 선택해주세요.</div>
		<div>
			<div class="host_infor_subject shop_profile">
				<div class="infor_subject_char">
				 	<div class="subject_char_header">업소정보</div>
				 	<div class="subject_char_footer">업소명, 전화번호, 주소</div>
			 	</div>
				<div class="infor_subject_imgs">
					<div>
						<img src="../images/icon_common/icon_angle_bracket_right.png">
					</div>
				</div>
			</div>
			<div class="host_infor_subject sales_infor">
				<div class="infor_subject_char">
					<div class="subject_char_header">영업정보</div>
					<div class="subject_char_footer">영업시간, 추천메뉴, 한줄소개, 부가정보</div>
				</div>
				<div class="infor_subject_imgs">
					<div>
						<img src="../images/icon_common/icon_angle_bracket_right.png">
					</div>
				</div>
			</div>
			<div class="host_infor_subject shop_photos">
				<div class="infor_subject_char">
					<div class="subject_char_header">사진관리</div>
					<div class="subject_char_footer">업소 사진 관리</div>
				</div>
				<div class="infor_subject_imgs">
					<div>
						<img src="../images/icon_common/icon_angle_bracket_right.png">
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="host_infor_mod_section" style="display: none">
		<div class="host_infor_back">
		 	<img src="../images/icon_common/icon_angle_bracket_left.png">
		 	<span class="alert_modified">변경된 내용이 있습니다.</span>
		</div>
		<form class="loaded_infor_content">
		</form>	
		<div class="host_infor_save" align="center">
			<button class="btn_infor_save btn_confirm">확인</button>
		</div>
	</div>
</section>
</div><!-- div.wrap -->
<script>
	$(document).ready(function(){
		
		var url = getParameters("p");
		$(".host_infor_content").hide();
		
		//업소정보 관리 - 업소 프로필
		$(document).on("click", ".shop_profile", function(){
			$(".host_infor_junction").hide();
			
			$.ajax({
				url: 'proc_load_host_infor.jsp',
				type: 'POST',
				data: { r_type : 1, p : url },
				success: function(data){
					$(".loaded_infor_content").empty();
					$(".loaded_infor_content").append(data);
					$(".host_infor_mod_section").show();
				}
			})
		});
		
		//업소정보 관리 - 영업정보
		$(document).on("click", ".sales_infor", function(){
			$(".host_infor_junction").hide();

			$.ajax({
				url: 'proc_load_host_infor.jsp',
				type: 'POST',
				data: { r_type : 2, p : url },
				success: function(data){
					$(".loaded_infor_content").empty();
					$(".loaded_infor_content").append(data);
					initIconDcRate($("input[name='discount']").val());
					initIconIsParking($("input[name='isParking']").val());
					initIconIsSeats($("input[name='isSeats']").val());
					$(".host_infor_mod_section").show();
				}
			})
		});
			
		//내용변경 경고 표시
		$(document).on("change", ".loaded_infor_content", function(e){
			console.log(e.target);
			$(".alert_modified").show();
		});
		
		//뒤로 가기
		$(document).on("click", ".host_infor_back", function(){
			var flag = true;
			var alert = $(".alert_modified").css("display");
			if( alert != "none" )
				flag = confirm("변경한 내용을 저장하지 않고 돌아갑니다.");
	
			if( flag ){
				$(".loaded_infor_content").empty();
				$(".host_infor_mod_section").hide();
				$(".host_infor_junction").show();
				$(".alert_modified").hide();
			}
		});
		
		//주소지 위도, 경도 변경
		$(document).on("change", "textarea[name='shop_addr']", function(){
			
			var full_address = $(".list_location_city option:selected").text() + $("textarea[name='shop_addr']").val();
			console.log(full_address);
			var geocoder = new daum.maps.services.Geocoder();
			
			geocoder.addressSearch(full_address, function(result, status){
				if(status === daum.maps.services.Status.OK){
					var coords = new daum.maps.LatLng(result[0].y, result[0].x);	
					$("#shop_lat").val(coords.getLat());
					$("#shop_lng").val(coords.getLng());
					console.log('result:');
					console.log(coords.getLat() +" : "+coords.getLng());
				}
			});
		});
		
		//확인
		$(document).on("click", ".btn_infor_save", function(){
			
			//textarea : 줄 띄우기 방지
			$("textarea").each(function(){
				var txt = $(this).val();
				$(this).val(txt.replace(/\n/g, ''));
			});
			var form = $(".loaded_infor_content").serialize();
			
			$.ajax({
				url: 'proc_infor.jsp',
				type: 'POST',
				data: form,
				success: function(){
					alert("저장이 완료되었습니다.");
					$(".alert_modified").hide();
				}
			})
		});
	});
</script>
</body>
</html>