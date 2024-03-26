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
		let pageBlock = document.getElementById("pageIndicator");
		pageBlock.innerHTML = "Page: " + wCurrentPage + "/" + wTotalPages;
	}
	
	function showPart(id)
	{
		var divBLK = document.getElementById(id);
    	if (divBLK.style.display === "none")
    	{
    		divBLK.style.display = "block";
    	}
	}
	
	function hidePart(id)
	{
		var divBLK = document.getElementById(id);
    	if (divBLK.style.display === "block")
    	{
    		divBLK.style.display = "none";
    	}
	}
	
	function viewAll()
	{
		hidePart("newProduct");
		showPart("allProducts");
		hidePart("stockin");
		fetchProducts(0);
		updatePageIndicator();
	}
	
	function newProduct()
	{
		showPart("newProduct");
		hidePart("allProducts");
		hidePart("stockin");
	}
	
	function stockIn()
	{
		hidePart("newProduct");
		hidePart("allProducts");
		showPart("stockin");
	}
	
	function checkIfExist(id) {
		  let urlExist = "http://localhost:8080/products/exist-" + id;
    	  var xmlhttp;
     	  if(window.XMLHttpRequest)
    			xmlhttp = new XMLHttpRequest();
    	  else
    			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    		
    	  xmlhttp.onreadystatechange=function()
    	  {
    		  console.log("xmlhttp.readyState = " + xmlhttp.readyState);
    		  console.log("xmlhttp.responseText=" + xmlhttp.responseText);
    		  console.log("xmlhttp.responseURL=" + xmlhttp.responseURL);
    		  console.log("xmlhttp.status=" + xmlhttp.status);
    		  
    		  // way 1
    		  if(xmlhttp.readyState == 4 && xmlhttp.status == 200)
    		  {
    			  if (xmlhttp.responseText == "true")
    				  isExist = true;
    			  else
    				  isExist = false;
    		  }
    	   }
    	   xmlhttp.open("GET", urlExist, false);
    	   xmlhttp.send();
	}
	
	function createProduct(event) {
		  event.preventDefault(); // Prevent default form submission
		// Get form data
		  var id = document.getElementById("id").value;
		  var name = document.getElementById("name").value;
		  var type = document.getElementById("type").value;
		  var price = document.getElementById("price").value;
		  var quantity = document.getElementById("quantity").value;
		  var symbol = document.getElementById("symbol").value;

		  let res = checkIfExist(id);
		  if(isExist == true)
		 {
		      $('#errorModal').modal('show');
		      $('#errorMessage').text("Duplicate ID");
		      return false;
	      }
		  var productData = {
		    id: id,
		    name: name,
		    type: type,
		    price: price,
		    quantity: quantity,
		    symbol: symbol
		  };
		console.log(JSON.stringify(productData));
		  // Send POST request with product data (assuming jQuery is included)
		  $.ajax({
		    url: "http://localhost:8080/products",
		    type: "POST",
		    data: JSON.stringify(productData),
		    contentType: "application/json; charset=utf-8",
		    success: function(response) {
		      $('#successModal').modal('show'); 
		      $('#successMessage').text("Create product success");
		    },
		    error: function(jqXHR, textStatus, errorThrown) {
		      var errorMessage = jqXHR.responseJSON ? jqXHR.responseJSON.message : "An error occurred while creating the product.";
		      $('#errorModal').modal('show');
		      $('#errorMessage').text(errorMessage);
		    }
		  });

		  return false;
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
		if (wCurrentPage == 1)
			hidePart("prevButton");
		else
			showPart("prevButton");
		showPart("nextButton");
	}
	
	function onNextButtonClicked()
	{
		if (wCurrentPage == wTotalPages)
			return;
		wCurrentPage = wCurrentPage+1;
		fetchProducts(wCurrentPage -1);
		updatePageIndicator();
		if (wCurrentPage >= wTotalPages)
			hidePart("nextButton");
		else
			showPart("nextButton");
		showPart("prevButton");
	}
	
	window.onload = fetchProducts(0); // Call the function when the page loads
	
	$(document).ready(function() {
			if (wCurrentPage == 1)
				hidePart("prevButton");
			if (wCurrentPage >= wTotalPages)
				hidePart("nextButton");
			updatePageIndicator();
		});
</script>

</head>
<body>


    <div id="particles-js" style="position:absolute; top:0; right:0; bottom:0; left:0; z-index:1;"></div>
    <div class="container-fluid" style="position:relative; z-index:2;">
    <div class="row">
        <div class="col-md-12">
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="navbar-toggler-icon"></span>
                </button> 
                <a class="navbar-brand navbar-light">Enterprise Project</a>
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="navbar-nav">
                       <li class="nav-item dropdown">
                			<a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    			Warehouse
               				</a>
                			<div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                    			<a class="dropdown-item" onclick="viewAll()">View All</a>
                    			<a class="dropdown-item" onclick="newProduct()">New Product</a>
                    			<a class="dropdown-item" onclick="stockIn()">Stock In</a>
                			</div>
            			</li>
                        <li class="nav-item">
                             <a class="nav-link" href="OrderPage">Order</a>
                        </li>
                        <li class="nav-item">
                             <a class="nav-link" href="TaskPage">Delivery</a>
                        </li>
                    </ul>
                    <ul class="navbar-nav ml-md-auto">
                        <li class="nav-item active">
                             <a class="nav-link" href="#">
                             <strong>
                             ACCOUT
                             </strong>
                             <span class="sr-only">(current)MA</span></a>
                        </li>
                        
                        <!-- <form class="form-inline" role="form" action="LogoutServlet">
                        <button  type="submit" class="btn btn-primary my-2 my-sm-0">LOGOUT</button>
                        </form> -->
                    </ul>
                </div>
            </nav>
        </div>
    </div>
    
<div class="row" id="allProducts" style="display: block;">
<div class="col-md-1"></div>
<div class="col-md-10 mx-auto">
<b id="pageIndicator"></b>
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
  
      <div class="btn-container prev-btn">
      <button type="button" class="btn btn-primary" id="prevButton" style="display: block;" onclick="onPrevButtonClicked()">PREV</button>
    </div>
    <div class="btn-container next-btn">
      <button type="button" class="btn btn-primary" id="nextButton" style="display: block;" onclick="onNextButtonClicked()">NEXT</button>
    </div>
</div>
<div class="col-md-1"></div>
</div>

<div class="row" id="stockin" style="display: none;">
	<div class="col-md-2"></div>
	<div class="col-md-8 mx-auto">
	<h2>Stock In</h2>
	<button type="button" class="btn btn-primary" onclick="submitStockIn()">Stock In</button>
	<table class="table table-striped mt-2">
    <thead>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Quantity</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
   </tbody>
  </table>
  <button type="button" class="btn btn-primary" id="addRowBtn" style="float: right;">Add Product</button>
</div>
	<div class="col-md-2"></div>
</div>
    
<div class="row" id="newProduct" style="display: none;">
<div class="col-md-4"></div>
<div class="col-md-4 mx-auto">
	<h2>Create New Product</h2>
    <form onsubmit="createProduct(event)">
      <div class="form-group">
        <label for="id">ID:</label>
        <input type="number" class="form-control" id="id" name="id" placeholder="Enter ID (if applicable)" min="1" max="999">
      </div>
      <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" class="form-control" id="name" name="name" placeholder="Enter product name">
      </div>
      <div class="form-group">
        <label for="type">Type:</label>
        <select class="form-control" id="type" name="type">
          <option value="NonWeight">NonWeight</option>
          <option value="Weight">Weight</option>
        </select>
      </div>
      <div class="form-group">
        <label for="price">Price (*100):</label>
        <input type="number" class="form-control" id="price" name="price" placeholder="Enter price" min="1" max="99999999">
      </div>
      <div class="form-group">
        <label for="quantity">Quantity:</label>
        <input type="number" class="form-control" id="quantity" name="quantity" placeholder="Enter quantity" min="1" max="99999999">
      </div>
      <div class="form-group">
        <label for="symbol">Symbol:</label>
        <input type="text" class="form-control" id="symbol" name="symbol" placeholder="Enter symbol">
      </div>
 	 <button type="submit" class="btn btn-primary">Create</button>
    </form>
</div>
<div class="col-md-4"></div>
</div>


    
</div>

<script type="text/javascript">
var addRowBtn = document.getElementById("addRowBtn");

function submitStockIn()
{
	let tableBody = document.getElementById("stockin").getElementsByTagName("tbody")[0];
	  let productList = []; // Array to store product data

	  // Loop through all rows in the table body
	  for (let i = 0; i < tableBody.rows.length; i++) {
	    let row = tableBody.rows[i];
	    let cells = row.cells;

	    // Extract data from each cell, assuming the ID is in the first cell, name in the second, and quantity in the third
	    let id = cells[0].querySelector('input').value; // Assuming input fields are within cells
	    let name = cells[1].querySelector('input').value;
	    let quantity = cells[2].querySelector('input').value;
	    
	    if(name == "Product not found" || name == "Error fetching name")
	    	continue;

	    // Create a product object with extracted data
	    let product = {
	      id: id,
	      name: name,
	      type: "NonWeight", // uselesss no need is server
	      price: "0", // uselesss
	      quantity: quantity,
	      symbol: "JJ" //uselesss
	    };

	    // Add the product object to the list
	    productList.push(product);
	  }

	  // Send the product list to the server for update (replace with your actual server-side logic)
	  fetch('http://localhost:8080/products/stockin', {
	    method: 'POST', // Specify POST for updates
	    headers: {
	      'Content-Type': 'application/json' // Set content type for JSON data
	    },
	    body: JSON.stringify(productList) // Convert product list to JSON string
	  })
	  .then(response => {
	    if (response.ok) {
	      console.log("Stock updated successfully");
	      $('#successModal').modal('show'); 
	      $('#successMessage').text("Stock updated successfully");
	      // if ok, clear table
	    	for (let i = 0; i < tableBody.rows.length; i++) {
	    		let row = tableBody.rows[i];
	    		tableBody.removeChild(row);
	    	}
	    } else {
	      console.error("Error updating stock:", response.statusText);
	      $('#errorModal').modal('show');
	      $('#errorMessage').text(response.statusText);
	    }
	  })
	  .catch(error => {
	    console.error("Error sending request:", error);
	      $('#errorModal').modal('show');
	      $('#errorMessage').text(error);
	  });
}

function deleteStockInRow(obj)
{
    console.log(parseInt(obj.children[0].innerText));
    var tableBody = document.getElementById("stockin").getElementsByTagName("tbody")[0];
    tableBody.removeChild(obj);
}

addRowBtn.addEventListener("click", function() {
  let tableBody = document.getElementById("stockin").getElementsByTagName("tbody")[0];
  let newRow = tableBody.insertRow();

  // Create cells for ID, Name (readonly), and Quantity
  let cell1 = newRow.insertCell();
  let cell2 = newRow.insertCell();
  let cell3 = newRow.insertCell();
  
  
  let deleteCell = newRow.insertCell();   // Add a new cell for the "Delete" button
  deleteCell.classList.add("text-center"); // Optional: Center the button
  let deleteButton = document.createElement("button");
  deleteButton.classList.add("btn", "btn-danger", "btn-sm"); // Bootstrap classes for button style
  deleteButton.textContent = "Delete";
  deleteButton.addEventListener("click", function() {
	  deleteStockInRow(newRow);	});
  // Add the button to the delete cell
  deleteCell.appendChild(deleteButton);

  // Add input field for ID with event listener for automatic lookup
  cell1.innerHTML = '<input type="number" class="form-control id-input" placeholder="Enter ID">';
  var idInput = cell1.querySelector('.id-input'); // Cache reference to input field
  idInput.addEventListener('keyup', function(event) {
	  console.log('keyup');
	  console.log(event.keyCode);
     {
      let url = 'http://localhost:8080/products/get-' + idInput.value;
      console.log(url);
      fetch( url, {
		    method: 'GET',
		    headers: {
		        'Content-Type': 'application/json'
		    },
		})
        .then(response => response.json())
        .then(data => {
         console.log(data.name)
          if (data.name) {
            cell2.innerHTML = '<input type="text" class="form-control" value="' + data.name + '" readonly>';
          } else {
            cell2.innerHTML = '<input type="text" class="form-control" value="Product not found" readonly>';
          }
        })
        .catch(error => {
          console.error("Error fetching product name:", error);
          cell2.innerHTML = '<input type="text" class="form-control" value="Error fetching name" readonly>';
        });
    }
  });

  // Add input field for quantity
  cell3.innerHTML = '<input type="number" class="form-control" placeholder="Enter quantity" min="1" max="9999999">';
});
</script>

<div class="modal fade" id="successModal" tabindex="-1" role="dialog" aria-labelledby="successModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="successModalLabel">Product Created</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p id="successMessage"></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="errorModal" tabindex="-1" role="dialog" aria-labelledby="errorModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="errorModalLabel">Error</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p id="errorMessage"></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

</body>
</html>