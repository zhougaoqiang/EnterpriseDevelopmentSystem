package Enterprise.SmartWarehouse.Properties;
import org.springframework.stereotype.Service;

@Service
public class SmartWarehouseService {
    private final SmartWarehouseProperties properties;

    public SmartWarehouseService(SmartWarehouseProperties properties) {
        this.properties = properties;
    }
    
	public String getMapKey() {
		return properties.getMapKey();
	}

	public String getRegion() {
		return properties.getRegion();
	}

	public String getLanguage() {
		return properties.getLanguage();
	}

	public String getVersion() {
		return properties.getVersion();
	}

	public String getJsAPIUrl() {
		return properties.getJsAPIUrl();
	}

	//get distance matrix number
	public int getMaxDMNumber() {
		return properties.getMaxDMNumber();
	}

	public String getDistanceMatixUrl() {
		return properties.getDistanceMatixUrl();
	}
	
    public String getUrl() 
    {
        String url = getJsAPIUrl();
        url +=("v=" + getVersion() + "&");
        url +=("key=" + getMapKey() + "&");
        url +=("region=" + getRegion() + "&");
        url +=("language=" + getLanguage());
        return url;
    }
}
