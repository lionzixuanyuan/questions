(function($){
  var map = $(".world-map"),
    // leftBtn = $("a.arrow-left"),
    // rightBtn = $("a.arrow-right"),
    citys = map.find("a"),
    stepLength = 150,
    totalDiff = -600,
    pos = 0,

    wrapper = $(".wrapper"),
    messageDetail = $(".message-detail"),
    closeBtn = messageDetail.find(".close-btn"),
    messageTitle = messageDetail.find("h3"),
    messageList = messageDetail.find("dl");

  // leftBtn.on('click', function(){
  //   pos = pos + stepLength ;
  //   if(pos > 0){
  //     pos = 0;
  //     leftBtn.addClass("hide");
  //     return;
  //   }
    
  //   rightBtn.removeClass("hide");
  //   map.css({'margin-left': pos});
  // });

  // rightBtn.on('click', function(){
  //   pos = pos - stepLength;
  //   if(pos < totalDiff){
  //     pos = totalDiff;
  //     rightBtn.addClass("hide");
  //     return;
  //   }
    
  //   leftBtn.removeClass("hide");
  //   map.css({'margin-left': pos});
  // });

  closeBtn.on('click', function(e){
    e.preventDefault();

    messageDetail.addClass("hide");
    wrapper.removeClass("hide");
  });

  // 点击展示城市问题
  citys.each(function(index){
    var city = $(this);

    city.on('click', function(e){
      e.preventDefault();

      $.ajax({
        type: "POST",
        url: "/questions/city_messages",
        data: {
          city: city.text().replace(/\(\d*\)/,""),
          authenticity_token: authToken()
        },
        success: function(data){
          showQuestions(data);
        }
      });
      
    });
  });

  messageList.on('click', '.q-title', function(e){
    e.preventDefault();
    var el = $(this).parent();
    el.toggleClass("open");
    el.next().toggleClass("hide");
  });

  messageList.on('click', 'a.reply', function(e){
    e.preventDefault();
    var el = $(this).parent().parent();
    el.toggleClass("open");
    el.next().toggleClass("hide");
  });

  messageList.on('click',"a.vote", function(e){
    e.preventDefault();
    var el = $(this),
      span = el.find("span"),
      question_id = el.attr("q-id");

    if(el.hasClass("disabled")){
      return false;
    }

    // ajax 设置点赞次数
    $.ajax({
      type: "POST",
      url: "/questions/click_awesome",
      data: {
        question_id: question_id,
        authenticity_token: authToken()
      },
      success: function(data){
        span.text(parseInt(span.text(),10)+1);
      }
    });

    el.addClass("disabled");
  });

  messageList.on('click','button.answer', function(e){
    e.preventDefault();
    var el = $(this),
      question_id = el.attr("q-id"),
      ul_block = $("#ul_"+question_id),
      answer_text_area = $("#answer_"+question_id);
      answer_text = answer_text_area.val();

    console.log("question_id: "+question_id+"    answer_text:"+answer_text);
    if ($.trim(answer_text) != "") {
      // ajax 提交问题
      $.ajax({
        type: "POST",
        url: "/questions/answer_question",
        data: {
          question_id: question_id,
          answer_text: answer_text,
          authenticity_token: authToken()
        },
        success: function(data){
          // 成功后渲染页面
          ul_block.append("<li>"+answer_text+"</li>");
          answer_text_area.val("");
        }
      });
    };

    return false;
  });

  function showQuestions(opt){
    wrapper.addClass("hide");
    messageDetail.removeClass("hide");
    messageTitle.text(opt.title);
    messageList.empty();
    messageList.prepend(opt.q_html);


    // if(window.orientation==180||window.orientation==0){
    //   // alert("请旋转屏幕，横屏查看，谢谢！");
    //   // return;
    //   setTimeout(function(){
    //     window.scrollTo(window.screen.width,window.screen.height*0.55);
    //   },100);
    // }

  }
})(Zepto);