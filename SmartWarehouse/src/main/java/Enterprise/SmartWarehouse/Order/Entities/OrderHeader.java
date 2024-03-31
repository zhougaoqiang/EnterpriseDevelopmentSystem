package Enterprise.SmartWarehouse.Order.Entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "order_header")
public class OrderHeader {
	public enum EDeliveryStatus{
		Pending,
		InProgress,
		Shipped,
		Abandoned,
	}
	
	@Id
	private Integer id;
	@Column(name = "nominal_price")
	private Integer nominalPrice;
	@Column(name = "actual_price")
	private Integer actualPrice;

	@Column(name = "delivery_status")
	private EDeliveryStatus deliveryStatus;
	private String datetime;
	private String address;
	private double longitude;
	private double latitude;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getNominalPrice() {
		return nominalPrice;
	}
	public void setNominalPrice(Integer nominalPrice) {
		this.nominalPrice = nominalPrice;
	}
	public Integer getActualPrice() {
		return actualPrice;
	}
	public void setActualPrice(Integer actualPrice) {
		this.actualPrice = actualPrice;
	}
	public EDeliveryStatus getDeliveryStatus() {
		return deliveryStatus;
	}
	public void setDeliveryStatus(EDeliveryStatus deliveryStatus) {
		this.deliveryStatus = deliveryStatus;
	}
	public String getDatetime() {
		return datetime;
	}
	public void setDatetime(String datetime) {
		this.datetime = datetime;
	}
	public double getLongitude() {
		return longitude;
	}
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	public double getLatitude() {
		return latitude;
	}
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	public OrderHeader(Integer id, Integer nominalPrice, Integer actualPrice, EDeliveryStatus deliveryStatus,
			String datetime, String add, double longitude, double latitude) {
		super();
		this.id = id;
		this.nominalPrice = nominalPrice;
		this.actualPrice = actualPrice;
		this.deliveryStatus = deliveryStatus;
		this.datetime = datetime;
		this.address = add;
		this.longitude = longitude;
		this.latitude = latitude;
	}

	public OrderHeader()
	{
		
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	@Override
	public String toString() {
		return "OrderHeader [id=" + id + ", nominalPrice=" + nominalPrice + ", actualPrice=" + actualPrice
				+ ", deliveryStatus=" + deliveryStatus + ", datetime=" + datetime + ", address=" + address
				+ ", longitude=" + longitude + ", latitude=" + latitude + "]";
	}
	
}
