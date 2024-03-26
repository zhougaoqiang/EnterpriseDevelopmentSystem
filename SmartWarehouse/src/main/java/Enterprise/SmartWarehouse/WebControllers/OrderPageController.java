package Enterprise.SmartWarehouse.WebControllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import Enterprise.SmartWarehouse.Product.Service.ProductService;

public class OrderPageController {
	@Autowired
	ProductService service;
	
    @GetMapping("/Order")
    public String hello(Model model) {
        return "order";  // here return warehouse.jsp
    }
}
