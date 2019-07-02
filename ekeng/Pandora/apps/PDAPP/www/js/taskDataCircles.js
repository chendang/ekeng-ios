var colors = [
		['#C6C6C6', '#ffae00'],
		['#C6C6C6', '#7dc855'],
		['#C6C6C6', '#5a7bef'],
		['#C6C6C6', '#bf00d6'],
		['#C6C6C6', '#F4BCBF'],
		['#C6C6C6', '#D43A43'],
		['#C6C6C6', '#A6A600'],
		['#C6C6C6', '#F9F900'],
		['#C6C6C6', '#73BF00']
	],
	circles = [];

function getColor(iType) {
	var colorVal = "";
	switch(iType) {
		case 'Sport':
			colorVal = colors[0];
			break;
		case 'Food':
			colorVal = colors[1];
			break;
		case 'Med':
			colorVal = colors[2];
			break;
		case 'Feel':
			colorVal = colors[3];
			break;
		case 'Edu':
			colorVal = colors[4];
			break;
		case 'Home':
			colorVal = colors[5];
			break;
		case 'Monitor':
			colorVal = colors[6];
			break;
		case 'Question':
			colorVal = colors[7];
			break;
		
	}
	return colorVal;
}



function getCircleMaxValue(iType) {
	var maxVal = 0;
	switch(iType) {
		case 'Sport':
			maxVal = 100;
			break;
		case 'Food':
			maxVal = 100;
			break;
		case 'Feel':
			maxVal = 100;
			break;
		case 'Med':
			maxVal = 100;
			break;
		case 'Edu':
			maxVal = 100;
			break;
		case 'Home':
			maxVal = 100;
			break;
		case 'Monitor':
			maxVal = 100;
			break;
		case 'Question':
			maxVal = 100;
			break;
		
	}

	return maxVal;

}

function getCircle(childx, valx, colorx, maxVal) {
	circles.push(Circles.create({
		id: childx.id,
		value: valx,
		text:function(value){return value + '%';},
		radius: 30,
		width: 2,
		maxValue: maxVal,
		colors: colorx
	}));
}





