﻿(function(w){

function plusReady(){

	checkLogin();
}
if(w.plus){
	plusReady();
}else{
	document.addEventListener('plusready',plusReady,false);
}

function checkLogin(){
	var objuser=JSON.parse(plus.storage.getItem('user'));
	if(objuser==undefined || objuser==null || objuser==''){
		plus.nativeUI.toast("请登陆");
		var _self=plus.webview.currentWebview();
		_self.close();
		var _LoginView=plus.webview.getWebviewById("login.html");
        if(_ViewPage==null){
        	_LoginView=plus.webview.create("../login.html","login.html",{},{});
        }
        _LoginView.show("slide-in-right",50);
		return false;
	}
}

})(window);





function HeadShow(){
var _self = plus.webview.currentWebview();
var headview = _self.getNavigationbar();
var bitmap_menu = new plus.nativeObj.Bitmap("menu");
bitmap_menu.loadBase64Data("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABoAAAAXCAYAAAAV1F8QAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA4ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTMyIDc5LjE1OTI4NCwgMjAxNi8wNC8xOS0xMzoxMzo0MCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo1YjhhYTEyNC05ZTEwLTVkNDAtODY4ZC00N2JkODQwNzY1YTQiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6OURGRUI4RjU5QzBCMTFFNkJCNTQ4RUM4NzMxMTU3MTciIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6OURGRUI4RjQ5QzBCMTFFNkJCNTQ4RUM4NzMxMTU3MTciIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTUuNSAoV2luZG93cykiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDpmYjNlZmEyYS03MTc0LWE0NDctOWQxZC03YmFiZTU0Y2IyNTAiIHN0UmVmOmRvY3VtZW50SUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDpjY2EwMDkyNS05YTgzLTExZTYtODQ2Ny05YjllZGQ0ZjY4ZWIiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz7TRpHzAAAA9UlEQVR42mL4//8/A5HYFIj3A7EoCXrgmFiF1kD84T8EXAZiMVItYmIgDByBeCcQ80P54kAswUAqIOASdyD++h8BngOxFrWDzgeIfyBZ8gSI1cmxBJ9FQUD8E8mSB0CsRK4luCyKAOLfSJbcBWJ5SizBZlEcEP9BsuQGEEtTagm6RalA/BfJElAyFqeGJcgWZQPxPyRLzgGxCLUsgVnU8Z8OAJRhXRnoAEAW7aaHRbji6Dy5hSc5qe4qEEvQwiK65SO6lgx0LevoWnrTtT6CYUcg/oJk2Ssg1qNFVb4fiN2B+COU/xKIX1C7KkdvBe0jNyMDBBgAgpspmLqGqdUAAAAASUVORK5CYII=");
headview.drawBitmap(bitmap_menu, {},{
    top: "12px",
    left: "10px",
    width: "20px",
    height: "16px"
});		
	
headview.interceptTouchEvent(true);
headview.addEventListener("click", function(e) {
    CloseCurrentView();
});	

}



function clicked(url,id,type,headtitle) {
        var nwaiting = plus.nativeUI.showWaiting();
        var _ViewPage=plus.webview.getWebviewById(id);
        if(_ViewPage==null){
        	_ViewPage=plus.webview.create(url,id,{'navigationbar':{'backgroundColor':'#E92F2F','titleText':headtitle,'titleColor':'#EFFFFF'}},{});
        }
        _ViewPage.addEventListener("loaded", function() { //注册新webview的载入完成事件
         nwaiting.close(); //新webview的载入完毕后关闭等待框
        _ViewPage.show(type,150); //把新webview窗体显示出来，显示动画效果为速度150毫秒的右侧移入动画
        }, false);

}

function clickedParm(url,id,type,parm,headtitle) {
        var nwaiting = plus.nativeUI.showWaiting();
        var _ViewPage=plus.webview.getWebviewById(id);
        if(_ViewPage==null){
        	_ViewPage=plus.webview.create(url,id,{'navigationbar':{'backgroundColor':'#E92F2F','titleText':headtitle,'titleColor':'#EFFFFF'}},parm);
        }
        
        _ViewPage.addEventListener("loaded", function() { //注册新webview的载入完成事件
         nwaiting.close(); //新webview的载入完毕后关闭等待框
        _ViewPage.show(type,150); //把新webview窗体显示出来，显示动画效果为速度150毫秒的右侧移入动画
        }, false);

}

function clickedParmBlue(url,id,type,parm,headtitle) {
        var nwaiting = plus.nativeUI.showWaiting();
        var _ViewPage=plus.webview.getWebviewById(id);
        if(_ViewPage==null){
        	_ViewPage=plus.webview.create(url,id,{'navigationbar':{'backgroundColor':'#33A3D4','titleText':headtitle,'titleColor':'#EFFFFF'}},parm);
        }
        
        _ViewPage.addEventListener("loaded", function() { //注册新webview的载入完成事件
         nwaiting.close(); //新webview的载入完毕后关闭等待框
        _ViewPage.show(type,150); //把新webview窗体显示出来，显示动画效果为速度150毫秒的右侧移入动画
        }, false);

}

function clickedNoHead(url,id,type) {
        var nwaiting = plus.nativeUI.showWaiting();
        var _ViewPage=plus.webview.getWebviewById(id);
        if(_ViewPage==null){
        	_ViewPage=plus.webview.create(url,id,{},{});
        }
        _ViewPage.addEventListener("loaded", function() { //注册新webview的载入完成事件
         nwaiting.close(); //新webview的载入完毕后关闭等待框
        _ViewPage.show(type,150); //把新webview窗体显示出来，显示动画效果为速度150毫秒的右侧移入动画
        }, false);

}

function clickedNoHeadParm(url,id,type,parm) {
        var nwaiting = plus.nativeUI.showWaiting();
        var _ViewPage=plus.webview.getWebviewById(id);
        if(_ViewPage==null){
        	_ViewPage=plus.webview.create(url,id,{},parm);
        }
        
        _ViewPage.addEventListener("loaded", function() { //注册新webview的载入完成事件
         nwaiting.close(); //新webview的载入完毕后关闭等待框
        _ViewPage.show(type,150); //把新webview窗体显示出来，显示动画效果为速度150毫秒的右侧移入动画
        }, false);

}

 function GoToAnxious(tourl,num,headtxt){
  	      var parm = {"testNum" : num}
          clickedParm(tourl,tourl,'slide-in-right',parm,headtxt);
  }

 function GoToFamily(tourl,tourl,code){
  	      var parm = {"rolecode" : code}
          clickedNoHeadParm(tourl,tourl,'slide-in-right',parm);
  }

 function GoTopicParm(tourl,tourl,type,code){
  	      var parm = {"TopicId" : code}
          clickedNoHeadParm(tourl,tourl,type,parm);
  }
 


function back(){
	plus.key.addEventListener("backbutton",function(){
		plus.webview.currentWebview().close();

	});
}

function CloseCurrentView(){
	plus.webview.currentWebview().close();
		
}

function dblBackQuit(){
		var first = null;
       plus.key.addEventListener('backbutton', function(){
        //首次按键，提示‘再按一次退出应用’
        if(!first){
            first = new Date().getTime();
		    plus.nativeUI.toast("再按一次退出应用");
            setTimeout(function(){
                first = null;
            },1000);
        }else{
            if(new Date().getTime()-first<1000){
                plus.runtime.quit();
            }
        }
    }, false);
}

