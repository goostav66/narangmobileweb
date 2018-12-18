<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<%@include file="../nfc_header.jsp"%>

<style>
	.wrap, .step_pay_first, .step_pay_second{ display: flex; flex-flow: column; align-items: center; }
	.step_pay_first, .step_pay_second{ /* position: absolute; top: 40vmin; */ width: fit-content; }
	.step_pay_second{ display: none; left: 100vw; }
	.heading_pay{ font-size: 1.5rem; font-weight: 900; margin-top: 3vmin; }
	.panel_pay_select{ width: 60vmin; padding: 5vmin; background-color: #fff; font-size: 1.3rem; font-weight: 700; margin: 2vmin 0; border-radius: 3vmin; display: flex; align-items: center; }
	.radiobutton{ border: 1px solid #45A737; margin-right: 1vmin; width: 1.1rem; height: 1.1rem; }
	.radiobutton input[type=radio]{ opacity: 0; margin: 0; width: 0; height: 0; }
	
	.step_pay_second>div{ margin: 1vmin 0; }
	.panel_pay_back{ background-color: #FFF; padding: 2vmin; border-radius: 5px; width: 95%; display: flex; }
	.panel_pay_back span{ font-size: 0.9rem; font-weight: 500;}
	.pay_back_arrow{ width: 2.4rem; height: 2.4rem; margin-right: 1vmin; position: relative; }
	
	#arrow_upp, #arrow_bot{ position: absolute; left: 0; width: 20px; height: 2px; background-color: #000; }
	#arrow_upp{ top: 30%; transform: rotate(-45deg); }
	#arrow_bot{ bottom: 30%; transform: rotate(45deg); }
	
	.panel_pay_back #pay_selected{ font-size: 1.2rem; font-weight: 700; border-radius: 5px; }
	.panel_pay_qr{ margin: 1vmin 0; }
	.panel_pay_number{ margin: 1vmin 0; font-size: 1.2rem; font-weight: 700; background-color: #FFF; padding: 2vmin; border-radius: 5px; }
	.panel_pay_number input{ padding: 1vmin; font-size: 1.1rem; margin-right: 1vmin; border-radius: 5px; }
	.panel_pay_send{ background-color: #FFF; padding: 1vmin; border-radius: 5px; }
	.panel_pay_send button{ color: #000; border: 2px solid #45A737; background-color: #FFF; font-size: 1.1rem; font-weight: 700; padding: 2vmin 15vmin; border-radius: 5px; }
	
	.e_bill{ display: flex; margin: 5vmin; border-top: 1px solid #000; border-bottom: 1px solid #000; margin-bottom: 2vmin; }
	.e_bill>div{ padding: 3vmin 13vmin; }
	
	.bill_origin{ display: none; flex-flow: column; align-items: center; position: fixed; top: 20%; background-color: #fff; }

	.bill_origin>div{ margin: 2vmin 0; }
	
	.bill_table{ display: flex; flex-flow: column; width: 96vmin; }
	.bill_tr{ display: flex; flex-flow: row; padding: 2vmin 0; }
	.bill_tr:first-child, .bill_tr:last-child{ border-top: 1px dashed #000; border-bottom: 1px dashed #000; }
	.bill_tr div:first-child{ width: 30vmin; text-align: center; padding: 0.5vmin 1vmin; }
	.bill_tr div:nth-child(2){ width: 20vmin; text-align: right; padding: 0.5vmin 1vmin; }
	.bill_tr div:nth-child(3){ width: 15vmin; text-align: center; padding: 0.5vmin 1vmin; }
	.bill_tr div:last-child{ width: 30vmin; text-align: center; padding: 0.5vmin 1vmin; }
	
	.flex{ display: flex; }
	#guid_bill{ font-size: 0.8rem; color: #aaa; }
	.btn_payment{ color: #000; border: 2px solid #45A737; background-color: #fff; border-radius: 5px; padding: 3vmin 10vmin; font-weight: 700; }
</style>
<body>
<div class='wrap'>
	<span class='heading_pay'>Narang Pay</span>
	
	<div class="e_bill">
		<div>계산서</div><div>73,000 원</div>
	</div>
	<span id="guid_bill">상세 금액을 보시려면 계산서를 터치해주세요.</span>
	<div class="bill_origin">
		<div>금강 왕 생삼겹살</div>
		<div>테이블 번호 30-3</div>
		<div>일시 2018.11.10 19:30:25</div>
		
		<div class="bill_table">
			<div class="bill_tr">
				<div style="text-align:center">품목</div><div style="text-align:center">단가</div><div style="text-align:center">수량</div><div style="text-align:center">금액</div>	
			</div>
			<div class="bill_tr">
				<div>생 왕목살</div><div>12,000</div><div>3</div><div>36,000</div>	
			</div>
			<div class="bill_tr">
				<div>소주</div><div>4,000</div><div>4</div><div>16,000</div>	
			</div>
			<div class="bill_tr">
				<div>냉면</div><div>7,000</div><div>3</div><div>21,000</div>	
			</div>
			<div class="bill_tr">
				<div>합계금액</div><div style="width: 60vmin; text-align: right; ">73,000</div>	
			</div>
		</div>
		<div>
			<button class="btn_payment">결제하기</button>
		</div>
	</div>
	
	<div class="step_pay_first">
		<div class='panel_pay_select'>
			<div class='radiobutton'>
				<input type='radio' name='radio_pay' value='카카오페이'>
			</div>
			<span>카카오페이</span>
		</div>
		<div class='panel_pay_select'>
			<div class='radiobutton'>
				<input type='radio' name='radio_pay' value='서울페이'>
			</div>
			<span>서울페이</span>		
		</div>
		<div class='panel_pay_select'>
			<div class='radiobutton'>
				<input type='radio' name='radio_pay' value='경남페이'>
			</div>
			<span>경남페이</span>
		</div>
	</div>
	<div class="step_pay_second">
		<div class='panel_pay_back'>
			<div class='pay_back_arrow'>
				<div id='arrow_upp'></div>
				<div id='arrow_bot'></div>
			</div>
			<div class='pay_back_text'>
				<span id='pay_selected'></span><br>
				<span>결제 수단 변경하기</span>
			</div>
		</div>
		<div class='panel_pay_qr'>
			<img src='../images/sample_img/qr_border.png'>
		</div>
		
		<div class='panel_pay_number'>
			<input type='number' placeholder='결제할 금액을 입력하세요.'>원
		</div>
		<div class='panel_pay_send'>
			<button type='button'>보내기</button>
		</div>
	</div>

</div>
</body>
<script>
	$(document).ready(function(){
		$(".panel_pay_select").click(function(){
			$(".radiobutton").each(function(){
				$(this).css("background-color", "#FFF");
			});
			$(this).find(".radiobutton").css("background-color", "#45A737");
			$(this).find("input[name=radio_pay]").prop("checked", true);
			stepPaySecond($("input[name=radio_pay]:checked").val());	
		});
		
		$(".panel_pay_back").click(function(){
			stepBackFirst();
		});
		
		$(".e_bill").click(function(){
			$(".bill_origin").toggleClass("flex");
			$("#guid_bill").toggle();
		});
		$(".bill_origin").click(function(){
			$(".bill_origin").toggleClass("flex");
			$("#guid_bill").toggle();
		});
		function stepPaySecond(pay){
			location.href="https://qr.kakaopay.com/281006012000000717354660";
			//window.open("");
			
			/* if(pay == '카카오페이'){
				location.href='kakaopay.jsp';
			} else{
				$("#pay_selected").text(pay);
				$(".step_pay_first").animate({left: "-100vw"});
				$(".step_pay_second").css({"display": "flex"});
				$(".step_pay_second").animate({left: "13vw"});		
			}	 */
		}
		
		function stepBackFirst(){
			$(".step_pay_second").animate({ left: "113vw" });
			//$(".step_pay_second").css({"display": "none"});
			$(".step_pay_first").animate({left: "13vw"});
			
		}
	});
</script>