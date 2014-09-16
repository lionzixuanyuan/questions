(function($){
    var cityContainer = $(".city-container");

    cityContainer.each(function(){
        var el = $(this),
            leftBtn = el.find("a.arrow-left"),
            rightBtn = el.find("a.arrow-right"),
            cityList = el.find("ul.city-list"),
            citysCount = cityList.find("li").length,
            stepLength = cityList.parent().width(),
            pos = 0;

        cityList.css({width: citysCount * stepLength});

        leftBtn.on('click', function(){
            pos ++ ;
            if(pos > 0){
                pos = 0;
                leftBtn.addClass("hide");
                return;
            }
            
            rightBtn.removeClass("hide");
            cityList.css({'margin-left': pos * stepLength});
        });

        rightBtn.on('click', function(){
            pos -- ;
            if(pos < (citysCount-1)*-1){
                pos = (citysCount-1)*-1;
                rightBtn.addClass("hide");
                return;
            }
            
            leftBtn.removeClass("hide");
            cityList.css({'margin-left': pos * stepLength});
        });
    });
})(Zepto);