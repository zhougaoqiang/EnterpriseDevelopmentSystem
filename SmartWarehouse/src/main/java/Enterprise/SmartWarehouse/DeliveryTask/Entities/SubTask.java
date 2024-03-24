package Enterprise.SmartWarehouse.DeliveryTask.Entities;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;;

@Entity
@Table(name = "sub_task")
public class SubTask {	
	@Id
	private Integer orderId;
	
	@ManyToOne
    @JoinColumn(name = "task_id")
	private TaskHeader taskHeader;
	
	private String address;
	private EDeliveryStatus status;
	private Integer sequence;
	private double longitude;
	private double latitude;
	
	public Integer getOrderId() {
		return orderId;
	}
	public void setOrder_id(Integer order_id) {
		this.orderId = order_id;
	}
	public TaskHeader getTaskHeader() {
		return taskHeader;
	}
	public void setTaskHeader(TaskHeader taskHeader) {
		this.taskHeader = taskHeader;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public EDeliveryStatus getStatus() {
		return status;
	}
	public void setStatus(EDeliveryStatus status) {
		this.status = status;
	}
	public Integer getSequence() {
		return sequence;
	}
	public void setSequence(Integer sequence) {
		this.sequence = sequence;
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
	
	
}
