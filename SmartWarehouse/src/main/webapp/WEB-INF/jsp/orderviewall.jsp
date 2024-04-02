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
		fetchOrders(0);
		fetchPages();
		updatePageIndicator();
	}

	function fetchPages() {
		let pUrl= "http://localhost:8080/orders/pages";
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
	
	function fetchOrders(pageNumber) {
		let pUrl= "http://localhost:8080/orders?page="+pageNumber + "&size=10";
		console.log(pUrl);
		  $.ajax({
		    url: pUrl,
		    type: "GET", // Use GET for fetching data
		    dataType: "json", // Expect JSON response
		    success: function(data) {
		    	console.log(data.content);
		    	allOrderTable(data.content); // Call function to update the table with fetched data
		    },
		    error: function(jqXHR, textStatus, errorThrown) {
		      console.error("Error fetching products:", textStatus, errorThrown);
		      // Handle errors appropriately (e.g., display an error message to the user)
		    }
		  });
		}
	
	function fetchOrdersByStatus(status){
		let pUrl= "http://localhost:8080/orders/fetch?status="+status;
		console.log(pUrl);
		
		  $.ajax({
			    url: pUrl,
			    type: "GET", // Use GET for fetching data
			    dataType: "json", // Expect JSON response
			    success: function(data) {
			    	console.log(data);
			    	console.log("status " + status);
			    	if (status === 0)
			    		statusOrderTable(data, true);
			    	else
			    		statusOrderTable(data, false);
			    },
			    error: function(jqXHR, textStatus, errorThrown) {
			      console.error("Error fetching products:", textStatus, errorThrown);
			      // Handle errors appropriately (e.g., display an error message to the user)
			    }
		});
	}
	
	function statusOrderTable(orders, isPending) {
		  var tableBody = document.getElementById("allOrders").getElementsByTagName("tbody")[0];
		  tableBody.innerHTML = ""; // Clear existing table content
	      
		  for (var i = 0; i < orders.length; i++) {
		    let order = orders[i];
		    let row = tableBody.insertRow();
		    row.insertCell().innerHTML = order.id;
		    row.insertCell().innerHTML = order.address;
		    row.insertCell().innerHTML = order.nominalPrice;
		    row.insertCell().innerHTML = order.actualPrice;
		    row.insertCell().innerHTML = order.datetime;
		    // row.insertCell().innerHTML = order.deliveryStatus;
		    
		    let statusCell = row.insertCell();
	        let statusSelect = document.createElement("select");
	        statusSelect.onchange = function() {
	          // Call function to handle user-selected status change (replace with your logic)
	           handleOrderStatusChange(order.id, this.value);
	       };
	       statusCell.appendChild(statusSelect);

	    // Populate select options based on status enum (replace with your options)
	    for (let option of options) {
	      let optionElement = document.createElement("option");
	      optionElement.text = option;
	      optionElement.value = option; // Assuming enum values match option text
	      if (option == order.deliveryStatus) {
	        optionElement.selected = true; // Select the current status
	      }
	      statusSelect.appendChild(optionElement);
	    }
		    
	        // Add a checkbox in the last cell
	        if (isPending)
	        {
		        let checkboxCell = row.insertCell();
		        let checkbox = document.createElement('input');
		        checkbox.type = 'checkbox';
		        checkbox.value = order.id; // You can set the value to order.id or any other unique identifier
		        checkboxCell.appendChild(checkbox);
	        }
		  }
		  
		  if (isPending == true)
			  showDeliveryButton();
		  else
			  hideDeliveryButton();
	}
	
	async function handleOrderStatusChange(orderId, newStatus) {
		  console.log("Order id ", orderId, "status changed to", newStatus); // Example placeholder
		  
		  try {
			  
			  let position = options.lastIndexOf(newStatus);
			  	let url = "http://localhost:8080/orders/updateStatus?id="+orderId + "&status=" + position;
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

	function allOrderTable(orders) {
	  var tableBody = document.getElementById("allOrders").getElementsByTagName("tbody")[0];
	  tableBody.innerHTML = ""; // Clear existing table content
      
	  for (var i = 0; i < orders.length; i++) {
	    let order = orders[i];
	    let row = tableBody.insertRow();
	    row.insertCell().innerHTML = order.id;
	    row.insertCell().innerHTML = order.address;
	    row.insertCell().innerHTML = order.nominalPrice;
	    row.insertCell().innerHTML = order.actualPrice;
	    row.insertCell().innerHTML = order.datetime;
	    // row.insertCell().innerHTML = order.deliveryStatus;
	    
	    let statusCell = row.insertCell();
	    let statusSelect = document.createElement("select");
	    statusSelect.onchange = function() {
	      // Call function to handle user-selected status change (replace with your logic)
	      handleOrderStatusChange(order.id, this.value);
	    };
	    statusCell.appendChild(statusSelect);

	    // Populate select options based on status enum (replace with your options)
	    for (let option of options) {
	      let optionElement = document.createElement("option");
	      optionElement.text = option;
	      optionElement.value = option; // Assuming enum values match option text
	      if (option == order.deliveryStatus) {
	        optionElement.selected = true; // Select the current status
	      }
	      statusSelect.appendChild(optionElement);
	    }
	  }
	  hideDeliveryButton();
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
	
	function hideDeliveryButton()
	{
		let deliveryBtn = document.getElementById("deliveryBtn");
		deliveryBtn.style.visibility = "hidden";
	}
	
	function showDeliveryButton()
	{
		let deliveryBtn = document.getElementById("deliveryBtn");
		deliveryBtn.style.visibility = "visible";
	}
	
	function onDelivery111()
	{
	    var tableBody = document.getElementById("allOrders").getElementsByTagName("tbody")[0];
	    var checkboxes = tableBody.querySelectorAll('input[type="checkbox"]');
	    var selectedOrderIds = [];

	    checkboxes.forEach(function(checkbox) {
	        if (checkbox.checked) {
	            selectedOrderIds.push(parseInt(checkbox.value));
	        }
	    });

	    console.log(selectedOrderIds);
	    console.log(JSON.stringify({ orderIds: selectedOrderIds }));
	    
	    
	}
	
	async function onDelivery() {
		  const tableBody = document.getElementById("allOrders").getElementsByTagName("tbody")[0];
		  const checkboxes = tableBody.querySelectorAll('input[type="checkbox"]');
		  const selectedOrderIds = [];

		  checkboxes.forEach(checkbox => {
		    if (checkbox.checked) {
		      selectedOrderIds.push(parseInt(checkbox.value));
		    }
		  });

		  if (!selectedOrderIds.length) {
		    console.warn("No orders selected!");
		    return; // Exit if no orders selected
		  }

		  const jsonData = JSON.stringify({ orderIds: selectedOrderIds });
		  
		  try {
			    const response = await fetch("/delivery/init", {
			      method: "PUT",
			      headers: { "Content-Type": "application/json" },
			      body: jsonData,
			    });

			    if (!response.ok) {
			      throw new Error(`Error sending data: ${response.statusText}`);
			    }

			    console.log("Data sent successfully");
			    window.location.href = "/Task/NewTaskWithOrders";

			  } catch (error) {
			    console.error("Error sending order IDs:", error);
			    // Handle errors (optional)
			  }
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
          	<option value="1">Pending</option>
          	<option value="2">In Progress</option>
          	<option value="3">Shipped</option>
          	<option value="4">Abandoned</option>
        </select>
	</div>
	<div class="col-md-1"></div>
</div>

<div class="row" id="allOrders">

<div class="col-md-1"></div>
<div class="col-md-10 mx-auto">
<table class="table table-striped mt-1">
    <thead>
      <tr>
        <th>ID</th>
        <th>Address</th>
        <th>Nominal Price</th>
        <th>Actual Price</th>
        <th>Date Time</th>
        <th>Delivery Status</th>
        <th></th>
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

   <div class="row" id="deliveryBtn">
        <div class="col-md-10 col-lg-10"></div>
        <div class="col-md-2 col-lg-2">
        	<button type="button" class="btn btn-primary" onclick="onDelivery()">Delivery</button>
        </div>
    </div>
   </div> 

<%@ include file="modal.jsp" %>
</body>
</html>