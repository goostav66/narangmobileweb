<%@page import="connectDB.TagBean"%>
<%@page import="java.util.Vector"%>
<%@page import="connectDB.FranchiseBean"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="tMgr" class="connectDB.TagMgr"/>
<%
	String url = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	FranchiseBean fBean = fMgr.getFranchInfo(url);
	String shop_name = fBean.getShop_name();
	int shop_idx = fBean.getIdx();
	
	response.setHeader("pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.addHeader("Cache-Control","No-store");
	response.setDateHeader("Expires",1L);
%>	
<style>
	.tag_infor{ margin: 2vw 1vw; }
	.tag_panel { margin: 1vw; }
	.tag_panel>div, .tag_panel_add>div{ float: left; border: 1px solid black; border-radius: 3px; padding: 1vw 4vw; margin: 1vw;}
	#input_keyword{ font-size: 1.1rem; }	
	#btn_keyword, #btn_tag { border: 1px solid #00A199; color: #00A199; background-color: #fff; border-radius: 2px; font-size: 1.1rem; }
	#btn_tag{ padding: 8px 20px; }
	#btn_keyword:hover, #btn_tag:hover{ color: #fff; background-color: #00A199; }	
	
</style>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="검색어 관리" name="h"/>
</jsp:include>
	<section class="section_host">
	
		<div class="tag_infor"><span>예약 서비스에서 검색되는 키워드를 설정할 수 있습니다.</span></div>
		<div class="tag_panel">
		<%
			Vector<TagBean> tList = tMgr.getTagList(shop_idx);
			for(int i = 0; i<tList.size(); i++){
				TagBean tag = tList.get(i); %>
			<div id="<%=tag.getIdx()%>"><%=tag.getTag()%></div>
		<%	}%>
		</div>
		<div class="tag_panel_add"></div>
		<div style="clear: both">
			<input type="text" id="input_keyword">
			<button type="button" id="btn_keyword">추가</button>
		</div>
		<div class="tag_infor"><span>추가 : 추가 버튼 클릭</span><br><span>삭제 : 키워드 클릭</span></div>
		<div align='center' style="margin-top: 3vw;">
			<form method="POST" action="tag_proc.jsp?p=<%=url%>">
				<input type='hidden' name='shop_idx' value="<%=shop_idx%>">
				<input type='hidden' name='tag_new'>
				<input type='hidden' name='tag_del_idx'>
				<button type="button" id="btn_tag">저장</button>
			</form>
		</div>
	</section>
	</div><!-- .wrap -->
	<script>
	$(document).ready(function(){
		var tag_new = [];
		$("#btn_keyword").click(function(e){
			var text = $("#input_keyword").val().trim();
			if(text == ""){
				$("#input_keyword").val("");
				return;
			}
			$("#input_keyword").val("");
			$(".tag_panel_add").append("<div class='tag_new'>"+text+"</div>");
			$("#input_keyword").focus();
			tag_new.push(text);
			
			$(".tag_new").click(function(e2){
				e2.preventDefault();
				var idx = $(this).index();
				if(idx != -1){	
					$(this).remove();
					tag_new.splice(idx, 1);
				}
			});
		});
		
		var tag_del_idx = [];
		$(".tag_panel>div").click(function(e2){
			e2.preventDefault();
			var id = $(this).attr('id');
			$(this).remove();
			tag_del_idx.push(id);
		});
		
		$("#btn_tag").click(function(){
			$("input[name='tag_new']").val(tag_new);
			$("input[name='tag_del_idx']").val(tag_del_idx);
			$("form").submit();
		});
	});
	</script>
	</body>
	</html>