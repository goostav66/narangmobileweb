<%@page import="java.util.HashMap"%>
<%@page import="connectDB.MenuBean"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<jsp:useBean id="mMgr" class="connectDB.MenuMgr"/>
<%
	String url = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	if(host == null || !host.equals(url)) response.sendRedirect("host_board.jsp?p="+url);
	
	int shop_idx = fMgr.getFranchInfo(url).getIdx();
	
	String realPath = getServletContext().getRealPath("/images/menu");
	mMgr.trimMenuFile(realPath);
	
	response.setHeader("pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.addHeader("Cache-Control","No-store");
	response.setDateHeader("Expires",1L);
%>

<html>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="�޴��� ����" name="h"/>
</jsp:include>
	
<section class="section_host">
	<input type="hidden" name="url" value="<%=url%>">
	<div class="host_menu_control">����</div>
	<div class="host_menu_panel" style="display: -webkit-box; -webkit-box-orient: block-axis; margin-bottom: 10vmin; ">
<%	Vector<MenuBean> vlist = mMgr.getMenuList(shop_idx);
	int i;
	for(i = 0; i<vlist.size(); i++){
		MenuBean menu = vlist.get(i);
		String menu_photo = menu.getMenu_photo();
		
		boolean isUnion = false;
		if(menu.getPrice()!=0)
			isUnion=true;
%>
	<form class="form_host_menu" method="POST" enctype="multipart/form-data" style="-webkit-box-ordinal-group: <%=menu.getMenu_order()%>;">
		<div class="layout_host_menu">
			<input type="hidden" name="idx" value="<%=menu.getIdx()%>">
			<div class="host_menu_left" align='center'>
			<%if (menu_photo == null || menu_photo.equals("")){%>
				<img src="../images/menu/noimage.jpg" class="host_menu_photo">
			<%} else{%>
				<img src="<%=menu_photo%>" class="host_menu_photo">
			<%} %>
				<input type="file" name="menu_photo" accept="image/*">
				<input type="hidden" name="img_src_prev" value="<%=menu_photo%>">
			</div>
			<div class="host_menu_right">
				<div class="host_menu_delete">
					<span class="menu_upper">����</span>
					<span class="menu_lower">�Ʒ���</span>
					<img src="../images/icon_common/icon_x.png">
				</div>
				<div class="host_menu_type">
					<select name="menu_type">
						<option value="0" <%if(menu.getMenu_type()==0){%>selected<%}%>>��ü�޴�</option>
						<option value="1" <%if(menu.getMenu_type()==1){%>selected<%}%>>����Ư��</option>
					</select>
				</div>
				<div class="host_menu_name">
					<input type="text" name="menu_name" value="<%=menu.getMenu_name()%>" placeholder="�޴� �̸�" maxlength="10" required>
					<span></span>
				</div>
				<div class="host_menu_price" <%if(!isUnion){ out.write("style='display: none'"); }%>>
					<input type="number" name="price" value="<%=menu.getPrice()%>" placeholder="����">
					<button class="toggle_price">��/��/�� ��ȯ</button>
				</div>
				<div class="host_menu_price" <%if(isUnion){ out.write("style='display: none'"); }%>>
					<input type="number" name="price_s" value="<%=menu.getPrice_s()%>" placeholder="��">
					<input type="number" name="price_m" value="<%=menu.getPrice_m()%>" placeholder="��">
					<input type="number" name="price_l" value="<%=menu.getPrice_l()%>" placeholder="��">
					<button class="toggle_price">���ϰ��� ��ȯ</button>
				</div>
				<div class="host_menu_info">
					<textarea name="menu_infor" placeholder="�޴� ����" maxlength="60"><%=menu.getMenu_infor()%></textarea>
					<span></span>
				</div>
			</div>
		</div>
	</form>
<%} %>	
	
	<!-- <section id="host_new_menu_layout">	
	</section>	 -->
	</div>	
	<div class="host_new_btn_fixed host_menu_add">
		<img src="../images/icon_common/icon_+.png">
	</div>
</section>
</div><!-- div.wrap -->
<script>
/* 	$(document).ready(function(){
		var BOG = "-webkit-box-ordinal-group";
	}); */
</script>
</body>
</html>