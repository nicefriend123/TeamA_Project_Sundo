<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta http-equiv="Content-Type" content="text/html"/>
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
<meta name="description" content="" />
<meta name="author" content="" />
<title>title</title>
<script src="https://cdn.jsdelivr.net/npm/ol@v7.4.0/dist/ol.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v7.4.0/ol.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link href="../resources/css/mapTest.css" rel="stylesheet">
<link href="../resources/css/fileUp.css" rel="stylesheet">
<!-- bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet"/>
<link href="../resources/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<script src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
	
$(function(){
	
	var wmsSd, wmsSgg, wmsBjd, bjdlegend, sgglegend;
    var layerList = [];
		
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
       	layers: [Base], //지도에서 사용할 레이어 목록 정의
       	target: 'map',
       	view: olView,
       	//overlays: [ overlay ]
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
    	  	    	}),
    	  	    	properties:{name:'wms'}
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
    	var sd_CQL = "sgg_cd="+$("#sggSelect").val();
    	
    	$.ajax({
        	url : "/sggSelect.do",
           	type : "post",
           	dataType : "json",
   	        data : {"sggName" : sggName},
     	    success : function(result) {
              	map.getView().fit([result.xmin, result.ymin, result.xmax, result.ymax], {duration : 500});
              	
              	map.removeLayer(wmsSd);
              	
              	wmsSgg = new ol.layer.Tile({
    	  	       	source : new ol.source.TileWMS({
    	  	    		url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
    	  	        	params : {
    	  	          		'VERSION' : '1.1.0', // 2. 버전
    	  	          		'LAYERS' : 'testhere:tl_bjd', // 3. 작업공간:레이어 명
    	  	          		'CQL_FILTER' : sd_CQL,
    	  	          		'STYLES' : 'carbon3',
    	  	          		'BBOX' : [1.386872E7, 3906626.5, 1.4428071E7, 4670269.5], 
    	  	          		'SRS' : 'EPSG:3857', // SRID
    	  	          		'FORMAT' : 'image/png' // 포맷
    	  	        	},
    	  	        	serverType : 'geoserver',
    	  	    	}),
    	  	    	properties:{name:'wms'}
				}); 
    	          
    	  	    map.addLayer(wmsSgg);
    	  	    
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
        var sggcode = $("#sggSelect").val(); 
		map.removeLayer(wmsSd);   
	    
	    if(sggcode == "" || sggcode == null){
		    var sdcode = $("#sggSelect").val();
	 	    //var sgg_CQL = "sgg_cd='"+ sggcode +"'";
	    	alert("여기");
	    	
	    	 if ($("#legendSelect").val() == "equalInterval") {
	    		sgglegend = new ol.layer.Tile({
		  	       	source : new ol.source.TileWMS({
		  	    		url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
		  	        	params : {
		  	          		'VERSION' : '1.1.0', // 2. 버전
		  	          		'LAYERS' : 'testhere:sggEqual', // 3. 작업공간:레이어 명
		  	          		'CQL_FILTER' : sd_CQL,
		  	          		'BBOX' : [1.387148932991382E7, 3910407.083927817, 1.46800091844669E7, 4666488.829376992], 
		  	          		'SRS' : 'EPSG:3857', // SRID
		  	          		'FORMAT' : 'image/png' // 포맷
		  	        	},
		  	        	serverType : 'geoserver',
		  	    	}),
		  	    	properties:{name:'wms'}
				}); 
		          
	          	map.addLayer(sgglegend);
	  	      	
				
	  	    	} else if($("#legendSelect").val() == "jenkins"){
				
	  	    		sgglegend = new ol.layer.Tile({
		  	       		source : new ol.source.TileWMS({
		  	    			url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
		  	        		params : {
		  	          			'VERSION' : '1.1.0', // 2. 버전
		  	          			'LAYERS' : 'testhere:sggNatural', // 3. 작업공간:레이어 명
		  	          			'CQL_FILTER' : sd_CQL,
		  	          			'BBOX' : [1.387148932991382E7, 3910407.083927817, 1.46800091844669E7, 4666488.829376992], 
		  	          			'SRS' : 'EPSG:3857', // SRID
		  	          			'FORMAT' : 'image/png' // 포맷
		  	        		},
		  	        		serverType : 'geoserver',
		  	    		}),
		  	    		properties:{name:'wms'}
					}); 
		          
	          		map.addLayer(sgglegend);
				}
	    	 
		    } else {

				map.removeLayer(wmsSgg);   
		    	var sggcode = $("#sggSelect").val();
	 	    	var sgg_CQL = "sgg_cd='"+ sggcode +"'";
			
	  			if ($("#legendSelect").val() == "equalInterval") {
	  				bjdlegend = new ol.layer.Tile({
			  	       	source : new ol.source.TileWMS({
			  	    		url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
			  	        	params : {
		  		          		'VERSION' : '1.1.0', // 2. 버전
		  	    	      		'LAYERS' : 'testhere:bjdlayer', // 3. 작업공간:레이어 명
		  	        	  		'CQL_FILTER' : sgg_CQL,
		  	          			'BBOX' : [1.387148932991382E7, 3910407.083927817, 1.46800091844669E7, 4666488.829376992], 
		  	          			'SRS' : 'EPSG:3857', // SRID
		  	          			'FORMAT' : 'image/png' // 포맷
		  	        		},
		  	        		serverType : 'geoserver',
		  	    		}),
		  	    		properties:{name:'wms'}
					}); 
		          
	          		map.addLayer(bjdlegend);
	  	      	
	  	    	} else if($("#legendSelect").val() == "jenkins"){
				
	          	 	bjdlegend = new ol.layer.Tile({
			  	       	source : new ol.source.TileWMS({
			  	    		url : 'http://localhost/geoserver/testhere/wms', // 1. 레이어 URL
			  	        	params : {
		  		          		'VERSION' : '1.1.0', // 2. 버전
		  	    	      		'LAYERS' : 'testhere:bjdnatural', // 3. 작업공간:레이어 명
		  	        	  		'CQL_FILTER' : sgg_CQL,
		  	          			'BBOX' : [1.387148932991382E7, 3910407.083927817, 1.46800091844669E7, 4666488.829376992], 
		  	          			'SRS' : 'EPSG:3857', // SRID
		  	          			'FORMAT' : 'image/png' // 포맷
		  	        		},
		  	        		serverType : 'geoserver',
		  	    		}),
		  	    		properties:{name:'wms'}
					}); 
		          
	          		map.addLayer(bjdlegend);
				}
	    	}
  	        
  		});
 	

	//맵 클릭 이벤트
	map.on('singleclick', async (evt) => {
		
		let container = document.createElement('div');
	    container.setAttribute("class", "ol-popup-custom");
	    
	    let content = document.createElement('div');
	    content.setAttribute("class", "popup-content");
	    //content.classList.add('popup-content');
	    
	    container.appendChild(content);
	    document.body.appendChild(container);
	    
	    var coordinate = evt.coordinate; // 클릭한 지도 좌표

	    
		console.log(map.getLayers().getArray());
		
		const wmsLayer = map.getLayers().getArray().filter(layer => {
	        return layer.get("name") === 'wms';
	    })[0];
		
		console.log(wmsLayer);
		
		const source = wmsLayer.getSource();
		
		console.log(source);
			
		const url = source.getFeatureInfoUrl(coordinate, map.getView().getResolution() || 0, 'EPSG:3857', {
			QUERY_LAYERS: 'testhere:bjdlayer',
			INFO_FORMAT: 'application/json'
		});
		
		console.log(url);
			
		// GetFeatureInfo URL이 유효할 경우
		if (url)
		{
			const request = await fetch(url.toString(), { method: 'GET' }).catch(e => alert(e.message));

			// 응답이 유효할 경우
			if (request)
			{
				// 응답이 정상일 경우
				if (request.ok)
				{
					const json = await request.json();

					// 객체가 하나도 없을 경우
					if (json.features.length === 0)
					{
						overlay.setPosition(undefined);
					}

					// 객체가 있을 경우
					else
					{	
						
						//ajax로 사용량 불러오기
						
						// GeoJSON에서 Feature를 생성
						const feature = new ol.format.GeoJSON().readFeature(json.features[0]);

						// 생성한 Feature로 VectorSource 생성
						const vector = new ol.source.Vector({ features: [ feature ] });
						console.log(vector)
						
					    content.innerHTML = '<div class="info">' + feature.get('sgg_cd') +
					    					'</div><div class="info">' + feature.get('totalusage') + ' kwt' +
					    					'</div>';
					    
					    var overlay = new ol.Overlay({
					        element: container,
					      });
						
					    map.addOverlay(overlay);
					    overlay.setPosition(coordinate);

					}
				}

				// 아닐 경우
				else
				{
					alert(request.status);
				}
			}
		}
			
	});		
	

		
	
  	
 	//파일 업로드
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
	        	showToast("전송중..");
	        },
			success : function(result){
				showToast("완료!");
	
			},
			error : function(){
				showToast("통신 실패");
				
			}
		}).done(function(data) {

        })
		
	});
  
  
  
})   
	 	 
</script>
<style type="text/css">
.ol-popup-custom {
    padding: 0;
    margin: 0;
    pointer-events: none;
    position: absolute;
    background-color: white;
    filter: drop-shadow(3px 3px 7px rgba(0,0,0,0.6));
    border: 1px solid black;
    min-width: 120px;
    width: auto;
    left: -60px; /* 위치를 조정, -width의 절반값 */
    min-height: 48px;
    height: auto;
    bottom: -50%; /* 위치를 조정, -height의 절반값 */
    box-sizing: border-box;
    text-align: center;
    overflow: hidden;
}
.popup-content {
	display : block;
   	position: absolute;
   	width: 100%;
   	box-sizing: border-box;
   	line-height: 100%;
}
.info {
    display: inline-block;
    line-height: 100%;
    width: 100%;
   	height:auto;
    font-size:10px;
    font-weight: bold;
    box-sizing: border-box;
    justify-content: center;
}

</style>
</head>
<body class="sb-nav-fixed">
<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
	<!-- Navbar Brand-->
    <a class="navbar-brand ps-3" href="maptest.do">탄소배출지도</a>
    <!-- Sidebar Toggle-->
    <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!">
        <i class="fas fa-bars"></i>
	</button>
    <!-- Navbar Search-->
    <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
        <div class="input-group">
          <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch"/>
          <button class="btn btn-primary" id="btnNavbarSearch" type="button">
            <i class="fas fa-search"></i>
          </button>
        </div>
	</form>
    <!-- Navbar-->
    <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
    	<li class="nav-item dropdown">
        	<a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
        		<i class="fas fa-user fa-fw"></i>
        	</a>
          	<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
            	<li><a class="dropdown-item" href="#!">Settings</a></li>
            	<li><a class="dropdown-item" href="#!">Activity Log</a></li>
            	<li><hr class="dropdown-divider" /></li>
            	<li><a class="dropdown-item" href="#!">Logout</a></li>
          	</ul>
        </li>
	</ul>
</nav>
<div id="layoutSidenav">
	<div id="layoutSidenav_nav">
		<!-- Sidebar -->
		<%@ include file="./menu.jsp" %>
	</div>
	<div id="layoutSidenav_content">
        <main>
			<div class="map_content">
        		<div class="map" id="map" style="width: 1150px; height: 800px;"></div>
      		</div>
			<div id="toastBox"></div>
			<div id="map-popup"></div>
			
	        <!-- Modal -->
			<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  			<div class="modal-dialog">
				    <div class="modal-content">
				      <div class="modal-header">
				        <button type="button" class="close" data-dismiss="modal">&times;</button>
				      </div>
				      <div class="modal-body">
				        <div class="chart" id="chart_div" style="width:100%; height:100%;"></div>
				      </div>
				      <div class="modal-footer">
				      </div>
				    </div>
				  </div>
			</div>
        </main>
        <footer class="py-4 bg-light mt-auto">
        	<div class="container-fluid px-4">
            	<div class="d-flex align-items-center justify-content-between small">
            	</div>
          	</div>
        </footer>
	</div>
</div>


<script type="text/javascript">
google.charts.load('current', {'packages':['corechart']});
google.charts.setOnLoadCallback(drawChart);

let chart = [];
chart = ${sdChart};	

function showToast(message) {
	let toast = document.getElementById('toastBox');
	toast.innerText= message;
	toast.style.display = 'block';
    setTimeout(function() {
        toast.style.display = 'none';
    }, 5000); // 3초
}

		
function drawChart() {
	
	let totalChart = [];
		
	for (var i = 0; i < chart.length; i++) {
		let element = [chart[i].sd_nm, chart[i].usage];
		totalChart.push(element);
	}
	
	totalChart.unshift(['지역명', '배출량']);

	// Create the data table.
    var data = new google.visualization.arrayToDataTable(totalChart);
	
	// Set chart options
    var options = {
    	chart: {
        	title: '탄소배출량',
       		},
        bars: 'horizontal', // Required for Material Bar Charts.
        hAxis: {format: 'decimal'},
        height: 600,
        colors: ['#1b9e77'],
        legend: {
        	position: 'none'
        	},
    };

    // chart 보이기
    var obj = document.getElementById('chart_div');
    var chartObj = new google.visualization.BarChart(obj);
    chartObj.draw(data, options);
	}
	

</script>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="../resources/js/scripts.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
<script src="../resources/js/datatables-simple-demo.js"></script>
</body>
</html>