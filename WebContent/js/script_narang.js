$(document).ready(function(){
	resize_title();
	//����ȭ�� �޴� ������ ��ġ ����
	$(".menu_icon").click(function(){
		navigator.vibrate(100);
	});
	
	//����ȭ�� ���� �����̵� ����
	$(".photo_panel:eq(0)").css("display", "flex");
	var photo_panel_index = 0;
	var photo_panel_length = $(".photo_panel").length;
	
	var handle = null;
	if(photo_panel_length > 1) 
		setAutoPhotoSlide(4000);
	
	function setAutoPhotoSlide(interval){
		if(handle == null){
			handle = setInterval(function(){
				photo_panel_index++;
				if(photo_panel_index >= photo_panel_length)
					photo_panel_index = 0;
				setPhotoSlide(photo_panel_index, 0);
			}, 4000);
		}
	}
	
	$(".main_promotion_slide").marquee({
		duplicated: true
	});
	
	
	//����ȭ�� �����̵� ����
	var touch_start_x;
	var touch_end_x;
	$(document).on("touchstart", ".main_photo", function(e){
		touch_start_x = e.touches[0].clientX;
	});
	
	$(document).on("touchend", ".main_photo", function(e){
		touch_end_x = e.changedTouches[0].clientX;
		
		if( touch_start_x > touch_end_x && photo_panel_length > 1 ){//swipe RtL
			photo_panel_index++;
			if(photo_panel_index >= photo_panel_length) photo_panel_index = 0;
			setPhotoSlide(photo_panel_index, 0);
		}else if( touch_start_x < touch_end_x && photo_panel_length > 1 ){//swipe LtR
			photo_panel_index--;
			if(photo_panel_index < 0) photo_panel_index = photo_panel_length-1;
			setPhotoSlide(photo_panel_index, 1);
		}
	});
	
	//����ȭ�� �����̵� : �ش� �ε����� ������ ���/������ �����
	function setPhotoSlide(index, direction){
		var slide = $(".photo_panel:eq("+index+")");
		$(".photo_panel").each(function(){
			$(this).hide();
		});
		clearInterval(handle);
		handle = null;
		if(direction == 0)//next
			slide.css({'display': 'flex', 'left': '100%'});
		else if(direction == 1)//prev
			slide.css({'display': 'flex', 'left': '-100%'});
		slide.animate({left: 0}, 500);
		setAutoPhotoSlide(4000);
	} 
	
	//�븮���� ȣ�� : �ȵ���̵忡�� �������� ���� ȣ��
	$("#call_driver_button").click(function(){
		var os = navigator.appVersion.toLowerCase();
		var url = getParameters("p");
		/*if(os.indexOf("android") != -1){*/
			$.ajax({
				url : 'call_driver/proc_call.jsp',
				type : 'POST',
				data : { p : url }
			})
			location.href="tel:07086702936";	
		//}
	});
	
	//��� �����̵�(���Ͽ���)
	var banner_idx = 1;
	$(".scrollBanner img:eq(0)").show();
	$(".dot:eq(0)").css("background-color", "#999");
	setInterval(function(){
		$(".scrollBanner img").each(function(){
			if(banner_idx >= 4)
				banner_idx = 0;

			if( $(this).index() == banner_idx){
				$(this).show();
				$(".dot:eq("+$(this).index()+")").css("background-color", "#999");
			}
			else{
				$(this).hide();
				$(".dot:eq("+$(this).index()+")").css("background-color", "#eee");
			}
		});
		banner_idx++;
	}, 2000);
	
	
	//����(�׽�Ʈ)
	$(document).on('change', '#translate', function(){
		var code = getParameters("p");
		var shared = getParameters("is");
		if(shared == null)
			shared = 'null';
		location.href='index.jsp?p='+code+'&is='+shared+'&lan='+this.value;
	});
	
	
	//��������: ���һ���<->���� ���
	$(".loc").click(function(){
		$("#shop_photo").toggle();
		$("#map_photo").toggle();
	});
	
	//���ڸ޴���: �޴� ���� �÷�Ʈ
	$(".menu_photo").click(function(){
		var menu_name = $(this).next().find(".menu_name").text();
		var src = $(this).find("div").css('background-image');
	    src = src.replace('url(','').replace(')','');
		$("#menu_detail_name").text(menu_name);
		$("#menu_detail_img").css("background-image", 'url('+src+')');
		
		$(".dialog_background").show();
		$(".dialog_menu_detail").show();
		
		$(".dialog_background").click(function(){
			$(".dialog_background").hide();
			$(".dialog_menu_detail").hide();
		});
		$(".dialog_close").click(function(){
			$(".dialog_background").hide();
			$(".dialog_menu_detail").hide();
		});
	});
	
	
	//���θ�� ������ - �̺�Ʈ ���� ù���ܸ� ��������
	$(".shop_msg span").each(function(){
		var text_msg = $(this).find("p:first-child").text();
		$(this).text(text_msg);
	});
	
	//����������: �����ϱ� �÷�Ʈ
	$(".share_main_page").click(function(){
		var shop_name = $(".shop_name").text();
		float_share_dialog(shop_name);
	});
	
	//���������� �����ϱ�
	$(".share_main_sms").click(function(){
		var code = $("input[name='url']").val();
		var title = $(".shop_name").text();
		var url = "http://hanjicds001.gabia.io/index.jsp?p="+code+"%2526is=y";
		share_sms(title, url);
	});
	$(".share_main_kakao").click(function(){
		var url = $("input[name='url']").val();
		var address = $("input[name='address']").val();
		var title = $(".shop_name").text();
		var description = $("input[name='intro_text']").val();
		var imageUrl = $("input[name='mainImg']").val();
		var webUrl = "http://hanjicds001.gabia.io/index.jsp?p="+url+"&is=y";
		
		share_kakao_location(address, title, description, imageUrl, webUrl);
	});
	$(".share_main_face").click(function(){
		var code = $("input[name='url']").val();
		var url = "http://hanjicds001.gabia.io/index.jsp?p="+code+"%26is=y&amp";
		share_facebook(encodeURIComponent(url));
	});
	
	
	//�ٷΰ���
	$(document).on("click", ".event_btn .direct", function(){
		var code = $(this).closest(".layout_event").find("input[name='url']").val();
		var url = '../index.jsp?p='+code+'&is=y';
		
		location.href=url;
	});
	
	$(document).on("click", ".discount_btn .direct", function(){
		var code = $(this).closest(".layout_discount").find("input[name='url']").val();
		var idx = $(this).closest(".layout_discount").find("input[name='dc_idx']").val();
		
		var url = 'franch_infor.jsp?p='+code+'&idx='+idx;
		location.href=url;
	});

	//�������� �����ϱ�
	$(".discount_btn .share_pop").click(function(){
		var title = "�������� ����";
		var layout = $(this).closest(".layout_discount");
		float_share_dialog(title, layout);
	});
	
	
	$(".share_dc_sms").click(function(){
		var layout = $(this).closest(".dialog_share");
		var code = layout.find("input[name='dialog_url']").val();
		
		var dc_idx;
		$(".set_discount").each(function(){
			if( $(this).find("input[name='url']").val() == code ) {
				dc_idx = $(this).find("input[name='dc_idx']").val();
				return;
			}
		});

		var title = layout.find(".dialog_title").text();
		var url = "http://hanjicds001.gabia.io/reserve/franch_infor.jsp?p="+code+"%2526idx="+dc_idx+"%2526is=y";
		share_sms(title, url);
		
	});
	$(".share_dc_kakao").click(function(){
		var layout = $(this).closest(".dialog_share");
		var code = layout.find("input[name='dialog_url']").val();
		var src;
		
		$(".layout_discount").each(function(){
			if( $(this).find("input[name='url']").val() == code ){
				src = $(this);
				return;
			}
		});
		
		var title = src.find(".shop_name").text()+"���� �������� �����!";
		var description = src.find(".shop_msg").text();
		var imageUrl = src.find(".shop_photo img").attr('src');
		var webUrl = 'http://hanjicds001.gabia.io/reserve/franch_infor.jsp?p='+src.find("input[name='url']").val()+'&idx='+src.find("input[name='dc_idx']").val()+'&is=y';
		
		share_kakao_feed(title, description, imageUrl, webUrl);
	});

	$(".share_dc_face").click(function(){
		var layout = $(this).closest(".dialog_share");
		var code = $("input[name='dialog_url']").val();
		
		var src;
		
		$(".layout_discount").each(function(){
			if( $(this).find("input[name='url']").val() == code ){
				src = $(this);
				return;
			}
		});
		
		var title = src.find(".shop_name").text()+"���� �������� �����!";
		var imageUrl = src.find(".shop_photo img").attr('src');
		
		var dc_idx = src.find("input[name='dc_idx']").val();
			
		var url = "http://hanjicds001.gabia.io/reserve/franch_infor.jsp?p="+code+"&idx="+dc_idx+"&is=y";
		share_facebook(encodeURIComponent(url), imageUrl, title);
		
	});
	
	
	//������ �̺�Ʈ: ������ �̵�, ����â �÷�Ʈ
	$(".set_popup").click(function(e){
		var source = e.target.className;
		var url = $(this).find("input[name='url']").val();
		if(source != "share_icon" && source != "popup_share"){
			location.href='../index.jsp?p='+url+'&is=y';
		}else{
			var layout = $(this).closest(".set_popup");
			set_selected_layout(layout);
		}
		
	});
	
	//������ �̺�Ʈ ���� �˾�â
	$(".event_btn .share_pop").click(function(){
		var title = "�̺�Ʈ ����";
		var layout = $(this).closest(".layout_event");
		float_share_dialog(title, layout);
	});
	
	
	//������ �̺�Ʈ �����ϱ�(����)
	$(".share_event_sms").click(function(){
		var code = $("input[name='dialog_url']").val();
		var title = $(".dialog_title").text();
		var url = "http://hanjicds001.gabia.io/index.jsp?p="+code+"%2526is=y";
		share_sms(title, url);	
	});
	//������ �̺�Ʈ �����ϱ�(īī����)
	$(".share_event_kakao").click(function(){
		var code = $("input[name='dialog_url']").val();
		
		var src;
		$(".layout_event").each(function(){
			if( $(this).find("input[name='url']").val() == code ){
				src = $(this);
				return;
			}
		});
		
		var title = src.find(".shop_name").text()+"���� �̺�Ʈ�� �������Դϴ�";
		var description = src.find(".shop_msg").text();
		var imageUrl = src.find(".shop_photo img").attr('src');
		var webUrl = 'http://hanjicds001.gabia.io/index.jsp?p='+src.find("input[name='url']").val()+'&is=y';			
		share_kakao_feed(title, description, imageUrl, webUrl);
	
	});
	
	$(".share_event_face").click(function(){
		var layout = $(this).closest(".dialog_share");
		
		var code = layout.find("input[name='dialog_url']").val();
		var url = "http://hanjicds001.gabia.io/index.jsp?p="+code+"&is=y";

		share_facebook(encodeURIComponent(url));
		
	});
	
	//������ �˻�
	$(document).on('keyup', '#text_search_reserve', function(e){
		var key = e.keyCode;
		if(key == 13){//enter : �˻�
			var keyword = $(this).val();
			if(keyword != ""){
				$("form").submit();
			}
		}
	})

	//������ �̾߱� ����â �÷�Ʈ
	$(".share_board").click(function(){
		 var title = "�Խù� �����ϱ�";
		 var board_idx = $(this).closest(".board_article").find("input[name='board_idx']").val();		 
		 $("input[name='dialog_bIdx']").val(board_idx);
		 
		 float_share_dialog(title);
	});
	//������ �̾߱� �����ϱ�
	$(".share_board_sms").click(function(){
		var code = $("input[name='url']").val();
		var idx = $("input[name='dialog_bIdx']").val();
		var shop_name = $("input[name='shop_name']").val(); 
		var title = shop_name+" ������ �̾߱⿡�� �ۼ��� ���� Ȯ���غ�����";
		var url = "http://hanjicds001.gabia.io/host/host_board_ex.jsp?p="+code+"&idx="+idx;
		
		share_sms(title, encodeURIComponent(url));
	});
	
	$(".share_board_kakao").click(function(){
		var code = $("input[name='url']").val();
		var idx = $("input[name='dialog_bIdx']").val();	
		var src;
		
		$(".board_article").each(function(){
			if( $(this).find("input[name='board_idx']").val() == idx){
				src = $(this);
				return;
			}
		});
		
		var title = $("input[name='shop_name']").val();
		var description = "������ �̾߱⿡�� �ۼ��� ���� Ȯ���غ�����";
		var imageUrl;
		if( src.find(".board_content img") != null )
			imageUrl = src.find(".board_content img").attr('src');
		else
			imageUrl = $("input[name='photo_url']").val();
		var webUrl = "http://hanjicds001.gabia.io/host/host_board_ex.jsp?p="+code+"&idx="+idx;
		
		share_kakao_feed(title, description, imageUrl, webUrl);
	});
	$(".share_board_face").click(function(){
		var code = $("input[name='url']").val();
		var idx = $("input[name='dialog_bIdx']").val();
		var url = "http://hanjicds001.gabia.io/host/host_board_ex.jsp?p="+code+"&idx="+idx;
		
		var src;
		
		$(".board_article").each(function(){
			if( $(this).find("input[name='board_idx']").val() == idx){
				src = $(this);
				return;
			}
		});
		
		var imageUrl;
		if( src.find(".board_content img") != null )
			imageUrl = src.find(".board_content img").attr('src');
		else
			imageUrl = $("input[name='photo_url']").val();
		var title = $("input[name='shop_name']").val() + " ������ �̾߱⿡�� �ۼ��� ���� Ȯ���غ�����";
		
		share_facebook(encodeURIComponent(url), imageUrl, title);
	});
	
	//�մ��̾߱� - ������ �ʱ� ����
	$(".layer_emoticon input[name='emoticon']:first").prop('checked', true);

	//�մ��̾߱� - ����
	$(".review_delete img").click(function(){
		if( !confirm("�����Ͻðڽ��ϱ�?") )
			return;
		var reply_idx = $(this).attr("id");
		$.ajax({
			url: 'proc_reply.jsp',
			type: 'POST',
			data: {reply_idx: reply_idx} 
		})
		var layout = $(this).closest(".layout_host_review");
		layout.remove();
	});
	
	//������ �̾߱� : ���̵� �޴� ���
	$(".icon_sideNav").click(function(){
		$(".sideNav_background").show();
		$(".sideNav").addClass("sideNav_block");
	});
	$(".close_sideNav").click(function(){
		$(".sideNav_background").hide();
		$(".sideNav").removeClass("sideNav_block");
	});
	$(".sideNav_background").click(function(){
		$(".sideNav_background").hide();
		$(".sideNav").removeClass("sideNav_block");
	});	

	//�������� ���� - ����
	$(".host_infor_save").click(function(e){
		e.preventDefault();
		
		if( confirm("������ ������ �����ϰڽ��ϱ�?") ){	
			//��ȿ�� üũ
			if( $("input[name='shop_name']").val().trim() == "" ){
				alert("���Ҹ��� �Է����ּ���.");
				$("input[name='shop_name']").focus();
				return;
			}else if( $("input[name='shop_phone']").val().trim() == "" ){
				alert("��ȭ��ȣ�� �Է����ּ���.");
				$("input[name='shop_phone']").focus();
				return;
			}else if( $("textarea[name='shop_addr']").val().trim() == "" ){
				alert("�ּҸ� �Է����ּ���.");
				$("textarea[name='shop_addr']").focus();
				return;
			}else if( $("input[name='open_weekDay']").val() == "" || $("input[name='close_weekDay']").val() == "" || $("input[name='open_weekEnd']").val() == "" || $("input[name='close_weekEnd']").val() == "" ){
				alert("�ð��� �Է����ּ���.");
				return;
			}
			$(".host_infor_right textarea").each(function(){
				var txt = $(this).val();
				$(this).val(txt.replace(/\n/g, ''));
			});
			
			//�ּ��� ����, �浵 ����
			var full_address = $(".list_location_city option:selected").text() + $("textarea[name='shop_addr']").val();
			
			var geocoder = new daum.maps.services.Geocoder();
			
			geocoder.addressSearch(full_address, function(result, status){
				if(status === daum.maps.services.Status.OK){
					var coords = new daum.maps.LatLng(result[0].y, result[0].x);	
					$("#shop_lat").val(coords.getLat());
					$("#shop_lng").val(coords.getLng());			
				}
				$(".form_host_infor").submit();
			});
		}
	});
	
	//�������� ���� - ���
	$(".host_infor_cancel").click(function(e){
		e.preventDefault();
		var code = $("input[name='url']").val();
		if( confirm("����ϰڽ��ϱ�?\n������ ������ ������� �ʽ��ϴ�.") )
			location.href="host_infor.jsp?p="+code;
	});
	

	
	//�������� ���� - �ΰ����� ������ ����
	$("#extra_dc_rate").click(function(){
		var input_discount = $(this).find("input[name='discount']");
		$(this).children("img").css("display", "none");
		
		var discount_rate = input_discount.val()*1 + 5;
		if( discount_rate>15 ) discount_rate = 0;
		initIconDcRate(discount_rate);
		input_discount.val(discount_rate);
	});
	$("#extra_is_parking").click(function(){
		var input_isParking = $(this).find("input[name='isParking']");
		$(this).children("img").css("display", "none");
		
		var isParking = input_isParking.val()*1 + 1;
		if( isParking>1 ) isParking = 0;
		initIconIsParking(isParking);
		input_isParking.val(isParking);
	});
	$("#extra_is_seats").click(function(){
		var input_isSeats = $(this).find("input[name='isSeats']");
		$(this).children("img").css("display", "none");
		
		var isSeats = input_isSeats.val()*1 + 1;
		if( isSeats>1 ) isSeats = 0;
		initIconIsSeats(isSeats);
		input_isSeats.val(isSeats);
	});
	//�������� ���� - ���ڼ� ���� ǥ��&�����
	$(document).on("focus", ".host_infor_right textarea", function(){
		setTextLength($(this), $(this).next("span"), 100);
	});
	$(document).on("blur", ".host_infor_right textarea", function(){
		$(this).next("span").text("");
	});
	$(document).on("keyup", ".host_infor_right textarea", function(){
		var txt = $(this).val();
		if( txt.length > 100){
			var maximum_txt = txt.substr(0, 100);
			$(this).val(maximum_txt);
		}else{
			setTextLength($(this), $(this).next("span"), 100);
		}
	});
	
	//�������� ���� - ���� ����
	$(".host_photo_mgr").click(function(e){
		e.preventDefault();
		var code = $("input[name='url']").val();
		window.open("host_infor_photo.jsp?p="+code);
	});
	//�������� ���� - ���� Ȯ��
	$(".host_infor_photo img").click(function(){
		$(".dialog_shop_photo img").attr("src", $(this).attr("src"));
		$(".dialog_shop_photo").css("display", "flex");
	});
	$(".dialog_shop_photo").click(function(){
		$(this).hide();
	});
	
	//���һ��� ���� - ��ư Ȱ��ȭ
	$(document).on("focus", "input[name='photo_select']", function(){
		$(".host_photo_remote button").each(function(){
			$(this).prop('disabled', false);
		});
	});
	//���һ��� ����
	var BOG = "-webkit-box-ordinal-group";	
	$(".host_photo_remote .top").click(function(){//�� ����
		var selectedBox = $("input[name='photo_select']:checked").closest(".layer_photo");
		var idx = selectedBox.css(BOG);
		$(".layer_photo").each(function(){
			if( $(this).css(BOG) < idx )
				$(this).css( BOG, ($(this).css(BOG)*1+1).toString() );
		});
		selectedBox.css( BOG, "1" );
		$(document).scrollTop(0);
	});
	
	$(".host_photo_remote .up").click(function(){//����
		var selectedBox = $("input[name='photo_select']:checked").closest(".layer_photo");
		var idx = selectedBox.css(BOG);
		
		$(".layer_photo").each(function(){	
			if( $(this).css(BOG) == (idx-1) ){
				$(this).css(BOG, idx);
				return;
			}
		});
		selectedBox.css( BOG, (idx-1).toString() );
		var pos = selectedBox.position();
		$(document).scrollTop(pos.top-40);
	});
	
	$(".host_photo_remote .down").click(function(){//�Ʒ���
		var selectedBox = $("input[name='photo_select']:checked").closest(".layer_photo");
		var idx = selectedBox.css(BOG);
		var last_bog = $(".layer_photo").length;
		$(".layer_photo").each(function(){
			if( $(this).css(BOG) == (idx*1+1) ){
				$(this).css(BOG, idx);
				return;
			}
		});
		if( idx < last_bog ) {
			selectedBox.css( BOG, (idx*1+1).toString() );
			var pos = selectedBox.position();
			$(document).scrollTop(pos.top-40);
		}
	});

	$(".host_photo_remote .bottom").click(function(){//�ǾƷ���
		var selectedBox = $("input[name='photo_select']:checked").closest(".layer_photo");
		var idx = selectedBox.css(BOG);
		var last_bog = $(".layer_photo").length;
		
		$(".layer_photo").each(function(){
			if( $(this).css(BOG) > idx )
				$(this).css(BOG, ($(this).css(BOG)-1).toString());
		});
		if( idx < last_bog ) {
			selectedBox.css( BOG, last_bog.toString() );
			$(document).scrollTop($(document).height());
		}
	});

	//���һ��� ���� - �߰�
	$(".host_photo_remote .append").click(function(){
		if ( $(".layer_photo").length >= 8 ){
			alert("������ �ִ� 8������� ����� �� �ֽ��ϴ�.");
			return;
		}
		var cms = new Date().getTime();
		var input_file = '<input type="file" name="'+cms+'" accept="image/*">';
		
		$(input_file).appendTo(".host_photo_files").click();
		
		$("input[name='"+cms+"']").change(function(){
			var selectedBox = $("input[name='photo_select']:checked").closest(".layer_photo"); 
			var idx = $(".layer_photo:last").css(BOG);
			
			var layer_photo = '<div class="layer_photo">'
				 +'		<label>'
				 +'			<input type="hidden" name="cms" value="'+cms+'">'		
				 +'			<input type="radio" name="photo_select" class="photo_selector">'		
				 +'			<img src="">'		
				 +'		</label>'
				 +'</div>';
			
			if(selectedBox.index() != -1 ){
				idx = selectedBox.css(BOG);
				$(".layer_photo").each(function(){
					if( $(this).css(BOG) > idx)
						$(this).css(BOG, ($(this).css(BOG)*1+1).toString());
				});
			}
			var img = $(layer_photo).appendTo($(".host_photo")).css(BOG, (idx*1+1).toString()).find("img");
			readURL(this, img);
		});
	});
	
	//���һ��� ���� - ����
	$(".host_photo_remote .remove").click(function(){
		if( !confirm("�����Ͻðڽ��ϱ�?\n������ ����ص� ������ ������ ������ �� �����ϴ�.") )
			return;
		
		var selectedBox = $("input[name='photo_select']:checked").closest(".layer_photo"); 
		var idx = selectedBox.css(BOG);
		var del_idx = selectedBox.find("input[name='idx']").val();
		
		$.ajax({
			url: 'proc_infor_photo.jsp',
			type: 'post',
			data: {del_idx : del_idx},
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			dataType: 'html'
		})
		
		$(".layer_photo").each(function(){
			if( $(this).css(BOG) > idx )
				$(this).css(BOG, ($(this).css(BOG)-1).toString() );
		});
		selectedBox.remove();
	});
	
	//���һ��� ���� - ����
	$(".host_photo_remote .save").click(function(){
		var code = $("input[name='url']").val();
		$(".layer_photo").each(function(){
			var idx = $(this).find("input[name='idx']").val();
			if(idx != null){//���� �̹���
				$.ajax({
					url: 'proc_infor_photo.jsp?p='+code,
					type: 'post',
					data: {shop_photo_idx : idx, bog : $(this).css(BOG)},
					contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
					dataType: 'html'
				})	
			}else{//�ű� �̹���
				var cms = $(this).find("input[name='cms']").val();
				var photo;
				$(".host_photo_files input[type='file']").each(function(){
					if( cms == $(this).attr("name") ){
						photo = $(this).get(0).files[0];
						return false;
					}
				});
				var formData = new FormData();
				formData.append("bog", $(this).css(BOG));
				formData.append("file", photo);
				
				$.ajax({
					url: 'proc_infor_photo.jsp?p='+code,
					type: 'POST',
					data: formData,
					processData: false,
					contentType: false
				});
			}
		});
		
		alert("������ �Ϸ�Ǿ����ϴ�.");
		location.href="host_infor_photo.jsp?p="+code;
	});
	
	$(".host_photo_remote .exit").click(function(){
		if(confirm("â�� �ݽ��ϴ�.")){
			opener.location.reload();
			window.close();
			
		}
	});
	
	//�޴��� ���� - �޴� ����
	$(".host_menu_control").click(function(){
		if(!confirm("������ ������ �����ϰڽ��ϱ�?"))
			return;
		var flag = true;
		var code = $("input[name='url']").val();
		var form_menu_mod = $(".form_host_menu");
		var form_menu_new = $(".form_host_new_menu");
		
		form_menu_mod.each(function(){//���� �޴� : ����
			var form = $(this)[0];
			var id = $(this).attr("id");
			
			//��ȿ�� �˻�, ���� �ʱ�ȭ
			if( $(this).find(".host_menu_name input").val().trim() == "" ){
				alert("�޴� �̸��� �Է����ּ���.");
				flag = false;
				var offset = $(this).offset();
				$(document).scrollTop(offset.top);
				return false;
			}else{
				$(this).find(".host_menu_price").each(function(){
					if( $(this).css("display") == "none" )
						$(this).children().val(0);
					else if( $(this).children("input[name='price']").val() == 0 ||
							($(this).children("input[name='price_s']").val() == 0 && $(this).children("input[name='price_m']").val() == 0 && $(this).children("input[name='price_l']").val() == 0) ){
						alert("������ �Է����ּ���.");	
						flag = false;
						var offset = $(this).offset();
						$(document).scrollTop(offset.top);
						return false;
					}
				});
			}
			
			
			var textarea = $(this).find("textarea[name='menu_infor']");
			textarea.val(textarea.val().replace(/\n/g, ''));
			var formData = new FormData(form);
			
			if( $(this).find("input[name='menu_photo']").files != null )//�޴� ����
				formData.append("menu_photo", $(this).find("input[name='menu_photo']").files[0]);
			
			var menu_order = $(this).css(BOG);//�޴� ����
			formData.append("menu_order", menu_order);
			
			$.ajax({
				url: 'proc_menu.jsp?p='+code,
				type: 'POST',
				data: formData,
				processData: false,
				contentType: false
			});
			
		});
		
		if(!flag) return;
		
		form_menu_new.each(function(){//�ű� �޴� : �߰�
			
			var form = $(this)[0];
			var id = $(this).attr("id");
			//��ȿ�� �˻�, ���� �ʱ�ȭ
			if( $(this).find(".host_menu_name input").val().trim() == "" ){
				alert("�޴� �̸��� �Է����ּ���.");
				flag = false;
				var offset = $(this).offset();
				$(document).scrollTop(offset.top);
				//return false;
			}else{
				$(this).find(".host_menu_price").each(function(){
					if( $(this).css("display") == "none" )
						$(this).children().val(0);
					else if( $(this).children("input[name='price']").val() == 0 ||
							($(this).children("input[name='price_s']").val() == 0 && $(this).children("input[name='price_m']").val() == 0 && $(this).children("input[name='price_l']").val() == 0) ){
						alert("������ �Է����ּ���.");	
						flag = false;
						var offset = $(this).offset();
						$(document).scrollTop(offset.top);	
						return false;
					}
				});
			}
				
			
			var formData = new FormData(form);
			
			if( $(this).find("input[name='menu_photo']").files != null )//�޴� ����
				formData.append("menu_photo", $(this).find("input[name='menu_photo']").files[0]);
			
			var menu_order = $(this).css(BOG);//�޴� ����
			formData.append("menu_order", menu_order);
			
			$.ajax({
				url: 'proc_menu.jsp?p='+code,
				type: 'POST',
				data: formData,
				processData: false,
				contentType: false
			});
			
		});
		if(flag){
			alert("������ �Ϸ�Ǿ����ϴ�.");
		}
	});

	//�޴��� ���� - �޴� ����
	$(document).on('click', '.menu_delete', function(){
		if(confirm("�޴��� �����ϰڽ��ϱ�?\n������ �޴��� ������ �� �����ϴ�.")){
			var menu_idx = $(this).closest(".form_host_menu").find("input[name='idx']").val();
			if(menu_idx != null){
				$.ajax({
					url: 'proc_menu.jsp',
					type: 'post',
					data: {del_menu_idx : menu_idx},
					contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
					dataType: 'html'
				})
			}
			var form = $(this).closest("form");
			var this_bog = form.css(BOG);
			$(".host_menu_panel form").each(function(){
				if($(this).css(BOG) > this_bog){
					$(this).css(BOG, ($(this).css(BOG)-1).toString());
					return;
				}
			});
			$(this).closest("form").remove();
		}
	});

	//�޴��� ���� - �޴��̸� ���ڼ� ǥ���ϱ� & �����
	var max_length_menu_name = 10;
	var max_length_menu_info = 60;
	$(document).on("focus", ".host_menu_name input", function(){	
		setTextLength($(this), $(this).next("span"), max_length_menu_name);
	});
	$(document).on("blur", ".host_menu_name input", function(){
		$(this).next("span").text("");
	});
	$(document).on("keyup", ".host_menu_name input", function(e){
		var txt = $(this).val();
		if( txt.length > max_length_menu_name ){
			var menu_name = txt.substr(0, max_length_menu_name);
			$(this).val(menu_name);
			return;
		}else{
			setTextLength($(this), $(this).next("span"), max_length_menu_name);
		}
	});
	
	//�޴��� ���� - �޴����� ���ڼ� ǥ���ϱ� & �����
	$(document).on("focus", ".host_menu_info textarea", function(){
		setTextLength($(this), $(this).next("span"), max_length_menu_info);
	});
	$(document).on("blur", ".host_menu_info textarea", function(){
		$(this).next("span").text("");
	});
	$(document).on("keyup", ".host_menu_info textarea", function(){
		var txt = $(this).val();
		if( txt.length > max_length_menu_info ){
			var menu_info = txt.substr(0, max_length_menu_info);
			$(this).val(menu_info);
			return;
		}else{
			setTextLength($(this), $(this).next("span"), max_length_menu_info);
		}
	});

	//�޴��� ���� - �� �޴�ĭ �߰�
	$(".host_menu_add").click(function(){
		var new_menu_lastIdx = $(".host_menu_panel form").length;
		console.log(new_menu_lastIdx);
		$(".host_menu_panel").append(form_host_new_menu);
		$(".form_host_new_menu:last").css("-webkit-box-ordinal-group", (new_menu_lastIdx+1).toString());
		$(document).scrollTop($(document).height());
	});
	
	//�޴��� ���� - �̹��� �ø���
	$(document).on('click', '.host_menu_photo', function(){
		var file = $(this).next("input[type='file']");
		file.click();
		
		file.change(function(){
			var img = $(this).prev(".host_menu_photo");
			readURL(this, img);	
		});
	});
	
	//�޴��� ���� - ���� �ٲٱ�
	$(document).on('click', '.toggle_price', function(e){
		e.preventDefault();
		$(this).closest(".layout_host_menu").find(".host_menu_price").toggle();
	});
	
	//�޴��� ���� - �޴� ������
	$(document).on('click', '.menu_brief', function(){
		var menu = $(this).closest(".layout_host_menu");
		var menu_name = menu.find("input[name='menu_name']").val();
		menu.find(".menu_name_brief").text(menu_name);
		menu.find(".host_menu_details").hide();
		$(this).hide();
		menu.find(".menu_detail").show();
	});
	
	//�޴��� ���� - �޴� �ڼ���
	$(document).on('click', '.menu_detail', function(){
		var menu = $(this).closest(".layout_host_menu");
		menu.find(".menu_name_brief").text("");
		menu.find(".host_menu_details").show();
		$(this).hide();
		menu.find(".menu_brief").show();
	});
	
	//�޴��� ���� - ���� �ٲٱ� (����)
	$(document).on('click', '.menu_upper', function(){
		var menu = $(this).closest('form');
		var idx = menu.css(BOG);
		
		$(".host_menu_panel form").each(function(){
			if( $(this).css(BOG) == (idx-1) ){
				$(this).css(BOG, idx);
				return;
			}
		});
		menu.css( BOG, (idx-1).toString() );
	});
	
	//�޴��� ���� - ���� �ٲٱ�(�Ʒ���)
	$(document).on('click', '.menu_lower', function(){
		var menu = $(this).closest('form');
		var idx = menu.css(BOG);
		var last_bog = $(".host_menu_panel form").length;
		
		$(".host_menu_panel form").each(function(){
			if($(this).css(BOG) == (idx*1+1) ){
				$(this).css(BOG, idx);
				return;
			}
		});
		if( idx < last_bog )
			menu.css( BOG, (idx*1+1).toString() );	
	});
	
	//�մ� �̾߱� ��ȸ - overflowed text toggle
	$(".review_message").click(function(){
		$(this).closest(".host_review_comment").toggleClass("limitedHeight");
	});
	//�մ� �̾߱� ��ȸ - ���� Ȯ��� ����
	$(".review_photo_take").click(function(){
		var photos = $(this).closest(".host_review_photo");
		var idx = $(this).index();
		
		photos.find(".review_photo_take").each(function(){
			var src = $(this).css('background-image');
		    src = src.replace('url(','').replace(')','');
		
			var div = "<div style='background-image: url("+src+")'></div>";

			if( $(this).index() == idx )
				$(".photo_slide_select").append(div);
			$(".photo_slides").append(div);
		});
	
		$(".dialog_review_photo").css("display", "flex");
	});
	//�մ� �̾߱� ��ȸ - ���� Ȯ��â �ݱ�
	$(".photo_slide_close").click(function(){
		$(".photo_slide_select").empty();
		$(".photo_slides").empty();
		$(".dialog_review_photo").hide();
	});
	//�մ� �̾߱� ��ȸ - Ȯ���� ���� ����
	$(document).on("click", ".photo_slides img", function(){
		var src = $(this).css('background-image');
	    src = src.replace('url(','').replace(')','');
		$(".photo_slide_select div").css("background-image", 'url('+src+')');
	});
	//�մ� �̾߱� ��ȸ - ���� ���� ����
	$(".review_photo_more").click(function(){
		togglePhotoMore($(this));
		$(this).siblings(".review_photo_take:not(:eq(0))").each(function(){
			$(this).toggle();
		});
	});
	
	//�̺�Ʈ ���� - ��¥ ����
	$(".host_event_duration input[type='date']").change(function(e){
		value = e.target.value;
		parameter = e.target.className;
		
		if(value != null && value != ""){
			$(this).prev("span").text(value);
			var idx = $(this).closest(".layout_host_event").find("input[name='idx']").val();
			$.ajax({
				url: 'proc_event.jsp',
				type: 'POST',
				data: { event_duration_idx : idx, parameter : parameter, date : value },
				contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
				dataType: 'html'
			})	
		}else{
			alert("��¥�� ������ �� �����ϴ�.");
			$(this).val($(this).prev().text());
			return;
		}
	});
	//�̺�Ʈ ���� - ����ġ
	$(document).on("click", ".event_floating_border", function(){
		var idx = $(this).closest(".layout_host_event").find("input[name='idx']").val();
		var checkbox = $(this).siblings(".isFloating");
		checkbox.trigger("click");
		
		$.ajax({
			url: 'proc_event.jsp',
			type: 'POST',
			data: { event_floating_idx : idx },
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			dataType: 'html'
		})
	});

	//�̺�Ʈ ���� - ���� ������ �̵�
	$(document).on("click", ".host_event_content", function(e){
		var code = $("input[name='url']").val();
		var idx = $(this).siblings("input[name='idx']").val();
		
		location.href="host_event_textEditor.jsp?p="+code+"&idx="+idx;
	});
	
	//�̺�Ʈ ���� - �̺�Ʈ ���� ������ ��� ���ö� �ʱ�ȭ, �̸����� ��ư Ȱ��ȭ
	$(".event_background input[name='background_img']").each(function(){
		var prev_background = $("input[name='event_background']").val();
		if( $(this).val() == prev_background ){
			$(this).prop("checked", true);
			setEnabledButton($(".host_event_preview"));
			return;
		}
	});
	$(document).on("click", ".event_background input", function(){
		setEnabledButton($(".host_event_preview"));
	});
	
	//�̺�Ʈ ���� - ���� ����, ���, �̸�����
	$(document).on("click", ".host_event_save", function(){
		var idx = getParameters("idx");
		var url = getParameters("p");
		var message = $(".ql-editor").html();
		var background_img = $(".event_background input:checked").val();
		
		if($(".ql-editor").text().search("<") != -1 || $(".ql-editor").text().search(">") != -1 ){
			alert("���뿡 ���Ե� �� ���� Ư�����ڰ� �ֽ��ϴ�.(>, <)");
			return;
		}
		
		if(idx != null){//�̺�Ʈ ���� ����
			$.ajax({
				url: 'proc_event.jsp',
				type: 'POST',
				data: { event_message_idx : idx, message : message, background_img : background_img },
				contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
				dataType: 'html',
				success: function(){
					alert("������ �Ϸ�Ǿ����ϴ�.");
					window.history.back();
				}	
			})
		}else{//�̺�Ʈ ���� �߰�
			if($(".ql-editor").text().trim() == ""){
				alert("������ �Է����ּ���.");
				$(".ql-editor").trigger("click");
				return;
			}else if($("input[name='background_img']:checked").val() == null){
				alert("����� �������ּ���.");
				return;
			}else if( $("input[name='date_start']").val() == "" || $("input[name='date_end']").val() == "" ){
				alert("��¥�� �Է����ּ���.");
				return;
			}
			$.ajax({
				url: 'proc_event.jsp',
				type: 'POST',
				data: { event_message_url : url, background_img : $("input[name='background_img']:checked").val(),
					message : $(".ql-editor").html(), date_start : $("input[name='date_start']").val(), date_end : $("input[name='date_end']").val() },
				success: function(){
					alert("������ �Ϸ�Ǿ����ϴ�.");
					window.history.back();
				}	
				
			})
		}
	});
	$(document).on("click", ".host_event_cancel", function(){
		window.history.back();
	});
	$(document).on("click", ".host_event_preview", function(){
		var message = $(".ql-editor").html();
		var background_img = $("input[name='background_img']:checked").val();
		$(".dialog_event").css("background-image", "url('../images/sample_img/"+background_img+"')");
		$(".dialog_event span").html(message);
		$(".dialog_background").show();
		$(".dialog_event").css("display", "flex");
		
		$(".dialog_background").click(function(){
			$(this).hide();
			$(".dialog_event").hide();
		});
	});

	
	//�̺�Ʈ ���� - ����
	$(document).on("click", ".host_event_delete img", function(){
		if( !confirm("�̺�Ʈ�� �����Ͻðڽ��ϱ�?") )
			return;
		var layout = $(this).closest(".layout_host_event");
		var idx = layout.find("input[name='idx']").val();
		
		$.ajax({
			url: 'proc_event.jsp',
			type: 'POST',
			data: {del_event_idx : idx},
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			dataType: 'html',
			success: function(){
				layout.remove();
			}
		})
	
	});
	
	//�������� ���� - ����
	$(document).on("click", ".host_discount_save", function(e){
		e.preventDefault();
		if($("input[name='date']").val() == ""){
			alert("��¥�� �Է����ּ���.");	
			$("input[name='date']").focus();
			return;
		}else if($("input[name='time_start']").val() == ""){
			alert("���۽ð��� �Է����ּ���.");
			$("input[name='time_start']").focus();
			return;
		}else if($("input[name='time_end']").val() == ""){
			alert("����ð��� �Է����ּ���.");
			$("ipnut[name='time_end']").focus();
			return;
		}else if($("input[name='menu']").val() == ""){
			alert("���θ޴��� �Է����ּ���.");
			$("input[name='menu']").focus();
			return;
		}else if( $("input[name='dc_rate']").val() <= 0 || $("input[name='dc_rate']").val() > 100 ){
			alert("�������� �˸°� �Է����ּ���(1~100% ����).");
			$("input[name='dc_rate']").focus();
			return;
		}
		
		var form = $(".form_discount");
		var params = form.serialize();
		$.ajax({
			url: 'proc_discount.jsp',
			type: 'POST',
			data: params,
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			dataType: 'html',
			success: function(){
				alert("������ �Ϸ�Ǿ����ϴ�.");
				location.reload();
			}
		})
	});
	
	//�������� ���� - ����
	$(document).on("click", ".host_discount_delete", function(e){
		e.preventDefault();
		if(!confirm("������ ��� �����Ͻðڽ��ϱ�?"))
			return;
		
		var idx = $("input[name='idx']").val();
		
		if( idx != 0 ){
			$.ajax({
				url: 'proc_discount.jsp',
				type: 'POST',
				data: {del_sale_idx : idx},
				contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
				dataType: 'html',
				success: function(){
					location.reload();
				}		
			})
		}else{
			location.reload();
		}
		
	});
		
	//�������� ���� - ���θ޴� ���ڼ� ����
	var max_length_discount_menu = 20;
	$(document).on("focus", "input[name='menu']", function(){
		setTextLength($(this), $(this).next("span"), max_length_discount_menu);
	});
	$(document).on("blur", "input[name='menu']", function(){
		$(this).next("span").text("");
	});
	$(document).on("keyup", "input[name='menu']", function(e){
		var txt = $(this).val();
		if( txt.length > max_length_discount_menu ){
			var discount_menu = txt.substr(0, max_length_discount_menu);
			$(this).val(discount_menu);
			return;
		}else{
			setTextLength($(this), $(this).next("span"), max_length_discount_menu);
		}
	});
	//�������� ���� - ���κ�� ���ڼ� ����
	var max_length_discount_etc = 100;
	$(document).on("focus", "textarea[name='etc']", function(){
		setTextLength($(this), $(this).next("span"), max_length_discount_etc);
	});
	$(document).on("blur", "textarea[name='etc']", function(){
		$(this).next("span").text("");
	});
	$(document).on("keyup", "textarea[name='etc']", function(e){
		var txt = $(this).val();
		if( txt.length > max_length_discount_etc ){
			var discount_etc = txt.substr(0, max_length_discount_etc);
			$(this).val(discount_etc);
			return;
		}else{
			setTextLength($(this), $(this).next("span"), max_length_discount_etc);
		}
	});
	
	//�˻��� ����  - Ű���� �߰� & ���ڼ� ����
	$(document).on("keyup", ".keyword_input input", function(e){
		var url = getParameters("p");
		
		if(e.keyCode == 13){
			var keyword = $(this).val();
			$.ajax({
				url: 'proc_keyword.jsp',
				type: 'POST',
				data: { p : url, insert_keyword : keyword },
				success: function(){
					$(".keyword_input input").val("");
					$(".keyword_list").append("<div>"+keyword+"</div>");
					$(".keyword_input span").text("");
				}
			})
		}else{
			setTextLength($(this), $(this).next("span"), 10);
		}
	});
	$(document).on("focus", ".keyword_input input", function(){
		setTextLength($(this), $(this).next("span"), 10);
	});
	$(document).on("blur", ".keyword_input input", function(){
		$(this).next("span").text("");
	});
	
	//�˻��� ���� - Ű���� ����
	$(document).on("click", ".keyword_list div", function(){
		var url = getParameters("p");
		var keyword = $(this);  
		$.ajax({
			url: 'proc_keyword.jsp',
			type: 'POST',
			data: { p : url, delete_keyword_idx : keyword.attr('id') },
			success: function(){
				keyword.remove();
			}
		})
	});
	
	setHistoryInit();
	
	//�븮���� ��� - �ʱ� ����
	function setHistoryInit(date, append){
		var history_date = date;
		
		if ( date == null )	
			history_date = new Date();
		
		if ( append != null )
			history_date.setMonth(history_date.getMonth()+append);
		
		var history_year = history_date.getFullYear();
		var history_month = history_date.getMonth()+1;
		
		$(".call_history_year").text(history_year);
		$(".call_history_month").text(history_month);
		getHistoryMonthly(history_year, history_month);
	}

	//�븮���� ��� - �޺� ȣ���� ��ȸ
	function getHistoryMonthly(year, month){
		var url = getParameters("p");
		$.ajax({
			url: 'proc_call.jsp',
			type: 'POST',
			data: { call_url: url, year: year, month: month},
			success: function(data){
				$(".result_data").remove();
				$(".result_history").append(data);
			}
		})
	}
	
	//�븮���� ��� - ������ �̵�
	$(document).on("click", ".call_month_prev", function(){
		var year = $(".call_history_year").text();
		var month = ($(".call_history_month").text()).toString();
		if(month.length < 2) month = "0"+month;
		
		setHistoryInit(new Date(year+"-"+month), -1);
	});
	
	//�븮���� ��� - ������ �̵�
	$(document).on("click", ".call_month_next", function(){
		var year = $(".call_history_year").text();
		var month = ($(".call_history_month").text()).toString();
		if(month.length < 2) month = "0"+month;
		
		setHistoryInit(new Date(year+"-"+month), 1);
	});
	
	//�븮���� ��� - �� ȣ��ð� ���� 
	$(document).on("click", ".result_data", function(){
		$(this).siblings(".result_data_detail").toggle();
	});
	$(document).on("click", ".result_data_detail", function(){
		$(this).siblings(".result_data").click();
	});
	
	
	//�մ� �̾߱� ��ȸ - ���� ���� ���� ��ư ��� 
	function togglePhotoMore(img){
		var src = img.attr("src");
		if(src.indexOf("+") != -1)
			img.attr("src", "../images/icon_common/-.png");
		else
			img.attr("src", "../images/icon_common/+.png");
	}
	
	//��й�ȣ ���� - üũ
	$(document).on("click", ".host_password_update button", function(){
		var pass1 = $("input:first").val();
		var pass2 = $("input:last").val();
		
		if( pass1 == "" || pass2 == ""){
			alert("��й�ȣ�� �Է����ּ���.");
			return;
		}else if( pass1 != pass2 ){
			alert("��й�ȣ�� ��ġ���� �ʽ��ϴ�.");
			return;
		}
		
		$("form").submit();
	});
	//����â ����
	function float_share_dialog(title, layout){
		var url;
		if(layout != null){
			url = layout.find("input[name='url']").val();
			$(".dialog_share input[name='dialog_url'").val(url);
		}
		
		$(".dialog_title").text(title);
		$(".dialog_share").show();
		$(".dialog_background").show();
		
		$(".dialog_close").click(function(){
			close_share_dialog(layout);
		});
		$(".dialog_background").click(function(){
			close_share_dialog(layout);
		});
	}
	//����â �ݱ�
	function close_share_dialog(layout){
		$(".dialog_share").hide();
		$(".dialog_background").hide();
		if(layout != null)
			layout.css('background-color', '#fff');
	}
	//���õ� ������ ���̶���Ʈ & ����â ���� ȣ��
	function set_selected_layout(layout){
		var shop_name = layout.find(".shop_name").text();
		layout.css('background-color', 'rgba(69, 167, 55, 0.5)');	
		float_share_dialog(shop_name, layout);
	}
	//�����ϱ� - ���ڸ޽��� 
	function share_sms(title, url){
		location.href="sms:?body="+title+" "+url;	
	} 
	//�����ϱ� - ���̽���
	function share_facebook(url, image, title){
		$("meta[name='og:image']").attr('content', image);
		$("meta[name='og:title']").attr('content', title);
		location.href="https://www.facebook.com/sharer/sharer.php?u="+url;
	}
	//�����ϱ� - īī����(�ǵ�)
	function share_kakao_feed(title, description, imageUrl, webUrl){
		Kakao.Link.sendDefault({	
			objectType: 'feed',
			content: {
				title: title,
				description: description,
				imageUrl: imageUrl,
				link: {
					mobileWebUrl: webUrl,
					webUrl: webUrl
				}
			},
			buttons: [{
				title: '������ ����',
				link: {
					mobileWebUrl: webUrl,
					webUrl: webUrl
				}
			}]
		});
	}
	//�����ϱ� - īī����(��ġ)
	function share_kakao_location(address, title, description, imageUrl, webUrl){
		Kakao.Link.sendDefault({
	        objectType: 'location',
	        address: address,
	        content: {
	          title: title,
	          description: description,
	          imageUrl: imageUrl,
	          link: {
	            mobileWebUrl: webUrl,
	            webUrl: webUrl
	          }
	        },
	        buttons: [
	          {
	            title: '������ ����',
	            link: {
	              mobileWebUrl: webUrl,
	              webUrl: webUrl
	            }
	          }
	        ]
	      });
	}
});

function resize_title(){//���Ҹ� ���� ũ�� ����
	var length = $(".nav_title").text().length;
	
	if(length>10 && length<17){ $(".nav_title").css("font-size", "1.5rem"); }
	else if(length>16){ $(".nav_title").css("font-size", "1.1rem"); }
}

function callShop(tel){//��ȭ �ɱ�(���ڸ޴���, ���༭��)
	if(tel == null || tel.length == 0){
		alert("��ȭ��ȣ ������ �������� �ʽ��ϴ�.");
	}else{
		location.href='tel:'+tel;
	}
}

function initFranchInforLabel(shop_type, shop_name, menu_size){//���ڸ޴���(��������)������  �� �ʱ⼳��
	if( shop_type == 3 || shop_type == 5 || (shop_type == 4 && menu_size == 0) ){
		$(".label").hide();
		$(".nav_title").text(shop_name);
	}
	
	var m = getParameters('m');

	if(m == null)//�������� ��_����׵θ� �ٲٱ� 
		$(".label:eq(0)").css("border-top-color", "#AAA");
	else if(m == 0)
		$(".label:eq(1)").css("border-top-color", "#AAA");
	else if(m == 1)
		$(".label:eq(2)").css("border-top-color", "#AAA");
}

function initIconDcRate(dcRate){
	var dcRate_idx = dcRate / 5;
	$("#extra_dc_rate img:eq("+dcRate_idx+")").css("display", "block");
}
function initIconIsParking(isParking){
	$("#extra_is_parking img:eq("+isParking+")").css("display", "block");
}
function initIconIsSeats(isSeats){
	$("#extra_is_seats img:eq("+isSeats+")").css("display", "block");	
}



function initReviewLayout(){
	$(".layout_host_review").each(function(){
		var phone = $(this).find("input[name='phone']").val();
		if(phone != null && phone.trim() != "" && phone != "null"){
			var href_tel = "<a href='tel:"+phone+"'><img src='../images/icon_common/icon_sms.png'></a>";
			$(this).find(".review_infor_contact").append(href_tel);
		}
		var photo_size = $(this).find("input[name='photo_size']").val();
		if(photo_size == 0){
			$(this).find(".host_review_photo").hide();
		} else if(photo_size > 1){
			$(this).find(".review_photo_take").each(function(){
				$(this).css("left", $(this).index()*30+"vmin");
				if($(this).index() != 0)
					$(this).hide();
			});
			
			$(this).find(".review_photo_more").show();	
		}
	});
}
function setEnabledButton(button){//��ư Ȱ��ȭ
	button.removeClass("button_disabled");
	button.prop("disabled", false);
}

function setTextLength(input, span, maxlength){//���ڼ� ǥ��
	var txt = input.val();
	var TPM = txt.length+"/"+maxlength;
	span.text(TPM);
}


function readURL(input, img) {//���� ���ε�� �̹��� �̸�����
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            img.attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
    }
}

function getParameters(paramName) {//GET ��� URL �Ķ���� ��������
    // ���ϰ��� ���� ���� ����
    var returnValue;

    // ���� URL ��������
    var url = location.href;

    // get �Ķ���� ���� ������ �� �ִ� ? �� �������� slice �� �� split ���� ����
    var parameters = (url.slice(url.indexOf('?') + 1, url.length)).split('&');

    // �������� ���� �񱳸� ���� paramName ���� ��û�� �������� ���� return
    for (var i = 0; i < parameters.length; i++) {
        var varName = parameters[i].split('=')[0];
        if (varName.toUpperCase() == paramName.toUpperCase()) {
            returnValue = parameters[i].split('=')[1];
            return decodeURIComponent(returnValue);
        }
    }
};

var form_host_new_menu = '<form class="form_host_new_menu" enctype="multipart/form-data" style="-webkit-box-ordinal-group: -1">'
	+'<div class="layout_host_menu">'
	+'	<div class="host_menu_settings">'
	+'		<span class="menu_name_brief"></span>'	
	+'		<span class="menu_detail"><img src="../images/icon_common/icon_menu_detail.png"></span>'
	+'		<span class="menu_brief"><img src="../images/icon_common/icon_menu_brief.png"></span>'
	+'		<span class="menu_upper"><img src="../images/icon_common/icon_arrow_upper.png" alt="�޴� ����"></span>'
	+'		<span class="menu_lower"><img src="../images/icon_common/icon_arrow_lower.png" alt="�޴� �Ʒ���"></span>'
	+'		<span class="menu_delete"><img src="../images/icon_common/icon_menu_delete.png" alt="�޴� ����"></span>'
	+'	</div>'
	+'	<div class="host_menu_details">'
	+'	<div class="host_menu_left" align="center">'	
	+'		<img src="../images/menu/noimage.jpg" class="host_menu_photo">'
	+'		<input type="file" name="menu_photo" accept="image/*">'
	+'	</div>'
	+'	<div class="host_menu_right">'
	+'		<div class="host_menu_type">'
	+'			<select name="menu_type">'
	+'				<option value="0">��ü�޴�</option>'
	+'				<option value="1">����Ư��</option>'
	+'			</select>'
	+'		</div>'
	+'		<div class="host_menu_name">'
	+'			<input type="text" name="menu_name" placeholder="�޴� �̸�" maxlength=10>'
	+'			<span></span>'
	+'		</div>'
	+'		<div class="host_menu_price">'
	+'			<input type="number" name="price" placeholder="����">'
	+'			<button class="toggle_price">��/��/�� ��ȯ</button>'
	+'		</div>'
	+'		<div class="host_menu_price" style="display: none;">'
	+'			<input type="number" name="price_s" placeholder="��">'
	+'			<input type="number" name="price_m" placeholder="��">'
	+'			<input type="number" name="price_l" placeholder="��">'
	+'			<button class="toggle_price">���ϰ��� ��ȯ</button>'
	+'		</div>'
	+'		<div class="host_menu_info">'
	+'			<textarea name="menu_infor" placeholder="�޴� ����" maxlength="60"></textarea>'
	+'			<span></span>'
	+'		</div>'
	+'	</div></div>'
	+'</div></form>';