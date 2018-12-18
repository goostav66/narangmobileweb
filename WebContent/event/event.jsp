<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.sql.*,javax.sql.*, javax.naming.*" %>
<%
	Connection conn = null;
	ResultSet rs   = null;
	PreparedStatement pstmt = null;

	request.setCharacterEncoding("utf-8");
%>
<%
	String param = request.getParameter("p");

	if (param == null) param =  "um1";
%>
<%

  String m_serial = "";

	if(request.getParameter("serial") == null)
	     m_serial = "";
    else m_serial = request.getParameter("serial");

%>
<%
String img_prepare = "";

try {	
			
			Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            DataSource ds = (DataSource)envCtx.lookup("jdbc/jnfcdb");

            conn = ds.getConnection();

			String query = "SELECT * FROM shop s JOIN roulette r ON s.`idx` = r.`shop_idx` WHERE r.`beer_cup` + r.`beer_bottle` + r.`drink` + r.`food` + r.`soju` + r.`airplane` >= 1 AND s.url = '"+param+"'";
		
		    pstmt=conn.prepareStatement(query);

			rs = pstmt.executeQuery(query);

			rs.last();      
			int rowcount = rs.getRow();
			rs.beforeFirst();
			
			
			if(rowcount >= 1){
				//out.println("SUCCESS");
				img_prepare = "";
			}else {
				img_prepare = "_2";
			}

	}catch(Exception e){ 
		e.printStackTrace();
		out.println("fail");
	}finally{
		  if(rs != null) try{rs.close();}catch(SQLException sqle){}
		if(pstmt != null) try{pstmt.close();}catch(SQLException sqle){}
		if(conn != null) try{conn.close();}catch(SQLException sqle){}
	}
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width, initial-scale=1,  user-scalable=no">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">

<link rel="stylesheet" href="../css/reset.css" />
<link rel="stylesheet" href="../css/style.css" />

<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="../js/jquery.mobile-1.4.5/jquery.mobile-1.4.5.min.js"></script>
<script src="../js/script.js"></script>

<!-- 위 3개의 메타 태그는 *반드시* head 태그의 처음에 와야합니다; 어떤 다른 콘텐츠들은 반드시 이 태그들 *다음에* 와야 합니다 -->
<title> NFC ZONE </title>

<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">

<!-- IE8 에서 HTML5 요소와 미디어 쿼리를 위한 HTML5 shim 와 Respond.js -->
<!-- WARNING: Respond.js 는 당신이 file:// 을 통해 페이지를 볼 때는 동작하지 않습니다. -->
<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<![endif]-->
 <style>

body {background-color:#01999a}

.show-grid { margin-top: 0px; }
.show-grid [class^="col-"] {
  padding-top: 0px;
  padding-left: 0px;
  padding-right: 0px;
  padding-bottom: 0px;
  background-color: #eee;
  border: 0px solid #ddd;
}

#alertBox	{margin-top:40px}
#comment	{padding-top:30px; width:100%; text-align:center; font-size:10pt; color:#fff}

#r_contents	{
width:100%; height:250px;
background:url("../images/bg_roulette.jpg"); 
background-size: 100% 100%;
background-repeat: no-repeat;
background-position: center; }

#CANVAS_1	{display:block; margin:0 auto; margin-top:60px}

#btn_r	{margin:0 auto; width:80px}
#btn_r img	{}
#btn_stop	{display:none}

#popup	{display:none; position:absolute; z-index:100; width:100%}

 </style>

<script language="javascript">
$( document ).ready(function() {
	if (self.name != 'reload') {
         self.name = 'reload';
         self.location.reload(true);
     }
	 else self.name = ''; 

/* 커스텀 Alert */
	var ALERT_TITLE = "N대다 룰렛이벤트";
	var ALERT_BUTTON_TEXT = "확인";

	if(document.getElementById) {
		window.alert = function(txt) {
			createCustomAlert(txt);
		}
	}

	function createCustomAlert(txt) {
		d = document;

		if(d.getElementById("modalContainer")) return;

		mObj = d.getElementsByTagName("body")[0].appendChild(d.createElement("div"));
		mObj.id = "modalContainer";
		mObj.style.height = d.documentElement.scrollHeight + "px";
		
		alertObj = mObj.appendChild(d.createElement("div"));
		alertObj.id = "alertBox";
		if(d.all && !window.opera) alertObj.style.top = document.documentElement.scrollTop + "px";
		alertObj.style.left = (d.documentElement.scrollWidth - alertObj.offsetWidth)/2 + "px";
		alertObj.style.visiblity="visible";

		h1 = alertObj.appendChild(d.createElement("h1"));
		h1.appendChild(d.createTextNode(ALERT_TITLE));

		msg = alertObj.appendChild(d.createElement("p"));
		//msg.appendChild(d.createTextNode(txt));
		msg.innerHTML = txt;

		btn = alertObj.appendChild(d.createElement("a"));
		btn.id = "closeBtn";
		btn.appendChild(d.createTextNode(ALERT_BUTTON_TEXT));
		btn.href = "#";
		btn.focus();
		btn.onclick = function() { removeCustomAlert(); return false; }

		alertObj.style.display = "block";
		
	}

	function removeCustomAlert() {
		document.getElementsByTagName("body")[0].removeChild(document.getElementById("modalContainer"));
	}
	/* 커스텀 Alert */

window.addEventListener("load", eventWindowLoaded, false);

  var myWidth = 150, myHeight = 150;

/*
function alertSize() {
 
  if( typeof( window.innerWidth ) == 'number' ) {
    //Non-IE
    myWidth = window.innerWidth;
    myHeight = window.innerHeight;
  } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
    //IE 6+ in 'standards compliant mode'
    myWidth = document.documentElement.clientWidth;
    myHeight = document.documentElement.clientHeight;
  } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
    //IE 4 compatible
    myWidth = document.body.clientWidth;
    myHeight = document.body.clientHeight;
  }
//  window.alert( 'Width = ' + myWidth );
 // window.alert( 'Height = ' + myHeight );

 var myElem = document.getElementById('CANVAS_1');
 

// 얻은 요소의 style 속성의 크기를 변경합니다.
 //myElem.style.width = myWidth + "px";
// myElem.style.height = myWidth + "px";
 myElem.width = myWidth;
 myElem.height = myWidth;

}
*/


function alertSize() {

 var myElem = document.getElementById('CANVAS_1');
 

 myElem.width = 150;
 myElem.height = 150;

}

function eventWindowLoaded()
{
	initCanvas1();
}

function initCanvas1()
{
	var can1;

	var btn; // 룰렛버튼 영역
	var btn_start;
	var btn_stop;
	
	var popup; //팝업창
	var pop_img; // 팝업창 이미지

	var context1;
	var rotate = 0;
	var refreshIntervalId;
	var result;
	var isClick = 0; // 0: 룰렛을 돌리지 않은 상태 , 1 : 룰렛을 돌린 상태

	alertSize();

	can1 = document.getElementById("CANVAS_1");
	
	btn = document.getElementById("btn_r");
	btn_start = document.getElementById("btn_start");
	btn_stop = document.getElementById("btn_stop");
	
	popup = document.getElementById("popup");
	pop_img = document.getElementById("pop_img");


	if(!canvasAvailable1())
		alert("Canvas doesn't exist");
	context1 = can1.getContext("2d");
	drawImage();

	function canvasAvailable1()
	{	
		if(!can1 || !can1.getContext)
			return false;
		else
			return true;
	}

	function drawImage()
	{
		var sprite1 = new Image();
		var frameIdx = 0;
		var spriteFrames = [0, 1, 2, 3, 4, 5, 6, 7,
							8, 9, 10, 11, 12, 13, 14, 15,
							16, 17, 18, 19, 20, 21, 22, 23];
		

		sprite1.src = "../images/r_item.jpg";
		sprite1.addEventListener('load', eventSpriteLoaded, false);

		    btn.onmousedown = function(event)
			{
				if(rotate == 0)
				{	
					++rotate;
    	         	startUp();
					btn_stop.style.display = "block";
					btn_start.style.display = "none";
				}
				else{
					
					if(isClick == 0){
						stopUp();
					}else{
						if(popup.style.display == "none"){
							popup.style.display = "block";
						}else{
							popup.style.display = "none";
						}					
					}

				}
            }


		function eventSpriteLoaded()
		{
			defaultDraw();
			//startUp();
		}

		function startUp()
		{
			refreshIntervalId = setInterval(drawDynamicImage, 50); // 룰렛 속도
			
			/* 룰렛 천천히
			
			setTimeout(function(){
				clearInterval(refreshIntervalId);
				refreshIntervalId = setInterval(drawDynamicImage, 20);
				}, 500);

			setTimeout(function(){
				clearInterval(refreshIntervalId);
				refreshIntervalId = setInterval(drawDynamicImage, 40);
				}, 1000);

			setTimeout(function(){
				clearInterval(refreshIntervalId);
				refreshIntervalId = setInterval(drawDynamicImage, 60);
				}, 1500);

			setTimeout(function(){
				clearInterval(refreshIntervalId);
				refreshIntervalId = setInterval(drawDynamicImage, 80);
				}, 2000);
			
			setTimeout(function(){
				clearInterval(refreshIntervalId);
				refreshIntervalId = setInterval(drawDynamicImage, 100);
				}, 2500);
			setTimeout(function(){
				clearInterval(refreshIntervalId);
				refreshIntervalId = setInterval(drawDynamicImage, 150);
				}, 3000);

				 */

			//setTimeout(stopUp, 1000); // 1000: 1초
		}

		

        function stopUp()
		{
			  ++isClick;

			  clearInterval(refreshIntervalId);
			  //console.log(frameIdx); //1번부터 시작
			  findName();
			  pop_img.src = "../images/"+result;
			  popup.style.display = "block";
		}
		
		function findName()
		{
			//console.log(frameIdx);
			switch(frameIdx){
				case 1 :
				case 9 :
				case 17 :
					result = "pop_beer_cup"+".png"; break; //맥주
				case 2 :
				case 10 :
				case 18 :
					result = "pop_airplane"+".png"; break; //항공권
				
				case 3 :
				case 11 :
				case 19 :
					result = "pop_food"+".png"; break; //안주 1접시
				case 4 :
				case 12 :
				case 20 :
					result = "pop_fail"+".png"; break; //꽝
				
				case 5 :
				case 13 :
				case 21 :
					result = "pop_drink"+".png"; break; //음료
				case 6 :
				case 14 :
				case 22 :
					result = "pop_beer_bottle"+".png"; break; //맥주 1병
				
				case 7 :
				case 15 :
				case 23 :
					result = "pop_fail"+".png"; break; //꽝
				
				case 8 :
				case 16 :
				case 0 :
					result ="pop_soju"+".png"; break; //소주
			}	
		}

		function defaultDraw()
		{
      		var spriteIX = 0;
			var spriteIY = 0;

			context1.fillStyle = '#009897';
			context1.fillRect(0, 0, myWidth, myWidth);

			context1.drawImage(sprite1, spriteIX, spriteIY, 300, 300, 0, 0,myWidth,myWidth); 
			

		   //window.alert( 'Width = ' + myWidth );
			//context1.drawImage(sprite1, 0, 0,720,720, 0, 0, myWidth, myWidth);
			
		}

		function drawDynamicImage()
		{		
			var spriteX = Math.floor(spriteFrames[frameIdx] % 8) * 300;
			var spriteY = 0; // 일렬로 된 이미지 일때 Y는 0
			//var spriteY = Math.floor(spriteFrames[frameIdx] / 8) * 300;

			context1.fillStyle = '#009897';
			context1.fillRect(0, 0, myWidth, myWidth);

			context1.drawImage(sprite1, spriteX, spriteY, 300, 300, 0, 0, myWidth, myWidth);
           //(이미지,자르기기준x,자르기기준y,자르기width,자르기height,기준점x,기준점y,width,height)
		   //context1.drawImage(sprite1, spriteX, spriteY, 300, 300, 0, 0, myWidth, myWidth);
			
			frameIdx++;
			//console.log(spriteX, spriteY);

			if(frameIdx == spriteFrames.length)
				frameIdx = 0; 
			
		}
	}
}

});


</script>


</head>

<body >
 	  <div class="container-fluid" >
          
          <div class="row show-grid">
				<div class="col-xs-12 nopadding" style="background-color:#009897;"><img src="../images/event1-1<%=img_prepare%>.jpg" class="img-responsive"></div>
               <div id="popup"><img src="../images/pop_1.png" width="100%" alt="popup" id="pop_img" /></div>
            </div> 
   
			
			<div class="row show-grid">
			
			<div class="col-xs-12 nopadding" id="r_contents" style="background-color:#009897;"> 
                <canvas id="CANVAS_1">
               </canvas>
          </div>
		  <div id="btn_r">	  
			  <img src="../images/btn_start.png" width="80px" alt="" id="btn_start" />
			  <img src="../images/btn_stop.png" width="80px" alt="" id="btn_stop" />
		  </div>
		  <div id="comment">* 당첨된 상품은 한 테이블에 한 사람만 한합니다.</div>
			</div>

            <div class="row show-grid">
                <div class="col-xs-12 nopadding" style="background-color:#009897;"><img src="../images/event3-1.jpg" class="img-responsive"></div>
               
            </div>

        
        </div>
	<!-- /.container -->

	<!-- jQuery (부트스트랩의 자바스크립트 플러그인을 위해 필요합니다) -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<!-- 모든 컴파일된 플러그인을 포함합니다 (아래), 원하지 않는다면 필요한 각각의 파일을 포함하세요 -->
	<!-- 합쳐지고 최소화된 최신 자바스크립트 -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
</body>
</html>
