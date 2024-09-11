package bb.saleapp.exception;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Global exception handler for the application.
 */
@ControllerAdvice
public class GlobalResponseEntityExceptionHandler extends ResponseEntityExceptionHandler {

    @Override
    protected ResponseEntity<Object> handleNoResourceFoundException(
            @NonNull NoResourceFoundException ex,
            @Nullable HttpHeaders headers,
            @Nullable HttpStatusCode status,
            @Nullable WebRequest request){

        HttpStatus httpStatus = (status != null) ? HttpStatus.valueOf(status.value()) : HttpStatus.BAD_REQUEST;
        ApiErrorResponse errorResponse = new ApiErrorResponse(
                LocalDateTime.now(),
                ex.getMessage(),
                request != null ? request.getDescription(true) : ErrorCode.NOT_FOUND.getDescription(),
                httpStatus,
                ErrorCode.NOT_FOUND.getCode()
        );
        return new ResponseEntity<>(errorResponse, httpStatus);
    }


    /**
     * Customize the handling of {@link MethodArgumentNotValidException}.
     * <p>This method delegates to {@link #handleExceptionInternal}.
     *
     * @param ex      the exception to handle
     * @param headers the headers to be written to the response
     * @param status  the selected response status
     * @param request the current request
     * @return a {@code ResponseEntity} for the response to use, possibly
     * {@code null} when the response is already committed
     */
    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(
            @NonNull MethodArgumentNotValidException ex,
            @Nullable HttpHeaders headers,
            @Nullable HttpStatusCode status,
            @Nullable WebRequest request) {

        Map<String, String> validationErrors = ex.getBindingResult().getFieldErrors().stream()
                .collect(Collectors.toMap(
                        FieldError::getField,
                        fieldError -> fieldError.getDefaultMessage() != null ? fieldError.getDefaultMessage() : "Invalid value"
                ));

        HttpStatus httpStatus = (status != null) ? HttpStatus.valueOf(status.value()) : HttpStatus.BAD_REQUEST;

        ValidationErrorResponse errorResponse = new ValidationErrorResponse(
                LocalDateTime.now(),
                "Validation failed",
                request != null ? request.getDescription(true) : ErrorCode.VALIDATION_ERROR.getDescription(),
                httpStatus,
                ErrorCode.VALIDATION_ERROR.getCode(),
                validationErrors
        );

        return new ResponseEntity<>(errorResponse, httpStatus);
    }

    /**
     * Handles ApiException and provides a standardized error response.
     *
     * @param ex      the exception
     * @param request the web request
     * @return a ResponseEntity with an ApiErrorResponse
     */
    @ExceptionHandler(ApiException.class)
    public ResponseEntity<ApiErrorResponse> handleApiException(ApiException ex, WebRequest request) {
        ApiErrorResponse errorResponse = new ApiErrorResponse(
                LocalDateTime.now(),
                ex.getMessage(),
                request.getDescription(true),
                ex.getStatus(),
                ex.getErrorCode().getCode()
        );
        return new ResponseEntity<>(errorResponse, ex.getStatus());
    }

    /**
     * Handles general exceptions and provides a generic error response.
     *
     * @param ex      the exception
     * @param request the web request
     * @return a ResponseEntity with an ApiErrorResponse
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiErrorResponse> handleGlobalException(Exception ex, WebRequest request) {
        ApiErrorResponse errorResponse = new ApiErrorResponse(
                LocalDateTime.now(),
                ex.getMessage(),
                request.getDescription(true),
                HttpStatus.INTERNAL_SERVER_ERROR,
                ErrorCode.GENERAL_ERROR.getCode()
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
