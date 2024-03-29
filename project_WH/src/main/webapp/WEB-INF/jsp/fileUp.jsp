<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>title</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link href="../resources/css/fileUp.css" rel="stylesheet">
<script type="text/javascript">
$(function(){
	
	var modal1 = document.getElementById("upLoadingModalContainer");
	var modal2 = document.getElementById("finishedModalContainer");
	
	$("#upLoadingModalContainer").bind({
		   ajaxStart: function() { $(this).modal('show'); },
		   ajaxStop: function() { $(this).modal('hide'); }
	}); 
	
	
	$("#submitBtn").click(function(){
		
		var formData = new FormData();
		var inputFile = $("input[name='upFile']");
		var files = inputFile[0].files;
		//console.log(files);
		
		for(var i =0; i<files.length; i++){
			
			formData.append("upFile", files[i]);
		}
		
		//txt인지 체크
		
		//업로드중 모달 on
		
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
	        	modal1.classList.toggle("show"); // show modal here
	        	//$('#upLoadingModalContainer').show();
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
</script>
</head>
<body>
	<div class="fileUpLoad">
		<input type="file" id="upFile" name="upFile">
		<button type="button" id="submitBtn">업로드</button>
	</div>

	<div id="upLoadingModalContainer" class="modal">
		<div id="upLoadingModal" class="modalContent">
			<p>모달 창 1입니다.</p>
		</div>
	</div>
	<div id="finishedModalContainer" class="modal">
		<div id="finishedModal" class="modalContent">
			<p>모달 창2 입니다.</p>
		</div>
	</div>

</body>
</html>