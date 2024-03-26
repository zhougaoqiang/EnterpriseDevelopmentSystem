package Enterprise.SmartWarehouse.WebControllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import Enterprise.SmartWarehouse.Product.Service.ProductService;

public class OrderPageController {
	@Autowired
	ProductService service;
	
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
    	
        return "orderneworder";
    }
}
