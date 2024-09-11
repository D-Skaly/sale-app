package bb.saleapp.exception;

import lombok.Getter;

@Getter
public enum ErrorCode {

    // General errors
    NOT_FOUND("NOT_FOUND", "The requested resource was not found."),
    VALIDATION_ERROR("VALIDATION_ERROR", "There was a validation issue with the input data."),
    GENERAL_ERROR("GENERAL_ERROR", "An unspecified error occurred."),

    // Authorization errors
    UNAUTHORIZED("UNAUTHORIZED", "Access is denied."),
    FORBIDDEN("FORBIDDEN", "Access to the resource is forbidden."),

    // Specific errors
    OUT_OF_STOCK("OUT_OF_STOCK", "The item is out of stock."),
    ALREADY_PROCESSED("ALREADY_PROCESSED", "The request has already been processed."),
    CANNOT_BE_MODIFIED("CANNOT_BE_MODIFIED", "The resource cannot be modified."),
    PAYMENT_FAILED("PAYMENT_FAILED", "The payment process failed.");

    private final String code;
    private final String description;

    ErrorCode(String code, String description) {
        this.code = code;
        this.description = description;
    }

    /**
     * Find the error code by its string representation.
     *
     * @param code the string representation of the error code.
     * @return the corresponding ErrorCode.
     * @throws IllegalArgumentException if the error code does not exist.
     */
    public static ErrorCode fromCode(String code) {
        for (ErrorCode errorCode : values()) {
            if (errorCode.getCode().equals(code)) {
                return errorCode;
            }
        }
        throw new IllegalArgumentException("Invalid error code: " + code);
    }
}
