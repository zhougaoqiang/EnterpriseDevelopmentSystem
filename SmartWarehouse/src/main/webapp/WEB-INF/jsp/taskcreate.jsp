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

<script>
     var map;
     var seqIndicator;
     var markers = [];
     var index = new Number;
     var deleteIndex= new Number;
     var geocoder;
     var alreadyShowed;
     
     var startLocation; //lat ,lng
     var startAddress = "";
     
     var needInitOrders = ${loadRequest};
     var initOrderIds  = ${orderIds}; 
     
     function initMap() {
        var mapOptions = {
                zoom: 11,
                center: new google.maps.LatLng(1.3521, 103.8198),
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                minZoom: 11,
                mapId: "DEMO_MAP_ID",
          };
         map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions);
         // google.maps.event.addListener(map, 'rightclick', function(event) { placeMarker(event.latLng); });
         
         geocoder = new google.maps.Geocoder();
         seqIndicator = 1;
         index = 1;
         autocomplete = new google.maps.places.Autocomplete(document.getElementById('startLocationInput'));
         initOrders();
    }
    
     
    async function initOrders() {
    	console.log(needInitOrders);
    	if (needInitOrders == true){
    		 for (const id of initOrderIds) {
    			 let url = "http://localhost:8080/orders/orderheader-" + id;
    			 await fetch(url).then(response => response.json())
    			        .then(data => {
    						console.log(data);
    						let location = new google.maps.LatLng(data.latitude, data.longitude);
    						let orderId = data.id;
    						addOrderResponse(location, orderId.toString());
    			        })
    			        .catch(error => {alert("Error fetching order:", error);});
    		 }
    	}
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
    	  
    	  if (startAddress.length > 0)
   		  {
    	     	const marker = new google.maps.Marker({
    	    	    map: map,
    	    	    position: startLocation,
    	    	    title: startAddress
    	    	  });
    	   }
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
    			th1.innerText = "Order";
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
                
                // showFirstPointAlert();
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
    
    function addOrder(){
        let order = document.getElementById("OrderIdInput").value;
        
        fetch("http://localhost:8080/orders/orderheader-" + order)
        .then(response => response.json())
        .then(data => {
			console.log(data);
			let location = new google.maps.LatLng(data.latitude, data.longitude);
			let orderId = data.id;
			addOrderResponse(location, orderId.toString());
        })
        .catch(error => {
            alert("Error fetching order:", error);
        });
        
        document.getElementById("OrderIdInput").value = '';
    }
    
    function addCompanyAddress(){
        let address = document.getElementById("startLocationInput").value;
        geocoder.geocode({
            region: 'SG',
            address: address
        }, function(result, status) {
            if (status == 'OK' && result.length > 0) {
                startLocation = result[0].geometry.location;
                startAddress = address;
                
            	const marker = new google.maps.Marker({
            	    map: map,
            	    position: startLocation,
            	    title: startAddress
            	  });
            }
        });
    }
    
    function addOrderResponse(location, orderId) {
    	const marker = new google.maps.Marker({
    	    map: map,
    	    position: location,
    	    title: orderId
    	  });

        markers.push(marker);
        updateTable(marker);
        seqIndicator++;
        index++;
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
        }
    }
    
    
	function clearAllInfo()
	{
		deleteMarkerWholeTable();
		document.getElementById("taskTitle").value = "";
		showModal(true);
		document.getElementById("startLocationInput").value = "";
		document.getElementById("OrderIdInput").value = "";
		startAddress = "";
	}
   
    function sendDataToServer(){
    	  if(index < 2)
    	  {
    	    alert("Please select more locations!");
    	    return;
    	  }
    	  if (startAddress.length < 1)
    	  {
      	    alert("NO Start Address!");
    	    return;
    	  }

    	  let sendMarkers = [];
    	  let title = document.getElementById("taskTitle").value;
    	  if(title === "")
    	  {
      	    alert("If you'd like to avoid any confusion, please enter title!");
    	    return;
    	  }
    	  let rb;
    	  if (document.getElementById("needReturn").value == "Yes")
    		  rb = 1;
    	  else
    		  rb = 0;
    	  let algo = document.getElementById("TspAlgorithms").value;
    	  
    	  const now = new Date();
    	  const timestampInSeconds = Math.floor(now.getTime() / 1000);
    	  
    	  
    	  var markerTbl = document.getElementById("MarkerTable");
    	  sendMarkers.push({
    		  orderId : timestampInSeconds,
    		  address: startAddress,
    		  status: "Pending",
    		  sequence: 0,
    	      longitude : startLocation.lng(),
    	      latitude : startLocation.lat(),
    	  });
    	  
    	  for(let i = 0; i < markers.length; ++i)
    	  {
              let perPoint= {    	      
    		  orderId : parseInt(markerTbl.rows[i+1].cells[1].innerText),
    		  address: "not saved",
    		  status: "Pending",
    		  sequence: i + 1,
    	      longitude : markers[i].position.lng(),
    	      latitude : markers[i].position.lat()
    	    }
    	    sendMarkers.push(perPoint);
    	  }
    	  
    	  async = false;
    	  
    	  let header = {
    			  id: timestampInSeconds,
    			  title: title,
    			  status: "Pending",
    			  decision: algo,
    			  needReturn: rb
    	  }
    	  
    	  let jsonData = {
    		taskHeader: header,
    		subTasks: sendMarkers
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
    		
    	   xmlhttp.open("POST", "http://localhost:8080/delivery", async);
    	   xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    	   xmlhttp.send(jsonString);
    }
    
    google.maps.event.addDomListener(window, 'load', initMap);
    alreadyShowed = false;
</script>

</head>
<body>
<div class="container-fluid" style="position:relative;">
<%@ include file="menu.jsp" %>

    <div class="row">        
        <div class="col-md-7">
            <div id="map-canvas" style="height: 500px; min-width: 400px; width:100%" class="mt-3">
           </div>
        </div>

        <div class="col-md-5">
            <div class="row">
               <div class="col-md-5 col-lg-5">
                	<div class="input-group mb-3 mt-3">
                    <input id="OrderIdInput" type="text" class="form-control" placeholder="Order">
                    <div class="input-group-append">
                    	<button class="btn btn-secondary" onclick="addOrder()">Add</button>
                    </div>
                	</div>
                </div>
                <div class="col-md-7">
                	<div class="input-group mb-3 mt-3">
                    <input id="startLocationInput" type="text" class="form-control" placeholder="location">
                    <div class="input-group-append">
                    	<button class="btn btn-secondary" onclick="addCompanyAddress()">Start Location</button>
                    </div>
                	</div>
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
</div>
</div>
</div>
<%@ include file="modal.jsp" %>
</body>
</html>