<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
<title>Warehouse Delivery</title>
<style>
    .navbar-dark .navbar-brand {
        color: #ffffff; /* 设置亮色文字 */
    }
    .navbar-dark .navbar-brand:hover {
        color: #cccccc; /* 鼠标悬停时的颜色变化 */
    }
	.btn-container {
	  display: flex;
	}
	.prev-btn {
	  justify-content: flex-start; /* Align prevButton to the left */
	}
	.next-btn {
	  justify-content: flex-end;   /* Align nextButton to the right */
	}
</style>

<script type="text/javascript">
	var wTotalPages = ${totalPages};
	var wCurrentPage = 1;
	var options = ["Pending", "InProgress", "Shipped", "Abandoned"];
	function updatePageIndicator()
	{
		console.log(wTotalPages)
		console.log(wCurrentPage)
		console.log("page testing")
		let pageBlock = document.getElementById("displayPage");
		pageBlock.innerHTML = wCurrentPage + "/" + wTotalPages;
	}
	
	function viewAll()
	{
		fetchTasks(0);
		fetchPages();
		updatePageIndicator();
	}

	
    function onClickViewOnMap(obj) {
    	  let tr = obj.parentNode.parentNode;
    	  let id = tr.children[0].innerText; // Assuming the ID is in the first column (index 0)
    	  console.log("Sent ID:", id);
    	  const url = `http://localhost:8080/Task/MapView?id=`+id;
    	  console.log("Sent url:", url);
    	  window.open(url, "_blank");  // Open the URL in a new tab
    	  return false;
      }

	function fetchPages() {
		let pUrl= "http://localhost:8080/delivery/pages";
		console.log(pUrl);
		  $.ajax({
		    url: pUrl,
		    type: "GET", // Use GET for fetching data
		    dataType: "json", // Expect JSON response
		    success: function(data) {
		      console.log(data);
		      wTotalPages = data;
		      console.log(wTotalPages);
		    }
		  });
		}
	
	function fetchTasks(pageNumber) {
		let pUrl= "http://localhost:8080/delivery?page="+pageNumber + "&size=10";
		console.log(pUrl);
		  $.ajax({
		    url: pUrl,
		    type: "GET", // Use GET for fetching data
		    dataType: "json", // Expect JSON response
		    success: function(data) {
		    	console.log(data.content);
		    	allTaskTable(data.content); // Call function to update the table with fetched data
		    },
		    error: function(jqXHR, textStatus, errorThrown) {
		      console.error("Error fetching products:", textStatus, errorThrown);
		      // Handle errors appropriately (e.g., display an error message to the user)
		    }
		  });
		}
	
	function fetchOrdersByStatus(status){
		let pUrl= "http://localhost:8080/delivery/fetch?status="+status;
		console.log(pUrl);
		  $.ajax({
			    url: pUrl,
			    type: "GET", // Use GET for fetching data
			    dataType: "json", // Expect JSON response
			    success: function(data) {
			    	console.log(data);
			    	statusOrderTable(data);
			    },
			    error: function(jqXHR, textStatus, errorThrown) {
			      console.error("Error fetching products:", textStatus, errorThrown);
			      // Handle errors appropriately (e.g., display an error message to the user)
			    }
		});
	}
	
	function statusTaskTable(tasks) {
		allTaskTable(tasks);
	}

	function allTaskTable(tasks) {
	  var tableBody = document.getElementById("allTasks").getElementsByTagName("tbody")[0];
	  tableBody.innerHTML = ""; // Clear existing table content
      
	  for (var i = 0; i < tasks.length; i++) {
	    let task = tasks[i];
	    let row = tableBody.insertRow();
	    row.insertCell().innerHTML = task.id;
	    row.insertCell().innerHTML = task.title;
	    row.insertCell().innerHTML = task.decision;
	    row.insertCell().innerHTML = getNeedReturnString(task.needReturn);
	    
	    let statusCell = row.insertCell();
	    let statusSelect = document.createElement("select");
	    statusSelect.onchange = function() {
	      // Call function to handle user-selected status change (replace with your logic)
	      handleTaskStatusChange(task.id, this.value);
	    };
	    statusCell.appendChild(statusSelect);

	    for (let option of options) {
	      let optionElement = document.createElement("option");
	      optionElement.text = option;
	      optionElement.value = option; // Assuming enum values match option text
	      if (option == task.status) {
	        optionElement.selected = true; // Select the current status
	      }
	      statusSelect.appendChild(optionElement);
	    }
	    row.insertCell().innerHTML = "<td><a href='#' onclick='onClickViewOnMap(this)'>View On Map</a></td>";
	  }
	}
	
	async function handleTaskStatusChange(taskId, newStatus) {
		  console.log("Task", taskId, "status changed to", newStatus);
		  
		  try {
			  
			  let position = options.lastIndexOf(newStatus);
			  	let url = "http://localhost:8080/delivery/updateStatus?id="+taskId + "&status=" + position;
			    const response = await fetch(url);

			    console.log(response);
			    if (!response.ok) {
			      throw new Error(`Error updating order status: ${response.statusText}`);
			    }

			    alert("Order status updated successfully!");
			  } catch (error) {
			    alert("Error updating order status:", error);
			  }
	}
	
	function getNeedReturnString(needReturn){
		return needReturn == 1 ? "Yes" : "No";
	}
		
		
	function onPrevButtonClicked()
	{
		if (wCurrentPage == 1)
			return;
		
		wCurrentPage = wCurrentPage-1;
		fetchProducts(wCurrentPage -1);
		updatePageIndicator();
	}
	
	function onNextButtonClicked()
	{
		if (wCurrentPage == wTotalPages)
			return;
		wCurrentPage = wCurrentPage+1;
		fetchProducts(wCurrentPage -1);
		updatePageIndicator();
	}
	
	function handleStatusChange()
	{
	    let selectElement = document.getElementById('statusSelection');
	    let selectedValue = selectElement.value;

	    console.log('Selected status:', selectedValue);
	    if (selectedValue == "0")
	    {
	    	viewAll();
	    	showPageIndicator();
	   	}
	    else
	    {
		    let val = parseInt(selectedValue) -1;
		    fetchOrdersByStatus(val);
		    hidePageIndicator();
	    }

	}
	
	function hidePageIndicator()
	{
		let pageIndicator = document.getElementById("pageIndicator");
		pageIndicator.style.visibility = "hidden";
	}
	
	function showPageIndicator()
	{
		let pageIndicator = document.getElementById("pageIndicator");
		pageIndicator.style.visibility = "visible";
		fetchPages();
		updatePageIndicator();
	}
	
	$(document).ready(function() {
			viewAll();
		});
</script>

</head>
<body>
<div class="container-fluid" style="position:relative;">
<%@ include file="menu.jsp" %>
<div class="row mt-1">
	<div class="col-md-1"></div>
	<div class="col-md-2"><h3>View All</h3></div>
	<div class="col-md-6"></div>
	<div class="col-md-2">
        <select class="form-control" id="statusSelection" name="status" onchange="handleStatusChange()">
        	<option value="0">All</option>
          	<option value="2">In Progress</option>
          	<option value="3">Shipped</option>
          	<option value="4">Abandoned</option>
        </select>
	</div>
	<div class="col-md-1"></div>
</div>

<div class="row" id="allTasks">

<div class="col-md-1"></div>
<div class="col-md-10 mx-auto">
<table class="table table-striped mt-1">
    <thead>
     <tr>
       <th>#</th>
       <th>Title</th>
       <th>Method</th>
       <th>Is Return</th>
       <th>Status</th>
       <th>Map</th>
     </tr>
    </thead>
    <tbody>
   </tbody>
  </table>
</div>
<div class="col-md-1"></div>
</div>
    <div class="row mt-1" id="pageIndicator">
        <div class="col-md-9 col-lg-9"></div>
        <div class="col-md-3 col-lg-3">
            <ul class="pagination pagination-sm" >
            <li class="page-item"><a class="page-link" href="#" onclick="onPrevButtonClicked()">Prev</a></li>
            <li class="page-item">
            <a class="page-link" id="displayPage">
                <script> updatePageIndicator()</script>
            </a>
            </li>
            <li class="page-item"><a class="page-link" href="#" onclick="onNextButtonClicked()">Next</a></li>
            </ul>
        </div>
    </div>
</div> 

<%@ include file="modal.jsp" %>
</body>
</html>