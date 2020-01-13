<%--------------------------------------------------------------------------
CSE532 -- Project 2
File name: demoView.jsp
Author(s): Ravinder Singh (112681203), Rajat Hande (112684167)
Brief description: Front end file served to the client.
---------------------------------------------------------------------------%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<title>WOCO - Demo</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<style>
.pdg {
padding: 10px;
height: 80vh;
}
.queryBlock {
padding: 10px;
border-bottom: 1px solid lightgray;
}
</style>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="container">
<h3 class="text-center">ToDB Homework 2- WOCO</h3>
<h4 style="margin-bottom: 15px" class="text-center">Ravinder Singh, Rajat R Hande</h4>

<div class="col-md-5 well pdg">

	<div class="row queryBlock">
	<span class="col-md-10">Find all companies that are (partially) owned by one of their board members.
	</span>
	<button class="col-md-2 btn btn-success" onclick="runQuery(1)">Run</button>
	</div>
	
	<div class="row queryBlock">
	<span class="col-md-10">Find the net worth for every person in the database. 
	</span>
	<button class="col-md-2 btn btn-success" onclick="runQuery(2)">Run</button>
	</div>
	<div class="row queryBlock">
	
	<span class="col-md-10">For each company, find the board member that owns the most shares of that company among
all the board members of that company.
	</span>
	<button class="col-md-2 btn btn-success" onclick="runQuery(3)">Run</button>
	</div>
	<div class="row queryBlock">
	
	<span class="col-md-10">Find all pairs.
	</span>
	<button class="col-md-2 btn btn-success" onclick="runQuery(4)">Run</button>
	</div>
	<div class="row queryBlock">
	
	<span class="col-md-10">For each person, find the companies he controls and the percentage of control, if that percentage is greater than 10%.
	</span>
	<button class="col-md-2 btn btn-success" onclick="runQuery(5)">Run</button>
	</div>
</div>

<div id="resultDiv" class="col-md-6 well pdg" style="overflow-y: scroll; margin-left: 10px">

</div>
</div>
</body>
<script>
function runQuery(qn) {
	$.get('/WOCODemo/runQuery?queryNumber=' + qn,
		      function (data, textStatus, jqXHR) {
		$('#resultDiv').html(data);
		    });
}
</script>
</html>