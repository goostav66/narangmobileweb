<%@ page contentType="text/html; charset=utf-8" %>

<%
	response.addHeader("Access-Control-Allow-Origin", "*");
	String param = request.getParameter("p");
	String ver = request.getParameter("ver");

%>
<meta name="viewport" content="width=device-width">
<link rel="stylesheet" href="../css/index_style.css?ver=1"/>
<body>
<section data-role="page" id="index" >

<div id="index">
	<div>
		<img src="../images/event/game_title.png" width="100%" alt="" />
	</div>
	<div style="height:65%; overflow:auto">
		<table class="game_items">
			<tr>
				<td>
					<a href="http://play.famobi.com/smarty-bubbles">
						<img src="../images/event/game_SmartyBubbles.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/smarty-bubbles" class="game_text">
						스마티 버블스
					</a>
				</td>
				<td>
					<a href="http://play.famobi.com/fruita-crush">
						<img src="../images/event/game_FruitaCrushTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/fruita-crush" class="game_text">
						플루티카 크러쉬
					</a>
				</td>
			</tr>
			<tr>
				<td>
					<a href="http://play.famobi.com/nut-rush">
						<img src="../images/event/game_NutRushTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/nut-rush" class="game_text">
						너트 러쉬
					</a>
				</td>
				<td>
					<a href="http://play.famobi.com/western-solitaire">
						<img src="../images/event/game_WesternSolitaireTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/western-solitaire" class="game_text">
						웨스턴 카드게임
					</a>
				</td>
			</tr>
			<tr>
				<td>
					<a href="http://play.famobi.com/mini-putt-forest">
						<img src="../images/event/game_MiniPuttForestTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/mini-putt-forest" class="game_text">
						미니 풋 포레스트
					</a>
				</td>
				<td>
					<a href="http://play.famobi.com/cartoon-flight">
						<img src="../images/event/game_CartoonFlightTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/cartoon-flight" class="game_text">
						카툰 플라이트
					</a>
				</td>
			</tr>
			<tr>
				<td>
					<a href="http://play.famobi.com/puzzletag">
						<img src="../images/event/game_PuzzletagTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/puzzletag" class="game_text">
						퍼즐태그
					</a>
				</td>
				<td>
					<a href="http://play.famobi.com/mahjong-relax">
						<img src="../images/event/game_MahjongTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/mahjong-relax" class="game_text">
						마작 릴렉스
					</a>
				</td>
			</tr>
			<tr>
				<td>
					<a href="http://play.famobi.com/speed-pool-king">
						<img src="../images/event/game_SpeedBilliardsTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/speed-pool-king" class="game_text">
						스피드 당구
					</a>
				</td>
				<td>
					<a href="http://play.famobi.com/thug-racer">
						<img src="../images/event/game_ThugRacerTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/thug-racer" class="game_text">
						폭력배 레이서
					</a>
				</td>
			</tr>
			<tr>
				<td>
					<a href="http://play.famobi.com/endless-truck">
						<img src="../images/event/game_EndlessTruckTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/endless-truck" class="game_text">
						무한 트럭
					</a>
				</td>
				<td>
					<a href="http://play.famobi.com/classic-bowling">
						<img src="../images/event/game_ClassicBowlingTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/classic-bowling" class="game_text">
						클래식 볼링
					</a>
				</td>
			</tr>
			<tr>
				<td>
					<a href="http://play.famobi.com/baseball-pro">
						<img src="../images/event/game_BaseballProTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/baseball-pro" class="game_text">
						베이스볼 프로
					</a>
				</td>
				<td>
					<a href="http://play.famobi.com/ultimate-boxing">
						<img src="../images/event/game_UltimateBoxingTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/ultimate-boxing" class="game_text">
						최후의 복싱
					</a>
				</td>
			</tr>
			<tr>
				<td>
					<a href="http://play.famobi.com/soccer-bubbles">
						<img src="../images/event/game_SoccerBubblesTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/soccer-bubbles" class="game_text">
						축구 버블스
					</a>
				</td>
				<td>
					<a href="http://play.famobi.com/basketball">
						<img src="../images/event/game_BasketballTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/basketball" class="game_text">
						농구게임
					</a>
				</td>
			</tr>
			<tr>
				<td>
					<a href="http://play.famobi.com/euro-2016-goal-rush">
						<img src="../images/event/game_Euro2016GoalRushTeaser.jpg" width="100" height="100" alt="" />
					</a>
					<a href="http://play.famobi.com/euro-2016-goal-rush" class="game_text">
						유로2016: 골러쉬
					</a>
				</td>
			</tr>

		</table>
	</div>
</div>

<style>
#index {width:100%; height:100%;  overflow:auto;
background-image:url('../images/event/game_bg.jpg'); background-repeat: no-repeat; background-size: cover;}

.game_items	{margin:0 auto; width:90%; height:90%; border:10px;}
.game_items tr td	{padding:10px; text-align: center;  }
.game_items tr td .game_text	{display:block; margin-top:10px; color: #000 !important; font-size:10pt; font-weight: 700; text-decoration:none}
</section>
</body>
</html>
