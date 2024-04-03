package Enterprise.SmartWarehouse.Order.Controller;
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
import Enterprise.SmartWarehouse.Order.Repository.*;
import Enterprise.SmartWarehouse.Order.Service.OrderService;
import Enterprise.SmartWarehouse.Product.Entities.Product;
import Enterprise.SmartWarehouse.Product.Service.ProductService;
import Enterprise.SmartWarehouse.Order.Entities.*;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/orders")
public class OrderController {
	@Autowired
	OrderService service;
	@Autowired
	ProductService productService;
	
	
	@GetMapping    // orders?page=0&size=10
	public Iterable<OrderHeader> getAllOrders(Pageable pageable){
		return service.getAllOrders(pageable);
	}
	
	@PostMapping
	public Order createOrder(@RequestBody Order order)
	{
		System.out.println("Create order => " + order.toString());
		return service.createOrder(order);
	}
	
	@PutMapping
	public Order updateOrder(@RequestBody Order order)
	{
		return service.updateOrder(order);
	}
	
	@GetMapping("/product-{id}")
	public ResponseEntity<Product> getProduct(@PathVariable("id") Integer id)
	{
		return productService.getProduct(id);
	}

	@GetMapping("/{id}")
	public Optional<Order> getOrder(@PathVariable("id") Integer id)
	{
		return service.getOrder(id);
	}
	
	@GetMapping("/orderheader-{id}")
	public Optional<OrderHeader> getOrderHeader(@PathVariable("id") Integer id)
	{
		System.out.println("receive id " + id);
		return service.getOrderHeader(id);
	}
	
	@GetMapping("/exist-{id}")
	public boolean isExist(@PathVariable("id") Integer id) {
		System.out.println(id);
		return service.isExist(id);
	}
	
	@GetMapping("/count")
	public long count()
	{
		return service.count();
	}
	
	@GetMapping("/pages")
	public long pages()
	{
		return service.totalPages();
	}
	
	@GetMapping("/generateOrderId")
	public long getOrderId()
	{
		return service.getOrderId();
	}
	
	@GetMapping("/fetch")
	public Iterable<OrderHeader> getAllOrdersByStatus(@RequestParam(value = "status", required = false) Integer status)
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
		
		return service.getAllOrdersByStatus(sts);
	}
	
	@GetMapping("/updateStatus")
	public void updateOrderStatus(@RequestParam(value = "id", required = true) Integer id, @RequestParam(value = "status", required = true) Integer status)
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
        
        service.updateOrderStatus(id, sts);
	}
}
