package Enterprise.SmartWarehouse.DeliveryTask.Repository;
import org.springframework.data.repository.CrudRepository;
import java.util.List;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.SubTask;
//import Enterprise.SmartWarehouse.DeliveryTask.Entities.TaskHeader;
//import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;
//import jakarta.persistence.Id;
//import jakarta.persistence.JoinColumn;
//import jakarta.persistence.ManyToOne;

public interface SubTaskRepository extends CrudRepository<SubTask, Integer>{
	List<SubTask> findByTaskHeaderId(Integer id);
}




//public interface OrderItemRepository extends CrudRepository<OrderItem, Integer>{
//	List<OrderItem> findByOrderHeaderId(Integer headerId);
//}

/*
CREATE DATABASE IF NOT EXISTS smartwarehouse;
USE smartwarehouse;

DROP TABLE IF EXISTS `sub_task`;

CREATE TABLE `sub_task` (
  `order_id` INT PRIMARY KEY,
  `task_id` INT NOT NULL,
  `address` VARCHAR(100) NOT NULL,
  `status` INT NOT NULL,
  `sequence` INT NOT NULL,
  `longitude` DOUBLE NOT NULL,
  `latitude` DOUBLE NOT NULL,
  FOREIGN KEY (`task_id`) REFERENCES `task_header`(`id`)
);

*/