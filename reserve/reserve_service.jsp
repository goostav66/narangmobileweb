<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<% 
    String url = request.getParameter("p");//업소코드
	String lan = request.getParameter("lan");
%>
<html>
<title>가맹점 리스트</title>
<%@include file="../nfc_header.jsp"%>

<style>
	.goog-text-highlight { background-color: #fff; -webkit-box-shadow: none; }
	
	#toTop{ position: fixed; bottom: 1%; right: 1%; }

	#snackbar { display: none; width: 80vmin; background-color: #333; color: #fff; text-align: center; border-radius: 2px; padding: 3vw 0; position: fixed; z-index: 1; left: 10vw; bottom: 15vmin; font-size: 17px; }	
	#snackbar.show { visibility: visible; }
</style>

<script>
	$(document).ready(function(){
		setTimeout(google_style, 300);
		
		function google_style(){	
			var lang = '<%=lan%>';
			var $frame = $('.goog-te-menu-frame:first');
			
			var context ='한국어';
			if(lang == 'en') context = '영어';
			else if(lang == 'ja') context = '일본어';
			else if(lang == 'zh') context = '중국어(간체)';
			
			if(context != '한국어') {
				$frame.contents().find('.goog-te-menu2-item span.text:contains('+context+')').get(0).click();
			}
			else { 
				var $frame_cancle = $('.goog-te-menu-frame:eq(2)'); 
				$frame_cancle.contents().find('.goog-te-menu2-item:eq(0) div span.text').get(0).click(); 
			} 
		}
		
	});
</script>
<script>
	function callShop(tel){
		if(tel == null || tel.length == 0){
			alert("전화번호 정보가 존재하지 않습니다.");
		}else{
			location.href='tel:'+tel;
		}
	}
</script>
<body>
	<div class="wrap">
		<nav id="top">
			<a href="../index.jsp?p=<%=url%>&is=<%=isShared%>&lan=<%=lan%>"><img class="icon_home" src="../images/icon_common/icon_home.png"></a>
			<span class="nav_title">가맹점 리스트</span>
			<img class="icon_home invisible" src="../images/icon_common/icon_home.png">	
		</nav>
		<div id="google_translate_element"></div>
		<div>
			<input type="search" id="text_search_reserve" name="text" placeholder="검색" autocomplete="off">
		</div>
		<div style="position: relative">
			<div class="layer_tabs" id='id_tab'>
				<div class="tabs">전체 가맹점</div>
				<div class="tabs">한식</div>
				<div class="tabs">일식</div>
				<div class="tabs">노래방</div>
				<div class="tabs">퓨전주점</div>
				<div class="tabs">유흥주점</div>
				<div class="tabs">기타</div>
			</div>
			<div id="tabs_left"></div>
			<div id="tabs_right"></div>
		</div>
		<div align="center">
			<button class="btn_goto_set_discount" onclick="location.href='set_discount.jsp?p=<%=url%>'">번개할인</button>
		</div>
		<div id="toTop"><a href="#top"><img src="../images/icon_common/icon_totop.png" style="width: 10vmin"></a></div>
		
		<div class="reserve_list"></div>
		
		<div align='center' style="width: 100vmin"><button id='btn_more'>더 보기</button></div>
		<div id="snackbar">가맹점을 찾을 수 없습니다.</div>
	</div>
	<script>
		$(document).ready(function(){
			var xhttp;
			var lindex = 0;
			var type = 0;
			var word = $("#text_search_reserve").val();
			GET_HTML_NEW_TAB();
			SELECT_TAB(type);
			
			$(".tabs").click(function(){
				type = $(this).index(); 
				lindex = 0;
				GET_HTML_NEW_TAB();
				SELECT_TAB(type);
			});	
				
			$("#text_search_reserve").on('search',function(){
				var tmp_word = $(this).val();
				
				lindex = 0;
				type = 0; 
				word = "";
				
				if(tmp_word.search("한식")!=-1)
					type = 1;
				else if(tmp_word.search("일식")!=-1)
					type = 2;
				else if(tmp_word.search("노래방")!=-1)
					type = 3;
				else if(tmp_word.search("퓨전")!=-1)
					type = 4;
				else if(tmp_word.search("유흥")!=-1)
					type = 5;
				else 
					word = tmp_word;
				
				GET_HTML_NEW_TAB();
				SELECT_TAB(type);
				
				$(this).blur();
				$("#text_search_reserve").val(word);
			});
	
			$("#btn_more").on('click', function(){
				lindex += 6;
				GET_HTML_ADD_TAB();
			});	
						
			function GET_HTML_NEW_TAB(){
				var xhttp = new XMLHttpRequest();
				xhttp.onreadystatechange = function(){
					if(this.readyState == 4 && this.status == 200){
						var appendedText = this.responseText.trim();
						if(appendedText == 'no_reserve_list'){
							$(".reserve_list").html("");
							 $("#snackbar").fadeIn("slow");
							 setTimeout(function(){
								$("#snackbar").fadeOut("slow");
							}, 2000);  
							$("#btn_more").hide();
							$("#toTop").hide();
						}
						else{
							$(".reserve_list").html(this.responseText);		
						}	
					}
				};
				xhttp.open("POST", "reserve_list_load.jsp", true);
				xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=euc-kr");
				xhttp.send("p=<%=url%>&l=0&type="+type+"&w="+word+"&lan=<%=lan%>");
			}
			
			function GET_HTML_ADD_TAB(){
				var xhttp = new XMLHttpRequest();
				xhttp.onreadystatechange = function(){
					if(this.readyState == 4 && this.status == 200){
						var appendedText = this.responseText.trim();
						if(appendedText == 'no_reserve_list'){
							$("#snackbar").fadeIn("slow");
								setTimeout(function(){
									$("#snackbar").fadeOut("slow");
								}, 2000); 
							$("#btn_more").hide();
						}
						else
							$(".reserve_list").append(appendedText);
					}
				};
				xhttp.open("POST", "reserve_list_load.jsp", true);
				xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=euc-kr");
				xhttp.send("p=<%=url%>&l="+lindex+"&type="+type+"&w="+word+"&lan=<%=lan%>");
			}	

			function SELECT_TAB(idx){
				$(".tabs").each(function(){
					$(this).css({"color":"#000", "border-bottom":"none"});
				});
				$(".tabs:eq("+idx+")").css({"color":"#5BC51A", "border-bottom":"2px solid #5BC51A"});
				$("#snackbar").hide();
				$("#btn_more").show();
				$("#toTop").show();
			}	
		});
	</script>	
</body>