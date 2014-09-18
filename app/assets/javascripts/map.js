(function($){
  var map = $(".world-map"),
    leftBtn = $("a.arrow-left"),
    rightBtn = $("a.arrow-right"),
    citys = map.find("a"),
    stepLength = 150,
    totalDiff = -600,
    pos = 0,

    messageDetail = $(".message-detail"),
    closeBtn = messageDetail.find(".close-btn"),
    messageTitle = messageDetail.find("h3"),
    messageList = messageDetail.find("dl");

  leftBtn.on('click', function(){
    pos = pos + stepLength ;
    if(pos > 0){
      pos = 0;
      leftBtn.addClass("hide");
      return;
    }
    
    rightBtn.removeClass("hide");
    map.css({'margin-left': pos});
  });

  rightBtn.on('click', function(){
    pos = pos - stepLength;
    if(pos < totalDiff){
      pos = totalDiff;
      rightBtn.addClass("hide");
      return;
    }
    
    leftBtn.removeClass("hide");
    map.css({'margin-left': pos});
  });

  closeBtn.on('click', function(e){
    e.preventDefault();

    messageDetail.addClass("hide");
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
          console.log(data);
          showQuestions(data);
        }
      });
      
    });
  });

  function showQuestions(opt){
    messageDetail.removeClass("hide");
    messageTitle.text(opt.title);
    messageList.empty();
    messageList.prepend(opt.q_html);


  }
})(Zepto);