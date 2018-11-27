
$(function(){

    var swiper = new Swiper('.swiper-container', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        slidesPerView: 1,
        autoplay: 3000,
        autoplayDisableOnInteraction: false,
        loop: true
    });
    $(".shangjia").click(function(){
        layer.msg('正在为您准备客服',{
            time:2000,
            area:['50%','75px']
        })
    });
    $(".join").click(function(){
        layer.open({
            type: 1,
            title:false,
            closeBtn: 1, //显示关闭按钮
            shift: 2,
            scrollbar: false,
            shadeClose: false, //开启遮罩关闭
            content: $("#affirm_join"),
            area: ['100%','287px'],
            offset: 'rb'
        });
        $(".affirm_jieshao").css("width",parseInt($(".affirm_up").width())-parseInt($(".img_box").width())+"px");
    });
    $("#affirm_join .affirm_ok").click(function(){
        layer.closeAll('page');
        layer.msg('订单提交成功',{
            time:1000
        });
       
    });
    $(".buy").click(function(){
        layer.open({
            type: 1,
            title:false,
            closeBtn: 1, //显示关闭按钮
            shift: 2,
            scrollbar: false,
            shadeClose: false, //开启遮罩关闭
            content: $("#affirm_buy"),
            area: ['100%','287px'],
            offset: 'rb'
        });
        $("#affirm_buy .affirm_jieshao").css("width",parseInt($("#affirm_buy .affirm_up").width())-parseInt($("#affirm_buy .img_box").width())+"px");
    });
    $("#affirm_buy .affirm_ok").click(function(){
        layer.closeAll('page');
        layer.msg('添加购物车成功',{
            time:1000
        });
        
    });
    $(".norms a").click(function(){
        $(".norms a").removeClass("active");
        $(this).addClass("active");
    });
    //**************************************************button
   
});
