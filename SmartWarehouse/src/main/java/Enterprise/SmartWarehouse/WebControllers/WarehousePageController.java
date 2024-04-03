package Enterprise.SmartWarehouse.WebControllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import Enterprise.SmartWarehouse.Product.Service.ProductService;

@Controller
public class WarehousePageController {
	@Autowired
	ProductService service;

	@GetMapping("/Warehouse")
	public String warehouse(Model model) {
		// default
		model.addAttribute("totalPages", service.totalPages());
		return "warehouseviewall"; // here return warehouse.jsp
	}

	@GetMapping("/Warehouse/ViewAll")
	public String viewAll(Model model) {
		model.addAttribute("totalPages", service.totalPages());
		return "warehouseviewall"; // here return warehouse.jsp
	}

	@GetMapping("/Warehouse/NewProduct")
	public String newProduct(Model model) {
		model.addAttribute("totalPages", service.totalPages());

		return "warehousenewproduct"; // here return warehouse.jsp
	}

	@GetMapping("/Warehouse/StockIn")
	public String stockIn(Model model) {
		model.addAttribute("totalPages", service.totalPages());
		return "warehousestockin"; // here return warehouse.jsp
	}
}
