<%@ page contentType="text/html; charset=utf-8" %>

<%
	String param = request.getParameter("p");
	String ver = request.getParameter("ver");

%>
<meta name="viewport" content="width=device-width">

<link rel="stylesheet" href="../css/index_style.css?ver=1"/>
<style>
	body{ margin: 0; top: 0px !important;}
	table{ width: 100vmin; height: 40vmax; }
	table tbody{ vertical-align: top; }
	table td { padding-top: 10vmin; }
	table td img{ width: 20vmin; }
	.wrap{ width: 100vmin; height: 100vmax; background-repeat: no-repeat; background-size: cover; background-position: center; }	
</style>
<body>
<div class="wrap" style="margin: auto; width: 100vmin; height: 100vmax; 
		background-image: url('../images/event/event_bg.jpg');
		background-repeat: no-repeat;
		background-size: cover;
		background-position: center;">
  <input type="hidden" name="topmenu_height" id="topmenu_height" >
  <div id="top_menu">
    <table>
    <tr class="menu-img">
      <td>
        <a href='event_roulette.jsp?p=<%=param%>' target="_self"> <% //이벤트 페이지 접속시 target="_self" 필수 %>
	        <img src="../images/event/top_img_15.png" alt="button" /><br>
	        <img src="../images/event/top_menu_17.png" alt="button" />
        </a>
      </td>
      <td>
        <a href="event_lotto.jsp?p=<%=param%>" target="_self">
	        <img src="../images/event/top_img_16.png" alt="button" /><br>
	        <img src="../images/event/top_menu_18.png" alt="button" />
        </a>
      </td>
	  <td>
		<a href="event_game.jsp?p=<%=param%>" target="_self">
	        <img src="../images/event/top_img_18.png" alt="button" /><br>
	        <img src="../images/event/top_menu_20.png" alt="button" />
        </a>
      </td>
      <td>
        <a href="http://sazoo.com/ss/run/sazoo/ddi/result.php" target="_self">
	        <img src="../images/event/top_img_17.png" alt="button" /><br>
	        <img src="../images/event/top_menu_19.png" alt="button" />
        </a>
      </td>      
    </tr>
    
    </table>

  </div>

</div>

</body>
</html>
