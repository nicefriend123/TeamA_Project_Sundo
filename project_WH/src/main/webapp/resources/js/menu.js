/*!
    * Start Bootstrap - SB Admin v7.0.7 (https://startbootstrap.com/template/sb-admin)
    * Copyright 2013-2023 Start Bootstrap
    * Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-sb-admin/blob/master/LICENSE)
    */
    // 
// Scripts
// 

$(function(){
	
	//var modal1 = document.getElementById("upLoadingModalContainer");
	//var modal1 = document.querySelector("upLoadingModalContainer");
	//var modal2 = document.getElementById("finishedModalContainer");
/*	
	$("#upLoadingModalContainer").bind({
		   ajaxStart: function() { $(this).modal('show'); },
		   ajaxStop: function() { $(this).modal('hide'); }
	}); */
	
	
	$("#submitBtn").click(function(){
		
		var formData = new FormData();
		var inputFile = $("input[name='upFile']");
		var files = inputFile[0].files;
		//console.log(files);
		
		for(var i =0; i<files.length; i++){
			
			formData.append("upFile", files[i]);
		}
		
		//txt인지 체크
		
		//업로드
 		$.ajax({
			url : "fileUp.do",
			type : "post",
			async: true,
			accept : "multipart/form-data",
			enctype : "multipart/form-data",
			processData : false,
			contentType : false,
			dataType : "text",
			data : formData,
	        beforeSend: function(){
	        	//modal1.classList.toggle("show"); // show modal here
	        	//$('#upLoadingModalContainer').show();
	        	showToast();
	        },
			success : function(result){
				alert("일단 통과");
				//업로드중 모달 off
				//modal1.classList.toggle("hide");
				//$('#upLoadingModalContainer').modal('hide');
	
			},
			error : function(){
				alert("꽝");
            	$('#upLoadingModalContainer').hide();
			}
		}).done(function(data) {
            $('#upLoadingModalContainer').hide();
           
            modal2.classList.toggle("show");
            setTimeout(function () {
            	$('#finishedModalContainer').hide();
            }, 3000);
           

        }) 
		
	});
	

	
})