//判断2
$("#form1").on("submit", function (){

  if($.trim($("#name").val())==""){
    alert('请填写提问人姓名');
    $("#name").focus();
    return false;
  }

  if($.trim($("#address").val())==""){
    alert('请填写提问人收信地址');
    $("#address").focus();
    return false;
  }

  if($.trim($("#university").val())==""){
    alert('请填写大学');
    $("#university").focus();
    return false;
  }

  if($.trim($("#email").val())==""){
    alert('请填写邮箱');
    $("#email").focus();
    return false;
  }else if(!checkemail($("#email").val())){
    alert('邮件地址有误,请重新填写');  
    $("#email").focus();
    return false;
  }
  
  if($.trim($("#mobile").val())==""){
    alert('请填写提问人手机号');
    $("#mobile").focus();
    return false;
  }else if(!checkMobile($("#mobile").val())){
    alert('手机号有误,请重新填写');
    $("#mobile").focus();
    return false;   
  }

  if($.trim($("#vcode").val())==""){
    alert('请填写验证码');
    $("#vcode").focus();
    return false;
  }

  var vcode_flag;

  $.ajax({
    type: "POST",
    url: "/questions/examine_valid_num",
    async: false,
    data: {
      phone: $("#mobile").val(),
      valid_num: $("#vcode").val(),
      authenticity_token: authToken()
    },
    success: function(data){
      if (data.state == "error") {
        vcode_flag = false;
      }else{
        vcode_flag = true;
      };
    }
  });

  if (!vcode_flag) {
    alert("验证码不正确");
    $("#vcode").focus();
    return false;
  };

  if($.trim($("#question").val())==""){
    alert('请填写提问内容');
    $("#question").focus();
    return false;
  }
  
});

function main(){
  var sendVcodeBtn = $('#send-vcode'),
    cdTime = 60,
    cdTimer;

  sendVcodeBtn.on('click', function(){
    if($("#mobile").val()==""){
      alert('请填写提问人手机号');
      $("#mobile").focus();
      return false;
    }else if(!checkMobile($("#mobile").val())){
      alert('手机号有误,请重新填写');
      $("#mobile").focus();
      return false;   
    }

    $.ajax({
      type: "POST",
      url: "/questions/send_valid_sms",
      data: {
        phone: $("#mobile").val(),
        authenticity_token: authToken()
      },
      success: function(data){
        if (data.state == "success") {
          alert("验证码发送成功！");
        } else{
          alert("验证码发送失败，请稍后再试！");
        };
      }
    });

    // alert("验证码[123456]已发送！");

    sendVcodeBtn.attr("disabled", true);

    cdTimer = setTimeout(cd,1000);
  });

  function cd(){
    if(cdTime > 0){
      cdTime --;
      cdTimer = setTimeout(cd, 1000);
      sendVcodeBtn.val(cdTime+'秒后重发');
    }else{
      clearTimeout(cdTimer);
      cdTime = 60;
      sendVcodeBtn.val("发送验证码").removeAttr("disabled");
    }
  }
}
main();


function checkMobile(str){
  if(!(/^1[3|5|8]\d{9}$/.test(str))){
    return false;
  }
  return true;
}

// 功能函数
function checkemail(email){
  var myreg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
  if(email!=""){
    if(!myreg.test(email)){
      return false;
    }
  }
  return true;
}