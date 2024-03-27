<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>title</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/ol3/4.6.5/ol.js" integrity="sha512-O7kHS9ooekX8EveiC94z9xSvD/4xt10Qigl6uEKvspYykdux3Ci5QNu5fwi4ca0ZkZI/oCgx5ja8RklWUEqzxQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ol3/4.6.5/ol-debug.css" integrity="sha512-hBSieZLd5rse9gdkfv4n0pDU4D04SxpqBtwDzRy/QiXRBhczDyfCTDTnHCada73ubNqiQv6BLgCRXHAJPUwC5w==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link href="../resources/css/mapTest.css" rel="stylesheet">
<script type="text/javascript">
	
$(function(){
	
	var wmsSd, wmsSgg, wmsBjd;
    var layerList = [];
		
	var Base = new ol.layer.Tile({
		name : "Base",
		source: new ol.source.XYZ({
			url: 'https://api.vworld.kr/req/wmts/1.0.0/1C6740EE-D23E-3A90-8F40-1D342D80666C/Base/{z}/{y}/{x}.png'
		})
	}); // WMTS API 사용
		
   	var olView = new ol.View({
       	center: ol.proj.transform([127.100616,37.402142], 'EPSG:4326', 'EPSG:3857'), //좌표계 변환
       	zoom: 6     
    });// 뷰 설정
    
    var map = new ol.Map({
       	layers: [Base], //지도에서 사용할 레이어 목록 정의
       	target: 'map',
       	view: olView
    });
	
    $("#sdSelect").on("change", function() {      
    	var sd_CQL = "sd_cd="+$("#sdSelect").val();
       	var test = $("#sdSelect option:checked").text();
       	
       	$.ajax({
        	url : "/maptest.do",
           	type : "post",
           	dataType : "json",
   	        data : {"test" : test},
     	    success : function(result) {
     	    	map.removeLayer(wmsSd);
     	     		
              	var geom = result.at(-1);
              	//console.log(geom);
     	     		
              	map.getView().fit([geom.xmin, geom.ymin, geom.xmax, geom.ymax], {duration : 500});
     	     		
    	        wmsSd = new ol.layer.Tile({
    	  	       	source : new ol.source.TileWMS({
    	  	    		url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
    	  	        	params : {
    	  	          		'VERSION' : '1.1.0', // 2. 버전
    	  	          		'LAYERS' : 'testhere:el_test', // 3. 작업공간:레이어 명
    	  	          		'CQL_FILTER' : sd_CQL,
    	  	          		'STYLES' : 'carbonBase',
    	  	          		'BBOX' : [1.387148932991382E7, 3910407.083927817, 1.46800091844669E7, 4666488.829376992], 
    	  	          		'SRS' : 'EPSG:3857', // SRID
    	  	          		'FORMAT' : 'image/png' // 포맷
    	  	        	},
    	  	        	serverType : 'geoserver',
    	  	    	})
				}); 
    	          
    	  	    map.addLayer(wmsSd);
  	     	
              	$("#sggSelect").empty();
              	var listSgg = "<option>시군구 선택</option>";
              
              	for(var i=0;i<result.length-1;i++){
              		listSgg += "<option value='"+result[i].sgg_cd+"'>"+result[i].sgg_nm+"</option>"
              	}
              
              	$("#sggSelect").append(listSgg);

              		
           	},
           	error : function() {
              	alert("실패");
           	}
        })
     });
    
    
    $("#sggSelect").on("change", function(){
    	//var sdName = $("#sdSelect").val();
    	var sggName = $("#sggSelect option:checked").text();
    	
    	$.ajax({
        	url : "/sggSelect.do",
           	type : "post",
           	dataType : "json",
   	        data : {"sggName" : sggName},
     	    success : function(result) {
              	map.getView().fit([result.xmin, result.ymin, result.xmax, result.ymax], {duration : 500});
           	},
           	error : function() {
              	alert("실패");
           	}
        })
    	
    });
    
    
/*     
    $(".insertbtn").click(function() {

    	map.removeLayer(wmsSd);
        //map.removeLayer(wmsSgg);
        //map.removeLayer(wmsBjd);        
        var sggcode = $("#sggSelect").val();       
        var sgg_CQL = "sgg_cd="+$("#sggSelect").val();
        
    	$.ajax({
       		url : "/sggSelect.do",
	       	type : "post",
    	   	dataType : "json",
	        data : {"sggcd" : sggcode},
 	     	success : function(result) {
 	     		
 	        	wmsBjd = new ol.layer.Tile({
  	          		source : new ol.source.TileWMS({
  	          			url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
  	          			params : {
  	          				'VERSION' : '1.1.0', // 2. 버전
  	          				'LAYERS' : 'testhere:tl_bjd', // 3. 작업공간:레이어 명
  	          				'CQL_FILTER' : sgg_CQL,
  	          				'STYLES' : 'carbon1',
  	          				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
  	       					'SRS' : 'EPSG:3857', // SRID
  	        				'FORMAT' : 'image/png' // 포맷
  	          			},
  	          			serverType : 'geoserver',
  	          		})
  	          	}); 

  	        	map.addLayer(wmsBjd); 
 	     		
 	       	},
 	       	error : function() {
 	          	alert("실패");
 	       	}
 	    })

 	});
	        	   	
 */
 
	$(".interval").click(function(){
  		if ($("#legendSelect").val() == "equalInterval") {
			//map.removeLayer(wmsSd);   
  	       	var sggcode = $("#sggSelect").val();
  	      	var bjdcode;
  	        	        
  	        $.ajax({
  	        	url : "/equalInterval.do",
  	        	type : "post",
  	        	dataType : "json",
  	        	data : {"sggcd" : sggcode},
  	        	success : function(result) {
  	        		
  	    	        for (var j = 0; j < layerList.length; j++) {
  	    	        	map.removeLayer(layerList[j]);						
  	  				}
  	    	      	
  	    	        layerList = [];
  	        		console.log(result);
  	        	 	var sggcd2 = $("#sggSelect").val();
  	        	 	console.log(sggcd2);
  	        	 	     		
  	                for(var i=0; i<result.length; i++){
  	                	var b = result[i].bjdcd;
	  	        	 	var bjdcd2 = b.substring(0, 3);
	  	        	    var bjd_CQL = "bjd_cd=" + sggcd2 + bjdcd2;
	  	        	 	var styles = "carbon" + result[i].level;
	  	        	 	
	  	        	 	bjdcode = new ol.layer.Tile({
	  	  	          		source : new ol.source.TileWMS({
	  	  	          			url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
	  	  	          			params : {
	  	  	          				'VERSION' : '1.1.0', // 2. 버전
	  	  	          				'LAYERS' : 'testhere:tl_bjd', // 3. 작업공간:레이어 명
	  	  	          				'CQL_FILTER' : bjd_CQL,
	  	  	          				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
	  	  	       					'SRS' : 'EPSG:3857', // SRID
	  	  	       					'STYLES' : styles,
	  	  	       					'FORMAT' : 'image/png', // 포맷
	  	  	       					'TRANSPARENT' : 'TRUE',
	  	  	          			},
	  	  	          			serverType : 'geoserver',
	  	  	          		})
	  	  	          	});
	  	        	 	layerList.push(bjdcode);
  	                }
					
  	    	        for (var j = 0; j < layerList.length; j++) {
  	    	        	map.addLayer(layerList[j]);						
  	  				}
  	        	},
  	        	 error : function(){
  	        	 	    alert("실패");
  	        	 }
  	        })
			
  	    } else {
			alert("ho");
		}
  	        
  	});
  
})   

	 	 
</script>

</head>
<body>
	<div class="container">
		<div class="main">
		</div>
		<div class="menu">
         <div class="btncon">
            <select id="sdSelect">
               <option>시도 선택</option>
               <c:forEach items="${sdlist }" var="sd">
                  <option class="sd" value="${sd.sd_cd }">${sd.sd_nm}</option>
               </c:forEach>
            </select> 
            
            <select id="sggSelect">
               <option>시군구 선택</option>
            </select> 
            
            <button class="insertbtn">이동</button>

            <select name="legend" id="legendSelect">
               <option>범례 선택</option>
               <option class="legend" value="jenkins">NaturalBreaks</option>
               <option class="legend" value="equalInterval">등간격</option>
            </select>

            <button class="interval">보기</button>
            <a href='/fileUp.do'>파일 업로드</a>
         </div>
		</div>
 		<div class="main">
        	<div class="map" id="map" style="width: 900px; height: 1000px;"></div>
      	</div>
	</div>
</body>

</html>