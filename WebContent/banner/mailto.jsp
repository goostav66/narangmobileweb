<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<html>
<head>
<title>상담문의</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="mobile-web-app-capable" content="yes">
<link rel="stylesheet" href="http://bplan.kr/theme/basic/css/default.css?ver=171222">
<link rel="stylesheet" href="http://bplan.kr/theme/basic/skin/board/online_qna/style.css?ver=171222">
<script>
var g5_url       = "http://bplan.kr";
var g5_bbs_url   = "http://bplan.kr/bbs";
var g5_is_member = "";
var g5_is_admin  = "";
var g5_is_mobile = "";
var g5_bo_table  = "notice";
var g5_sca       = "";
var g5_editor    = "";
var g5_cookie_domain = "";
</script>
<script src="http://bplan.kr/js/jquery-1.8.3.min.js"></script>
<script src="http://bplan.kr/js/jquery.menu.js?ver=171222"></script>
<script src="http://bplan.kr/js/common.js?ver=171222"></script>
<script src="http://bplan.kr/js/wrest.js?ver=171222"></script>
<script src="http://bplan.kr/js/placeholders.min.js"></script>
<link rel="stylesheet" href="http://bplan.kr/js/font-awesome/css/font-awesome.min.css">
</head>
<body>

<style>
.board-title{
	font-size:20px;
	font-weight:bold;
	padding:15px 0;
	text-align:center;
}

.board-container{
	padding:15px;
}
</style>

<div class='board-title'>
상담문의</div>
<div class='board-container'><!-- skin : theme/online_qna -->
<section id="bo_w">
    <h2 class="sound_only">상담문의 글쓰기</h2>

    <!-- 게시물 작성/수정 시작 { -->
    <form name="fwrite" id="fwrite" action="http://bplan.kr/bbs/write_update.php" onsubmit="return fwrite_submit(this);" method="post" enctype="multipart/form-data" autocomplete="off" style="width:100%">
    <input type="hidden" name="uid" value="2018091317375001">
    <input type="hidden" name="w" value="">
    <input type="hidden" name="bo_table" value="notice">
    <input type="hidden" name="wr_id" value="0">
    <input type="hidden" name="sca" value="">
    <input type="hidden" name="sfl" value="">
    <input type="hidden" name="stx" value="">
    <input type="hidden" name="spt" value="">
    <input type="hidden" name="sst" value="">
    <input type="hidden" name="sod" value="">
    <input type="hidden" name="page" value="">
    
    
    <div class="bo_w_info write_div">
            <label for="wr_name" class="sound_only">이름<strong>필수</strong></label>
        <input type="text" name="wr_name" value="" id="wr_name" required class="frm_input required" placeholder="이름">
    
            <label for="wr_password" class="sound_only">비밀번호<strong>필수</strong></label>
        <input type="password" name="wr_password" id="wr_password" required class="frm_input required" placeholder="비밀번호">
    
                <label for="wr_email" class="sound_only">이메일</label>
            <input type="text" name="wr_email" value="" id="wr_email" class="frm_input email " placeholder="이메일">
        </div>

        <div class="write_div">
        <label for="wr_homepage" class="sound_only">홈페이지</label>
        <input type="text" name="wr_homepage" value="" id="wr_homepage" class="frm_input full_input" size="50" placeholder="홈페이지">
    </div>
    
        <div class="write_div">
        <span class="sound_only">옵션</span>
        
<input type="checkbox" id="html" name="html" onclick="html_auto_br(this);" value="" >
<label for="html">HTML</label>    </div>
    
	
    <div class="bo_w_tit write_div">
        <label for="wr_subject" class="sound_only">제목<strong>필수</strong></label>
        
        <div id="autosave_wrapper write_div">
            <input type="text" name="wr_subject" value="" id="wr_subject" required class="frm_input full_input required" size="50" maxlength="255" placeholder="제목">
                    </div>
        
    </div>

    <div class="write_div">
        <label for="wr_content" class="sound_only">내용<strong>필수</strong></label>
        <div class="wr_content ">
                        <span class="sound_only">웹에디터 시작</span>
<textarea id="wr_content" name="wr_content" class="" maxlength="65536" style="width:100%;height:300px"></textarea>
<span class="sound_only">웹 에디터 끝</span>                    </div>
        
    </div>

        <div class="bo_w_link write_div">
        <label for="wr_link1"><i class="fa fa-link" aria-hidden="true"></i><span class="sound_only"> 링크  #1</span></label>
        <input type="text" name="wr_link1" value="" id="wr_link1" class="frm_input full_input" size="50">
    </div>
        <div class="bo_w_link write_div">
        <label for="wr_link2"><i class="fa fa-link" aria-hidden="true"></i><span class="sound_only"> 링크  #2</span></label>
        <input type="text" name="wr_link2" value="" id="wr_link2" class="frm_input full_input" size="50">
    </div>
    
    

        <div class="write_div">
        
<script>var g5_captcha_url  = "http://bplan.kr/plugin/kcaptcha";</script>
<script src="http://bplan.kr/plugin/kcaptcha/kcaptcha.js"></script>
<fieldset id="captcha" class="captcha">
<legend><label for="captcha_key">자동등록방지</label></legend>
<img src="http://bplan.kr/plugin/kcaptcha/img/dot.gif" alt="" id="captcha_img"><input type="text" name="captcha_key" id="captcha_key" required class="captcha_box required" size="6" maxlength="6">
<button type="button" id="captcha_mp3"><span></span>숫자음성듣기</button>
<button type="button" id="captcha_reload"><span></span>새로고침</button>
<span id="captcha_info">자동등록방지 숫자를 순서대로 입력하세요.</span>
</fieldset>    </div>
    

    <div class="btn_confirm write_div">
        <a href="./board.php?bo_table=notice" class="btn_cancel btn">취소</a>
        <input type="submit" value="작성완료" id="btn_submit" accesskey="s" class="btn_submit btn">
    </div>
    </form>

    <script>
        function html_auto_br(obj)
    {
        if (obj.checked) {
            result = confirm("자동 줄바꿈을 하시겠습니까?\n\n자동 줄바꿈은 게시물 내용중 줄바뀐 곳을<br>태그로 변환하는 기능입니다.");
            if (result)
                obj.value = "html2";
            else
                obj.value = "html1";
        }
        else
            obj.value = "";
    }

    function fwrite_submit(f)
    {
        var wr_content_editor = document.getElementById('wr_content');
if (!wr_content_editor.value) { alert("내용을 입력해 주십시오."); wr_content_editor.focus(); return false; }

        var subject = "";
        var content = "";
        $.ajax({
            url: g5_bbs_url+"/ajax.filter.php",
            type: "POST",
            data: {
                "subject": f.wr_subject.value,
                "content": f.wr_content.value
            },
            dataType: "json",
            async: false,
            cache: false,
            success: function(data, textStatus) {
                subject = data.subject;
                content = data.content;
            }
        });

        if (subject) {
            alert("제목에 금지단어('"+subject+"')가 포함되어있습니다");
            f.wr_subject.focus();
            return false;
        }

        if (content) {
            alert("내용에 금지단어('"+content+"')가 포함되어있습니다");
            if (typeof(ed_wr_content) != "undefined")
                ed_wr_content.returnFalse();
            else
                f.wr_content.focus();
            return false;
        }

        if (document.getElementById("char_count")) {
            if (char_min > 0 || char_max > 0) {
                var cnt = parseInt(check_byte("wr_content", "char_count"));
                if (char_min > 0 && char_min > cnt) {
                    alert("내용은 "+char_min+"글자 이상 쓰셔야 합니다.");
                    return false;
                }
                else if (char_max > 0 && char_max < cnt) {
                    alert("내용은 "+char_max+"글자 이하로 쓰셔야 합니다.");
                    return false;
                }
            }
        }

        if (!chk_captcha()) return false;

        document.getElementById("btn_submit").disabled = "disabled";

        return true;
    }
    </script>
</section>
<!-- } 게시물 작성/수정 끝 -->
</div>

<!-- ie6,7에서 사이드뷰가 게시판 목록에서 아래 사이드뷰에 가려지는 현상 수정 -->
<!--[if lte IE 7]>
<script>
$(function() {
    var $sv_use = $(".sv_use");
    var count = $sv_use.length;

    $sv_use.each(function() {
        $(this).css("z-index", count);
        $(this).css("position", "relative");
        count = count - 1;
    });
});
</script>
<![endif]-->

</body>
</html>
