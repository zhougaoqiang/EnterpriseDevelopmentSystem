package Enterprise.SmartWarehouse.Product.Repository;

import org.springframework.data.repository.CrudRepository;

import Enterprise.SmartWarehouse.Product.Entities.Product;


public interface ProductRepository extends CrudRepository<Product, Integer>{

}


/*
CREATE DATABASE IF NOT EXISTS smartwarehouse;
USE smartwarehouse;

DROP TABLE IF EXISTS `product`;

CREATE TABLE `product` (
  `id` INT,
  `name` VARCHAR(100) NOT NULL UNIQUE,
  `type` INT NOT NULL,
  `price` INT NOT NULL,
  `quantity` INT NOT NULL,
  `symbol` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`));


*/