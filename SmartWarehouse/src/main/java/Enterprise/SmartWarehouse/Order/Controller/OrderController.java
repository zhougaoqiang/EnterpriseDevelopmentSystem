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
import Enterprise.SmartWarehouse.Product.Entities.Product;
import Enterprise.SmartWarehouse.Order.Entities.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/orders")
public class OrderController {
	@Autowired
	OrderHeaderRepository headerRepos;
	@Autowired
	OrderItemRepository itemRepos;
	
	
	@GetMapping    // orders?page=0&size=10
	public Iterable<OrderHeader> getAllOrders(Pageable pageable){
		return headerRepos.findAll(pageable);
	}

	/*
	 * http://localhost:8080/orders Post
	 * 
	 {
  "orderHeader": {
    "id": 3,
    "nominalPrice": 1000,
    "actualPrice": 900,
    "deliveryStatus": "Pending",
    "datetime": "2024-03-23T10:26:00",
    "longitude": 120.0,
    "latitude": 30.0
  },
  "orderItems": [
    {
      "itemId": 31,
      "price": 100,
      "quantity": 2,
      "symbol": "pcs",
      "totalPrice": 200
    },
    {
      "itemId": 32,
      "price": 200,
      "quantity": 3,
      "symbol": "pcs",
      "totalPrice": 600
    }
  ]
}

	 */
	
	@PostMapping
	public Order createOrder(@RequestBody Order order)
	{
		try {
	        OrderHeader savedHeader = headerRepos.save(order.getOrderHeader());
	        for (OrderItem item : order.getOrderItems()) {
	            item.setOrderHeader(savedHeader);
	        }
	        itemRepos.saveAll(order.getOrderItems());
	        order.setOrderHeader(savedHeader);

	        return order;
		} catch (Exception e) {
			throw new RuntimeException("Error creating order: " + e.getMessage(), e);
		}
	}
	
	@PutMapping
	public Order updateOrder(@RequestBody Order order){
		try {
	        OrderHeader savedHeader = headerRepos.save(order.getOrderHeader());
	        for (OrderItem item : order.getOrderItems()) {
	            item.setOrderHeader(savedHeader);
	        }
	        itemRepos.saveAll(order.getOrderItems());
	        order.setOrderHeader(savedHeader);
	        return order;
		} catch (Exception e) {
			throw new RuntimeException("Error creating order: " + e.getMessage(), e);
		}
	}

	@GetMapping("/{id}")
	public Optional<Order> getOrder(@PathVariable("id") Integer id) {
		Optional<OrderHeader> orderHeaderOpt = headerRepos.findById(id);
        if (!orderHeaderOpt.isPresent()) {
            return Optional.empty();
        }

        OrderHeader orderHeader = orderHeaderOpt.get();
        // The jpa will auto generate this function ?
        List<OrderItem> orderItems = itemRepos.findByOrderHeaderId(orderHeader.getId());

        Order order = new Order();
        order.setOrderHeader(orderHeader);
        order.setOrderItems(orderItems);

        return Optional.of(order);
	}
}
