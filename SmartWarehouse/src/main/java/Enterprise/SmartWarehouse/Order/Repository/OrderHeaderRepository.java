package Enterprise.SmartWarehouse.Order.Repository;
//import org.springframework.data.repository.CrudRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader;


public interface OrderHeaderRepository extends JpaRepository<OrderHeader, Integer>{

}

/*
CREATE DATABASE IF NOT EXISTS smartwarehouse;
USE smartwarehouse;

DROP TABLE IF EXISTS `order_header`;

CREATE TABLE `order_header` (
  `id` INT,
  `nominal_price` INT NOT NULL,
  `actual_price` INT NOT NULL,
  `delivery_status` INT NOT NULL,
  `datetime` VARCHAR(20) NOT NULL,
  `longitude` DOUBLE NOT NULL,
  `latitude` DOUBLE NOT NULL,
  PRIMARY KEY (`id`));


*/
