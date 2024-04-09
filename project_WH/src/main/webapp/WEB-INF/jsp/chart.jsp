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
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<style type="text/css">
#chart_div{
	width: 100%; 
	height:auto;
}
#chart_tb{
	margin-left:100px;
	width: 70%; 
	height:auto;
}
</style>
<script type="text/javascript">
	google.charts.load('current', {'packages':['corechart']});
	google.charts.setOnLoadCallback(drawChart);

	let chartData = [];
	chartData = ${sdChart};	

	function drawChart() {
		
		renderTable(chartData);
		
 		let totalChart = [];
		
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
        //console.log(tbodyData);
        document.querySelector('#chartTB > tbody').innerHTML = tbodyData.join("");
    }
            

	
$(function(){
	
    $("#chartView").on("click", function() {      
       	var sido = $("#sdChart option:checked").text();
       	var sdCode = $('#sdChart').val();
       	
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
     	    	document.querySelector(".card-header").innerText = "시군구별 탄소 배출량";
     	    	
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
	<%@ include file="./header.jsp" %>
</nav>
<div id="layoutSidenav">
	<div id="layoutSidenav_nav">
		<!-- Sidebar -->
		<%@ include file="./menu.jsp" %>
	</div>
	<div id="layoutSidenav_content">
        <main>
        	 <!-- 사이드 메뉴 -->
        	<div class="map_sideMenu">
        		<!-- 지역별 사용량 -->
        		<div class="form-group mb-3">
	        		<label class="menuTitle">시도별 탄소 배출량</label>
	        		<div class="input-group mb-2">
	        				<select id="sdChart" class="form-select form-select-sm">
								<option>시도 선택</option>
								<c:forEach items="${totalChart }" var="sd">
									<option class="sd" value="${sd.sd_cd }">${sd.sd_nm}</option>
								</c:forEach>
							</select>					
	        		</div>     		
					<div class="btn btn-secondary btn-sm" id ="chartView">보기</div>
        		</div>

        	</div>
			<div class="map_content">
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