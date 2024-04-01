package Enterprise.SmartWarehouse.DeliveryTask.Controller;
import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import Enterprise.SmartWarehouse.DeliveryTask.Repository.*;
import Enterprise.SmartWarehouse.DeliveryTask.Service.DeliveryTaskService;
import Enterprise.SmartWarehouse.Definitions.CommonDefintions.TspDecision;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.List;
import java.util.Optional;
import Enterprise.SmartWarehouse.TspAlgorithm.*;


@RestController
@RequestMapping("/delivery")
public class DeliveryTaskController {
	@Autowired
	private TaskHeaderRepository headerRepos;
	@Autowired
	private SubTaskRepository subTaskRepos;
    @Autowired
    private TspService tspService;
    @Autowired
    private DeliveryTaskService deliveryService;

	@GetMapping    // orders?page=0&size=10
	public Iterable<TaskHeader> getAllTasks(Pageable pageable){
		return deliveryService.getAllTasks(pageable);
	}
	
	@PostMapping
	public Task createTask(@RequestBody Task task)
	{
		return deliveryService.createTask(task);
	}
	
	@PutMapping
	public Task updateTask(@RequestBody Task task){
		
		return deliveryService.updateTask(task);
	}
	
	@GetMapping("/{id}")
	public Optional<Task> getOrder(@PathVariable("id") Integer id) {
		return deliveryService.getOrder(id);
	}
}
