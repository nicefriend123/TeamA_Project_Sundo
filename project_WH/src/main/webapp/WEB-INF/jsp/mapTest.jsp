<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>title</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/ol3/4.6.5/ol.js"
	integrity="sha512-O7kHS9ooekX8EveiC94z9xSvD/4xt10Qigl6uEKvspYykdux3Ci5QNu5fwi4ca0ZkZI/oCgx5ja8RklWUEqzxQ=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ol3/4.6.5/ol-debug.css"
	integrity="sha512-hBSieZLd5rse9gdkfv4n0pDU4D04SxpqBtwDzRy/QiXRBhczDyfCTDTnHCada73ubNqiQv6BLgCRXHAJPUwC5w=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"
	integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	
	<script type="text/javascript">
	$(function(){
	
		var wmsSd, wmsSgg, wmsBjd;
		
		
		var Base = new ol.layer.Tile({
			name : "Base",
			source: new ol.source.XYZ({
				url: 'https://api.vworld.kr/req/wmts/1.0.0/1C6740EE-D23E-3A90-8F40-1D342D80666C/Base/{z}/{y}/{x}.png'
			})
		}); // WMTS API 사용
		
   		var olView = new ol.View({
        	center: ol.proj.transform([127.100616,37.402142], 'EPSG:4326', 'EPSG:3857'), //좌표계 변환
        	zoom: 8     
    	});// 뷰 설정
    
    	var map = new ol.Map({
        	layers: [Base], //지도에서 사용할 레이어 목록 정의
        	target: 'map',
        	view: olView
    	});
	
    	$("#sdselect").on("change", function() {      
        
        	var test = $("#sdselect option:checked").text();
        	$.ajax({
           		url : "/maptest.do",
           		type : "post",
           		dataType : "json",
   	        	data : {"test" : test},
     	     	success : function(result) {
              	$("#sgg").empty();
              	var wmsSgg = "<option>시군구 선택</option>";
              
              	for(var i=0;i<result.length;i++){
              		wmsSgg += "<option value='"+result[i].sgg_cd+"'>"+result[i].sgg_nm+"</option>"
              	}
              
              	$("#sgg").append(wmsSgg);
           	},
           	error : function() {
              	alert("실패");
           		}
        	})
     	});
    
    $(".insertbtn").click(function() {

        map.removeLayer(wmsSd);
        map.removeLayer(wmsSgg);
        map.removeLayer(wmsBjd);
        
        var sd_CQL = "sd_cd="+$("#sdselect").val();
        var sgg_CQL = "sgg_cd="+$("#sgg").val();
        
        var sdSource = new ol.source.TileWMS({
           url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
           params : {
              'VERSION' : '1.1.0', // 2. 버전
              'LAYERS' : 'testhere:tl_sd', // 3. 작업공간:레이어 명
              'CQL_FILTER' : sd_CQL,
              'BBOX' : [ 1.3871489341071218E7, 3910407.083927817,
                    1.4680011171788167E7, 4666488.829376997 ],
              'SRS' : 'EPSG:3857', // SRID
              'FORMAT' : 'image/png', // 포맷
              'TRANSPARENT' : 'TRUE',

           },
           serverType : 'geoserver',
        });

        wmsSd = new ol.layer.Tile({
           source : sdSource,
           opacity : 0.5
        });

        //for(var i in sd) sd[i].setStyle(style);

        //map.addLayer(sd); // 맵 객체에 레이어를 추가함
    	wmsSd = new ol.layer.Tile({
      		source : new ol.source.TileWMS({
      			url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
      			params : {
      				'VERSION' : '1.1.0', // 2. 버전
      				'LAYERS' : 'testhere:tl_sd', // 3. 작업공간:레이어 명
      				'CQL_FILTER' : sd_CQL,
      				'BBOX' : [1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997], 
      				'SRS' : 'EPSG:3857', // SRID
      				'FORMAT' : 'image/png', // 포맷
      			},
      			serverType : 'geoserver',
      			})		
      		});	
    	

    	 
    	wmsSgg = new ol.layer.Tile({
    		source : new ol.source.TileWMS({
    	  		url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
    	  		params : {
    	  			'VERSION' : '1.1.0', // 2. 버전
    	  			'LAYERS' : 'testhere:tl_sgg', // 3. 작업공간:레이어 명
    	  			'CQL_FILTER' : sgg_CQL,
    	  			'BBOX' : [1.386872E7, 3906626.5, 1.4428071E7, 4670269.5], 
    	  			'SRS' : 'EPSG:3857', // SRID
    	  			'FORMAT' : 'image/png' // 포맷
    	  		},
    	  		serverType : 'geoserver',
    	  		})
    		});
    	  	

    	 
        wmsBjd = new ol.layer.Tile({
      		source : new ol.source.TileWMS({
      			url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
      			params : {
      				'VERSION' : '1.1.0', // 2. 버전
      				'LAYERS' : 'testhere:el_bjd', // 3. 작업공간:레이어 명
      				'CQL_FILTER' : sgg_CQL,
      				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
      				'SRS' : 'EPSG:3857', // SRID
      				'STYLES' : 'carbon3',
      				'FORMAT' : 'image/png' // 포맷
      			},
      			serverType : 'geoserver',
      			})
      		});
      	
    	 	map.addLayer(wmsSd);
    		map.addLayer(wmsSgg); 
    	 	map.addLayer(wmsBjd);     
    

	});
  
})   
	    
 
	 	 
</script>
</head>

<body>
   <div class="container">
      <div class="main">
         <div class="btncon">
            <select id="sdselect">
               <option>시도 선택</option>
               <c:forEach items="${sdlist }" var="sd">
                  <option class="sd" value="${sd.sd_cd }">${sd.sd_nm}</option>
               </c:forEach>
            </select> 
            
            <select id="sgg">
               <option>시군구 선택</option>
            </select> 
            
            <select>
               <option selected="selected">범례 선택</option>
            </select>

            <button class="insertbtn">입력하기</button>
         </div>
         <div class="map" id="map"></div>
      </div>
   </div>
</body>

</html>