package Enterprise.SmartWarehouse.DeliveryTask.Repository;
import org.springframework.data.repository.CrudRepository;
import java.util.List;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.SubTask;
//import Enterprise.SmartWarehouse.DeliveryTask.Entities.TaskHeader;
//import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;
//import jakarta.persistence.Id;
//import jakarta.persistence.JoinColumn;
//import jakarta.persistence.ManyToOne;

public interface SubTaskRepository extends CrudRepository<SubTask, Integer>{
	List<SubTask> findByTaskHeaderId(Integer id);
}