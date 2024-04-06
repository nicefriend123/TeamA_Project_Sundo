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
<style type="text/css">
main{
	width: 100%;
	height: 100%;
}
.map_content{
	width: 100%;
	height: 100%;
	display : row;
}
#chart_div{
	width: 80%; 
	height:auto;
}
#chart_tb{
	margin-left:50px;
	width: 60%; 
	height:auto;
}
</style>
<script type="text/javascript">
	google.charts.load('current', {'packages':['corechart']});

	let chartData = [];
	chartData = ${sdChart};	
	console.log(chartData);
	
	google.charts.setOnLoadCallback(drawChart);

	function drawChart() {
 		let totalChart = [];
		renderTable(chartData);
 		
		for (var i = 0; i < chartData.length; i++) {
			let element = [chartData[i].sd_nm, chartData[i].usage];
			totalChart.push(element);
		}
		
		totalChart.unshift(['지역명', '배출량']);

		// Create the data table.
	    var data = new google.visualization.arrayToDataTable(totalChart);
    	
    	// Set chart options
        var options = {
            "title": '시도 별 탄소배출량',
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
	    var chart = new google.visualization.BarChart(obj);
	    chart.draw(data, options);
  	}
	
    function renderTable(chartData) {
        let tbodyData = [];
        //for (const iterator of chartData) {
        for (var i = 0; i < chartData.length; i++) {
            tbodyData.push(
            		"<tr><td>" + chartData[i].sd_nm + "</td><td>" + chartData[i].usage + "</td></tr>"
            )
        }
        console.log(tbodyData);
        document.querySelector('#chartTB > tbody').innerHTML = tbodyData.join("");
    }
	
$(function(){
	
    $("#chartView").on("click", function() {      
       	var sido = $("#sdChart option:checked").text();
       	
       	$.ajax({
        	url : "/chart.do",
           	type : "post",
           	dataType : "json",
   	        data : {"sido" : sido},
   	        async: false,
     	    success : function(result) {
     	    	var sggdata = JSON.parse(result);
     	    	chartData = sggdata;
     	    	google.charts.setOnLoadCallback(drawChart);
              
           	},
           	error : function() {
              	alert("실패");
           	}
        })
     });	
})

</script>
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
<!--         		<div class="map" id="map" style="width: 1150px; height: 800px;"></div> -->
				<div id="chart_div">
				</div>
				<div id="chart_tb">
					<div class="card mb-4">
						<div class="card-header">시도별 탄소 배출량</div>
						<div class="card-body">
							<div class="datatable-wrapper fixed-columns">
								<table id="chartTB" class="datatable-table">
									<thead>
										<tr>
											<th>지역 명</th>
											<th>탄소 배출량</th>
										</tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
      		</div>
        </main>
        <footer class="py-4 bg-light mt-auto">
        	<div class="container-fluid px-4">
            	<div class="d-flex align-items-center justify-content-between small"></div>
          	</div>
        </footer>
	</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="../resources/js/scripts.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
<script src="../resources/js/datatables-simple-demo.js"></script>
</body>
</html>