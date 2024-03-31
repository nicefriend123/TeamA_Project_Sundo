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
<script src="https://cdnjs.cloudflare.com/ajax/libs/ol3/4.6.5/ol.js" integrity="sha512-O7kHS9ooekX8EveiC94z9xSvD/4xt10Qigl6uEKvspYykdux3Ci5QNu5fwi4ca0ZkZI/oCgx5ja8RklWUEqzxQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ol3/4.6.5/ol-debug.css" integrity="sha512-hBSieZLd5rse9gdkfv4n0pDU4D04SxpqBtwDzRy/QiXRBhczDyfCTDTnHCada73ubNqiQv6BLgCRXHAJPUwC5w==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link href="../resources/css/mapTest.css" rel="stylesheet">
<link href="../resources/css/fileUp.css" rel="stylesheet">
<!-- bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet"/>
<link href="../resources/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
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
			map.removeLayer(wmsSd);   
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
			
  	    } else if($("#legendSelect").val() == "jenkins"){
			
		}
  	        
  	});
 
 /* 
 	//맵 클릭 이벤트
	map.on('singleclick', function(evt) {
	    var coordinate = evt.coordinate;
	    var hdms = ol.coordinate.toStringHDMS(ol.proj.transform(coordinate, 'EPSG:3857', 'EPSG:4326'));
	    
	    // 툴팁 DIV 생성
	    let element = document.createElement("div");
	    element.classList.add('ol-popup');
	    element.innerHTML = `<a id="popup-closer" class="ol-popup-closer"></a> <div><p>You clicked here:</p><code>${hdms}</code></div>`;
	    element.style.display = 'block';

		// OverLay 생성
	    let overlay = new ol.Overlay({
	        element: element, // 생성한 DIV
	        autoPan: true,
	        className: "multiPopup",
	        autoPanMargin: 100,
	        autoPanAnimation: {
	            duration: 400
	        }
	    });
		//오버레이의 위치 저장
	    overlay.setPosition(coordinate);
	    //지도에 추가
	    map.addOverlay(overlay);

		// 해당 DIV 다켓방법
	    let oElem = overlay.getElement();
	    oElem.addEventListener('click', function(e) {
	        var target = e.target;
	        if (target.className == "ol-popup-closer") {
	            //선택한 OverLayer 삭제
	            map.removeOverlay(overlay);

	        }
	    });
	});
  */

  
  
  
  
  
})   
	 	 
</script>

</head>
<body class="sb-nav-fixed">
	<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
      <!-- Navbar Brand-->
      <a class="navbar-brand ps-3" href="index.html">탄소배출지도</a>
      <!-- Sidebar Toggle-->
      <button
        class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0"
        id="sidebarToggle"
        href="#!"
      >
        <i class="fas fa-bars"></i>
      </button>
      <!-- Navbar Search-->
      <form
        class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0"
      >
        <div class="input-group">
          <input
            class="form-control"
            type="text"
            placeholder="Search for..."
            aria-label="Search for..."
            aria-describedby="btnNavbarSearch"
          />
          <button class="btn btn-primary" id="btnNavbarSearch" type="button">
            <i class="fas fa-search"></i>
          </button>
        </div>
      </form>
      <!-- Navbar-->
      <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
        <li class="nav-item dropdown">
          <a
            class="nav-link dropdown-toggle"
            id="navbarDropdown"
            href="#"
            role="button"
            data-bs-toggle="dropdown"
            aria-expanded="false"
            ><i class="fas fa-user fa-fw"></i
          ></a>
          <ul
            class="dropdown-menu dropdown-menu-end"
            aria-labelledby="navbarDropdown"
          >
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
        <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
          <div class="sb-sidenav-menu">
            <div class="nav">
              <div class="sb-sidenav-menu-heading">지도 보기</div>
              <a
                class="nav-link collapsed"
                href="maptest.do"
                data-bs-toggle="collapse"
                data-bs-target="#collapseLayouts"
                aria-expanded="false"
                aria-controls="collapseLayouts"
              >
                <div class="sb-nav-link-icon">
                  <i class="fas fa-tachometer-alt"></i>
                </div>
                탄소배출지도
                <div class="sb-sidenav-collapse-arrow">
                  <i class="fas fa-angle-down"></i>
                </div>
              </a>
              <div
                class="collapse"
                id="collapseLayouts"
                aria-labelledby="headingOne"
                data-bs-parent="#sidenavAccordion"
              >
                <nav class="sb-sidenav-menu-nested nav">
                  <a class="nav-link">            
            		<select id="sdSelect" class="form-select">
               		<option>시도 선택</option>
               		<c:forEach items="${sdlist }" var="sd">
                  		<option class="sd" value="${sd.sd_cd }">${sd.sd_nm}</option>
               		</c:forEach>
            		</select>
            		<select id="sggSelect" class="form-select">
               			<option>시군구 선택</option>
            		</select>
            		<select name="legend" id="legendSelect" class="form-select">
               			<option>범례 선택</option>
               			<option class="legend" value="jenkins">NaturalBreaks</option>
               			<option class="legend" value="equalInterval">등간격</option>
            		</select>
            		<div class="selectBox"> 
	            		<button class="interval">보기</button>
         			</div>
            		</div>
         		  </a>

              <a
                class="nav-link collapsed"
                href="index.html"
                data-bs-toggle="collapse"
                data-bs-target="#collapseFileUp"
                aria-expanded="false"
                aria-controls="collapseFileUp"
              >
                <div class="sb-nav-link-icon">
                  <i class="fas fa-tachometer-alt"></i>
                </div>
                파일 업로드
                <div class="sb-sidenav-collapse-arrow">
                  <i class="fas fa-angle-down"></i>
                </div>
              </a>
              <div
                class="collapse"
                id="collapseFileUp"
                aria-labelledby="headingOne"
                data-bs-parent="#sidenavAccordion"
              >
                <nav class="sb-sidenav-menu-nested nav">
                  <a class="nav-link fileUpLoad">
					<input type="file" id="upFile" name="upFile">
					<button type="button" id="submitBtn">업로드</button>
                  </a>
                </nav>
              </div>
              <div class="sb-sidenav-menu-heading">통계</div>
              <a class="nav-link">
                <div class="sb-nav-link-icon">
                  <i class="fas fa-chart-area"></i>
                </div>
                Charts
              </a>
            </div>
            </div>
          </nav>
          </div>
          <div class="sb-sidenav-footer">
            <div class="small">Logged in as:</div>
            Start Bootstrap
          </div>
        </nav>
      </div>
	<div id="layoutSidenav_content">
        <main>
			<div class="main">
        		<div class="map" id="map" style="width: 1200px; height: 800px;"></div>
      		</div>
        </main>
        <footer class="py-4 bg-light mt-auto">
          <div class="container-fluid px-4">
            <div class="d-flex align-items-center justify-content-between small">
              <div class="text-muted">Copyright &copy; Your Website 2023</div>
              <div>
                <a href="#">Privacy Policy</a>
                &middot;
                <a href="#">Terms &amp; Conditions</a>
              </div>
            </div>
          </div>
        </footer>
      </div>
    </div>
	<div class="container">
		<div class="menu">
         <div class="btncon">


            <div id="fileUp">
	            <a href='/fileUp.do'>파일 업로드</a>
            </div>
         </div>
         <div>
	        <button id="modalOpenButton">모달창 열기</button>
		</div>	
		</div>

	</div>
	


<div id="modalContainer" class="hidden">
	<div id="modalContent">
		<p>모달 창 입니다.</p>
		<button id="modalCloseButton">닫기</button>
	</div>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="js/scripts.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
<script src="assets/demo/chart-area-demo.js"></script>
<script src="assets/demo/chart-bar-demo.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
<script src="js/datatables-simple-demo.js"></script>
</body>
</html>