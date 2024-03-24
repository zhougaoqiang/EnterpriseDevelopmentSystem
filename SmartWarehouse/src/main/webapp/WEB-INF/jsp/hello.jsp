<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
<title>Login</title>
</head>
<body>

<% Object message = request.getAttribute("message");
   if(message!=null && !"".equals(message)){%>
   <script type="text/javascript">
   alert("<%=message%>");
   </script>
   <%}%>
   
<div id="particles-js" style="position:absolute; top:0; right:0; bottom:0; left:0; z-index:1;"></div>
<div class="container py-5" style="position:relative; z-index:2;">
    <div class="row">
        <div class="col-md-12 col-lg-12">
            <div class="row">
                <div class="col-md-6 col-lg-6 mx-auto">
                
                    <!-- form card login -->
                    <div class="card rounded-0">
                        <div class="card-header">
                            <h3 class="mb-0">Login</h3>  <!-- md: middle desktop, lg: larger desktops, sm: small tablets -->
                        </div>
                        <div class="card-body">
                            <form class="needs-validation" role="form" action="LoginServlet" autocomplete="off" id="formLogin" method="POST" novalidate>
                                <div class="form-group">
                                    <label for="id">Username</label>
                                    <input type="text" class="form-control form-control-lg rounded-0" name="id" id="id" required>
                                    <div class="invalid-feedback">Oops, you missed this one.</div>
                                </div>
                                <div class="form-group">
                                    <label>Password</label>
                                    <input type="password" class="form-control form-control-lg rounded-0" name="password" id="password" required>
                                    <div class="invalid-feedback">Enter your password too!</div>
                                </div>
                                <div>
                                    <p>No account? <a href="Register.jsp">Register</a></p>
                                </div>
                                <div>
                                    <a href="ResetPassword.jsp">Reset Password</a>
                                </div>

                                <button type="submit" class="btn btn-outline-primary btn-lg float-right" id="btnLogin" value="Submit">Login</button>
                            </form>
                            
                            
                            <script>
                            (function() {
                                'use strict';
                                 window.addEventListener('load', function() {
                                	    // Fetch all the forms we want to apply custom Bootstrap validation styles to
                                    var forms = document.getElementsByClassName('needs-validation');
                                    // Loop over them and prevent submission
                                    var validation = Array.prototype.filter.call(forms, function(form) {
                                    	   form.addEventListener('submit', function(event) {
                                    		    if (form.checkValidity() === false) {
                                    		    	  event.preventDefault();
                                    		    	  event.stopPropagation();
                                    		    	    }
                                    		    form.classList.add('was-validated');
                                    		    }, false);
                                    	    });
                                    }, false);
                                 })();
                            </script>
                        </div>
                        <!--/card-block-->
                    </div>
                    <!-- /form card login -->
                    
                 </div>
            </div>
            <!--/row-->
</div>
<!--/container-->
	</div>
</div>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/particles.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>