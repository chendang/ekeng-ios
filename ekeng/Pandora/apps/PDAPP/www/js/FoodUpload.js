  var filechooser = document.getElementById("choose");
  //    用于压缩图片的canvas
//var canvas = document.createElement("canvas");
//var ctx = canvas.getContext('2d');
  //    瓦片canvas
//var tCanvas = document.createElement("canvas");
//var tctx = tCanvas.getContext("2d");
  var maxsize = 100 * 1024;
  $("#upload").on("click", function() {
        filechooser.click();
      })
      .on("touchstart", function() {
        $(this).addClass("touch")
      })
      .on("touchend", function() {
        $(this).removeClass("touch")
      });
//FileReader 不支持ios8.1以上版本
//filechooser.onchange = function() {
//  if (!this.files.length) return;
//  var files = Array.prototype.slice.call(this.files);
//  if (files.length > 9) {
//    alert("最多同时只可上传9张图片");
//    return;
//  }
//  files.forEach(function(file, i) {
//    if (!/\/(?:jpeg|png|gif)/i.test(file.type)) return;
//    var reader = new FileReader();
//    var li = document.createElement("li");
////          获取图片大小
//    var size = file.size / 1024 > 1024 ? (~~(10 * file.size / 1024 / 1024)) / 10 + "MB" : ~~(file.size / 1024) + "KB";
//    li.innerHTML = '<div class="progress"><span></span></div><div class="size">' + size + '</div>';
//    $(".img-list").append($(li));
//    
//    reader.onload = function() {
//      var result = this.result;
//      var img = new Image();
//      img.src = result;
//      var data = compress(img);
//      $(li).css("background-image", "url(" + result + ")");
//      //如果图片大小小于100kb，则直接上传
//      if (result.length <= maxsize) {
//        img = null;
//        //upload(result, file.type, $(li));
//        
//        upload(data, file.type, $(li));
//        return;
//      }
////      图片加载完毕之后进行压缩，然后上传
//      if (img.complete) {
//        callback();
//      } else {
//        img.onload = callback;
//      }
//      function callback() {
//        
//        upload(data, file.type, $(li));
//        img = null;
//      }
//    };
//    reader.readAsDataURL(file);
//  })
//};



  filechooser.onchange = function() {
    if (!this.files.length) return;
    var files = Array.prototype.slice.call(this.files);
    if (files.length > 9) {
      hui.toast("最多同时只可上传9张图片");
      return;
    }
    files.forEach(function(file, i) {
      if (!/\/(?:jpeg|png|gif)/i.test(file.type)) {
      	hui.toast("不支持此图片类型");
      	return;
      }

      var li = document.createElement("li");
//          获取图片大小
      var size = file.size / 1024 > 1024 ? (~~(10 * file.size / 1024 / 1024)) / 10 + "MB" : ~~(file.size / 1024) + "KB";
      li.innerHTML = '<div class="progress"><span></span></div><div class="size">' + size + '</div>';
      $(".img-list").append($(li));
      
      
      getBase64(file,$(li));
      
      
      
    })
  };

  
  
  function getBase64(fileObj,$li){
            var file = fileObj;


                
            if(file){
                var url = window.URL.createObjectURL(file);//PS:不兼容IE
                var img = new Image();
                img.src = url;
                var base64="";
                var sendData="";
                $li.css("background-image", "url(" + url + ")");
                if (file.size>1024*1024){
                	img.onload = function(){
                	base64=compress(img);
                	sendData=base64.replace("data:"+file.type+";base64,",'');
                  upload(sendData, file.type, $li);
                 }
                }
                else{
                img.onload = function(){
                	  var cvs = document.createElement("canvas");
                    var ctx = cvs.getContext('2d');
                    ctx.clearRect(0,0,cvs.width,cvs.height);
                    cvs.width = img.width;
                    cvs.height = img.height;
                    ctx.drawImage(img,0,0,img.width,img.height);
                    base64 = cvs.toDataURL(file.type);
                    sendData=base64.replace("data:"+file.type+";base64,",'');
                    upload(sendData, file.type, $li);

                 }
                }
                
                
                
            }
        }
  
  //    使用canvas对大图片进行压缩
  function compress1(img) {
    var initSize = img.src.length;
    //如果图片大于四百万像素，计算压缩比并将大小压至400万以下

    var w = img.width,  
    h = img.height,  
    scale = w / h;  
    w = 480 || w; //480  你想压缩到多大，改这里  
    h = w / scale;
    
    var canvas = document.createElement('canvas');  
    var ctx = canvas.getContext('2d');  
   $(canvas).attr({  
    width: w,  
    height: h  
    });
    
    ctx.drawImage(img, 0, 0, w, h);  
    var base64 = canvas.toDataURL('image/jpeg', 1 || 1); //1最清晰，越低越模糊。
    return base64;
  }
  
    function compress(img) {
    var initSize = img.src.length;
    var width = img.width;
    var height = img.height;
    //如果图片大于四百万像素，计算压缩比并将大小压至400万以下
    var ratio;
    if ((ratio = width * height / 4000000) > 1) {
      ratio = Math.sqrt(ratio);
      width /= ratio;
      height /= ratio;
    } else {
      ratio = 1;
    }
    
   
    
      //    用于压缩图片的canvas
  var canvas = document.createElement("canvas");
  var ctx = canvas.getContext('2d');
  //    瓦片canvas
  var tCanvas = document.createElement("canvas");
  var tctx = tCanvas.getContext("2d");
    
    canvas.width = width;
    canvas.height = height;
//        铺底色
    ctx.fillStyle = "#fff";
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    //如果图片像素大于100万则使用瓦片绘制
    var count;
    if ((count = width * height / 1000000) > 1) {
      count = ~~(Math.sqrt(count) + 1); //计算要分成多少块瓦片
//            计算每块瓦片的宽和高
      var nw = ~~(width / count);
      var nh = ~~(height / count);
      tCanvas.width = nw;
      tCanvas.height = nh;
      for (var i = 0; i < count; i++) {
        for (var j = 0; j < count; j++) {
          tctx.drawImage(img, i * nw * ratio, j * nh * ratio, nw * ratio, nh * ratio, 0, 0, nw, nh);
          ctx.drawImage(tCanvas, i * nw, j * nh, nw, nh);
        }
      }
    } else {
      ctx.drawImage(img, 0, 0, width, height);
    }
    //进行最小压缩
    var ndata = canvas.toDataURL('image/jpeg', 0.1);
    console.log('压缩前：' + initSize);
    console.log('压缩后：' + ndata.length);
    console.log('压缩率：' + ~~(100 * (initSize - ndata.length) / initSize) + "%");
    tCanvas.width = tCanvas.height = canvas.width = canvas.height = 0;
    return ndata;
  }
  
  
  
  
  

  

  
  
  /**
   * 获取blob对象的兼容性写法
   * @param buffer
   * @param format
   * @returns {*}
   */
  function getBlob(buffer, format) {
    try {
      return new Blob(buffer, {type: format});
    } catch (e) {
      var bb = new (window.BlobBuilder || window.WebKitBlobBuilder || window.MSBlobBuilder);
      buffer.forEach(function(buf) {
        bb.append(buf);
      });
      return bb.getBlob(format);
    }
  }
  /**
   * 获取formdata
   */
  function getFormData() {
    var isNeedShim = ~navigator.userAgent.indexOf('Android')
        && ~navigator.vendor.indexOf('Google')
        && !~navigator.userAgent.indexOf('Chrome')
        && navigator.userAgent.match(/AppleWebKit\/(\d+)/).pop() <= 534;
    return isNeedShim ? new FormDataShim() : new FormData()
  }
  /**
   * formdata 补丁, 给不支持formdata上传blob的android机打补丁
   * @constructor
   */
  function FormDataShim() {
    console.warn('using formdata shim');
    var o = this,
        parts = [],
        boundary = Array(21).join('-') + (+new Date() * (1e16 * Math.random())).toString(36),
        oldSend = XMLHttpRequest.prototype.send;
    this.append = function(name, value, filename) {
      parts.push('--' + boundary + '\r\nContent-Disposition: form-data; name="' + name + '"');
      if (value instanceof Blob) {
        parts.push('; filename="' + (filename || 'blob') + '"\r\nContent-Type: ' + value.type + '\r\n\r\n');
        parts.push(value);
      }
      else {
        parts.push('\r\n\r\n' + value);
      }
      parts.push('\r\n');
    };
    // Override XHR send()
    XMLHttpRequest.prototype.send = function(val) {
      var fr,
          data,
          oXHR = this;
      if (val === o) {
        // Append the final boundary string
        parts.push('--' + boundary + '--\r\n');
        // Create the blob
        data = getBlob(parts);
        // Set up and read the blob into an array to be sent
        fr = new FileReader();
        fr.onload = function() {
          oldSend.call(oXHR, fr.result);
        };
        fr.onerror = function(err) {
          throw err;
        };
        fr.readAsArrayBuffer(data);
        // Set the multipart content type and boudary
        this.setRequestHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
        XMLHttpRequest.prototype.send = oldSend;
      }
      else {
        oldSend.call(this, val);
      }
    };
  }