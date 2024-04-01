<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"  import ="Definition.CommonConfiguration"%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
  <link rel="stylesheet" media="screen" href="style.css">
<% 
   String url = Definition.CommonConfiguration.GoogleMap.getUrl();
   if(url!=null && !"".equals(url)){
       out.println("<script src=\"" + url + "&libraries=places\"></script>");
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
%>

<script>
     var map;
     var seqIndicator;
     var markers = [];
     var index = new Number;
     var deleteIndex= new Number;
     var geocoder;
     var alreadyShowed;
     const uid <%out.println("=\""+UID+"\";");%>;
     
     <%
     String vip = (String)request.getSession().getAttribute("VIPExpireDate");
     if(vip !=null && !vip.isEmpty())
     {
         out.println("const maxMarkers = 50;");
     }
     else
     {
    	 out.println("const maxMarkers = 10;"); //determine by server
     }
     %>

     
     function initMap() {
        var mapOptions = {
                zoom: 11,
                center: new google.maps.LatLng(1.3521, 103.8198),
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                minZoom: 11
          };
         map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions);
         google.maps.event.addListener(map, 'rightclick', function(event) { placeMarker(event.latLng); });
         
         geocoder = new google.maps.Geocoder();
         seqIndicator = 1;
         index = 1;
         autocomplete = new google.maps.places.Autocomplete(document.getElementById('postalCodeText')); //initial autocomplete
    }
     
     function placeMarker(location) {
    	if(index > maxMarkers){
    		if(maxMarkers == 50) { //vip
    			alert("Cannot add more position!");
    			return;
    		}
    		
    		alert("Cannot add more position! You can upgrade to VIP to get 50 positions");
    		return;
    	}
     
    	 
    	 var marker = new google.maps.Marker({
    	    position: location,
    	    map: map,
    	    title: "Marker " + seqIndicator
    	  });
    	var infowindow = new google.maps.InfoWindow({
    		    content: 'Latitude: ' + location.lat() +
    		    '<br>Longitude: ' + location.lng() + '<br>title: ' + marker.title
    		  });
    	//infowindow.open(map,marker);
    	markers.push(marker);
    	updateTable(marker);
        seqIndicator++;
        index++;
        }
     
     function addResponse(location, markerTitle) {
         if(index > maxMarkers){
             if(maxMarkers == 50) { //vip
                 alert("Cannot add more position!");
                 return;
             }
             
             alert("Cannot add more position! You can upgrade to VIP to get 50 positions");
             return;
         }
      
         mTitle = markerTitle.substring(0, 40) + '...'
          var marker = new google.maps.Marker({
             position: location,
             map: map,
             title: mTitle
           });
         var infowindow = new google.maps.InfoWindow({
                 content: 'Latitude: ' + location.lat() +
                 '<br>Longitude: ' + location.lng() + '<br>title: ' + marker.title
               });
         //infowindow.open(map,marker);
         markers.push(marker);
         updateTable(marker);
         seqIndicator++;
         index++;
     }
     
    	// Sets the map on all markers in the array.
    	function setMapOnAll(map) {
    	  for (let i = 0; i < markers.length; i++) {
    	    markers[i].setMap(map);
    	  }
    	}
    	
    	// Removes the markers from the map, but keeps them in the array.
    	function hideMarkers() {
    	  setMapOnAll(null);
    	}

    	// Shows any markers currently in the array.
    	function showMarkers() {
    	  setMapOnAll(map);
    	}

    	// Deletes all markers in the array by removing references to them.
    	function deleteMarkers() {
    	  hideMarkers();
    	  markers = [];
    	}
    	
    	function showFirstPointAlert()
    	{
    		if(alreadyShowed == false)
    		{
    	         let div = document.getElementById("firstPointAlert");
    	         div.setAttribute("class", "alert alert-success alert-dismissible fade show ml-3");
    	         div.innerHTML='';
    	         div.innerHTML="<button type=\"button\" class=\"close\" data-dismiss=\"alert\">&times;</button> \
    	            <small>The first marker will be your starting location</small>";
    		}
    		alreadyShowed = true;
    	}
    	
    	function updateTable(marker) {
    		if (seqIndicator == 1) //no need to create header
    		{
    			var thead = document.getElementById("MarkerTableHead");
    			var tr = document.createElement("tr");
                thead.appendChild(tr);
                var th0 = document.createElement("th");
                th0.innerText = "#";
                tr.appendChild(th0);
                var th1 = document.createElement("th");
    			th1.innerText = "Title";
    			tr.appendChild(th1);
    			var th2 = document.createElement("th");
                th2.innerText = "Latitude";
                tr.appendChild(th2);
                var th3 = document.createElement("th");
                th3.innerText = "Longitude";
                tr.appendChild(th3);
                var th4 = document.createElement("th");
                th4.innerHTML = "<a href='#' onclick='deleteMarkerWholeTable()'>Delete All</a>";
                tr.appendChild(th4);
                
                showFirstPointAlert();
    		}
    		   
            var tbody = document.getElementById("MarkerTableBody");
            var tr = document.createElement("tr");
            tbody.appendChild(tr);
            var td0=document.createElement("td");
            var td1=document.createElement("td");
            td1.setAttribute("contenteditable", "true");
            td1.setAttribute("id", "Marker"+seqIndicator);
            var td2=document.createElement("td");
            var td3=document.createElement("td");
            var td4=document.createElement("td");
            tr.appendChild(td0);
            tr.appendChild(td1);
            tr.appendChild(td2);
            tr.appendChild(td3);
            tr.appendChild(td4);
            td0.innerText=index;
            td1.innerText=marker.title;
            td2.innerText=parseFloat(marker.position.lat()).toFixed(4);
            td3.innerText=parseFloat(marker.position.lng()).toFixed(4);
            td4.innerHTML="<a href='#' onclick='deleteMarkerTableRow(this)'>delete</a>"; 
    }
    	
    function deleteMarkerWholeTable() {
    	var thead = document.getElementById("MarkerTableHead");
    	thead.innerHTML = "";
    	var tbody = document.getElementById("MarkerTableBody");
    	tbody.innerHTML = "";
    	seqIndicator = 1;
    	index =1;
    	deleteMarkers();
    }
    
    function deleteSingleMarkerByIndex(deteleIndex){
        hideMarkers();
        console.log("get index " + deteleIndex);
        let newMarkers = [];
        console.log("before delete markers.length " + markers.length);
        for(let i = 0; i < markers.length; i++)
        {
            console.log(markers[i].title);
        }
        
        console.log(typeof(deteleIndex));
        newMarkers = markers.splice(deteleIndex, 1);
        showMarkers();
    }
    
    function deleteMarkerTableRow(obj) {
       let tr=obj.parentNode.parentNode;
       let table=tr.parentNode;
       table.removeChild(tr);
       deteleIndex = parseInt(tr.children[0].innerText) - 1;
       deleteSingleMarkerByIndex(deteleIndex);
       index--;
       updateTableIndex();
    }
    
    function updateTableIndex(){
    	var tbody = document.getElementById("MarkerTableBody");
    	var trs = tbody.children;
    	for(let i = 0; i < trs.length; i++)
    	{
     		var grandson = trs[i].children;
    		grandson[0].innerText=i+1;
    	}
    }
    
    //work with key only
    function addPostalCode(){
        let address = document.getElementById("postalCodeText").value;
        geocoder.geocode({
            region: 'SG',
            address: address
        }, function(result, status) {
            if (status == 'OK' && result.length > 0) {
            	addResponse(result[0].geometry.location, address);
            }
        });
        
        document.getElementById("postalCodeText").value = '';
    }
    
    function addPostalCodeList(postalCodeList){
        for(let i = 0; i < postalCodeList.length; i++)
        {
        	console.log(postalCodeList[i])
            geocoder.geocode({
                region: 'SG',
                address: postalCodeList[i]
            }, function(result, status) {
                if (status == 'OK' && result.length > 0) {
                	addResponse(result[0].geometry.location, postalCodeList[i]);
                }
            });
        }    }
    

    function openFile(event) {
         let input = event.target;
         let reader = new FileReader();
         reader.onload = function() {
             let text = reader.result;
             let postalCodeList = text.split('\n');
             postalCodeList = postalCodeList.filter(item=>item && item.trim()); //remove empty
             addPostalCodeList(postalCodeList);
         };
         reader.readAsText(input.files[0]);
    };
    
	function clearAllInfo()
	{
		deleteMarkerWholeTable();
		document.getElementById("taskTitle").value = "";
		showModal(true);
	}
	
	function showModal(show)
	{
		let mdl = document.getElementById("submitResultModal");
		if (show)
		{
			mdl.style.display = 'block';
		}
		else
		{
			mdl.style.display = 'none';
		}
	}
	
	function goHistory()
	{
		showModal(false);
	    var temp = document.createElement("form");
	    temp.action = "HistoryServlet";
	    temp.method = "get";
	    temp.style.display = "none";
	    document.body.appendChild(temp);
	    temp.submit();
	}
   
    function sendDataToServer(){
    	  if(index < 4)
    	  {
    	    alert("Please select more locations!");
    	    return;
    	  }

    	  let sendMarkers = [];
    	  let title = document.getElementById("taskTitle").value;
    	  if(title === "")
    	  {
      	    alert("If you'd like to avoid any confusion, please enter title!");
    	    return;
    	  }
    	  let rb = document.getElementById("needReturn").value;
    	  let algo = document.getElementById("TspAlgorithms").value;
    	  var markerTbl = document.getElementById("MarkerTable");
    	  for(let i = 0; i < markers.length; ++i)
    	  {
              let perPoint= {
    	      title : markerTbl.rows[i+1].cells[1].innerText,
    	      longitude : markers[i].position.lng(),
    	      latitude : markers[i].position.lat()
    	    }
    	    sendMarkers.push(perPoint);
    	  }
    	  
    	  let wait = document.getElementById("Wait").value;
    	  let async = false;
    	  if(wait == "Yes")
    		  async = true;
    	  
    	  let jsonData = {
    		UID: uid,
    		IsAsync: async,
    	    TaskTilte: title,
    	    /* Priority: pri, */
    	    IsReturnBack: rb,
  			Algorithm: algo,
    	    AllMarkers: sendMarkers
    	  };
    	  
    	  if(!async)
    	  {
    		  document.getElementById("TaskSubmitButton").disabled = true;
    	  }

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
    		  console.log("xmlhttp.readyState = " + xmlhttp.readyState);
    		  console.log("xmlhttp.responseText=" + xmlhttp.responseText);
    		  console.log("xmlhttp.responseURL=" + xmlhttp.responseURL);
    		  console.log("xmlhttp.status=" + xmlhttp.status);
    		  
    		  // way 1
    		  if(xmlhttp.readyState == 4 && xmlhttp.status == 200)
    		  {
    			  document.getElementById("TaskSubmitButton").disabled = false;
    	         /*  const response = JSON.parse(xmlhttp.responseText); */
    	          clearAllInfo();
    		  }
    		  else
    		  {
    		  }
    	   }
    		
    	   xmlhttp.open("POST", "NewTask", async);
    	   xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    	   xmlhttp.send(jsonString);

    	   //way 2
/*    	   fetch('NewTask', {
    		    method: 'POST',
    		    headers: {
    		        'Content-Type': 'application/json'
    		    },
    		    body: jsonString
    		})
    		.then(response => {
    			enableAllbuttons();
    		    if (!response.ok) {
    		        throw new Error('Network response was not ok');
    		    }
    		    alert(response.json());
    		})
    		.then(data => {
    		    // Handle the response from the Servlet if needed
    		    
    		})
    		.catch(error => {
    		    console.error('There was a problem with the fetch operation:', error);
    		}); */
    	}
    
    google.maps.event.addDomListener(window, 'load', initMap);
    alreadyShowed = false;
</script>

<title>Main Task</title>
</head>
<body>

    <div id="particles-js" style="position:absolute; top:0; right:0; bottom:0; left:0; z-index:1;"></div>
    <div class="container-fluid" style="position:relative; z-index:2;">
    <div class="row">
        <div class="col-md-12">
            <nav class="navbar navbar-expand-lg navbar-light bg-light" style="background-color:transparent !important;">
                 
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="navbar-toggler-icon"></span>
                </button> <a class="navbar-brand">DR.POS</a>
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="navbar-nav">
                        <li class="nav-item active">
                             <a class="nav-link">NEW TASK <span class="sr-only">(current)</span></a>
                        </li>
                        <li class="nav-item">
                             <a class="nav-link" href="History">HISTORY</a>
                        </li>
                        <li class="nav-item">
                             <a class="nav-link" href="Help">HELP</a>
                        </li>
<!--                        <li class="nav-item dropdown">
                             <a class="nav-link dropdown-toggle" href="http://example.com" id="navbarDropdownMenuLink" data-toggle="dropdown">Dropdown link</a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                                 <a class="dropdown-item" href="#">Action</a> <a class="dropdown-item" href="#">Another action</a> <a class="dropdown-item" href="#">Something else here</a>
                                <div class="dropdown-divider">
                                </div> <a class="dropdown-item" href="#">Separated link</a>
                            </div>
                        </li> -->
                    </ul>
<!--                    <form class="form-inline">
                        <input class="form-control mr-sm-2" type="text" /> 
                        <button class="btn btn-primary my-2 my-sm-0" type="submit">
                            Search
                        </button>
                    </form> -->
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
                             <span class="sr-only">(current)MA</span></a>
                        </li>
<!--                        <li class="nav-item dropdown">
                             <a class="nav-link dropdown-toggle" href="http://example.com" id="navbarDropdownMenuLink" data-toggle="dropdown">Dropdown link</a>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenuLink">
                                 <a class="dropdown-item" href="#">Action</a> <a class="dropdown-item" href="#">Another action</a> <a class="dropdown-item" href="#">Something else here</a>
                                <div class="dropdown-divider">
                                </div> <a class="dropdown-item" href="#">Separated link</a>
                            </div>
                        </li> -->
                        
                        <form class="form-inline" role="form" action="LogoutServlet">
                        <!--  <input class="form-control mr-sm-2" type="text" /> -->
                        <button  type="submit" class="btn btn-primary my-2 my-sm-0">LOGOUT</button>
                        </form>
                    </ul>
                </div>
            </nav>
        </div>
    </div>
    <div class="row">
        
        
        
        <div class="col-md-7">
            <div id="map-canvas" style="height: 500px; min-width: 400px; width:100%" class="mt-3">
           </div>
        </div>
        
        
        
        
        
        <!--  -->
        <div class="col-md-5">
            <div class="row">
               <div class="col-md-5 col-lg-5">
                	<div class="input-group mb-3 mt-3">
                    <input id="postalCodeText" type="text" class="form-control" placeholder="Address">
                    <div class="input-group-append">
                    <button class="btn btn-secondary" onclick="addPostalCode()">Add</button>
                    </div>
                	</div>
                </div>
                <div class="col-md-7">
                <!--                    <label for="exampleInputFile">
                        Load point from file
                    </label> -->
                    <input type="file" class="form-control-file mt-4" id="exampleInputFile" onchange='openFile(event)'/>
<!--                    <p class="help-block">
                        Example block-level help text here.
                    </p> -->
                </div>
            </div>
            
            <div id="accordion">
				<div class="card">
  				<div class="card-header">
    			<a class="card-link" data-toggle="collapse" href="#collapseOne">
     			Task Details
    			</a>
  				</div>
  				<div id="collapseOne" class="collapse show" data-parent="#accordion">
    			<div class="card-body">
      					        <div class="form-group">
                                    <label for="taskTitle">Title</label>
                                    <input type="text" class="form-control form-control-lg rounded-0" name="taskTitle" id="taskTitle">
                                </div>
                                <div class="form-group">
                                    <label>Return</label>
                                    <select id="needReturn" class="form-control">
      			     				<option value="Yes">Yes</option>
                     				<option value="No">No</option>
      								</select>
                                </div>
                                <div class="form-group">
                                    <label>Algorithm</label>
                  					<select id="TspAlgorithms" class="form-control">
                     				<option value="Auto">Auto</option>
                     				<option value="Quick">Quick</option>
                     				<option value="Best">Best</option>
      								</select>
                                </div>
                                <div class="form-group">
                                    <label>Wait</label>
                                    <select id="Wait" class="form-control">
                     				<option value="Yes">Yes</option>
                     				<option value="No">No, submit next plan</option>
                 					</select>
                                </div>
                                
    			</div>
				</div>
				</div>
			</div>
            
            <div class="row mt-3">
                    <div id="firstPointAlert">
                    </div>
            </div>
            

            <form id="MarkerForm">
            <div class="table-wrapper-scroll-y my-custom-scrollbar">
            <table id="MarkerTable" class="table table-striped table-hover table-sm">
                <thead id="MarkerTableHead"></thead>
                <tbody id="MarkerTableBody"></tbody>
            </table>
            </div>
            </form>
            
            <div class="row mt-3">
                <div class="col"></div>
                <div class="col"></div>
                <div class="col"></div>
                <div class="col">
                    <button id="TaskSubmitButton" type="button" class="btn btn-primary mb-3" onclick="sendDataToServer()">
                    <span class="spinner-border spinner-border-sm">SUBMIT</span>
                    </button>
                </div>
            </div>

	<div class="modal" id="submitResultModal">
    <div class="modal-dialog modal-sm">
    <div class="modal-content">
        <div class="modal-header">
        <h5 class="modal-title">Submitted</h5>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <div class="modal-body">
        <p>Please Check In History!</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="goHistory()">Go History</button>
          <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="showModal(false)">Close</button>
        </div>
    </div>
    </div>
    </div>
    </div>
    </div>
</div>
    <script src="js/particles.js"></script>
    <script src="js/app.js"></script>
</body>
</html>