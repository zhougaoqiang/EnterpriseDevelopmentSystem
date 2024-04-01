package Enterprise.SmartWarehouse.DeliveryTask.Service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import Enterprise.SmartWarehouse.Definitions.CommonDefintions.TspDecision;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.SubTask;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.Task;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.TaskHeader;
import Enterprise.SmartWarehouse.DeliveryTask.Repository.SubTaskRepository;
import Enterprise.SmartWarehouse.DeliveryTask.Repository.TaskHeaderRepository;
import Enterprise.SmartWarehouse.TspAlgorithm.TspService;

@Service
public class DeliveryTaskService {
	@Autowired
	private TaskHeaderRepository headerRepos;
	@Autowired
	private SubTaskRepository subTaskRepos;
    @Autowired
    private TspService tspService;
    
	public Iterable<TaskHeader> getAllTasks(Pageable pageable){
		return headerRepos.findAll(pageable);
	}
	
	public Task createTask(Task task)
	{
		try {
	        TaskHeader savedHeader = headerRepos.save(task.getTaskHeader());
	        for (SubTask item : task.getSubTasks()) {
	            item.setTaskHeader(savedHeader);
	        }
	        
	        Boolean needReturn = task.getTaskHeader().getNeedReturn() == 0 ? false : true;
	        Task processedTask = tspService.directStart(task, needReturn, task.getTaskHeader().getDecision());
	        subTaskRepos.saveAll(processedTask.getSubTasks());
	        task.setTaskHeader(savedHeader);
	        
	        return task;
		} catch (Exception e) {
			throw new RuntimeException("Error creating task: " + e.getMessage(), e);
		}
	}
	
	public Task updateTask(Task task){
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
	
	public Optional<Task> getOrder(Integer id) {
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
