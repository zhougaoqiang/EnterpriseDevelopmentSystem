package Enterprise.SmartWarehouse.Product.Controller;
import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
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
import Enterprise.SmartWarehouse.Product.Entities.Product;
import Enterprise.SmartWarehouse.Product.Repository.ProductRepository;

import java.util.Optional;

@RestController
@RequestMapping("/products")
public class ProductController {
	@Autowired
	ProductRepository productRepos;
	
	@GetMapping
	public Page<Product> getAllProducts(Pageable pageable){
        return productRepos.findAll(pageable);
	}

	@PostMapping
	public Product createProduct(@RequestBody Product product)
	{
		//post http://localhost:8080/products
		/*
		 * 
{
    "id":2,
    "name":"Pineapple",
    "type":"Weight",
    "price": 100,
    "quantity": 100000,
    "symbol":"g"
}
		 */
		
//		System.out.println("gaoqiang receive product");
		return productRepos.saveAndFlush(product);
	}

	@DeleteMapping
	public void deleteProduct(@RequestBody Product product)
	{
		productRepos.delete(product);
	}
	
	@PutMapping
	public Product updateProduct(@RequestBody Product product){
		return productRepos.save(product);
	}

	@GetMapping("/get-{id}")
	public ResponseEntity<Product> getProduct(@PathVariable("id") Integer id) {
	    Optional<Product> productOpt = productRepos.findById(id);
	    if (productOpt.isPresent()) {
	        return ResponseEntity.ok(productOpt.get()); //返回 HTTP 状态码 200（OK）和产品数据
	    } else {
	        return ResponseEntity.notFound().build(); //返回 HTTP 状态码 404（Not Found
	    }
	}
	
	@GetMapping("/exist-{id}")
	public boolean isExist(@PathVariable("id") Integer id) {
		return productRepos.existsById(id);
	}
	
	@GetMapping("/count")
	public long count(){
		return productRepos.count();
	}
}
