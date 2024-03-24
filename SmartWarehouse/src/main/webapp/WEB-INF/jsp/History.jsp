<%@page import="Database.DBTask"%>
<%@page import="Database.TaskInfo"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"  import ="Definition.CommonConfiguration"%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
  <link href="https://cdn.bootcss.com/bootstrap-datetimepicker/4.17.47/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
  <link href="https://unpkg.com/gijgo@1.9.14/css/gijgo.min.css" rel="stylesheet" type="text/css" />
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
  <script src="https://unpkg.com/gijgo@1.9.14/js/gijgo.min.js" type="text/javascript">
  </script>
  
  <link rel="stylesheet" media="screen" href="style.css">
<% 
   String url = Definition.CommonConfiguration.GoogleMap.getUrl();
   if(url!=null && !"".equals(url)){
       out.println("<script src=\"" + url + "\"></script>");
   }
%>

<%
String UID = (String)request.getSession().getAttribute("UID");
String Name = (String)request.getSession().getAttribute("Name");
if(UID == null || UID.isEmpty() || Name == null || Name.isEmpty())
{
    response.sendRedirect("Login.jsp");
}

response.addHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setDateHeader("Expires", 0);
int nPages = DBTask.getInstance().countTaskList(UID, "", "");
int totalPages = 0;
if (nPages%10 == 0)
	totalPages = nPages / CommonConfiguration.maxRowsInPage;
else 
	totalPages = nPages / CommonConfiguration.maxRowsInPage + 1;

%>

<script>
     const uid <%out.println("=\""+UID+"\";");%>;
     var totalPages <%out.println("="+totalPages+";");%>;
     var currentPage = 1;
     <%
     String vip = (String)request.getSession().getAttribute("VIPExpireDate");
     %>
     
     function displayPage(cp, tp)
     {
    	 var curPage = document.getElementById("displayPage");
    	 curPage.innerText = cp + '/' + tp;
    	 return ;
     }
     

     function onClickViewOnMap(obj) {
       var temp = document.createElement("form");
       temp.action = "MapViewServlet";
       temp.method = "post";
       temp.target = "_blank"; 
       temp.style.display = "none";
      
       let tr=obj.parentNode.parentNode;
       let tds = tr.children;
       let title = tds[2].innerText;
       let needRtn = tds[4].innerText;
       
       let opt1 = document.createElement("textarea");
       opt1.name = "UID";
       opt1.value = uid;
       temp.appendChild(opt1);
       let opt2 = document.createElement("textarea");
       opt2.name = "Date";
       opt2.value = tds[1].innerText;
       temp.appendChild(opt2);
       let opt3 = document.createElement("textarea");
       opt3.name = "TaskTitle";
       opt3.value = tds[2].innerText;
       temp.appendChild(opt3);
       let opt4 = document.createElement("textarea");
       opt4.name = "NeedReturn";
       opt4.value = tds[4].innerText;
       temp.appendChild(opt4);
       console.log("submit to Map View");
       document.body.appendChild(temp);
       temp.submit();
       return temp;
     }
     
     function fetchTable(title, date)
     {
         let async = false;
         let jsonData = {
           UID: uid,
           TaskTitle: title,
           Date: date,
           Page: currentPage
         };
         let jsonString = JSON.stringify(jsonData);
         console.log(jsonString);
         var xmlhttp;
         if(window.XMLHttpRequest)
         {
               xmlhttp = new XMLHttpRequest();
         }
         else
         {
               xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
         }
           
         xmlhttp.onreadystatechange=function()
         {
             if(xmlhttp.readyState == 4 && xmlhttp.status == 200)
             {  
                const response = JSON.parse(xmlhttp.responseText);
                totalPages = response.TotalPages;
                currentPage = response.CurrentPage;
                let body=document.getElementById("HistoryTableBody");
                body.innerHTML = response.TableInfo;
                displayPage(currentPage, totalPages);
             }
             else
             {
             }
          }
           
          xmlhttp.open("POST", "History", async);
          xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
          xmlhttp.send(jsonString);
     }
     
     function onSearch()
     {
    	 currentPage = 1;
         let task = document.getElementById("taskTitle").value;
         let date = document.getElementById("datepicker").value;
         fetchTable(task, date);
     }
     
     function showAll()
     {
    	 fetchTable("", "");
    	 document.getElementById("taskTitle").value = "";
    	 document.getElementById("datepicker").value = "";
     }
     
     function onNoResetSearch()
     {
         let task = document.getElementById("taskTitle").value;
         let date = document.getElementById("datepicker").value;
         fetchTable(task, date);
     }
     
     function onPrevClicked()
     {
    	 if (currentPage == 1)
    		 return;
    	 
    	 currentPage = currentPage - 1;
    	 onNoResetSearch();
     }
     
     function onNextClicked()
     {
    	 if (currentPage == totalPages)
    		 return;
    	 
    	 currentPage = currentPage + 1;
    	 onNoResetSearch();
     }
</script>

<title>History</title>
</head>
<body>

<div id="particles-js" style="position:absolute; top:0; right:0; bottom:0; left:0; z-index:1;"></div>
<div class="container-fluid" style="position:relative; z-index:2;">
    <div class="row">
        <div class="col-md-12">
            <nav class="navbar navbar-expand-lg navbar-light bg-light" style="background-color:transparent !important;">
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="navbar-toggler-icon"></span>
                </button> <a class="navbar-brand" href="#">DR.POS</a>
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="navbar-nav">
                        <li class="nav-item">
                             <a class="nav-link" href="NewTask">NEW TASK</a>
                        </li>
                        <li class="nav-item active">
                             <a class="nav-link">HISTORY<span class="sr-only">(current)</span></a>
                        </li>
                        <li class="nav-item">
                             <a class="nav-link" href="Help">HELP</a>
                        </li>
                    </ul>
                    <ul class="navbar-nav ml-md-auto">
                        <li class="nav-item active">
                             <a class="nav-link" href="#">
                             <strong>
                             <%
                             String name = (String)request.getSession().getAttribute("Name");
                             out.println(name);
                             %>
                             </strong>
                             <%
                             if(vip !=null && !vip.isEmpty())
                             {
                                 out.println("<span class=\"badge badge-pill badge-warning\">" + vip + "</span>");
                             }
                             %>
                             <span class="sr-only">(current)</span></a>
                        </li>
                        <form class="form-inline" role="form" action="LogoutServlet">
                        <button  type="submit" class="btn btn-primary my-2 my-sm-0">LOGOUT</button>
                        </form>
                    </ul>
                </div>
            </nav>
        </div>
    </div>
    <div class="row mt-3">
         <div class="col-md-1 col-lg-1">
         </div>
         <div class="col-md-1 col-lg-1">
         <button type="button" class="btn btn-outline-primary" onclick='showAll()' style="width:100%">ALL</button>
         </div>
         <div class="col-md-2 col-lg-2">
         </div>
         <div class="col-md-2 col-lg-2">
         </div>
         <div class="col-md-2 col-lg-2">
         <form>
             <input id="datepicker" width="100%" />
             <script>
               $('#datepicker').datepicker({
                uiLibrary: 'bootstrap4' });
                 </script>
         </form>
         </div>
         <div class="col-md-2 col-lg-2 input-group ">
                <form>
                <div class="input-group">
                <input type="text" class="form-control" id="taskTitle">
                                <div class="input-group-append">
                <span class="input-group-text">Title</span>
                </div>
                </div>
                </form>
         </div>
         <div class="col-md-1 col-lg-1">
         <button type="button" class="btn btn-outline-primary" onclick='onSearch()' style="width:100%">Search</button>
         </div>
         <div class="col-md-1 col-lg-1">
         </div>
    </div>
    
    <div class="row mt-3">
         <div class="col-md-1 col-lg-1">
         </div>
            <div class="col-md-10 col-lg-10">
            <form id="HistoryForm">
            <table id="HistoryTable" class="table table-striped table-hover">
                <thead id="TistoryTableHead"></thead>
                          <tr>
                            <th>#</th>
                            <th>Date</th>
                            <th>Title</th>
                            <th>Method</th>
                            <th>Is Return</th>
                            <th>Status</th>
                            <th>Map</th>
                          </tr>
                <tbody id="HistoryTableBody">
                         <!--  <tr>
                            <td>1</td>
                            <td>2023-09-20</td>
                            <td>TK1</td>
                            <td>Auto</td>
                            <td>Yes</td>
                            <td>Completed</td>
                            <td><a href='#' onclick='viewOnMap(this)'>View On Map</a></td>
                          </tr> -->
                          
                          <% 
                          ArrayList<TaskInfo> array = DBTask.getInstance().searchTaskList(UID, "", "", 1);
                          for(int i = array.size() - 1, j = 1; i >=0 ; i--, j++)
                          {
                              TaskInfo info = array.get(i);
                              out.println("<tr>");
                              out.println("<td>" + j + "</td>");
                              out.println("<td>" + info.getDate() + "</td>");
                              out.println("<td>" + info.getTaskTitle() + "</td>");
                              out.println("<td>" + info.getDecisionString() + "</td>");
                              out.println("<td>" + (info.needRetrun() == true ? "Yes" : "No") + "</td>");
                              out.println("<td>" + info.getStatusString() + "</td>");
                              if (info.getStatusString().compareTo("Completed") == 0)
                                  out.println("<td><a href='#' onclick='onClickViewOnMap(this)'>View On Map</a></td>");
                              else
                                  out.println("<td>Not Applicated</td>");
                              out.println("</tr>");
                          }
                         %>
                 </tbody>
            </table>
            </form>
         </div>
         <div class="col-md-1 col-lg-1">
         </div>
    </div>
    
    <div class="row mt-3">
        <div class="col-md-9 col-lg-9"></div>
        <div class="col-md-3 col-lg-3">
            <ul class="pagination pagination-sm">
            <li class="page-item"><a class="page-link" href="#" onclick="onPrevClicked()">Prev</a></li>
            <li class="page-item"><a class="page-link" id="displayPage">
                <script> displayPage(currentPage, totalPages)</script>
                </a>
            </li>
            <li class="page-item"><a class="page-link" href="#" onclick="onNextClicked()">Next</a></li>
            </ul>
        </div>
    </div>

</div>
    <script src="js/particles.js"></script>
    <script src="js/app.js"></script>
</body>
</html>