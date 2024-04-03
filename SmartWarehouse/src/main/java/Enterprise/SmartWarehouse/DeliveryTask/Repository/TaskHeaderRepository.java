package Enterprise.SmartWarehouse.DeliveryTask.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import Enterprise.SmartWarehouse.DeliveryTask.Entities.TaskHeader;

public interface TaskHeaderRepository extends JpaRepository<TaskHeader, Integer>, JpaSpecificationExecutor<TaskHeader> {

}


/*
CREATE DATABASE IF NOT EXISTS smartwarehouse;
USE smartwarehouse;

DROP TABLE IF EXISTS `sub_task`;
DROP TABLE IF EXISTS `task_header`;


CREATE TABLE `task_header` (
  `id` INT,
  `title` VARCHAR(200) NOT NULL,
  `status` INT NOT NULL,
  `decision` INT NOT NULL,
  `need_return` INT NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `sub_task` (
  `order_id` INT PRIMARY KEY,
  `task_id` INT NOT NULL,
  `address` VARCHAR(200) NOT NULL,
  `status` INT NOT NULL,
  `sequence` INT NOT NULL,
  `longitude` DOUBLE NOT NULL,
  `latitude` DOUBLE NOT NULL,
  FOREIGN KEY (`task_id`) REFERENCES `task_header`(`id`)
);
*/