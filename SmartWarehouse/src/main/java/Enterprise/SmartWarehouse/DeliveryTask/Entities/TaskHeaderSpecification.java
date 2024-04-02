package Enterprise.SmartWarehouse.DeliveryTask.Entities;

import org.springframework.data.jpa.domain.Specification;
import Enterprise.SmartWarehouse.Order.Entities.OrderHeader.EDeliveryStatus;

public class TaskHeaderSpecification {
    public static Specification<TaskHeader> hasStatus(EDeliveryStatus status) {
        return (root, query, criteriaBuilder) -> criteriaBuilder.equal(root.get("status"), status);
    }
}
