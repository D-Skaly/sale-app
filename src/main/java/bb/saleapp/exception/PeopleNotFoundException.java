package bb.saleapp.exception;

import org.springframework.http.HttpStatus;

public class PeopleNotFoundException extends ApiException {

    public PeopleNotFoundException(String message) {
        super(message, HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
    }
}
