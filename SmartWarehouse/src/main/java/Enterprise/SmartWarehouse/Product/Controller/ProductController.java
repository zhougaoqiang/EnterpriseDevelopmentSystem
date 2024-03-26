package Enterprise.SmartWarehouse.Product.Controller;
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
import Enterprise.SmartWarehouse.Product.Service.ProductService;
import java.util.List;

@RestController
@RequestMapping("/products")
public class ProductController {
	@Autowired
	ProductService service;
	
	@GetMapping // products?page=0&size=10
	public Page<Product> getAllProducts(Pageable pageable){
        return service.findAll(pageable);
	}

	@PostMapping("/stockin")
	public boolean stockIn(@RequestBody List<Product> products)
	{
		return service.stockIn(products);
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
		return service.createProduct(product);
	}

	@DeleteMapping
	public void deleteProduct(@RequestBody Product product)
	{
		System.out.println("receive delete product");
		System.out.println(product.getId());
		service.deleteProduct(product);
	}
	
	@PutMapping
	public Product updateProduct(@RequestBody Product product){
		return service.updateProduct(product);
	}

	@GetMapping("/get-{id}")
	public ResponseEntity<Product> getProduct(@PathVariable("id") Integer id) {
		System.out.println("receive get-{id}");
		System.out.println(id);
		return service.getProduct(id);
	}
	
	@GetMapping("/exist-{id}")
	public boolean isExist(@PathVariable("id") Integer id) {
		System.out.println(id);
		return service.isExist(id);
	}
	
	@GetMapping("/count")
	public long count(){
		return service.count();
	}
	
	@GetMapping("/pages")
	public long pages(){
		return service.totalPages();
	}
}
