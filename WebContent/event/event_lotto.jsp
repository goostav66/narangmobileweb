<%@ page contentType="text/html; charset=utf-8" %>

<%@page import="java.util.Calendar"%>
<%@ page import="java.util.*, java.text.*"  %>
<%

	 java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
	 String date = formatter.format(new java.util.Date());

	 String y = date.substring(0,4);
	 String month = date.substring(4,6);
	 String d = date.substring(6,8);

	 String today = y +"-"+ month +"-"+ d ;
	
	 String h = date.substring(8,10);
	 String m = date.substring(10,12);
	 String s = date.substring(12);

	 String time = h +":"+ m +":"+ s ;

%>
<%
	response.addHeader("Access-Control-Allow-Origin", "*");
	String param = request.getParameter("p");

%>

<style>
	#index{
		height: 100vh;
	}

</style>
<meta name="viewport" content="width=device-width">
<link rel="stylesheet" href="../css/index_style.css?ver=1"/>
<body>
<section data-role="page" id="index" >

<div id="index">
	<div class="lotto_wrapper">
		<img src="../images/event/lotto_title.png" width="100%" alt="" />
		
		<span class="lotto_text">로또 번호 생성</span>
		<span class="line"></span>
		<table id="lotto_num">
			<tr><th>A</th></tr>
			<tr><th>B</th></tr>
			<tr><th>C</th></tr>
			<tr><th>D</th></tr>
			<tr><th>E</th></tr>
		</table>
		
		<a id="btn_capture">갤러리 저장하기</a>
		<canvas id="canvas"></canvas>
	</div>
</div>


<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script type="text/javascript" src="../js/html2canvas.js"></script>
<script type="text/javascript" src="http://beneposto.pl/jqueryrotate/js/jQueryRotateCompressed.js"></script>
<script>
$( document ).ready(function() {
	
	var canvas = document.getElementById('canvas'),
		ctx = canvas.getContext('2d');

	var minNumber = 1; // minimum
	var maxNumber = 45; // maximum
	var array_num = [];
	var pre_randomnumber = 0;
	var randomnumber = 0;
	var color = '';
	var date = '<%=today+"_"+time%>';
	var start = 0;
	
	$(document).on('click', '.lotto_text', function () {
		if(start != 0 ) $('#btn_capture').css("display", "none");
		startLotto();
		setTimeout(function() { 
			$('#canvas').css("width", ($("#index").width()*2)+"px");
			$('#canvas').css("height", ($("#index").height()*2)+"px");
			fnCopy(); 
			$('#btn_capture').css("display", "block");
		}, 4000);
		start = 1;
	}); 

	function startLotto() {
		var num = 1;
		
		for(var j = 0; j < 5; j++){
			array_num = getNumber();
			if(start != 0) $('#lotto_num tr:eq('+j+') td').remove();
			for(var k = 0; k < 6; k++){	
				setNumber(j, k);
			}
		}
		
		$('.result').css("display", "none");
			
			var j = 0, max = 6;
			function f() {
				
				for(var i = 0; i < 6; i++){
				
					//console.log(j+","+ i +","+ (i+(6*j))+","+ (6*j) );
					$('.result:eq('+(i+(6*j))+')').css("display", "block");
					$('.result:eq('+(i+(6*j))+')').rotate({
					angle:0,
					animateTo:720
					});
				}
				
				j++;
				if( j < max ){
					setTimeout( f, 500 );
				}
			}
			f();

	}

	 function getNumber() {
		var array = [];
		for(var i = 0; i < 6; i++){	
			randomnumber = Math.floor(Math.random() * maxNumber  + minNumber);
				for(var j = 0; j < i; j++){
					while(randomnumber == array[j]){
						randomnumber = Math.floor(Math.random() * maxNumber  + minNumber);
					}	
				}
		
			array[i] = randomnumber;
		}		
		array.sort(function(a, b){return a-b});

		return array;
	}
	 
	function setNumber(j, k) {
		
		if( array_num[k] < 10 ) color = 'orange';
		else if( array_num[k] >= 10 && array_num[k] < 20 ) color = 'blue';
		else if( array_num[k] >= 20 && array_num[k] < 30 ) color = 'red';
		else if( array_num[k] >= 30 && array_num[k] < 40 ) color = 'gray';
		else if( array_num[k] >= 40 && array_num[k] <= 45 ) color = 'green';

		$('#lotto_num tr:eq('+j+')').append('<td><h2 class="result '+color+'">'+array_num[k]+'</h2></td>');
	}   
	
	/* function getNumber(i, j, k) {
		
		for(var j = 0; j < 5; j++){
			for(var i = 0; i < 6; i++){
				randomnumber = Math.floor(Math.random() * maxNumber  + minNumber);
				if (pre_randomnumber != randomnumber)
				{	
					pre_randomnumber = randomnumber;
					array_num[i] = randomnumber;
				}else i--;
			}
			
			array_num.sort(function(a, b){return a-b});
			
			
			for(var k = 0; k < 6; k++){
				if( array_num[k] < 10 ) color = 'orange';
				else if( array_num[k] >= 10 && array_num[k] < 20 ) color = 'blue';
				else if( array_num[k] >= 20 && array_num[k] < 30 ) color = 'red';
				else if( array_num[k] >= 30 && array_num[k] < 40 ) color = 'gray';
				else if( array_num[k] >= 40 && array_num[k] <= 45 ) color = 'green';
				
				$('#lotto_num tr:eq('+j+')').append('<td><h2 id="result" class="'+color+'">'+array_num[k]+'</h2></td>');

			}
		}
		
		return false;
	}    */
	
	

	document.getElementById('btn_capture').addEventListener('click', function() {
		downloadCanvas(this, 'canvas', 'lotto'+date+'.png');
	}, false);

	function fnCopy() {
		
		canvas.width = $("#index").width();
        canvas.height = $("#index").height();

		html2canvas($("#index"), {
			//allowTaint: true,
			//taintTest: false,
			useCORS: true,
			proxy: '/etc/proxy_image',
			onrendered: function(canvas) {
				var image = new Image();
				image.src = canvas.toDataURL();

				image.onload = function() {
					ctx.drawImage(image, 0, 0);

				};
			}
		});
	}    

	function downloadCanvas(link, canvasId, filename) {
		link.href = document.getElementById(canvasId).toDataURL();
		link.download = filename;
	}
	
	/*
	$.ajax({
		origin: 'http://www.nlotto.co.kr/',
		url:'http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=',
		type:'post',
		contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
		dataType: 'html',
		success:function(data){
			var obj =  $.parseJSON( data );
			for (var i in obj) {
				$('#result').append(obj.bnusNo);
			}
		}
	})
	*/
});
</script>

<style>
#index {background-image:url('../images/event/lotto_bg.jpg')}
.lotto_wrapper	{margin:0 auto; width:90%; height:90%; padding-top:10px; background-image:url('../images/event/lotto_paper_bg.png');
				 background-position: 0px 20px;background-repeat: no-repeat;}
.lotto_wrapper img {margin-top:20px}
.lotto_wrapper span {display: block; width: 90%; margin: 0 auto;}

.lotto_text	{padding:10px; text-align:center; width:150px !important; margin-bottom:10px !important; }
#lotto_num {margin:0 auto; width:90%; }
#lotto_num tr th {width:12px; height:45px; vertical-align:middle; text-align:left; font-weight: normal;}
.result	{float:left; margin:5px; width:20px; height:20px; padding:5px; font-size:12pt; color:#000; font-weight:bolder; border: 2px solid #fff; border-radius: 20px; color:#fff; text-align:center; line-height:20px}

.orange {background:orange}
.blue {background:#2ad}
.red {background:#f84b4b}
.gray {background:gray}
.green {background:#75bd49}

#canvas {display:none;}
.logo	{display:none; margin:0 auto; margin-bottom:10px}


#btn_capture, #btn_capture:visited, .lotto_text  {
	display:none;
	margin:0 auto;
	margin-top:10px;
	margin-bottom:10px;
	width:100px;
	text-align:center;
  background: #ffffff;
  background-image: -webkit-linear-gradient(top, #ffffff, #f0f0f0);
  background-image: -moz-linear-gradient(top, #ffffff, #f0f0f0);
  background-image: -ms-linear-gradient(top, #ffffff, #f0f0f0);
  background-image: -o-linear-gradient(top, #ffffff, #f0f0f0);
  background-image: linear-gradient(to bottom, #ffffff, #f0f0f0);
  -webkit-border-radius: 8;
  -moz-border-radius: 8;
  border-radius: 8px;
  font-family: Arial;
  color: #535353;
  font-size: 12px;
  padding: 10px 20px 10px 20px;
  border: solid #e2e7eb 1px;
  text-decoration: none;
}

#btn_capture:hover, #btn_capture:active,.lotto_text:hover {
  background: #ffffff;
  background-image: -webkit-linear-gradient(top, #f0f0f0, #ffffff);
  background-image: -moz-linear-gradient(top,  #f0f0f0, #ffffff);
  background-image: -ms-linear-gradient(top, #f0f0f0, #ffffff);
  background-image: -o-linear-gradient(top, #f0f0f0, #ffffff);
  background-image: linear-gradient(to bottom, #f0f0f0, #ffffff);
   -webkit-border-radius: 8;
  -moz-border-radius: 8;
  border-radius: 8px;
  font-family: Arial;
  color: #535353;
  font-size: 12px;
  padding: 10px 20px 10px 20px;
  border: solid #e2e7eb 1px;
  text-decoration: none;
}

.lotto_text,.lotto_text:visited  { font-weight:bolder;
background-image: -webkit-linear-gradient(top, #f9ee52, #e7c600);
  background-image: -moz-linear-gradient(top, #f9ee52, #e7c600);
  background-image: -ms-linear-gradient(top, #f9ee52, #e7c600);
  background-image: -o-linear-gradient(top, #f9ee52, #e7c600);
  background-image: linear-gradient(to bottom, #f9ee52, #e7c600);}

.lotto_text:hover, .lotto_text:active { font-weight:bolder;
background-image: -webkit-linear-gradient(top, #e7c600, #f9ee52);
  background-image: -moz-linear-gradient(top, #e7c600, #f9ee52);
  background-image: -ms-linear-gradient(top, #e7c600, #f9ee52);
  background-image: -o-linear-gradient(top, #e7c600, #f9ee52);
  background-image: linear-gradient(to bottom, #e7c600, #f9ee52); }

</style>
</section>
</body>
</html>
