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
</style>
</head>
<body>
<div class="container-fluid" style="position:relative;">
<%@ include file="menu.jsp" %>

    
<div class="row" id="stockin">
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
    

</div>
    
<script type="text/javascript">
var addRowBtn = document.getElementById("addRowBtn");

function submitStockIn()
{
	let tableBody = document.getElementById("stockin").getElementsByTagName("tbody")[0];
	  let productList = []; // Array to store product data

	  // Loop through all rows in the table body
	  for (let i = 0; i < tableBody.rows.length; i++)
	  {
	    let row = tableBody.rows[i];
	    let cells = row.cells;

	    // Extract data from each cell, assuming the ID is in the first cell, name in the second, and quantity in the third
	    let id = cells[0].querySelector('input').value; // Assuming input fields are within cells
	    let name = cells[1].querySelector('input').value;
	    let quantity = cells[2].querySelector('input').value;
	    
	    if(name == "Product not found" || name == "Error fetching name")
	    	continue;
	    
	    if (isNaN(quantity) || typeof quantity === "undefined")
	    {
	    	  $('#errorModal').modal('show');
	    	  $('#errorMessage').text("Invalid quantity. Please enter a number.");
	    	  return;
	    }

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
	       tableBody.innerHTML="";
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
  cell3.innerHTML = '<input type="number" class="form-control" value="1" min="1" max="9999999">';
});
</script>
<%@ include file="modal.jsp" %>
</body>
</html>