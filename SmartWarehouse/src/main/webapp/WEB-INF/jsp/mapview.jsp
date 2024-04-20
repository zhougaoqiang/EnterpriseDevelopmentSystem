<%@page import="java.util.ArrayList"%>
<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title>Map View</title>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
    <script src="https://html2canvas.hertzen.com/dist/html2canvas.js" type="text/javascript"></script> 
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
    <style>
        html,
        body {
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: 'Varela Round';
            }

         #container {
           height: 100%;
           display: flex;
         }
         	
         #sidebar {
           flex-basis: 15rem;
           flex-grow: 1;
           padding: 1rem;
           max-width: 30rem;
           height: 100%;
           box-sizing: border-box;
           overflow: auto;
         }
         	
         #map {
           flex-basis: 0;
           flex-grow: 4;
           height: 100%;
         }
    </style>
    <script>
    var taskId = ${taskId};
    function createScreenshotControl(map) {
    	  const controlButton = document.createElement('button');

    	  // Set CSS for the control.
    	 // controlButton.style.border = '0';
    	  controlButton.style.backgroundColor = '#fff';
    	  controlButton.style.border = '#fff';
    	  controlButton.style.borderRadius = '10px';
    	  controlButton.style.margin = '2px';
    	  controlButton.style.padding = '2px';
    	  controlButton.innerHTML = '<img src="screenshot.png" width="40" height="40" />'
    	  controlButton.title = 'Click to recenter the map';
    	  controlButton.type = 'button';

    	  // Setup the click event listeners: simply set the map to Chicago.
    	  controlButton.addEventListener('click', () => {
    	  });

    	  return controlButton;
    	}
    
    function printPanel()
    {
        html2canvas(document.getElementById("panel")).then(function (canvas) {
            var anchorTag = document.createElement("a");
            anchorTag.download = taskId + ".png";
            anchorTag.href = canvas.toDataURL();
            anchorTag.target = '_blank';
            anchorTag.click();
          });
    }
    
    function initMap() 
    {
          const map = new google.maps.Map(document.getElementById("map"), {
              zoom: 11,
              center: new google.maps.LatLng(1.3521, 103.8198),
              mapTypeId: google.maps.MapTypeId.ROADMAP,
              minZoom: 11
              });
              const directionsService = new google.maps.DirectionsService();
              const directionsRenderer = new google.maps.DirectionsRenderer({
              draggable: false,
              map,
              panel: document.getElementById("panel"),
              });

              directionsRenderer.addListener("directions_changed", () => {
              const directions = directionsRenderer.getDirections();

              if (directions) {
                computeTotalDistance(directions);}
              });
              
              displayRoute(
              directionsService,
              directionsRenderer);
   } 

    async function displayRoute(service, display) {
    	  try {
    	    let url = "http://localhost:8080/delivery/taskId-" + taskId;
    	    console.log(url);
    	    const response = await fetch(url);
    	    if (!response.ok) {
    	      throw new Error(`Error fetching task data: ${response.statusText}`);
    	    }

    	    const taskData = await response.json();
    	    console.log(taskData); // Check data structure

    	    let origin = new google.maps.LatLng(taskData[0].latitude, taskData[0].longitude);
    	    let destination = new google.maps.LatLng(taskData[taskData.length - 1].latitude, taskData[taskData.length - 1].longitude);
    	    let waypts = [];
 
    	    taskData.splice(0, 1);
    	    taskData.pop();
    	    
    	    for (const subTask of taskData) {
    	   	  console.log("latitude", subTask.latitude);
    	   	  console.log("longitude", subTask.longitude);
    	   		console.log("address", subTask.address);
    	   		waypts.push({
    	   	        location: new google.maps.LatLng(subTask.latitude, subTask.longitude),
    	   	        stopover: true,
    	   	      });
    	    }
    	    service.route({
    	        origin: origin,
    	        destination: destination,
    	        waypoints: waypts,
    	        travelMode: google.maps.TravelMode.DRIVING,
    	        avoidTolls: true,
    	      })
    	      .then((result) => {
    	        display.setDirections(result);
    	      })
    	      .catch((error) => {
    	        console.error("Error fetching task data:", error);
    	      });
    	  } catch (error) {
    	    console.error("Error fetching task data:", error);
    	  }
    	}

    function computeTotalDistance(result) {
      let total = 0;
      const myroute = result.routes[0];

      if (!myroute) {
        return;
      }

      for (let i = 0; i < myroute.legs.length; i++) {
        total += myroute.legs[i].distance.value;
      }

      total = total / 1000;
      document.getElementById("total").innerHTML = total + " km";
    }

        window.initMap = initMap;
    </script>
  </head>
  <body>
    <div id="container">
      <div id="map"></div>
      <div id="sidebar">
        <div class="row">
            <div class="col-md-8 col-lg-8 mt-1"><p>Total Distance: <span id="total"></span></p></div>
            <div class="cok-md-8 col-lg-4"><button type="button" class="btn btn-outline-secondary" onclick="printPanel()" style="width:100%">Print</button></div>
        </div>
        <div id="panel"></div>
      </div>
    </div>
    <script
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCOVkQCJBsUmAMIMFnaNIvP9lXOZkHLDDg&callback=initMap&v=weekly"
      defer
    ></script>
  </body>
</html>