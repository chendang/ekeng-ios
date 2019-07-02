function addShoppingCart(productId, productName, productPrice, rewardPoint, productImage, num) {
	var isSave = false;
	var goods = plus.storage.getItem("goods");  //取回goods变量
	goods = JSON.parse(goods); //把字符串转换成JSON对象
	if(goods != null && goods != "undefined") { //如果不为空，则判断购物车中是否包含了当前购买的商品
		var objs = goods.good;
		for(var i = 0; i < objs.length; i++) {
			isSave = false;
			if(objs[i].productId == productId) { //说明该商品已在购物车，则数量加1
				objs[i].productQuentity += num;
				isSave = true;
				break;
			}
		}
		if(!isSave) {
			objs[objs.length] = {
				productId: productId,
				productName: productName,
				productPrice: productPrice,
				rewardPoint: rewardPoint,
				productImage: productImage,
				productQuentity: num
			};
		}
	} else {
		var goods = {
			good: [{
				productId: productId,
				productName: productName,
				productPrice: productPrice,
				rewardPoint: rewardPoint,
				productImage: productImage,
				productQuentity: num
			}]
		} //要存储的JSON对象
	}
	goods = JSON.stringify(goods); //将JSON对象转化成字符串
	plus.storage.setItem("goods", goods);//用localStorage保存转化好的的字符串

}

function delGoodFromCart(productId) {

	var goods = plus.storage.getItem("goods");//取回goods变量

	goods = JSON.parse(goods); //把字符串转换成JSON对象

	if(goods != null && goods != "undefined") { //如果不为空，则判断购物车中是否包含了当前购买的商品

		var objs = goods.good;

		for(var i = 0; i < objs.length; i++) {

			if(objs[i].productId == productId) { //说明该商品已在购物车

				objs.splice(i, 1); //删除元素

				goods = JSON.stringify(goods); //将JSON对象转化成字符串

				plus.storage.setItem("goods", goods); //用localStorage保存转化好的的字符串

				return;

			}

		}

	}

}

function GoodsCarDecNum(productId) {

	var goods = plus.storage.getItem("goods"); //取回goods变量

	goods = JSON.parse(goods); //把字符串转换成JSON对象
	if(goods != null && goods != "undefined") {
		var objs = goods.good;
		for(var i = 0; i < objs.length; i++) {

			if(objs[i].productId == productId) {

				objs[i].productQuentity = parseInt(objs[i].productQuentity) - 1;

				if(objs[i].productQuentity <= 0) {

					objs.splice(i, 1); //删除此商品

				}

				goods = JSON.stringify(goods); //将JSON对象转化成字符串

				plus.storage.setItem("goods", goods);//用localStorage保存转化好的的字符串

				break;

			}

		}
	}

};



function addShoppingOrder(productId, productName, productPrice, rewardPoint, productImage, num) {
	var isSave = false;
	var OrderSubmit = plus.storage.getItem("OrderSubmit"); //取回goods变量
	OrderSubmit = JSON.parse(OrderSubmit); //把字符串转换成JSON对象
	if(OrderSubmit != null && OrderSubmit != "undefined") { //如果不为空，则判断购物车中是否包含了当前购买的商品
		var objs = OrderSubmit.order;
		for(var i = 0; i < objs.length; i++) {
			isSave = false;
			if(objs[i].productId == productId) { //说明该商品已在购物车，则数量加1
				objs[i].productQuentity += num;
				isSave = true;
				break;
			}
		}
		if(!isSave) {
			objs[objs.length] = {
				productId: productId,
				productName: productName,
				productPrice: productPrice,
				rewardPoint: rewardPoint,
				productImage: productImage,
				productQuentity: num
			};
		}
	} else {
		var OrderSubmit = {
			order: [{
				productId: productId,
				productName: productName,
				productPrice: productPrice,
				rewardPoint: rewardPoint,
				productImage: productImage,
				productQuentity: num
			}]
		} //要存储的JSON对象
	}
	OrderSubmit = JSON.stringify(OrderSubmit); //将JSON对象转化成字符串
	plus.storage.setItem("OrderSubmit", OrderSubmit); //用localStorage保存转化好的的字符串

}


function ClearShoppingOrder() {

       plus.storage.removeItem("OrderSubmit");//清空变量


}

function CalcGoodsNum() {
    var num=0;
	var goods = plus.storage.getItem("goods"); //取回goods变量

	goods = JSON.parse(goods); //把字符串转换成JSON对象
	if(goods != null && goods != "undefined") {
		var objs = goods.good;
		for(var i = 0; i < objs.length; i++) {



				num = num+parseInt(objs[i].productQuentity);



		}
	}
	
	return num;

};