<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>

<link rel="stylesheet" media="screen and (orientation: portrait)" href="../css/style_port.css?ver=1">
<link rel="stylesheet" media="screen and (orientation: landscape)" href="../css/style_land.css?ver=1">

<%
	String url = request.getParameter("p");
	int drive = 2;// 1부터 3까지
	String call_tel = "07086702936"; //DB연동: url->지역추출->지역 콜센터 
	
	final String PATH_ICON = "images/icon_common/";
	//아이콘 이미지 경로
	final String DRIVE = "d1.png";
	
%>
	<div class="menu_icon" id="menu_drive" >
		<img src="images/icon_common/d1.png"><br>	
		<img class="menu_txt" src="images/icon_common/d1_1.png">		
		<div id="drive_pop" class="nn_bubble">
			<a id="sms">문자 전송</a>
			<a id="tel">전화 연결</a>
		</div>
	</div>
	<audio id="myTune">
	  <source src="source/sample.mp3">
	</audio>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>	
	<script>
		$(document).ready(function(){
			$("#menu_drive").click(function(){
				var drive = <%=drive%>;	
				selectDrive(drive);
			});			
		});	
		
		function selectDrive(drive){
			switch(drive){
			case 1:
				location.href="sms:<%=call_tel%>?body=[업소코드:N<%=url%>N]안전히 모시겠습니다. 메시지를 전송하면 호출됩니다.";
				document.getElementById("myTune").play();
				break;
			case 2:
				location.href="tel:<%=call_tel%>";
				break;
			case 3:
				$("#share_pop").hide();
				$("#drive_pop").toggle(function(){
					$("#drive_pop a").click(function(){
						drive = $("a").index(this)+1;
						selectDrive(drive);
						drive=3;
					});
				});
				break;
			}
		}
	</script>

