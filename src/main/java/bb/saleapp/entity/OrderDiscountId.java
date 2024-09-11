package bb.saleapp.entity;

import jakarta.persistence.Embeddable;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.Objects;

@Setter
@Getter
@RequiredArgsConstructor
@Embeddable
public class OrderDiscountId implements Serializable {

    private Long orderId;
    private Long discountId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        OrderDiscountId that = (OrderDiscountId) o;
        return Objects.equals(orderId, that.orderId) &&
                Objects.equals(discountId, that.discountId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(orderId, discountId);
    }
}
