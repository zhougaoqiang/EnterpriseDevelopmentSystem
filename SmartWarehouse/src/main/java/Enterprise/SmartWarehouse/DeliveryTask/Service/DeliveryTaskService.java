package Enterprise.SmartWarehouse.DeliveryTask.Service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
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
import Enterprise.SmartWarehouse.DeliveryTask.Entities.TaskHeaderSpecification;
import Enterprise.SmartWarehouse.DeliveryTask.Repository.SubTaskRepository;
import Enterprise.SmartWarehouse.DeliveryTask.Repository.TaskHeaderRepository;
import Enterprise.SmartWarehouse.Order.Entities.Order;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeaderSpecification;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;
import Enterprise.SmartWarehouse.Order.Service.OrderService;
import Enterprise.SmartWarehouse.TspAlgorithm.TspService;

@Service
public class DeliveryTaskService {
	@Autowired
	private TaskHeaderRepository headerRepos;
	@Autowired
	private SubTaskRepository subTaskRepos;
	@Autowired
	private OrderService orderService;
    @Autowired
    private TspService tspService;
    
    final public int maxShowInOnePage = 10;
    
	public Iterable<TaskHeader> getAllTasks(Pageable pageable){
		System.out.println("receive get all tasks");
		return headerRepos.findAll(pageable);
	}
	
	public Task createTask(Task task)
	{
		try {
	        TaskHeader savedHeader = headerRepos.save(task.getTaskHeader());
	        System.out.println("init tast header => " + savedHeader.toString());
	        for (SubTask item : task.getSubTasks()) //for get Address
	        {
	        	int orderID = item.getOrderId();
	        	Optional<Order> order = orderService.getOrder(orderID);
	        	if (order.isPresent())
	        	{
	        		item.setAddress(order.get().getOrderHeader().getAddress());
	        	}
	        	System.out.println("init tast item => " + item.toString());
	            item.setTaskHeader(savedHeader);
	        }
	        
	        Boolean needReturn = task.getTaskHeader().getNeedReturn() == 0 ? false : true;
	        Task processedTask = tspService.directStart(task, needReturn, task.getTaskHeader().getDecision());
	        subTaskRepos.saveAll(processedTask.getSubTasks());
	        
	        for (SubTask item : task.getSubTasks()) //order status also need to be changed
	        {
	        	orderService.updateOrderStatus(item.getOrderId(), EDeliveryStatus.InProgress);
	        }
	        savedHeader.setStatus(EDeliveryStatus.InProgress);
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
	
	public Optional<Task> getTask(Integer id) {
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
	
	public Iterable<TaskHeader> getAllTasksByStatus(EDeliveryStatus status)
	{
		Specification<TaskHeader> spec = TaskHeaderSpecification.hasStatus(status);
		Iterable<TaskHeader> tmp = headerRepos.findAll(spec);
		for(TaskHeader oh : tmp)
		{
			System.out.println(oh.toString());
		}
		return tmp;
	}

	public long count(){
		return headerRepos.count();
	}
	
	public int totalPages() {
		return (int) ((headerRepos.count() / maxShowInOnePage) + 1);
	}
}
