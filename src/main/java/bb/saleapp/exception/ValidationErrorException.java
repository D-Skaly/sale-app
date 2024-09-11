package bb.saleapp.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

import java.util.Map;

/**
 * Exception thrown when validation errors occur.
 */
@Getter
public class ValidationErrorException extends ApiException {
    /**
     * -- GETTER --
     *  Retrieves the list of validation error messages.
     *
     */
    private final Map<String, String> validationErrors;

    /**
     * Constructs a ValidationErrorException with the specified message and validation errors.
     *
     * @param message the detail message.
     * @param validationErrors the list of validation error messages.
     */
    public ValidationErrorException(String message, Map<String, String> validationErrors) {
        super(message, HttpStatus.BAD_REQUEST, ErrorCode.VALIDATION_ERROR);
        this.validationErrors = validationErrors;
    }

}
