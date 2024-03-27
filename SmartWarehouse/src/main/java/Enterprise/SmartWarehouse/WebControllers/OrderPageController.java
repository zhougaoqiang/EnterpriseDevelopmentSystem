package Enterprise.SmartWarehouse.WebControllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import Enterprise.SmartWarehouse.Order.Service.OrderService;
import Enterprise.SmartWarehouse.Properties.SmartWarehouseService;

@Controller
public class OrderPageController {
	@Autowired
	OrderService service;
	
	@Autowired
	SmartWarehouseService propertyService;
	
    @GetMapping("/Order")
    public String order(Model model) {
        return "orderviewall";  // here return warehouse.jsp
    }
    
    @GetMapping("/Order/ViewAll")
    public String viewallorder(Model model) {
        return "orderviewall";  // here return warehouse.jsp
    }
    
    @GetMapping("/Order/NewOrder")
    public String newOrder(Model model) {
    	System.out.println("new order");
    	
    	model.addAttribute("newOrderId", service.getOrderId());
    	model.addAttribute("apiKey", propertyService.getMapKey());
        return "orderneworder";
    }
}
