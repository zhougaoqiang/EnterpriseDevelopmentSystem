package Enterprise.SmartWarehouse.DeliveryTask.Repository;
import org.springframework.data.repository.CrudRepository;
import java.util.List;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.SubTask;

public interface SubTaskRepository extends CrudRepository<SubTask, Integer>{
	List<SubTask> findByTaskHeaderId(Integer id);
}