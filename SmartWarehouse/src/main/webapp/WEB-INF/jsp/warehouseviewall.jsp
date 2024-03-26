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

	var isExist = false;
	var wTotalPages = ${totalPages};
	var wCurrentPage = 1;
	
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
		fetchProducts(0);
		updatePageIndicator();
	}


	function fetchPages() {
		let pUrl= "http://localhost:8080/products/pages";
		console.log(pUrl)
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
	
	function fetchProducts(pageNumber) {
		let pUrl= "http://localhost:8080/products?page="+pageNumber + "&size=10";
		console.log(pUrl)
		  $.ajax({
		    url: pUrl,
		    type: "GET", // Use GET for fetching data
		    dataType: "json", // Expect JSON response
		    success: function(data) {
		    	console.log(data.content);
		      updateProductTable(data.content); // Call function to update the table with fetched data
		    },
		    error: function(jqXHR, textStatus, errorThrown) {
		      console.error("Error fetching products:", textStatus, errorThrown);
		      // Handle errors appropriately (e.g., display an error message to the user)
		    }
		  });
		}
	
    function deleteRow(obj) {
        console.log(parseInt(obj.children[0].innerText));
        deleteProduct(parseInt(obj.children[0].innerText))
        var tableBody = document.getElementById("allProducts").getElementsByTagName("tbody")[0];
        tableBody.removeChild(obj);
     }
	
	function deleteProduct(id){
		
		  var productData = {
				    id:id,
				    name:"anyname",
				    type: "NonWeight",
				    price: 0,
				    quantity: 0,
				    symbol: "any-symbol"
				  };
		console.log(JSON.stringify(productData));
		
		  $.ajax({
			    url: "http://localhost:8080/products",
			    type: "DELETE",
			    dataType: "json",
			    data: JSON.stringify(productData),
			    contentType: "application/json; charset=utf-8",
			  });
	}

		function updateProductTable(products) {
		  var tableBody = document.getElementById("allProducts").getElementsByTagName("tbody")[0];
		  tableBody.innerHTML = ""; // Clear existing table content

		  for (var i = 0; i < products.length; i++) {
		    let product = products[i];
		    let row = tableBody.insertRow();
		    row.insertCell().innerHTML = product.id;
		    row.insertCell().innerHTML = product.name;
		    row.insertCell().innerHTML = product.type;
		    row.insertCell().innerHTML = product.price;
		    row.insertCell().innerHTML = product.quantity;
		    row.insertCell().innerHTML = product.symbol;
		    
		    let deleteCell = row.insertCell();   // Add a new cell for the "Delete" button
		    deleteCell.classList.add("text-center"); // Optional: Center the button

		    // Create a button element with appropriate styling and functionality
		    let deleteButton = document.createElement("button");
		    deleteButton.classList.add("btn", "btn-danger", "btn-sm"); // Bootstrap classes for button style
		    deleteButton.textContent = "Delete";

		    // Add an event listener to handle the delete action (implementation details omitted)
			deleteButton.addEventListener("click", function() {
				deleteRow(row);	
			});

		    // Add the button to the delete cell
		    deleteCell.appendChild(deleteButton);
		  }
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
	
	$(document).ready(function() {
			viewAll();
		});
</script>

</head>
<body>
<div class="container-fluid" style="position:relative;">
<%@ include file="menu.jsp" %>

<div class="row" id="allProducts">

<div class="col-md-1"></div>
<div class="col-md-10 mx-auto">
<h2>View All</h2>
<table class="table table-striped mt-3">
    <thead>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Type</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Symbol</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
   </tbody>
  </table>
</div>
<div class="col-md-1"></div>
</div>
    <div class="row mt-3">
        <div class="col-md-9 col-lg-9"></div>
        <div class="col-md-3 col-lg-3">
            <ul class="pagination pagination-sm">
            <li class="page-item"><a class="page-link" href="#" onclick="onPrevButtonClicked()">Prev</a></li>
            <li class="page-item"><a class="page-link" id="displayPage">
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