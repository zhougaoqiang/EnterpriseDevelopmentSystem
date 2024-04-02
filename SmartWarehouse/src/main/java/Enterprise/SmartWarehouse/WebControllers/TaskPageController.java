package Enterprise.SmartWarehouse.WebControllers;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import Enterprise.SmartWarehouse.DeliveryTask.Entities.Task;
import Enterprise.SmartWarehouse.DeliveryTask.Service.DeliveryTaskService;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader;
import Enterprise.SmartWarehouse.Order.Service.OrderService;
import Enterprise.SmartWarehouse.WebControllers.Model.NewTaskModel;

@Controller
public class TaskPageController {
	@Autowired
	OrderService orderService;
	@Autowired
	DeliveryTaskService taskService;
	
	@GetMapping("/Task/NewTask")
	public String newTask(Model model) {
        return "taskcreate";
    }
	
	@GetMapping("/Task/ViewAll")
	public String viewAll(Model model) {
		model.addAttribute("totalPages", taskService.totalPages());
        return "tasklist";
    }
	
    @PostMapping("/Task/NewTask")
    public String newTask(@RequestBody NewTaskModel newTask, Model model) {
    	ArrayList<OrderHeader> oHs = orderService.getOrdersByIdList(newTask.getOrderIds());
    	model.addAttribute("subTasksCount", oHs.size());
    	model.addAttribute("orderHeaders", oHs);
        return "taskcreate";
    }
    
    @GetMapping("Task/MapView")
    public String mapView(Model model, @RequestParam(value = "id", required = true) Integer id) {
    	System.out.println("receive id = " + id);
    	model.addAttribute("taskId", id);
    	return "mapview";
    }
    
}
