package Enterprise.SmartWarehouse.Product.Service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import Enterprise.SmartWarehouse.Product.Entities.Product;
import Enterprise.SmartWarehouse.Product.Repository.ProductRepository;

@Service
public class ProductService {
	@Autowired
	ProductRepository productRepos;
	final public int maxShowInOnePage = 10;
	
	public Page<Product> findAll(Pageable pageable){
        return productRepos.findAll(pageable);
	}

	public boolean stockIn(List<Product> products)
	{
		for(Product product : products)
		{
			Optional<Product> productOpt = productRepos.findById(product.getId());
		    if (!productOpt.isPresent())
		    {
		    	return false;
		    }
		}
		
		for(Product product : products)
		{
			Optional<Product> productOpt = productRepos.findById(product.getId());
		    Product pd = productOpt.get();
		    pd.setQuantity(pd.getQuantity() + product.getQuantity());
		    productRepos.saveAndFlush(pd);
		}
		return true;
	}
	
	public Product createProduct(Product product)
	{
		return productRepos.saveAndFlush(product);
	}

	public void deleteProduct(Product product)
	{
		productRepos.deleteById(product.getId());
	}
	
	public Product updateProduct(Product product){
		return productRepos.save(product);
	}

	public ResponseEntity<Product> getProduct(Integer id) {
	    Optional<Product> productOpt = productRepos.findById(id);
	    if (productOpt.isPresent()) {
	        return ResponseEntity.ok(productOpt.get()); //返回 HTTP 状态码 200（OK）和产品数据
	    } else {
	        return ResponseEntity.notFound().build(); //返回 HTTP 状态码 404（Not Found
	    }
	}
	
	public boolean isExist(Integer id) {
		return productRepos.existsById(id);
	}
	
	public long count(){
		return productRepos.count();
	}
	
	public int totalPages() {
		return (int) ((productRepos.count() / maxShowInOnePage) + 1);
	}
}
