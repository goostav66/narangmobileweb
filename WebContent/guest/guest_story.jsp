<%@page import="connectDB.GuestMgr"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="gMgr" class="connectDB.GuestMgr"/>
<%
	String url = request.getParameter("p");
%>
<html>
<head>
<title>NFC ZONE :: �մ��̾߱�</title>
<%@include file="../nfc_header.jsp"%>

<style>
	.reply_img{
		width: 30vw;
		height: 16vw;
	}
	.reply_file{
		position:absolute;
		top:0;
		left: 0;
		width: 28vw;
		height: 14vw;
		opacity: 0;
	}
	
</style>
</head>
<body>
<div class="wrap">
	<nav>
		<a href="../index.jsp?p=<%=url%>"><img class="icon_home" src="../images/icon_common/icon_home.png"></a>
		<span class="nav_title">�մ� �̾߱�</span>
		<img class="icon_home invisible" src="../images/icon_common/icon_home.png">	
	</nav>
	
	<img class="guest_img" src="../images/guest_story/guest_background.jpg">
	
	<section>
		<form id="form_reply" method="POST" action="replyProc.jsp?p=<%=url%>" enctype="multipart/form-data">
			<div class="layer_emoticon" align="center">
			<%for(int i = 0; i < GuestMgr.EMOTICON.length; i++){%>
				<label>
					<input type="radio" name="emoticon" value="<%=(i)%>">
					<img src="../images/guest_story/<%=GuestMgr.EMOTICON[i]%>" class="emoticon">
				</label>
			<%} %>
			</div>
			<div align="center">
				<textarea id="ta_comment" name="msg" maxlength="500"></textarea>
			</div>
			<div align="center">
				<button type="button" id="filebutton">����<br>�߰�</button>
				<div class="inputfile"></div>
				<div class="image" align="left"></div>
			</div> 
			<div style="clear: both; padding: 1vmin;">
				<span>����ó(�����Է�) : </span>
				<input type="text" name="phone" style="padding: 5px 3px; width: 60%;"><br>
				<span style="color: #555">ȸ�Ź��� �� �ִ� ����ó�� �Է��ϸ� ������ �ǰ߿� ���� �ǵ���� ������ �� �ֽ��ϴ�.</span><br>
			</div>
			<div align="center">
				<button id="confirm" type="button">���</button>		
			</div>
		</form>
	</section>
</div>
<script>
	$(document).ready(function(){
		$("#ta_comment").autoResize();
		
		$("#confirm").click(function(){
			var length = $("#ta_comment").val().length;
			if(length==0){
				alert("������ �Է����ּ���.");
				return;
			}else{
				document.forms['form_reply'].submit();
			}
		});
		
		var i = 0;
		$("#filebutton").click(function(e){
			i++;
			e.preventDefault();
			if($(".image img").length >= 3){
				alert('�̹����� �ִ� 3������ �߰��� �� �ֽ��ϴ�.');
				return;
			}

			var inputfile = "<input type='file' class='appendfile' name='fileupload_"+i+"' accept='image/*'>";
			$(".inputfile").append(inputfile);
			$("input[name='fileupload_"+i+"']").click();
		
			$("input[type='file']").change(function(e2){
				e2.preventDefault();
				var frame = "<img src='' id="+i+" class='imgfile'>";
				$(".image").append(frame);
				var img = $(".image img:last");
				readURL(this, img);
				
				$(".imgfile").click(function(e3){
					e3.preventDefault();
					var id = $(this).attr('id');
					$(this).remove();
					$("input[name='fileupload_"+id+"']").remove();
				});		
			});		
		});
	

	});
</script>
</body>
</html>