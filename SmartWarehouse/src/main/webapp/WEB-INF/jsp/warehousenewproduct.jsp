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

<script type="text/javascript">

	var isExist = false;
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
}
</script>
</head>
<body>
<div class="container-fluid" style="position:relative;">
<%@ include file="menu.jsp" %>

<div class="row" id="newProduct">
<div class="col-md-4"></div>
<div class="col-md-4 mx-auto">
	<h3>Create New Product</h3>
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
        <label for="price">Price (cent):</label>
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

<%@ include file="modal.jsp" %>

</body>
</html>