package Enterprise.SmartWarehouse.WebControllers;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WarehousePageController {
	
    @GetMapping("/Warehouse")
    public String hello(Model model) {
//        model.addAttribute("name", "gaoqiang");
        return "warehouse";  // here return warehouse.jsp
    }
}
