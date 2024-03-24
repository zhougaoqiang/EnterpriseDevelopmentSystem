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

	@GetMapping    // orders?page=0&size=10
	public Iterable<TaskHeader> getAllTasks(Pageable pageable){
		return headerRepos.findAll(pageable);
	}
	
	/*
{
  "taskHeader": {
    "id": 2,
    "datetime": "2024-03-23T10:26:00",
    "title": "task 1",
    "status": "Pending",
    "decision": "Auto"
  },
  "subTasks": [
    {
      "orderId": 1,
      "address": "Sin Ming Ave",
      "status": "Pending",
      "sequence": 0,
      "longitude": 120.0,
      "latitude": 30.0
    },
    {
      "orderId": 2,
      "address": "Bishan Ave",
      "status": "Pending",
      "sequence": 1,
      "longitude": 120.0,
      "latitude": 30.0
    }
  ]
}

	 */
	
	
	@PostMapping
	public Task createTask(@RequestParam boolean needBack, @RequestParam int decision, @RequestBody Task task)
	{
		try {
	        TaskHeader savedHeader = headerRepos.save(task.getTaskHeader());
	        for (SubTask item : task.getSubTasks()) {
	            item.setTaskHeader(savedHeader);
	        }
	        
	        TspDecision tspDecision;
	        switch(decision)
	        {
	        case 0:
	            tspDecision = TspDecision.Auto;
	            break;
	        case 1:
	        	tspDecision = TspDecision.Quick;
	            break;
	        case 2:
	        default:
	        	tspDecision = TspDecision.Best;
	            break;
	        }
	        
	        Task processedTask = tspService.directStart(task, needBack, tspDecision);
	        
	        subTaskRepos.saveAll(processedTask.getSubTasks());
	        task.setTaskHeader(savedHeader);
	        
	        return task;
		} catch (Exception e) {
			throw new RuntimeException("Error creating task: " + e.getMessage(), e);
		}
	}
	
	@PutMapping
	public Task updateTask(@RequestBody Task task){
		try {
	        TaskHeader savedHeader = headerRepos.save(task.getTaskHeader());
	        for (SubTask item : task.getSubTasks()) {
	            item.setTaskHeader(savedHeader);
	        }
	        subTaskRepos.saveAll(task.getSubTasks());
	        task.setTaskHeader(savedHeader);

	        return task;
		} catch (Exception e) {
			throw new RuntimeException("Error creating order: " + e.getMessage(), e);
		}
	}
	
	@GetMapping("/{id}")
	public Optional<Task> getOrder(@PathVariable("id") Integer id) {
		Optional<TaskHeader> taskHeaderOpt = headerRepos.findById(id);
        if (!taskHeaderOpt.isPresent()) {
            return Optional.empty();
        }

        TaskHeader taskHeader = taskHeaderOpt.get();
        // The jpa will auto generate this function ?
        List<SubTask> subtasks = subTaskRepos.findByTaskHeaderId(taskHeader.getId());

        Task task = new Task();
        task.setTaskHeader(taskHeader);
        task.setSubTasks(subtasks);

        return Optional.of(task);
	}
}
