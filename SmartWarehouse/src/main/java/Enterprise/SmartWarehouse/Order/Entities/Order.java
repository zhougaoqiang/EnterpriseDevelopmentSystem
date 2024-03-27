package Enterprise.SmartWarehouse.Order.Entities;
import java.util.List;

public class Order {
    private OrderHeader orderHeader;
    private List<OrderItem> orderItems;

    public Order() {
    }

    public OrderHeader getOrderHeader() {
        return orderHeader;
    }

    public void setOrderHeader(OrderHeader orderHeader) {
        this.orderHeader = orderHeader;
    }

    public List<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

	@Override
	public String toString() {
		return "Order [orderHeader=" + orderHeader;
	}
    
    
}
