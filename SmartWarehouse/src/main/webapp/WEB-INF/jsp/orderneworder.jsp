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
.form-control[type="number"]::-webkit-inner-spin-button,
.form-control[type="number"]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0; /* Optional: Remove margin for better alignment */
}
</style>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCOVkQCJBsUmAMIMFnaNIvP9lXOZkHLDDg&libraries=places">
</script>

<script type="text/javascript">
const googleMapAPIKey = "${apiKey}";
var currentLocation = {
			lat : 0.0,
			lng : 0.0,
};

function initAutocomplete() {
  console.log('initAutocomplete');
  autocomplete = new google.maps.places.Autocomplete(document.getElementById('addressInput'));
  autocomplete.addListener('place_changed', () => {
	    const place = autocomplete.getPlace();
	    currentLocation.lat = place.geometry.location.lat();
	    console.log(currentLocation.lat);
	    currentLocation.lng = place.geometry.location.lng();
	    console.log(currentLocation.lng);
	    });
}

var orderID = ${newOrderId};
function regenerateOrderId() {
	let pUrl= 'http://localhost:8080/orders/generateOrderId';
	console.log(pUrl)
	  $.ajax({
	    url: pUrl,
	    type: "GET", // Use GET for fetching data
	    success: function(data) {
	    	console.log(data);
	    	document.getElementById("newOrderID").innerHTML = "New Order : " + data;
	    },
	    error: function(jqXHR, textStatus, errorThrown) {
	      console.error("Error fetching products:", textStatus, errorThrown);
	    }
	  });
	}
	
function submitNewOrder()
{
	console.log("call submit new order");
	let tableBody = document.getElementById("newOrderTable").getElementsByTagName("tbody")[0];
	let itemList = []; // Array to store product data

	  // Loop through all rows in the table body
	  for (let i = 0; i < tableBody.rows.length; i++)
	  {
	    let row = tableBody.rows[i];
	    let cells = row.cells;

	    // Extract data from each cell, assuming the ID is in the first cell, name in the second, and quantity in the third
	    let id = cells[0].querySelector('input').value; // Assuming input fields are within cells
	    let name = cells[1].querySelector('input').value;
	    let price = cells[2].querySelector('input').value;
	    let symbol = cells[3].querySelector('input').value;
	    let quantity = cells[4].querySelector('input').value;
	    let totalPrice = cells[5].querySelector('input').value;
	    
	    if(name == "Product not found" || name == "Error fetching name")
	    	continue;
	    
	    if (isNaN(quantity) || typeof quantity === "undefined")
	    {
	    	  $('#errorModal').modal('show');
	    	  $('#errorMessage').text("Invalid quantity. Please enter a number.");
	    	  return;
	    }
	    if (isNaN(totalPrice) || typeof quantity === "undefined" || totalPrice == 0)
	    {
	    	  $('#errorModal').modal('show');
	    	  $('#errorMessage').text("Invalid total price. Please check");
	    	  return;
	    }
	    // Create a product object with extracted data
	    let item = {
	      itemId:parseInt(id),
	      price: parseInt(price),
	      quantity: parseInt(quantity),
	      symbol: symbol,
	   	  totalPrice: parseInt(totalPrice)
	    };

	    // Add the product object to the list
	    itemList.push(item);
	  }

	let np = parseInt(document.getElementById("totalPriceInput").value);
	let ap = parseInt(document.getElementById("actualPriceInput").value);
	const now = new Date();
	const utcString = now.toLocaleTimeString();
	console.log(utcString); // Output: Fri, 24 Mar 2024 12:23:37 G
	let orderHeader = {
			id: parseInt(orderID), 
			nominalPrice: np,
			actualPrice: ap,
			deliveryStatus: "Pending",
			datetime: utcString,
			address: document.getElementById('addressInput').value,
			longitude: currentLocation.lng,
			latitude: currentLocation.lat
	}
	
	let order = {
		orderHeader: orderHeader,
		orderItems: itemList
	}

	console.log(JSON.stringify(order));
	  // Send the product list to the server for update (replace with your actual server-side logic)
	  fetch('http://localhost:8080/orders', {
	    method: 'POST', // Specify POST for updates
	    headers: {
	      'Content-Type': 'application/json' // Set content type for JSON data
	    },
	    body: JSON.stringify(order) // Convert product list to JSON string
	  })
	  .then(response => {
	    if (response.ok) {
	      console.log("Stock updated successfully");
	      $('#successModal').modal('show'); 
	      $('#successMessage').text("Stock updated successfully");
	      // if ok, clear table
	       tableBody.innerHTML="";
	       document.getElementById("totalPriceInput").value = 0;
	       document.getElementById("actualPriceInput").value = 0;
	       document.getElementById("addressInput").value = 0;
	       regenerateOrderId();
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

google.maps.event.addDomListener(window, 'load', initAutocomplete);
</script>
</head>
<body>
<div class="container-fluid" style="position:relative;">
<%@ include file="menu.jsp" %>

    
<div class="row" id="newOrderTable">
	<div class="col-md-1"></div>
	<div class="col-md-10 mx-auto">
	<h3 id="newOrderID">New Order : ${newOrderId}</h3>
	
	<form class="form-inline" style="display: flex; justify-content: space-between;">
      <div class="form-group mb-2">
        <label for="addressInput">Address:</label>
        <input type="text" class="form-control" id="addressInput" placeholder="Enter Address">
      </div>
      <div class="form-group mb-2">
        <label for="totalPriceInput">Nominal Price ($):</label>
        <input type="number" class="form-control" id="totalPriceInput" value="0" min="0" readonly>
      </div>
      <div class="form-group mb-2">
        <label for="actualPriceInput">Actual Price ($):</label>
        <input type="number" class="form-control" id="actualPriceInput" value="0" min="0">
      </div>
      <button type="submit" class="btn btn-primary mb-2" onclick="submitNewOrder(); event.preventDefault();">Submit</button>
    </form>
	
	<table class="table table-striped mt-2">
    <thead>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Price(cent)</th>
        <th>Symbol</th>
        <th>quantity</th>
        <th>Total Price</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
   </tbody>
  </table>
  <button type="button" class="btn btn-primary" id="addRowBtn" style="float: right;">Add Product</button>
</div>
	<div class="col-md-1"></div>
</div>
</div>

<script type="text/javascript">
var addRowBtn = document.getElementById("addRowBtn");
function updateTotalPrice() {
	  let tableBody = document.getElementById("newOrderTable").getElementsByTagName("tbody")[0];
	  let totalPrice = 0;

	  // Loop through all rows in the table body
	  for (let i = 0; i < tableBody.rows.length; i++) {
	    let row = tableBody.rows[i];
	    let cells = row.cells;
	    let cell6 = cells[cells.length - 2]; // Assuming cell6 is the second-last cell

	    // Extract the total price from cell6, handling potential errors
	    let cell6Value = parseFloat(cell6.querySelector('input').value) || 0;
	    totalPrice += cell6Value;
	  }

	  // Update the total price in the form
	  document.getElementById("totalPriceInput").value = totalPrice;
	}
	
function deleteStockInRow(obj)
{
    console.log(parseInt(obj.children[0].innerText));
    var tableBody = document.getElementById("newOrderTable").getElementsByTagName("tbody")[0];
    tableBody.removeChild(obj);
    updateTotalPrice();
}

addRowBtn.addEventListener("click", function() {
  let tableBody = document.getElementById("newOrderTable").getElementsByTagName("tbody")[0];
  let newRow = tableBody.insertRow();

  let cell1 = newRow.insertCell(); //id
  let cell2 = newRow.insertCell(); //name
  let cell3 = newRow.insertCell(); //unit price
  let cell4 = newRow.insertCell(); //symbol
  let cell5 = newRow.insertCell(); //quantity
  let cell6 = newRow.insertCell(); //total price
  
  
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
      let url = 'http://localhost:8080/orders/product-' + idInput.value;
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
         console.log(data.price)
         if (data.price) {
             cell3.innerHTML = '<input type="text" class="form-control" value="' + data.price + '" readonly>';
           } else {
             cell3.innerHTML = '<input type="text" class="form-control" value="Product not found" readonly>';
           }
         console.log("data.symbol")
         console.log(data.symbol)
         if (data.symbol) {
             cell4.innerHTML = '<input type="text" class="form-control" value="' + data.symbol + '" readonly>';
           } else {
             cell4.innerHTML = '<input type="text" class="form-control" value="Product not found" readonly>';
           }
        })
        .catch(error => {
          console.error("Error fetching product name:", error);
          cell2.innerHTML = '<input type="text" class="form-control" value="Error fetching name" readonly>';
          cell3.innerHTML = '<input type="text" class="form-control" value="Error fetching name" readonly>';
          cell4.innerHTML = '<input type="text" class="form-control" value="Error fetching name" readonly>';
        });
    }
  });

  // Add input field for quantity
  cell5.innerHTML = '<input type="number" class="form-control" value="0" min="1" max="9999999">';
  cell6.innerHTML = '<input type="number" class="form-control" value="0" readonly>';

  var quantityInput = cell5.querySelector('input'); // Select the input element directly
  quantityInput.addEventListener('keyup', function(event) {
	  console.log("detect keyup");
	  if (cell3.querySelector('input') && cell3.querySelector('input').value) 
    {
    	console.log("calcualte");
      let quantity = parseInt(quantityInput.value);
      let unitPrice = parseInt(cell3.querySelector('input').value); // Parse for decimals
      let totalPrice = quantity * unitPrice;
      console.log("totalPrice"+ totalPrice);
      cell6.querySelector('input').value = totalPrice;
      updateTotalPrice();
    } else {
      cell6.value = "-";
    }
  });
});
</script>
<%@ include file="modal.jsp" %>
</body>
</html>