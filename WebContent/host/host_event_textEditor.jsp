<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="eMgr" class="connectDB.EventMgr"/>
<jsp:useBean id="eBean" class="connectDB.EventBean"/>
<%
	String url = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	if(host == null || !host.equals(url)) response.sendRedirect("host_board.jsp?p="+url);

	String s_idx = request.getParameter("idx");
	int idx = 0;
	if(s_idx != null )
		idx = Integer.parseInt(s_idx);
	
	eBean = eMgr.getPopup(idx);
	if( eBean.getUrl()!=null && !eBean.getUrl().equals(host) ) response.sendRedirect("host_board.jsp?p="+url);
	String background = eBean.getBackground_img();
	
	response.setHeader("pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.addHeader("Cache-Control","No-store");
	response.setDateHeader("Expires",1L);
	
	String[] background_imgs = {"bg_pop_sample1.png", "bg_pop_sample2.png", "bg_pop_sample3.jpg", "bg_pop_sample4.jpg", "bg_pop_sample5.png", "bg_pop_sample6.jpg", "bg_pop_sample7.jpg"};
%>
<style>
	.multiple_steps{ position: relative; height: 100vmin; }
	.step{ position: absolute; top: 20px; left: 5vw; width: 90vmin; height: 90vmin; }
	.step:not(:first-child){ display: none; }
	
	.step_dot{ display: inline-flex; margin-bottom: 5vmin; }
	.s_dot{ width: 10px; height: 10px; border-radius: 50%; background-color: #eee;}
	.s_dot:first-child{ background-color: #aaa; margin-left: 45vw; }
</style>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="이벤트 관리" name="h"/>
</jsp:include>
<section class="section_host">
	<span style="font-size: 0.8rem; color: #aaa">슬라이드하여 다음단계로 넘어갈 수 있습니다.</span>
	<div class="multiple_steps">
		<div class="step">
			<h3>이벤트 문구</h3>
			<div class="host_event_textEditor" style="height: 200px;">
			<%if(idx != 0) out.write( eBean.getMessage() );%>
			</div>
		</div>
		<div class="step">
			<div class="host_event_backgroundSelector">
				<h3>배경</h3>
				<div class="event_background">
					<input type="hidden" name="event_background" value="<%=background%>">
				<%for(int i = 0; i < background_imgs.length; i++){%>
					<label><input type="radio" name="background_img" value="<%=background_imgs[i]%>"><img src="../images/sample_img/<%=background_imgs[i]%>"></label>				
				<%}%>
				</div>
			</div>
		</div>
		
		<div class="step">
			<div class="host_event_dateSelector">
				<h3>날짜</h3>
				<input type="date" name="date_start" <%if(idx != 0){ out.write("value="+eBean.getDate_start()); }%>> ~ <input type="date" name="date_end" <%if(idx != 0){ out.write("value="+eBean.getDate_end()); } %>>
			</div>
		</div>
	</div>
	
	<div class="step_dot" align="center">
		<div class="s_dot"></div>
		<div class="s_dot"></div>
		<div class="s_dot"></div>
	</div>
	
	<div class="host_event_button">
		<button class="host_event_preview button_disabled" disabled>미리보기</button>
		<button class="host_event_save">저장</button>
		<button class="host_event_cancel">취소</button>
	</div>
</section>
<div class="dialog_background"></div>
<div class="dialog_event"><span></span></div>
<script>
	$(document).ready(function(){
		var toolbarOptions = [
			['bold', 'italic', 'underline', 'strike'],
			[{ 'color': [] }, { 'background': [] }]          // dropdown with defaults from theme
		];
		
		var quill = new Quill('.host_event_textEditor', {
			modules:{toolbar: toolbarOptions},
		    theme: 'snow'	 
	  	});
		
		var touch_start_x;
		var touch_end_x;
		
		$(document).on('touchstart', '.step', function(e){
			touch_start_x = e.touches[0].clientX;
		});
		
		$(document).on('touchend', '.step', function(e){
			touch_end_x = e.changedTouches[0].clientX;
			
			var length = $(".multiple_steps>div").length;
			var idx = $(this).index();
			
			if( touch_start_x - touch_end_x >= 100 ){//to next step
				var next = $(this).next();
				if(length == idx+1)
					return;
					//next = $(".step:first");
				
				next.css({'left' : '105vw'});
				$(this).animate({left : '-95vw'}, function(){
					$(this).hide();
					next.show(function(){
						next.animate({left : '5vw'});
					});
				});
				$(".step_dot>div:eq("+idx+")").css("background-color", "#eee");
				$(".step_dot>div:eq("+(idx+1)+")").css("background-color", "#aaa");
				
			}else if( touch_end_x - touch_start_x >= 100 ){//to previous step
				var prev = $(this).prev();
				if(idx == 0)
					return;
					//prev = $(".step:last");
				
				prev.css({'left' : '-95vw'});
				$(this).animate({left : '105vw'}, function(){
					$(this).hide();
					prev.show(function(){
						prev.animate({left : '5vw'});
					})
				});
				$(".step_dot>div:eq("+idx+")").css("background-color", "#eee");
				$(".step_dot>div:eq("+(idx-1)+")").css("background-color", "#aaa");
			}
		});
	});
</script>
</div><!-- div.wrap -->
</body>
</html>