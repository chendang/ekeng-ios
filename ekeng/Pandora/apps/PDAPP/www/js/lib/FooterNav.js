function _view(){
	this._view_obj = null;this._img_up_lst  = null;
	this._txt_lst  = null;this._img_dn_lst  = null;
	this._vTab_now = null;
	this.setTabInfo = function(view,_a,_b,_c){
		this._view_obj=view;
		var _h = window.innerHeight - 60;
		this._view_obj.setStyle({width:'100%',height:'60px',left:'0px',top:_h+'px'});
		this._view_obj.drawRect('#FFFFFF');
		this._view_obj.drawRect('#EEEEEE',{width:'100%',height:'1px'});
		this._view_obj.show();
		this._img_up_lst = _a;
		this._img_dn_lst = _b;
		this._txt_lst	= _c;
		var _w = window.innerWidth / _a.length;
		var _l = ( _w - 30 ) / 2;
		for(var i=1;i<_a.length;i++){
			this._view_obj.drawBitmap(_a[i],{},{height:'30px',width:'30px',top:'8px',left:_l+_w*i+'px'})
			this._view_obj.drawText(_c[i],{height:'15px',width:'30px',top:'40px',left:_l+_w*i+'px'},{color:'#7E848B',size:'12px'})
		}
			this._view_obj.drawBitmap(_b[0],{},{height:'30px',width:'30px',top:'8px',left:_l+'px'})
			this._view_obj.drawText(_c[0],{height:'15px',width:'30px',top:'40px',left:_l+'px'},{color:'#467AED',size:'12px'})
		this._vTab_now = 0;
	}
	this.setCB = function(CB){
		this._view_obj.addEventListener('click',function(e){
			var _Tab = switchTab(e.clientX);
			if(_Tab == _fbar._vTab_now){return;}
			var _w = window.innerWidth / _fbar._txt_lst.length;
			var _l = ( _w - 30 ) / 2;
			//down
			//_fbar._view_obj.drawRect('#FFFFFF',{height:'30px',width:'30px',top:'8px',left:_l+_w*_Tab+'px'})
			_fbar._view_obj.drawBitmap(_fbar._img_dn_lst[_Tab],{},{height:'30px',width:'30px',top:'8px',left:_l+_w*_Tab+'px'})
			_fbar._view_obj.drawText(_fbar._txt_lst[_Tab],{height:'15px',width:'30px',top:'40px',left:_l+_w*_Tab+'px'},{color:'#467AED',size:'12px'})
			//up
			_fbar._view_obj.drawBitmap(_fbar._img_up_lst[_fbar._vTab_now],{},{height:'30px',width:'30px',top:'8px',left:_l+_w*_fbar._vTab_now+'px'})
			_fbar._view_obj.drawRect('#FFFFFF',{height:'30px',width:'30px',top:'8px',left:_l+_w*_fbar._vTab_now+'px'})
			_fbar._view_obj.drawBitmap(_fbar._img_up_lst[_fbar._vTab_now],{},{height:'30px',width:'30px',top:'8px',left:_l+_w*_fbar._vTab_now+'px'})
			_fbar._view_obj.drawText(_fbar._txt_lst[_fbar._vTab_now],{height:'15px',width:'30px',top:'40px',left:_l+_w*_fbar._vTab_now+'px'},{color:'#7E848B',size:'12px'})
			_fbar._vTab_now = _Tab
			_w=null;_l=null;
			CB(_Tab);
		})
	}
}
function switchTab(x){
	_w = window.innerWidth / _fbar._txt_lst.length ;
	var _t = Math.ceil( x / _w)-1;
	_w = null;
	return _t;
}
var _fbar = new _view();
