<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="fileUp.do" method="post" accept="multipart/form-data" enctype="multipart/form-data">
		<input type="file" name="upFile">
		<input type="submit" name="upLoad" value="제출">
	</form>
</body>
</html>