package Enterprise.SmartWarehouse.Order.Entities;

import org.springframework.data.jpa.domain.Specification;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;

public class OrderHeaderSpecification {
	public static Specification<OrderHeader> hasStatus(EDeliveryStatus status) {
		return (root, query, criteriaBuilder) -> criteriaBuilder.equal(root.get("deliveryStatus"), status);
	}
}
