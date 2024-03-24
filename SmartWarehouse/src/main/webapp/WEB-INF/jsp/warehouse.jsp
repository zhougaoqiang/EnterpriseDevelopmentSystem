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
<!--   <link rel="stylesheet" media="screen" href="style.css"> -->

<title>Warehouse N Delivery System</title>
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
<!--                         <li class="nav-item active">
                             <a class="nav-link">Warehouse<span class="sr-only">(current)</span></a>
                        </li> -->
                       <li class="nav-item dropdown">
                			<a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    			Warehouse
               				</a>
                			<div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                    			<a class="dropdown-item" href="#" onclick="viewAll()">View All</a>
                    			<a class="dropdown-item" href="#" onclick="newProduct()">New Product</a>
                    			<a class="dropdown-item" href="#" onclick="stockIn()">Stock In</a>
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
                             ZHOU GAOQIANG
                             </strong>
                             <span class="sr-only">(current)MA</span></a>
                        </li>
                        
                        <form class="form-inline" role="form" action="LogoutServlet">
                        <!--  <input class="form-control mr-sm-2" type="text" /> -->
                        <button  type="submit" class="btn btn-primary my-2 my-sm-0">LOGOUT</button>
                        </form>
                    </ul>
                </div>
            </nav>
        </div>
    </div>
	</div>


</body>
</html>