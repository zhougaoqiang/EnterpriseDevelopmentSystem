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
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;
import Enterprise.SmartWarehouse.Definitions.CommonDefintions.TspDecision;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import Enterprise.SmartWarehouse.TspAlgorithm.*;
import Enterprise.SmartWarehouse.WebControllers.Model.NewTaskModel;


@RestController
@RequestMapping("/delivery")
public class DeliveryTaskController {
    @Autowired
    private DeliveryTaskService deliveryService;

	@GetMapping    // orders?page=0&size=10
	public Iterable<TaskHeader> getAllTasks(Pageable pageable){
		return deliveryService.getAllTasks(pageable);
	}
	
	@PostMapping
	public Task createTask(@RequestBody Task task)
	{
		System.out.println("receive task");
		return deliveryService.createTask(task);
	}
	
	@PutMapping
	public Task updateTask(@RequestBody Task task){
		
		return deliveryService.updateTask(task);
	}
	
	@PutMapping("/init")
	public void setInitSubTasks(@RequestBody NewTaskModel mode)
	{
		System.out.println("receive init orders");
		deliveryService.setInitSubTasks(mode);
	}
	
	@GetMapping("/pages")
	public long pages()
	{
		return deliveryService.totalPages();
	}
	
	@GetMapping("/taskId-{id}")
	public Iterable<SubTask> getSortedSubTasks(@PathVariable("id") Integer id)
	{
		Optional<Task> optionalTask = deliveryService.getTask(id);

		if (optionalTask.isPresent())
		{
		  Task task = optionalTask.get();
		  // Sort subTasks by sequence
		  List<SubTask> sortedSubTasks = new ArrayList<>(task.getSubTasks());
		  sortedSubTasks.sort(Comparator.comparingInt(SubTask::getSequence));

		  // Use the sorted subTasks (e.g., iterate or access elements)
		  for (SubTask subTask : sortedSubTasks)
		  {
		    System.out.println("SubTask Sequence: " + subTask.getSequence());
		  }
		  
			if (task.getTaskHeader().getNeedReturn() == 1)
			{
				sortedSubTasks.add(sortedSubTasks.get(0));
			}
			
			return sortedSubTasks;
		  
		} else {
		  System.out.println("Task not found for ID: " + id);
		  return null;
		}
	}
	
	@GetMapping("/fetch")
	public Iterable<TaskHeader> getAllTasksByStatus(@RequestParam(value = "status", required = false) Integer status)
	{
	    EDeliveryStatus sts;

        switch (status) {
            case 0:
                sts = EDeliveryStatus.Pending;
                break;
            case 1:
                sts = EDeliveryStatus.InProgress;
                break;
            case 2:
                sts = EDeliveryStatus.Shipped;
                break;
            case 3:
                sts = EDeliveryStatus.Abandoned;
                break;
            default:
                // Handle unexpected status values appropriately
                sts = EDeliveryStatus.Pending; // Assuming there is an 'Unknown' status in EDeliveryStatus
                break;
	    }
		
		return deliveryService.getAllTasksByStatus(sts);
	}
	
	@GetMapping("/updateStatus")
	public void updateTaskStatus(@RequestParam(value = "id", required = true) Integer id, @RequestParam(value = "status", required = true) Integer status)
	{
	    EDeliveryStatus sts = EDeliveryStatus.Pending;

        switch (status) {
            case 0:
                sts = EDeliveryStatus.Pending;
                break;
            case 1:
                sts = EDeliveryStatus.InProgress;
                break;
            case 2:
                sts = EDeliveryStatus.Shipped;
                break;
            case 3:
                sts = EDeliveryStatus.Abandoned;
                break;
            default:
                break;
	    }
        
        deliveryService.updateTaskStatus(id, sts);
	}
}
