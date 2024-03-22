<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>title</title>
<script src="https://cdn.jsdelivr.net/npm/ol@v7.4.0/dist/ol.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v7.4.0/ol.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript">
$(function(){
	
/* 	var cql_filter = 'CQL_FILTER = ' + encodeURIComponent("sd_cd = 11"); */
	
	var Base = new ol.layer.Tile({
		name : "Base",
		source: new ol.source.XYZ({
			url: 'https://api.vworld.kr/req/wmts/1.0.0/1C6740EE-D23E-3A90-8F40-1D342D80666C/Base/{z}/{y}/{x}.png'
		})
	}); // WMTS API 사용
  
    var olView = new ol.View({
        center: ol.proj.transform([127.100616,37.402142], 'EPSG:4326', 'EPSG:3857'), //좌표계 변환
        zoom: 7     
    });// 뷰 설정
    
    
    var map = new ol.Map({
        layers: [Base],
        target: 'map',
        view: olView
    });
	
/* 	var wmsSd = new ol.layer.Tile({
  		source : new ol.source.TileWMS({
  			url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
  			params : {
  				'VERSION' : '1.1.0', // 2. 버전
  				'LAYERS' : 'testhere:tl_sd', // 3. 작업공간:레이어 명
  				'CQL_FILTER' : 'sgg_cd=11470',
  				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
  				'SRS' : 'EPSG:3857', // SRID
  				'FORMAT' : 'image/png' // 포맷
  			},
  			serverType : 'geoserver',
  			})
  		});
  	
	 map.addLayer(wmsSd);  */ 
	 
 	var el_bjd = new ol.layer.Tile({
  		source : new ol.source.TileWMS({
  			url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
  			params : {
  				'VERSION' : '1.1.0', // 2. 버전
  				'LAYERS' : 'testhere:el_bjd', // 3. 작업공간:레이어 명
  				'BBOX' : [1.387148932991382E7, 3910407.083927817, 1.46800091844669E7, 4666488.829376992], 
  				'SRS' : 'EPSG:3857', // SRID
  				'FORMAT' : 'image/png' // 포맷
  			},
  			serverType : 'geoserver',
  			})
  		});
  	
	 map.addLayer(el_bjd);  
   
 // 1. 레이어 생성
    var originalLayer = new ol.layer.Vector({
        source: new ol.source.Vector({
            format: new ol.format.GeoJSON(), // GeoJSON 형식 사용
            url: 'http://localhost/geoserver/testhere/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=testhere%3Ael_bjd&maxFeatures=50&outputFormat=application%2Fjson' // 데이터 소스 경로 설정
        })
    });
 
 // 2. 벡터 레이어로 변환
    var vectorLayer = new ol.layer.Vector({
        source: originalLayer.getSource(), // 기존 레이어의 소스를 새로운 벡터 레이어의 소스로 설정
        // 기타 벡터 레이어 설정
    });

    // 맵에 벡터 레이어 추가
   // map.addLayer(vectorLayer);


    // 데이터의 최소값과 최대값을 기반으로 등간격 계산

     var dataValues = [];
        
     vectorLayer.getSource().forEachFeature(function(feature) {
     	var value = feature.get('usage'); // 속성 값을 가져옵니다.
        dataValues.push(value);
     });

      	var uniqueValues = []; // 중복 제거된 값들을 담을 배열
      	for (var i = 0; i < dataValues.length; i++) {
      		if (uniqueValues.indexOf(dataValues[i]) === -1) {
        		uniqueValues.push(dataValues[i]);
         	}
      	} 
       
        //최대값, 최소값
        var maxValue = Math.max.apply(null, uniqueValues);
        var minValue = 0;
        
        var numIntervals = 7; // 등간격을 몇 등분할 것인지
        var interval = (maxValue - minValue) / numIntervals;
        
        
        //범례 색상
        
        var colors = ['#FFFFFF', "#FFE5E5", '#FFCCCC', '#FF9999', '#FF6666', '#FF3333', '#FF0000'];
        
        // 범례 범주 생성
		var legend = [];
		for (var i = 0; i < numIntervals; i++) {
	   		var rangeStart = minValue + interval * i;
   			var rangeEnd = minValue + interval * (i + 1);
    		var category = 'From ' + rangeStart + ' to ' + rangeEnd; // 범주를 나타내는 텍스트
    		var color = colors[i];
    
    		legend.push({ category: category, color: color });
		};
	
	$("#addLegendToDOM").click(function(){
	    var legendContainer = document.getElementById('map'); // HTML에서 범례를 표시할 요소를 가져옵니다.
	    legend.forEach(function(item) {
	       var legendItem = document.createElement('div');
	       legendItem.innerHTML = '<span style="background-color:' + item.color + ';"></span>' + item.category;
	       legendContainer.appendChild(legendItem);
		})
	});
	
})
</script>

</head>
<body>
<div>
	<button type="button" id="addLegendToDOM()">등간격</button>
</div>
<div id="map" style="width: 1000px; height: 800px; left: 0px; top: 0px"></div>

</body>
</html>