package Enterprise.SmartWarehouse.DeliveryTask.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.TaskHeader;
//import Enterprise.SmartWarehouse.DeliveryTask.Entities.TaskHeader.TspDecision;
//import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;

public interface TaskHeaderRepository extends JpaRepository<TaskHeader, Integer>{

}


/*
CREATE DATABASE IF NOT EXISTS smartwarehouse;
USE smartwarehouse;

DROP TABLE IF EXISTS `task_header`;

CREATE TABLE `task_header` (
  `id` INT,
  `datetime` VARCHAR(50) NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `status` INT NOT NULL,
  `decision` INT NOT NULL,
  PRIMARY KEY (`id`));

*/