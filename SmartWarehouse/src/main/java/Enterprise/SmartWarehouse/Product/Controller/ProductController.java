package Enterprise.SmartWarehouse.Product.Controller;
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
import Enterprise.SmartWarehouse.Product.Entities.Product;
import Enterprise.SmartWarehouse.Product.Repository.ProductRepository;

import java.util.Optional;

@RestController
@RequestMapping("/products")
public class ProductController {
	@Autowired
	ProductRepository productRepos;
	
	@GetMapping
	public Iterable<Product> getAllProducts(){
		return productRepos.findAll();
	}

	@PostMapping
	public Product createProduct(@RequestBody Product product)
	{
		return productRepos.save(product);
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

	@GetMapping("/{id}")
	public Optional<Product> getProduct(@PathVariable("id") Integer id) {
		return productRepos.findById(id);
	}
}
