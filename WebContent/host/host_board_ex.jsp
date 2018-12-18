<%@page import="connectDB.FranchiseBean"%>
<%@page import="connectDB.BoardMgr"%>
<%@page import="connectDB.BoardBean"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="bMgr" class="connectDB.BoardMgr"/>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="ptMgr" class="connectDB.PhotoMgr"/>
<%
	String url = request.getParameter("p");
	int idx = Integer.parseInt(request.getParameter("idx"));
	BoardBean board = bMgr.getBoard(idx);
	
	int shop_idx = fMgr.getFranchInfo(url).getIdx();
	String shop_name = fMgr.getFranchInfo(url).getShop_name();
%>	
<%@include file="../nfc_header.jsp"%>
<style>
	@font-face{
		font-family: '스냅스 쾌남열차';
		src: url(../css/SNAPS_COOLGUYTRAIN.TTF) format('truetype');
	}
	.board_article{ margin: 0; padding: 1vmax 1vmin; background-color:#fff;}
	.host_btn{
		border: 1px solid #00A199;
		border-radius: 10px;
		background-color: #fff;
		color: #00A199;
		width: 20vmin;
		font-size: 1.2rem;
		margin-top: 1vmax;
		margin-right: 3vmin;
	}
	.host_btn:hover{ background-color: #00A199; color: #fff; }
	nav{
		position: relative;
	}
</style>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value=" " name="h"/>
</jsp:include>
<body>
<div class="wrap">
<%if(board.getIdx()==0){%>
	<script>
		alert("해당 게시물은 삭제되었습니다.");
		location.href="host_board.jsp?p=<%=url%>&is=y";
	</script>
<%}else{%>
	<nav>
		<img onclick="location.href='../index.jsp?p=<%=url%>&is=y'" class="icon_home" src="../images/icon_common/icon_home.png">
		<span class="nav_title">주인장 이야기</span>
		<img class="icon_home invisible" src="../images/icon_common/icon_home.png">	
	</nav>
	<section class="section_host">
	<input type="hidden" name="url" value="<%=url%>">
	<input type="hidden" name="shop_name" value="<%=shop_name%>">
	<input type="hidden" name="photo_url" value="<%=ptMgr.getMainPhoto(shop_idx).getPhoto_url()%>">
		<article class="board_article">
		<input type="hidden" name="board_idx" value="<%=idx%>">
			<div>
				<span class="board_regtime"><%=BoardMgr.TIME_TO_POST.format(board.getRegdate())%></span>
			</div>		
			<span class="board_content"><%=board.getContent()%></span>	
			<div class="share_board">
				<img src="../images/sample_img/narang_pic_6.png">
			</div>
		</article>
	</section>
	<div class="dialog_background"></div>
	<div class="dialog_share">
		<input type="hidden" name="dialog_bIdx" value="">
		<div class="dialog_close"><img src="../images/icon_common/icon_x.png"></div>
		<div class="dialog_title"></div>
		<div align="center" class="dialog_share_icon">
			<div class="share_board_sms" align='center'>
				<img src="../images/icon_common/icon_sms.png"><br>
				<span>문자메시지</span>
			</div>
			<div class="share_board_kakao" align='center'>
				<img src="../images/icon_common/icon_kakao.png"><br>
				<span>카카오톡</span>
			</div>
			<div class="share_board_face" align='center'>
				<img src="../images/icon_common/icon_fb.png"><br>
				<span>페이스북</span>
			</div>
		</div>
	</div>
	<%} %>
</div><!-- div.wrap -->
</body>
