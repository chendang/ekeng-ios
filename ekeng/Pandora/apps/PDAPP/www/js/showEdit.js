$(function() {
	"use strict";

	$('#content').artEditor({
		imgTar: '#imageUpload',
		limitSize: 5,   // 兆
		showServer: true,
		uploadUrl: 'http://healthapi.kzjk360.com/FileUpload/ArtEditPicUpload',
		data: {},
		uploadField: 'fileInput',
		placeholader: '<p>请输入文章正文内容(5-200个字符)</p>',
		validHtml: ["<br/>"],
		formInputId: 'target',
		uploadSuccess: function(res) {
			return res;
 
			
			
		},
		uploadError: function(res) {
			return res;
		}
	
	});
});

