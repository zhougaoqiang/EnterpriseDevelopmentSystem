package Enterprise.SmartWarehouse.Order.Repository;
import org.springframework.data.repository.CrudRepository;
import java.util.List;
import Enterprise.SmartWarehouse.Order.Entities.OrderItem;

public interface OrderItemRepository extends CrudRepository<OrderItem, Integer>{
	List<OrderItem> findByOrderHeaderId(Integer headerId);
}

/*
CREATE DATABASE IF NOT EXISTS smartwarehouse;
USE smartwarehouse;

DROP TABLE IF EXISTS `order_item`;

CREATE TABLE `order_item` (
  `item_id` INT PRIMARY KEY,
  `header_id` INT NOT NULL,
  `price` INT NOT NULL,
  `quantity` INT NOT NULL,
  `symbol` VARCHAR(20) NOT NULL,
  `total_price` INT NOT NULL,
  FOREIGN KEY (`header_id`) REFERENCES `order_header`(`id`)
);


*/