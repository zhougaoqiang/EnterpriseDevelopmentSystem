package Enterprise.SmartWarehouse.TspAlgorithm;

import java.util.*;
import Enterprise.SmartWarehouse.Definitions.CommonDefintions.TspDecision;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.SubTask;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.Task;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.*;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import Enterprise.SmartWarehouse.Properties.*;

@Service
public class TspService  extends TspAlgorithm
{
    TspDecision m_decision;
    private final SmartWarehouseService swService;

    TspService(SmartWarehouseService smartwarehouseservice)
    {
    	swService = smartwarehouseservice;
		m_needBack = true;
        m_runByThread = false;
        m_decision = TspDecision.Auto;
    }
    
    public Task directStart(Task info, boolean needBack, TspDecision decision)
    {
		m_needBack = needBack;
        m_runByThread = false;
        m_decision = decision;
        try
        {
            System.out.println("set orginal info");
            this.setOriginalInfo(info.getTaskHeader(), info.getSubTasks());
            
            //step 1 should generate google distance matrix
            System.out.println("generate distance matrix");
            this.generateDistanceMatrix();
            
            //step 2 calcuate;
            System.out.println("generate result");
            this.startCalculate();
            System.out.println("calculate finish");
            
            //step 3 get result:
            info.setSubTasks(this.getUpdatedPointList());
            
        }
        catch(Exception e)
        {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }
        return info;
    }

    private TspAlgorithm getInterestAlgorithm()
    {
        int place = m_arr.length;
        TspAlgorithm algo = null;

        try
        {
            if (TspDecision.Auto == m_decision)
            {
                if (place < 10)
                    algo = new TspNaive(m_arr, m_needBack);
                else if (place < 30)
                    algo = new TspAntColony(m_arr, m_needBack);
                else
                    algo = new TspGreedyNearestVertex(m_arr, m_needBack);
            }
            else if (TspDecision.Best == m_decision)
            {
                if (place < 10)
                    algo = new TspNaive(m_arr, m_needBack);
                else
                    algo = new TspCombination(m_arr, m_needBack);
            }
            else if (TspDecision.Quick == m_decision)
            {
                if (place < 10)
                    algo = new TspNaive(m_arr, m_needBack);
                else
                    algo = new TspGreedyNearestVertex(m_arr, m_needBack);
            }
            else
            {
                algo = new TspCombination(m_arr, m_needBack);
            }
        }
        catch (Exception e)
        {
        	System.out.println(e.getMessage());
        }

        if (algo != null)
        {
            algo.setOriginalInfo(m_taskInfo, m_oriPointList);
        }
        return algo;
    }

    @Override
    public final void startCalculate()
    {
        System.out.println("chose algo and set value");
        TspAlgorithm al = getInterestAlgorithm();
        System.out.println("algo start calculate");
        al.startCalculate();
        System.out.println("algo finish calculate");
        m_updatePointList = al.getUpdatedPointList();
        System.out.println("get result success");
    }

    public static int[][] getDummyCityDistanceTable(int city)
    {
        // latitude and longitude
        int lalo[][] = new int[city][2];
        for (int i = 0; i < city; ++i)
        {
            Random random = new Random();
            lalo[i][0] = random.nextInt(1001);
            lalo[i][1] = random.nextInt(1001);
        }

        int distance[][] = new int[city][city];

        for (int i = 0; i < city; ++i)
        {
            for (int j = 0; j < city; ++j)
            {
                if (i == j)
                    distance[i][j] = 0;
                else
                {
                    int x = lalo[i][0] - lalo[j][0];
                    int y = lalo[i][1] - lalo[j][1];
                    int dist = (int) Math.sqrt(x * x + y * y);
                    distance[i][j] = dist;
                    distance[j][i] = dist;
                }
            }
        }

        return distance;
    }

    

    
    /* additional info
     * For example, spaces in a string are either encoded with %20 or replaced with the plus sign (+). 
     * If you use a pipe character (|) as a separator, be sure to encode the pipe as %7C. 
     * A comma (,) in a string should be encoded as %2C.

        It is recommended you use your platform's normal URL building libraries to automatically encode your URLs,
         to ensure the URLs are properly escaped for your platform.
         
      Unsafe character  Encoded value
        Space   %20
        "   %22
        <   %3C
        >   %3E
        #   %23
        %   %25
        |   %7C
     */
    
    /* google api example
     * https://maps.googleapis.com/maps/api/distancematrix/json
          ?destinations=40.659569%2C-73.933783%7C40.729029%2C-73.851524%7C40.6860072%2C-73.6334271%7C40.598566%2C-73.7527626
          &origins=40.6655101%2C-73.89188969999998
          &key=YOUR_API_KEY
     *
     * IMPORTANT: For google api: the first is latitude, second is longitude. DO NOT MIX.
     *            For OSRM api: the first is longitude, second is latitude.
     */
    public void generateDistanceMatrix()
    {
    	int maxGoogleAcceptNumber = swService.getMaxDMNumber();
        int size = m_oriPointList.size();
        System.out.println("get size = " + size);
        if (size <= maxGoogleAcceptNumber)
            directGenerateDistanceMatrix();
        else
        {
            int count = size/maxGoogleAcceptNumber + 1;
            // re-group
            SubTask[][] pointList = new SubTask[count][10];
            int row = 0;
            int col = 0;
            for(SubTask point : m_oriPointList)
            {
                pointList[row][col++] = point;
                if(col == maxGoogleAcceptNumber)
                {
                    col = 0;
                    row++;
                }
            }
            
            m_arr = new int[size][size];
            // group * group
            for (int i = 0 ; i <count; ++i)
            {
                for (int j = i; j < count; ++j)
                {
                    //generate per url;
                	SubTask[] oriList = new SubTask[maxGoogleAcceptNumber];
                	SubTask[] desList = new SubTask[maxGoogleAcceptNumber];
                	System.arraycopy(pointList[i], 0, oriList, 0, oriList.length);
                	System.arraycopy(pointList[j], 0, desList, 0, desList.length);
                	
                	String url = generateUrl(oriList, desList);
                	if (url.isEmpty())
                	{
                		m_arr[size-1][size-1] = 0;
                		break;
                	}

                	
                    System.out.println("Send URL =>" + url);
                    String content = getURLContent(url);
                    System.out.println("Get return content =>"+content);
                    JSONObject jsonObject = new JSONObject(content);
                    JSONArray distanceMatrix = jsonObject.getJSONArray("rows");
                    int length = distanceMatrix.length();
                    System.out.println("get return matrix = "+ length);
                    if (length < 1)
                    {
                        System.out.println("unknown matrix!");
                        return;
                    }
                    boolean usingDuration = false;
                    String obj = usingDuration ? "duration" : "distance";
                    /*
                     * "rows": [ { "elements": [ { "distance": { "text": "1 m", "value": 0 },
                     * "duration": { "text": "1 min", "value": 0 }, "status": "OK" } ] } ]
                     */
                    int startX = i * maxGoogleAcceptNumber;
                    int startY = j * maxGoogleAcceptNumber;
                    System.out.println("startX=" + startX + "startY="+startY);
                    for(int k = 0; k < length; ++k)
                    {
                    	JSONObject rowObj = distanceMatrix.getJSONObject(k);
                    	JSONArray units = rowObj.getJSONArray("elements");
                    	System.out.println("get return legth = " + units.length());
                    	for(int l = 0; l <units.length();++l)
                    	{
                    		JSONObject unitObj = units.getJSONObject(l);
                    		int value = unitObj.getJSONObject(obj).getInt("value");
                    		int x = startX + k;
                    		int y = startY + l;
                    		System.out.println("set m_arr["+x+"]["+y +"]=" + value);
                    		
                    		m_arr[x][y] = value;
                    	}
                    }
                }
            }
            
            
            // Symmetrical filling
            for(int i = 0; i < size; ++i)
            {
            	for(int j = i; j < size; ++j)
            	{
            		m_arr[j][i] = m_arr[i][j];
            	}
            }
        }
    }
    
    private String generateUrl(SubTask[] oriList, SubTask[] destList)
    {
       int totalCount = 0;
       String url = swService.getDistanceMatixUrl();
       String ori = "origins=";
       for(int i = 0 ; i < oriList.length; ++i)
       {
//    	   System.out.println("origins url + i= "+i);
    	   if(oriList[i] == null)
    	   {
    		   System.out.println("break i= "+i);
    		   break;
    	   }
           ori = ori + String.valueOf(oriList[i].getLatitude())
           + "%2C"
           + String.valueOf(oriList[i].getLongitude())
           + "%7C";
           totalCount++;
       }
       
       String des = "destinations=";
       for(int i = 0 ; i < destList.length; ++i)
       {
//    	   System.out.println("destinations url + i= "+i);
    	   if(destList[i] == null)
    	   {
    		   System.out.println("break i= "+i);
    		   break;
    	   }
    	   des = des + String.valueOf(destList[i].getLatitude())
           + "%2C"
           + String.valueOf(destList[i].getLongitude())
           + "%7C";
    	   totalCount++;
       }
       if (totalCount < 3)
    	   return "";
       ori = ori.substring(0, ori.length() - 3);//remove last %7C
       des = des.substring(0, des.length() - 3);
       url = url + ori + "&" + des + "&" + "key=" + swService.getMapKey();
       return url;
    }
    
    
    private void directGenerateDistanceMatrix()
    {
        // TODO: call google distance matrix api here; then save to m_arr
        // NOTE: OSRM is free, can use OSRM instead of google for business use, web http://project-osrm.org/docs/v5.5.1/api/#requests
        String url = generateUrl(0, m_oriPointList.size());
        System.out.println("Send URL =>" + url);
        String content = getURLContent(url);
        System.out.println("Get return content =>"+content);
        JSONObject jsonObject = new JSONObject(content);
        JSONArray distanceMatrix = jsonObject.getJSONArray("rows");
        int length = distanceMatrix.length();
        System.out.println("get distance matrix length " + length);
        
        if (length != m_oriPointList.size())
        {
            System.out.println("unknown matrix!");
            return;
        }
        
        m_arr = new int[length][length];
        boolean usingDuration = false;
        String obj = usingDuration ? "duration" : "distance";
        /*
         * "rows": [ { "elements": [ { "distance": { "text": "1 m", "value": 0 },
         * "duration": { "text": "1 min", "value": 0 }, "status": "OK" } ] } ]
         */
        for(int i = 0; i < length; ++i)
        {
        	JSONObject rowObj = distanceMatrix.getJSONObject(i);
        	JSONArray units = rowObj.getJSONArray("elements");
        	for(int j = 0; j <length;++j)
        	{
        		JSONObject unitObj = units.getJSONObject(j);
        		int value = unitObj.getJSONObject(obj).getInt("value");
        		m_arr[i][j] = value;
        	}
        }
    }
    
    private String generateUrl(int start, int end)
    {
        System.out.println("start = " + start + "; end = "+ end);
        if(start >= end && (end-start >= 10)) // cannot over 10 every-time
            return "";
       String url = swService.getDistanceMatixUrl();

       String values = "";
       while(start < end)
       {
           values = values + String.valueOf(m_oriPointList.get(start).getLatitude())
                           + "%2C"
                           + String.valueOf(m_oriPointList.get(start).getLongitude())
                           + "%7C";
           start++;
       }
       values = values.substring(0, values.length() - 3); //remove last %7C
       String ori = "origins=" + values;
       String des = "destinations=" + values;
       // String region = "region=SG";
       // String departureTime = "departure_time="
       // String mode = "mode=driving"; //walking, bicycling, transit
       url = url + ori + "&" + des + "&" + "key=" +swService.getMapKey();
       return url;
    }
//
    private static String getURLContent(String urlStr)
    {
        BufferedReader in = null;
        StringBuffer sb = new StringBuffer();
        try
        {
            URL url = URI.create(urlStr).toURL();
            in = new BufferedReader(new InputStreamReader(url.openStream(), "UTF-8"));
            String str = null;
            while ((str = in.readLine()) != null)
            {
                sb.append(str);
            }
        }
        catch (Exception ex)
        {
            System.out.println(ex.getMessage());
        } 
        finally
        {
            try
            {
                if (in != null)
                {
                    in.close();
                }
            }
            catch (IOException ex)
            {
                System.out.println(ex.getMessage());
            }
        }
        String result = sb.toString();
        System.out.println(result);
        return result;
    }

    // not used;
    @Override
    public int[] getFullPath()
    {
        return null;
    }

    @Override
    public int getTotalLength()
    {
        return 0;
    }

    @Override
    public void run()
    {
    }
}
