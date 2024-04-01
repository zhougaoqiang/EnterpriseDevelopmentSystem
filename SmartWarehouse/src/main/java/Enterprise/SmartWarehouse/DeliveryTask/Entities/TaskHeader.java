package Enterprise.SmartWarehouse.DeliveryTask.Entities;
import Enterprise.SmartWarehouse.Definitions.CommonDefintions.TspDecision;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "task_header")
public class TaskHeader {
	
	@Id
	private Integer id;
	private String title;
	private EDeliveryStatus status;
	private TspDecision decision;
	
	@Column(name = "need_return")
	private int needReturn;
	
	
	public int getNeedReturn() {
		return needReturn;
	}
	public void setNeedReturn(int needReturn) {
		this.needReturn = needReturn;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public EDeliveryStatus getStatus() {
		return status;
	}
	public void setStatus(EDeliveryStatus status) {
		this.status = status;
	}
	public TspDecision getDecision() {
		return decision;
	}
	public void setDecision(TspDecision decision) {
		this.decision = decision;
	}
	
	
}
