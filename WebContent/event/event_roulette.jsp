<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<link rel="stylesheet" href="../css/index_style.css?ver=1">
<style>
body { background-image: url('../images/event/roulette_background.png'); background-size: 100% 100%; }
img { width: 13vw; }
div input { width: 35vw; }
div input, div button{ font-size: 1.3rem; margin-left: 2vw;  }
</style>
</head>
<body>
<div align='center' style='margin-top: 10vw'>
	<input type="text" id="entry" onfocus="this.value=''">
	<button onClick="addSegment();">추가</button>
	<button onClick="deleteSegment();">삭제</button>
</div>
<div align='center' style="margin-top: 10vw;"><img src="../images/event/icon_pin.png"></div>
<div align='center'>
	<canvas id='myCanvas' width=300 height=300>
	    Canvas not supported, use another browser.
	</canvas>
</div>
<div style="margin-top: 10vw" align='center'>
	<button onClick="theWheel.startAnimation(); this.disabled=true;" id="bigButton">회전</button>
	<button onClick="theWheel.stopAnimation(); theWheel.rotationAngle=0; theWheel.draw(); bigButton.disabled=false;">다시하기</button>
	<button onClick="location.reload()">처음부터</button>
</div>
<script src="../js/Winwheel.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/latest/TweenMax.min.js"></script>
<script>
	var bigButton = document.getElementById('bigButton');
    var theWheel = new Winwheel({
        'canvasId'    : 'myCanvas',
        'lineWidth'   : 1,
        'numSegments' : 0,
        'animation' :                   // Note animation properties passed in constructor parameters.
        {
            'type'     : 'spinToStop',  // Type of animation.
            'duration' : 5,             // How long the animation is to take in seconds.
            'spins'    : 16              // The number of complete 360 degree rotations the wheel is to do.
        }
    });
    fillStyle = ['#f74d08', '#f6874a', '#f6e84a', '#bbf64a', '#4af6c8', '#4aa7f6', '#8f4af6', '#fa4ef8'];

    var image = new Image();
    image.onload = function(){
    	var canvas = document.getElementById('myCanvas');
    	var ctx = canvas.getContext('2d');
    	
    	if(ctx){
    		ctx.save();
    		ctx.drawImage(image, 0, 0);   // Draw the image at the specified x and y.
    	    ctx.restore();
    	}
    };
    image.src = '../images/event/roulette.png';
    
    function addSegment()
    {
        var entry = document.getElementById('entry').value;
        if(entry == ""){
        	alert('참가자를 입력하세요.');
        	return;
        }
        theWheel.addSegment({
            'text' : entry,
            'fillStyle' :fillStyle[0] //'#'+Math.floor(Math.random()*16777215).toString(16) 
        }, 1);
        fillStyle.shift();
        theWheel.draw();
    }
 
    function deleteSegment()
    {
        theWheel.deleteSegment();
        theWheel.draw();
    }
</script>
</body>
</html>