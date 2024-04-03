package Enterprise.SmartWarehouse.Properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "smart-warehouse-config")
public class SmartWarehouseProperties {
	private final String mapKey;
	private final String region;
	private final String language;
	private final String version;
	private final String jsAPIUrl;
	private final int maxDMNumber;
	private final String distanceMatixUrl;

	public SmartWarehouseProperties(String mapKey, String region, String language, String version, String jsAPIUrl,
			int maxDMNumber, String distanceMatixUrl) {
		this.mapKey = mapKey;
		this.region = region;
		this.language = language;
		this.version = version;
		this.jsAPIUrl = jsAPIUrl;
		this.maxDMNumber = maxDMNumber;
		this.distanceMatixUrl = distanceMatixUrl;
	}

	public String getMapKey() {
		return mapKey;
	}

	public String getRegion() {
		return region;
	}

	public String getLanguage() {
		return language;
	}

	public String getVersion() {
		return version;
	}

	public String getJsAPIUrl() {
		return jsAPIUrl;
	}

	// get distance matrix number
	public int getMaxDMNumber() {
		return maxDMNumber;
	}

	public String getDistanceMatixUrl() {
		return distanceMatixUrl;
	}
}