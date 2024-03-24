package Enterprise.SmartWarehouse;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;

import Enterprise.SmartWarehouse.Product.Entities.Product;
import Enterprise.SmartWarehouse.Product.Entities.Product.EProductType;
import Enterprise.SmartWarehouse.Product.Repository.ProductRepository;

import Enterprise.SmartWarehouse.Order.Entities.*;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;
import Enterprise.SmartWarehouse.Order.Repository.*;


@SpringBootTest
class SmartWarehouseApplicationTests {
	@Autowired
	ApplicationContext context;
	
	@Test
	void contextLoads() {
//		
//		//test product ok
//		ProductRepository repository = context.getBean(ProductRepository.class);
//		Product product = new Product();
//		product.setId(1);
//		product.setName("Mac");
//		product.setType(EProductType.NonWeight);
//		product.setPrice(1800);
//		product.setQuantity(10);
//		product.setSymbol("pcs");
//		repository.save(product);
		
		OrderHeader head = new OrderHeader(1, 0, 0, EDeliveryStatus.Pending, "20240323102600", 0.327, 0.3289);
		List<OrderItem> itemList = new ArrayList<>();
		int sum = 0;
		for(int i = 1; i <= 10; i++)
		{
			OrderItem item = new OrderItem();
			item.setItemId(i);
			item.setOrderHeader(head);
			item.setPrice(i*10);
			item.setQuantity(i);
			item.setSymbol("pcs");
			int totalPrice = i*10*i;
			item.setTotalPrice(totalPrice);
			itemList.add(item);
			sum += totalPrice;
		}
		head.setActualPrice(sum);
		head.setNominalPrice(sum);

		OrderHeaderRepository headRepos = context.getBean(OrderHeaderRepository.class);
		headRepos.save(head);
		
		OrderItemRepository itemRepos = context.getBean(OrderItemRepository.class);
		itemRepos.saveAll(itemList);
	}

}
