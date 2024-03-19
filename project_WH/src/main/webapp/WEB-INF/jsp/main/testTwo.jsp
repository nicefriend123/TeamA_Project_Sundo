<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>title</title>
<script src="https://cdn.jsdelivr.net/npm/ol@v7.4.0/dist/ol.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v7.4.0/ol.css">
<script src="https://code.jquery.com/jquery-2.2.3.min.js"></script>
</head>

<body>
<div id="map" style="width: 1000px; height: 800px; left: 0px; top: 0px"></div>

<script type="text/javascript">	
	
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
	 
	var wmsSd = new ol.layer.Tile({
  		source : new ol.source.TileWMS({
  			url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
  			params : {
  				'VERSION' : '1.1.0', // 2. 버전
  				'LAYERS' : 'testhere:tl_sd', // 3. 작업공간:레이어 명
  				'CQL_FILTER' : 'sd_cd=11',
  				'BBOX' : [1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997], 
  				'SRS' : 'EPSG:3857', // SRID
  				'FORMAT' : 'image/png', // 포맷
  			},
  			serverType : 'geoserver',
  			})
  		});
	
	
	 map.addLayer(wmsSd);
	 
	var wmsSgg = new ol.layer.Tile({
		source : new ol.source.TileWMS({
	  		url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
	  		params : {
	  			'VERSION' : '1.1.0', // 2. 버전
	  			'LAYERS' : 'testhere:tl_sgg', // 3. 작업공간:레이어 명
	  			'CQL_FILTER' : 'sgg_cd=11470',
	  			'BBOX' : [1.386872E7, 3906626.5, 1.4428071E7, 4670269.5], 
	  			'SRS' : 'EPSG:3857', // SRID
	  			'FORMAT' : 'image/png' // 포맷
	  		},
	  		serverType : 'geoserver',
	  		})
		});
	  	
	map.addLayer(wmsSgg); 
	 
    var wmsBjd = new ol.layer.Tile({
  		source : new ol.source.TileWMS({
  			url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
  			params : {
  				'VERSION' : '1.1.0', // 2. 버전
  				'LAYERS' : 'testhere:tl_bjd', // 3. 작업공간:레이어 명
  				'CQL_FILTER' : 'sgg_cd=11470',
  				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
  				'SRS' : 'EPSG:3857', // SRID
  				'FORMAT' : 'image/png' // 포맷
  			},
  			serverType : 'geoserver',
  			})
  		});
  	
	 map.addLayer(wmsBjd);  
	 	 
</script>

</body>
</html>