package Enterprise.SmartWarehouse.Order.Entities;

import jakarta.persistence.*;

@Entity
@Table(name = "order_item")
public class OrderItem {

	@Id
	private Integer itemId;

	@ManyToOne
	@JoinColumn(name = "header_id")
	private OrderHeader orderHeader;

	private Integer price;
	private Integer quantity;
	private String symbol;
	@Column(name = "total_price")
	private Integer totalPrice;

	public OrderItem() {

	}

	public Integer getItemId() {
		return itemId;
	}

	public void setItemId(Integer itemId) {
		this.itemId = itemId;
	}

	public OrderHeader getOrderHeader() {
		return orderHeader;
	}

	public void setOrderHeader(OrderHeader orderHeader) {
		this.orderHeader = orderHeader;
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

	public Integer getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(Integer totalPrice) {
		this.totalPrice = totalPrice;
	}

	@Override
	public String toString() {
		return "OrderItem [itemId=" + itemId + ", orderHeader=" + orderHeader + ", price=" + price + ", quantity="
				+ quantity + ", symbol=" + symbol + ", totalPrice=" + totalPrice + "]";
	}

}
