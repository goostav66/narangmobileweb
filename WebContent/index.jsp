<%@page import="connectDB.ExtCommerceBean"%>
<%@page import="connectDB.SaleJoinBean"%>
<%@page import="connectDB.EventListBean"%>
<%@page import="connectDB.EventBean"%>
<%@page import="connectDB.FranchiseMgr"%>
<%@page import="connectDB.FranchiseListBean"%>
<%@page import="connectDB.PhotoBean"%>
<%@page import="java.util.Vector"%>
<%@page import="connectDB.FranchiseBean"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	//request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="ptMgr" class="connectDB.PhotoMgr"/>
<jsp:useBean id="eMgr" class="connectDB.EventMgr"/>
<jsp:useBean id="sMgr" class="connectDB.SaleMgr"/>
<% 
	String url = request.getParameter("p");
	
	FranchiseBean shop = fMgr.getFranchInfo(url); 
	
	int shop_idx = shop.getIdx();
	if(shop_idx == 0)
		response.sendRedirect("index.jsp?p="+url);
	int type = shop.getType();
	String pre_img = "";
	switch(type){ 
	case FranchiseMgr.TYPE_KOR:
	case FranchiseMgr.TYPE_JPN:
		pre_img = "images/sample_img/main_type_12.gif";
		break;
	case FranchiseMgr.TYPE_KARAOKE:
	case FranchiseMgr.TYPE_BAR_AD:
		pre_img = "images/sample_img/main_type_35.gif";
		break;
	case FranchiseMgr.TYPE_BAR_FU:
		pre_img = "images/sample_img/main_type_4.gif";
		break;
	default:
		pre_img = "images/sample_img/main_type_12.gif";
		break;
	}
	Vector<FranchiseBean> re_list = fMgr.getSomeFranchList(url, 9);
	Vector<ExtCommerceBean> ent_list = fMgr.getExtCommerceList(url, 5);
	
	Vector<PhotoBean> pt_list = ptMgr.getPhotoList(shop_idx);
	Vector<EventBean> pu_list = eMgr.getPopupListNow(url);
	%>
<html>
<title><%=shop.getShop_name()%></title>
<%@include file="nfc_header.jsp"%>
<style>
	@media only screen and (orientation: landscape){
		.pre{ display: none; }
		.wrap{ position: static !important; }
	}
	
	.wrap{ position: fixed; top: 0; left: 100vmin; overflow: auto;}
</style>
<body>
	<div class="pre" style="background-image:url('<%=pre_img%>')"></div>
	<div class="wrap">
		<input type="hidden" name="url" value="<%=url%>">
		<input type="hidden" name="address" value="<%=shop.getShop_addr()%>">
		<input type="hidden" name="intro_text" value="<%=shop.getIntro_text()%>">
		<input type="hidden" name="mainImg" value="<%=ptMgr.getMainPhoto(shop_idx).getPhoto_url()%>">
		
		<div id="google_translate_element"></div>
		
		<div class="header_logo">
			<img src="images/icon_common/logo_only.png">
			<span class="shop_name"><%=shop.getShop_name()%></span>
			<div style="display: inline; position: relative;" class="icon_translate">
				<img style="padding: 0; height: 2.3rem" src="images/sample_img/icon_translate.png">
				<select id="translate" style="position: absolute; top:0; left: 0; opacity: 0; height: 2rem; padding-left: 4vmin; width: 100%">
					<option value='ko'>한국어</option>
					<option value='en'>English</option>
					<option value='ja'>日本語</option>
					<option value='zh'>中文</option>
				</select>
			</div>
		</div>
		
		<div class="main_photo" align='center'>
		<%for(int i = 0; i<pu_list.size(); i++){
			EventBean event = pu_list.get(i);%>
			<div class="photo_panel" style="background-image: url('images/sample_img/<%=event.getBackground_img()%>')">
				<span><%=event.getMessage()%></span>
			</div>
		<%} %>
		<%for(int j = 0; j<pt_list.size(); j++){
			PhotoBean photo = pt_list.get(j);%>
			<div class="photo_panel" style="background-image: url('<%=photo.getPhoto_url()%>')">
			</div>
		<%} %>
		</div>
		
		<div class="main_menu_panel">
		<%if(language != null && !language.equals("ko")){%>
			<div class="menu_1st">
				<div id="call_driver_button" align="center">
					<img src="images/sample_img/<%=language%>/pic_1.png">
				</div>
				<div align="center">
					<a href="reserve/franch_infor.jsp?p=<%=url%>&is=<%=isShared%>&lan=<%=language%>">
						<img src="images/sample_img/<%=language%>/pic_2.png">
					</a>
				</div>
				<div align="center">
					<a href='reserve/reserve_list_renew.jsp?p=<%=url%>&is=<%=isShared%>&lan=<%=language%>'>
						<img src="images/sample_img/<%=language%>/pic_3.png">
					</a>
				</div>
				<div align="center">
					<img src="images/sample_img/<%=language%>/pic_4.png" class="share_main_page">
				</div>
			</div>
		<%} else{%>
			<div class="menu_1st">
				<div id="call_driver_button" align="center">
					<img src="images/sample_img/narang_pic_1.png">
				</div>
				<div align="center">
					<a href='reserve/franch_infor.jsp?p=<%=url%>&is=<%=isShared%>'>
					<%if(type == FranchiseMgr.TYPE_KARAOKE || type == FranchiseMgr.TYPE_BAR_AD){%>
						<img src="images/sample_img/narang_pic_9.png">
					<%}else{ %>
						<img src="images/sample_img/narang_pic_2.png">
					<%} %>
					</a>
				</div>
				<div align="center">
				<% if(url.equals("djs1a0122") || url.equals("bshwd25")){ %>
					<a href="banner/pay.jsp">
					<img style="width: 14.5vmin" src="images/sample_img/narang_pic_10.png"></a>
				<%} else{%>
					<a href="toon/webtoon.jsp">
					<img src="images/sample_img/narang_pic_8.png"></a>		
				<%} %>
				</div>
				<div align="center">
					<a href='reserve/reserve_list_renew.jsp?p=<%=url%>&is=<%=isShared%>'>
						<img src="images/sample_img/narang_pic_3.png">
					</a>
				</div>
				
			</div>
			<div class="menu_2nd">
				<div align="center">
					<img src="images/sample_img/narang_pic_4.png" alt="손님 이야기" class="menu_guest">	
				</div>
				<div align="center">
					<a href='host/host_board.jsp?p=<%=url%>&is=<%=isShared%>'><img src="images/sample_img/narang_pic_5.png"></a>
				</div>
				<div align="center">
					<img src="images/sample_img/narang_pic_6.png" class="share_main_page">
				</div>
				<div align="center">
					<a href="event/event_main.jsp?p=<%=url%>"><img src="images/sample_img/narang_pic_7.png"></a>
				</div>
				
			</div>
		<%} %>
		</div>
		<div class="main_promotion_slide" onclick="location.href='reserve/set_promotion.jsp?p=<%=url%>'">
		<%  
			Vector<EventListBean> eventList = eMgr.getEventListLocationally(url);
			Vector<SaleJoinBean> saleList = sMgr.getSaleListLocationally(url);
			if(eventList.size() + saleList.size() == 0){
				String recom_menu = shop.getRecom_menu().trim();
				String intro_text = shop.getIntro_text().trim();
				if (recom_menu.length() == 0 && intro_text.length() == 0){
					out.write("저희 업소에 방문하신 것을 환영합니다.");	
				}else{
					out.write("<strong>추천 메뉴</strong>");
					out.write("<span class='marquee_shop_intro'>"+shop.getRecom_menu()+"</span>");
					out.write("<span class='marquee_shop_intro'>"+shop.getIntro_text()+"</span>");
					
				}
				
			}
			else{
				out.write("<strong>이벤트·번개할인 안내          </strong>");
				for(int i = 0; i<eventList.size(); i++){
					EventListBean event = eventList.get(i);
					String event_shop_name = event.getShop_name();
					String event_shop_msg = event.getMessage();
					int index_end_p = event_shop_msg.indexOf("</p>");
					String phrase = event_shop_msg.substring(3, index_end_p);
					while(phrase.indexOf("<") != -1){
						int index_of_lt = phrase.indexOf("<");
						int index_of_gt = phrase.indexOf(">");
						String remove_str = phrase.substring(index_of_lt, index_of_gt+1);
						phrase = phrase.replace(remove_str, "");				 
					}
			%>
				◆<%=event_shop_name+" "%>
				<%=phrase%>
		<% 		} 
		
			
				for(int j = 0; j<saleList.size(); j++){
					SaleJoinBean sale = saleList.get(j);
					String sale_shop_name = sale.getShop_name();
					String sale_shop_menu = sale.getMenu();
					int sale_rate = sale.getDc_rate();
			%>
				◆<%=sale_shop_name + " "%>
				<%=sale_shop_menu + " "%>
				<%=sale_rate+"% 할인"%>
		<%		}
			}
		%>	
			
		</div> 
		<div class="main_banner" style="margin-top: 15px;">
			<div align="center">
				<img onclick="location.href='http://www.logoscorp.co.kr'" src="images/sample_img/event_logos.gif">
				<img src="images/sample_img/event_narang.png" onclick="location.href='tel:010-3831-1115'">
			</div>	
		</div>
		
		<%if(ent_list.size() > 0){%>
		<span style="font-family: '스냅스 쾌남열차'; font-size: 1.5rem; margin-left: 5vmin"> 소상공인 광장</span>
		<%} %>
		<div class="banner_hr">
			<div class="banner_hr_layout" onclick="window.open('banner/nfound.jsp')" align="center">
				<div class="banner_main"><img src="images/sample_img/banner_commerce.png"></div>
				<div class="banner_h1"><span>Na랑 NFC</span></div>
				<div class="banner_h2"><span>지사·대리점·가맹점 모집</span></div>
			</div>
		<%-- <%for(int i = 0; i<ent_list.size(); i++){ 
			ExtCommerceBean bean = ent_list.get(i); %>
			<div class="banner_hr_layout" onclick="window.open('<%=bean.getE_page_url()%>')" align='center'>
				<div class="banner_main"><img src="<%=bean.getE_main_img()%>"></div>
				<div class="banner_h1"><span><%=bean.getE_enterprise()%></span></span></div>
				<div class="banner_h2"><span><%=bean.getE_info()%></span></div>
			</div>
		<%} %>	 --%>
			
			<%if(url!=null && url.equals("djs1a0122")){%>
			<div class="banner_hr_layout" onclick="window.open('banner/eco_plaza.jsp')" align='center'>	
				<div class="banner_main"><img src="images/sample_img/ecotitle.png"></div>
				<div class="banner_h1"><span>조은생활(주)</span></div>
				<div class="banner_h2"><span>부산 센터장 이범창(010-8585-6855)</span></div>
			</div>
			<%} %>
		</div>
		
		<%if(re_list.size() > 0){%>
		<span style="font-family: '스냅스 쾌남열차'; font-size: 1.5rem; margin-left: 5vmin;"> Na랑 가맹점</span>
		<%} %>
		<div class="banner" align="center">
		<%for(int i = 0; i<re_list.size(); i++){
			FranchiseBean bean = re_list.get(i);
			String src = ptMgr.getMainPhoto(bean.getIdx()).getPhoto_url();
			if(src != null && !src.trim().equals("")){%>
			<div onclick="location.href='reserve/franch_infor.jsp?p=<%=bean.getUrl()%>&is=y'">
				<span class="banner_title"><%=bean.getShop_name()%></span>
				<img src="<%=ptMgr.getMainPhoto(bean.getIdx()).getPhoto_url()%>">
			</div>
			
		<%	}
		}%>
		</div>
		
		<div style="width:100vw; height: 5vh;"></div>
	</div>
	<div class="dialog_background"></div>
	<div class="dialog_share">
		<div class="dialog_close"><img src="images/icon_common/icon_x.png"></div>
		<div class="dialog_title"></div>
		<div align="center" class="dialog_share_icon">
			<div class="share_main_sms" align='center'>
				<img src="images/icon_common/icon_sms.png"><br>
				<span>문자메시지</span>
			</div>
			<div class="share_main_kakao" align='center'>
				<img src="images/icon_common/icon_kakao.png"><br>
				<span>카카오톡</span>
			</div>
			<div class="share_main_face" align='center'>
				<img src="images/icon_common/icon_fb.png"><br>
				<span>페이스북</span>
			</div>
		</div>
	</div>
<script>
	$(document).ready(function(){
		$(window).on('load', function(){
			$(".pre").css({'display': 'none'});
			$(".wrap").animate({left: 0}, "1500", function(){
				$(".wrap").css({'position':'initial'});
			});
			
			setTimeout(getTranslate(lan), 500);
		});
		
		

		$(".menu_guest").click(function(){
			if('<%=isShared%>' =='y'){
				alert("NFC 태그로 접속하지 않은 가맹점은 리뷰를 남길 수 없습니다.");
			}else{
				location.href='guest/guest_story.jsp?p=<%=url%>';
			}
		});
			
		
		var banner_idx = 1;
		$(".main_banner div img:eq(0)").show();
		setInterval(function(){
			$(".main_banner div img").each(function(){
				if(banner_idx >= 2)
					banner_idx = 0;

			 	if( $(this).index() == banner_idx){
					$(this).show();
				}
				else{
					$(this).hide();
				} 
			});
			banner_idx++;
		}, 3000); 
		
		//번역 - 초기값 설정
		var lan = getParameters("lan");
		$("#translate option").each(function(){
			if($(this).val() == lan){
				$(this).prop("selected", true);
			}
		});		
		
		//일본어일 때 공유팝업창 아이콘이 튀어나오는 문제 해결
		if(lan == 'ja'){
			$(".dialog_share_icon>div span").css("font-size", "0.6rem");
		}
		function getTranslate(flag_lang){
			var $frame = $('.goog-te-menu-frame:first');

			switch(flag_lang){
				case 'en':
					$frame.contents().find('.goog-te-menu2-item span.text:contains("영어")').get(0).click();
					break;
				case 'ja':
					$frame.contents().find('.goog-te-menu2-item span.text:contains("일본어")').get(0).click();			
					break;
				case 'zh':
					$frame.contents().find('.goog-te-menu2-item span.text:contains("중국어(간체)")').get(0).click();
					break;
				default:
					var $frame_cancle = $('.goog-te-menu-frame:eq(2)'); 
					$frame_cancle.contents().find('.goog-te-menu2-item:eq(0) div span.text').get(0).click();
					break;
			}
		}
	});
</script>
</body>
</html>
