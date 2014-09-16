(function($){
    var map = $(".world-map"),
        leftBtn = $("a.arrow-left"),
        rightBtn = $("a.arrow-right"),
        stepLength = 150,
        totalDiff = -600,
        pos = 0;

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
})(Zepto);