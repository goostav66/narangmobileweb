<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<html>
<head>
<title>��㹮��</title>

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
��㹮��</div>
<div class='board-container'><!-- skin : theme/online_qna -->
<section id="bo_w">
    <h2 class="sound_only">��㹮�� �۾���</h2>

    <!-- �Խù� �ۼ�/���� ���� { -->
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
            <label for="wr_name" class="sound_only">�̸�<strong>�ʼ�</strong></label>
        <input type="text" name="wr_name" value="" id="wr_name" required class="frm_input required" placeholder="�̸�">
    
            <label for="wr_password" class="sound_only">��й�ȣ<strong>�ʼ�</strong></label>
        <input type="password" name="wr_password" id="wr_password" required class="frm_input required" placeholder="��й�ȣ">
    
                <label for="wr_email" class="sound_only">�̸���</label>
            <input type="text" name="wr_email" value="" id="wr_email" class="frm_input email " placeholder="�̸���">
        </div>

        <div class="write_div">
        <label for="wr_homepage" class="sound_only">Ȩ������</label>
        <input type="text" name="wr_homepage" value="" id="wr_homepage" class="frm_input full_input" size="50" placeholder="Ȩ������">
    </div>
    
        <div class="write_div">
        <span class="sound_only">�ɼ�</span>
        
<input type="checkbox" id="html" name="html" onclick="html_auto_br(this);" value="" >
<label for="html">HTML</label>    </div>
    
	
    <div class="bo_w_tit write_div">
        <label for="wr_subject" class="sound_only">����<strong>�ʼ�</strong></label>
        
        <div id="autosave_wrapper write_div">
            <input type="text" name="wr_subject" value="" id="wr_subject" required class="frm_input full_input required" size="50" maxlength="255" placeholder="����">
                    </div>
        
    </div>

    <div class="write_div">
        <label for="wr_content" class="sound_only">����<strong>�ʼ�</strong></label>
        <div class="wr_content ">
                        <span class="sound_only">�������� ����</span>
<textarea id="wr_content" name="wr_content" class="" maxlength="65536" style="width:100%;height:300px"></textarea>
<span class="sound_only">�� ������ ��</span>                    </div>
        
    </div>

        <div class="bo_w_link write_div">
        <label for="wr_link1"><i class="fa fa-link" aria-hidden="true"></i><span class="sound_only"> ��ũ  #1</span></label>
        <input type="text" name="wr_link1" value="" id="wr_link1" class="frm_input full_input" size="50">
    </div>
        <div class="bo_w_link write_div">
        <label for="wr_link2"><i class="fa fa-link" aria-hidden="true"></i><span class="sound_only"> ��ũ  #2</span></label>
        <input type="text" name="wr_link2" value="" id="wr_link2" class="frm_input full_input" size="50">
    </div>
    
    

        <div class="write_div">
        
<script>var g5_captcha_url  = "http://bplan.kr/plugin/kcaptcha";</script>
<script src="http://bplan.kr/plugin/kcaptcha/kcaptcha.js"></script>
<fieldset id="captcha" class="captcha">
<legend><label for="captcha_key">�ڵ���Ϲ���</label></legend>
<img src="http://bplan.kr/plugin/kcaptcha/img/dot.gif" alt="" id="captcha_img"><input type="text" name="captcha_key" id="captcha_key" required class="captcha_box required" size="6" maxlength="6">
<button type="button" id="captcha_mp3"><span></span>�����������</button>
<button type="button" id="captcha_reload"><span></span>���ΰ�ħ</button>
<span id="captcha_info">�ڵ���Ϲ��� ���ڸ� ������� �Է��ϼ���.</span>
</fieldset>    </div>
    

    <div class="btn_confirm write_div">
        <a href="./board.php?bo_table=notice" class="btn_cancel btn">���</a>
        <input type="submit" value="�ۼ��Ϸ�" id="btn_submit" accesskey="s" class="btn_submit btn">
    </div>
    </form>

    <script>
        function html_auto_br(obj)
    {
        if (obj.checked) {
            result = confirm("�ڵ� �ٹٲ��� �Ͻðڽ��ϱ�?\n\n�ڵ� �ٹٲ��� �Խù� ������ �ٹٲ� ����<br>�±׷� ��ȯ�ϴ� ����Դϴ�.");
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
if (!wr_content_editor.value) { alert("������ �Է��� �ֽʽÿ�."); wr_content_editor.focus(); return false; }

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
            alert("���� �����ܾ�('"+subject+"')�� ���ԵǾ��ֽ��ϴ�");
            f.wr_subject.focus();
            return false;
        }

        if (content) {
            alert("���뿡 �����ܾ�('"+content+"')�� ���ԵǾ��ֽ��ϴ�");
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
                    alert("������ "+char_min+"���� �̻� ���ž� �մϴ�.");
                    return false;
                }
                else if (char_max > 0 && char_max < cnt) {
                    alert("������ "+char_max+"���� ���Ϸ� ���ž� �մϴ�.");
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
<!-- } �Խù� �ۼ�/���� �� -->
</div>

<!-- ie6,7���� ���̵�䰡 �Խ��� ��Ͽ��� �Ʒ� ���̵�信 �������� ���� ���� -->
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
