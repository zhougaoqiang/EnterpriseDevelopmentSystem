package Enterprise.SmartWarehouse.Product.Entities;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class Product {
	public enum EProductType
	{
		NonWeight,
		Weight,
	}
	@Id
	private Integer id;
	private String name;
	private EProductType type;
	private Integer price;
	private Integer quantity;
	private String symbol;
	
	public Product()
	{
		
	}
	
	public Product(Integer id, String name, EProductType type, Integer price, Integer quantity, String symbol) {
		super();
		this.id = id;
		this.name = name;
		this.type = type;
		this.price = price;
		this.quantity = quantity;
		this.symbol = symbol;
	}
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public EProductType getType() {
		return type;
	}
	public void setType(EProductType type) {
		this.type = type;
	}
	public Integer getPrice() {
		return price;
	}
	public void setPrice(Integer price) {
		this.price = price;
	}
	public Integer getQuantity() {
		return quantity;
	}
	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}
	public String getSymbol() {
		return symbol;
	}
	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}

	

}
