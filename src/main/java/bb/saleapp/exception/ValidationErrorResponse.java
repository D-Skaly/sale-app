package bb.saleapp.exception;

import lombok.Getter;
import lombok.Setter;
import org.springframework.http.HttpStatus;

import java.time.LocalDateTime;
import java.util.Map;

@Setter
@Getter
public class ValidationErrorResponse extends ApiErrorResponse {
    private Map<String, String> validationErrors;

    public ValidationErrorResponse(LocalDateTime timestamp, String message, String details, HttpStatus status, String errorCode, Map<String, String> validationErrors) {
        super(timestamp, message, details, status, errorCode);
        this.validationErrors = validationErrors;
    }
}
