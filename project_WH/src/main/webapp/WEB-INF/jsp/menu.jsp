<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
	<div class="sb-sidenav-menu">
		<div class="nav">
			<div class="sb-sidenav-menu-heading">지도 보기</div>
			<a id="mapPage" class="nav-link collapsed[href='maptest.do']" data-bs-toggle="collapse" data-bs-target="#collapseLayouts" aria-expanded="false" aria-controls="collapseLayouts">
				<i class="fas fa-tachometer-alt"></i>
				 탄소배출지도
				<div class="sb-sidenav-collapse-arrow">
					<i class="fas fa-angle-down"></i>
				</div>
			</a>
			<div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
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
					</a>
				</nav>
			</div>
			<a class="nav-link collapsed" data-bs-toggle="collapse" data-bs-target="#collapseFileUp" aria-expanded="false" aria-controls="collapseFileUp">
				<i class="fas fa-tachometer-alt"></i>
				파일 업로드
				<div class="sb-sidenav-collapse-arrow">
					<i class="fas fa-angle-down"></i>
				</div>
			</a>
			<div class="collapse" id="collapseFileUp" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
				<nav class="sb-sidenav-menu-nested nav">
					<a class="nav-link fileUpLoad">
						<input type="file" id="upFile" name="upFile">
						<button type="button" id="submitBtn">업로드</button>
					</a>
				</nav>
			</div>
			<div class="sb-sidenav-menu-heading">통계</div>
			<a class="nav-link" href="chart.do">
				<i class="fas fa-chart-area"></i>
				Charts
			</a>
		</div>
	</div>
</nav>

