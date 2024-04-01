package Enterprise.SmartWarehouse.Order.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import Enterprise.SmartWarehouse.Order.Entities.Order;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader;
import Enterprise.SmartWarehouse.Order.Entities.OrderItem;
import Enterprise.SmartWarehouse.Order.Repository.OrderHeaderRepository;
import Enterprise.SmartWarehouse.Order.Repository.OrderItemRepository;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeaderSpecification;

@Service
public class OrderService {
	@Autowired
	OrderHeaderRepository headerRepos;
	@Autowired
	OrderItemRepository itemRepos;
	
	final public int maxShowInOnePage = 10;
	
	
	public Iterable<OrderHeader> getAllOrders(Pageable pageable)
	{
		return headerRepos.findAll(pageable);
	}
	
	public Iterable<OrderHeader> getAllOrdersByStatus(EDeliveryStatus status)
	{
		Specification<OrderHeader> spec = OrderHeaderSpecification.hasStatus(status);
		Iterable<OrderHeader> tmp = headerRepos.findAll(spec);
		for(OrderHeader oh : tmp)
		{
			System.out.println(oh.toString());
		}
		return tmp;
	}
	
	public Order createOrder(Order order)
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
	
	public Order updateOrder(Order order){
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

	public Optional<Order> getOrder(Integer id) {
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
	
	public Optional<OrderHeader> getOrderHeader(Integer id) {
		Optional<OrderHeader> orderHeaderOpt = headerRepos.findById(id);
        if (!orderHeaderOpt.isPresent()) {
            return Optional.empty();
        }

        return orderHeaderOpt;
	}
	
	public ArrayList<OrderHeader> getOrdersByIdList(Iterable<Integer> ids)
	{
		ArrayList<OrderHeader> ordersList = new ArrayList<>();
		for(Integer id : ids)
		{
			Optional<OrderHeader> orderHeaderOpt = headerRepos.findById(id);
	        if (!orderHeaderOpt.isPresent())
	            continue;
	        
	        ordersList.add(orderHeaderOpt.get());
		}
		return ordersList;
	}
	
	public void saveOrdersStatus(Iterable<Integer> ids, EDeliveryStatus status)
	{
		for(Integer id : ids)
		{
			Optional<OrderHeader> orderHeaderOpt = headerRepos.findById(id);
	        if (!orderHeaderOpt.isPresent())
	            continue;
	        
	        orderHeaderOpt.get().setDeliveryStatus(status);
	        headerRepos.save(orderHeaderOpt.get());
		}
	}
	
	public boolean isExist(Integer id) {
		return headerRepos.existsById(id);
	}
	
	public long count(){
		return headerRepos.count();
	}
	
	public int totalPages() {
		return (int) ((headerRepos.count() / maxShowInOnePage) + 1);
	}
	
	public long getOrderId()
	{
		int sequence = (int) (headerRepos.count()% 1000);
		LocalDate today = LocalDate.now();
		int year = today.getYear() % 100; //2024 get 24
		int day = today.getDayOfYear(); // 0 - 366
		int orderId = 1+sequence + day* 1000 + year*1000*1000;
		System.out.println("get id => " + orderId);
		return orderId;
	}
}
