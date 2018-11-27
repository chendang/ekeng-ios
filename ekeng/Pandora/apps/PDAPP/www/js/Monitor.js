/**
 * Created by liu on 2017-08-29.
 */
(function () {
    Date.prototype.format || (Date.prototype.format = function(format) {
        var o = {
            "M+": this.getMonth() + 1, //month
            "d+": this.getDate(), //day
            "h+": this.getHours(), //hour
            "m+": this.getMinutes(), //minute
            "s+": this.getSeconds(), //second
            "q+": Math.floor((this.getMonth() + 3) / 3), //quarter
            "S": this.getMilliseconds() //millisecond
        };
        if (/(y+)/.test(format)) {
            format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        }
        for (var k in o) {
            if (new RegExp("(" + k + ")").test(format)) {
                format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
            }
        }
        return format;
    });
    var __sysTime = null;
    var _currentMonth = 0;//当前显示的月份
    var _currentYear = 0;//当前显示的年份
    var _global_data = null;//请求回来的当前月份的数据
    var util = {
        setGlobalData:function (data) {
            _global_data = data;
        },
        getGlobalData:function () {
            return _global_data;
        },
        setCurrentMonth:function (currentMonth) {
            _currentMonth = currentMonth;
        },
        getCurrentMonth:function () {
            return _currentMonth;
        },
        setCurrentYear:function (currentYear) {
            _currentYear = currentYear;
        },
        getCurrentYear:function () {
            return _currentYear;
        },
        setSysTime: function (systime) {
            if (systime) {
                __sysTime = systime;
            }
        },
        getSysTime: function () {
            return __sysTime;
        },
        /**
         * 字符串转为日期，只接受日期格式：2015-10-11 10:20:30 或者 2015/10/11 10:20:30
         * @param str
         */
        string2Date: function (str) {
            str = str.replace(/-/g, "/");
            return new Date(str);
        },
        formatDate:function (str) {
            return new Date(str).format("MM/dd");
        },
        confirm: function (strMsg, fnYes, fnNo) {
            var flag = window.confirm(strMsg);
            if (flag) {
                fnYes && fnYes();
            } else {
                fnNo && fnNo();
            }
        },
        now: function () {
            return +new Date();
        },
        Cjuery: function() {
            this.callbackBegin = function () {

            }
            this.callbackEnd = function () {

            };
            
            this.getData = function (url,data, ops) {
                var $def = $.Deferred();
                var _self = this;
                ops = ops || {};
                var isCallback = ops.isCallback || true;
                isCallback && _self.callbackBegin();
                hui.loading('数据加载中');    

                $.ajax($.extend({
                    type: "get",
                    url: url,
                    data:data
                }, ops)).then(function (data) {
                    isCallback && _self.callbackEnd();
                    hui.closeLoading();
                    $def.resolve(data)
                }, function (XMLHttpRequest, textStatus, errorThrown) {
                    isCallback && _self.callbackEnd();
                    hui.closeLoading();
                    $def.reject(data);
                });
                return $def.promise();
            };
            this.request = function (url,data,opt) {
                return this.getData(url,data || {}, opt||{});
            }
        },
        formatData:function (data) {
            var newData = data.map(function (item){
                var formatDate = util.string2Date(item.date);
                var newDate = new Date(formatDate);//dateYear
                var dateYear = newDate.format("yyyy");
                var dateMonth = newDate.format("MM");
                var dateDay = newDate.format("dd");
                var originalDate = newDate.getFullYear()+"-"+newDate.getMonth()+"-"+newDate.getDate();
                item.dateYear = dateYear;
                item.dateMonth = dateMonth;
                item.dateDay = dateDay;
                item.originalDate = originalDate;
                item.originalMonth = newDate.getMonth();
                item.originalDay = newDate.getDate();
                return item;
            });
            return newData;
        },
        recordHTML:function (data) {
            var recordLiTemplate ="";
            data.forEach(function (item) {
                recordLiTemplate += '<li class="item-content">'+
                    '<div class="item-inner">'+
                    '<div class="item-title">'+
                    '<h3>'+item.dateDay+'</h3>'+
                    '<p>'+item.dateMonth+'月</p>'+
                    '</div>'+
                    '<div class="item-after">'+
                    '<h3>'+item.content+'</h3>'+
                    '<p>'+item.dotime+'</p>'+
                    '</div>'+
                    '</div>'+
                    '</li>';
            });
            return recordLiTemplate;
        },
        dateshow:function (item) {
            var itemDom = $("[data-date='"+item.originalDate+"']");

            itemDom.html("<span>"+item.originalDay+"</span><em>"+item.title+"</em>");
            if(item.type == 1){
                itemDom.append("<i style='background:"+item.color+"'></i>");
            }else{
                itemDom.addClass("picker-calendar-day-type"+item.type);
            }

        }
    };
    window.util = $.extend(window.util || {}, util);
})();