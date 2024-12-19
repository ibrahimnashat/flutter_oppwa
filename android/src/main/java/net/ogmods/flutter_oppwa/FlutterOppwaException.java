package net.ogmods.flutter_oppwa;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;


class FlutterOppwaException extends Exception {

    private final String errorCode;

    public FlutterOppwaException(
            @NonNull String errorCode,
            @NonNull String message,
            @Nullable Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
    }

    public final String getErrorCode() {
        return errorCode;
    }

}
