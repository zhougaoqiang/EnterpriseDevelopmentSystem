<%@page import="Database.TaskInfo"%>
<%@page import="Database.PointInfo"%>
<%@page import="Database.DBTask"%>
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
    <script type="module" src="./index.js"></script>
    
    <script>
    <%
    String UID = (String)request.getSession().getAttribute("UID");
    String Date = (String)request.getSession().getAttribute("Date");
    String TaskTitle = (String)request.getSession().getAttribute("TaskTitle");
    String NeedReturn = (String)request.getSession().getAttribute("NeedReturn");
    if(UID == null || UID.isEmpty() || Date == null || Date.isEmpty() || TaskTitle == null || TaskTitle.isEmpty())
    {
        response.sendRedirect("Login.jsp");
    }
    response.addHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setDateHeader("Expires", 0);
    %>
    
    <%
         String donwloadFilename = Date + "-" + TaskTitle +".png";
         out.println("var filename=\"" + donwloadFilename + "\"");
    %>
    
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
        	console.log(filename);
            var anchorTag = document.createElement("a");
            anchorTag.download = filename;
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
              
              // Create the DIV to hold the control.
/*               const screenshotDiv = document.createElement('div');
              // Create the control.
              const screenshotControl = createScreenshotControl(map);
              // Append the control to the DIV.
              screenshotDiv.appendChild(screenshotControl);

              map.controls[google.maps.ControlPosition.TOP_CENTER].push(screenshotDiv); */
   }   

    function displayRoute(service, display) {
      service
        .route({
        	<%
        	System.out.println(UID + " " + Date + " "+ TaskTitle);
        	ArrayList<PointInfo> pointList = DBTask.getInstance().fetchTaskPointList(UID,Date,TaskTitle);
        	int size = pointList.size();
        	if (0 == NeedReturn.compareToIgnoreCase("Yes"))
        	{
                PointInfo OriginPoint = pointList.get(0);
                PointInfo DestinationPoint = OriginPoint;
                out.println("origin:new google.maps.LatLng("+ OriginPoint.getLatitudeWithOffset()+","+OriginPoint.getLongitudeWithOffset()+"),");
                out.println("destination:new google.maps.LatLng("+DestinationPoint.getLatitude()+","+DestinationPoint.getLongitude()+"),");
        	}
        	else
        	{
                PointInfo OriginPoint = pointList.get(0);
                PointInfo DestinationPoint = pointList.get(size - 1);
                out.println("origin:new google.maps.LatLng("+ OriginPoint.getLatitude()+","+OriginPoint.getLongitude()+"),");
                out.println("destination:new google.maps.LatLng("+DestinationPoint.getLatitude()+","+DestinationPoint.getLongitude()+"),");
        	} 
        	%>
          waypoints: [
        	  <%
        	  for (int i = 1; i < size - 1; ++i)
        	  {
        	      out.println("{location:new google.maps.LatLng(" + pointList.get(i).getLatitude() +","+pointList.get(i).getLongitude()+")},");
        	  }
        	  %>
          ],
          travelMode: google.maps.TravelMode.DRIVING,
          avoidTolls: true,
        })
        .then((result) => {
          display.setDirections(result);
        })
        .catch((e) => {
          alert("Could not display directions due to: " + e);
        });
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
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAPGAAlGSj_XQv24J_Qo-qEFtKsUHb-5OU&callback=initMap&v=weekly"
      defer
    ></script>
  </body>
</html>