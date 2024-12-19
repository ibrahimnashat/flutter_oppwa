package net.ogmods.flutter_oppwa;

import androidx.annotation.Nullable;

import com.oppwa.mobile.connect.checkout.meta.CheckoutThreeDS2Flow;
import com.oppwa.mobile.connect.exception.ErrorCode;
import com.oppwa.mobile.connect.payment.stcpay.STCPayVerificationOption;
import com.oppwa.mobile.connect.provider.Connect;
import com.oppwa.mobile.connect.provider.ThreeDS2Info;
import com.oppwa.mobile.connect.provider.TransactionType;
import com.oppwa.mobile.connect.provider.model.yookassa.YooKassaStatus;

public class FlutterEnums {
    public interface FlutterEnum<T> {
        T getValue();
    }

    @Nullable
    public static <T, K extends Enum<K> & FlutterEnum<T>> String toJson(K[] values, @Nullable T value) {
        if (value == null) return null;
        for (K e : values) if (e.getValue().equals(value)) return e.name();
        return null;
    }

    @Nullable
    public static <K extends Enum<K>> K find(K[] values, @Nullable String value) {
        if (value == null) return null;
        for (K e : values) if (e.name().equals(value)) return e;
        return null;
    }

    public enum FlutterProviderDomain implements FlutterEnum<Connect.ProviderDomain> {
        defaultDomain(Connect.ProviderDomain.DEFAULT),
        euDomain(Connect.ProviderDomain.EU);

        private final Connect.ProviderDomain value;

        FlutterProviderDomain(final Connect.ProviderDomain value) {
            this.value = value;
        }

        @Override
        public Connect.ProviderDomain getValue() {
            return this.value;
        }
    }

    public enum FlutterProviderMode implements FlutterEnum<Connect.ProviderMode> {
        test(Connect.ProviderMode.TEST),
        live(Connect.ProviderMode.LIVE);

        private final Connect.ProviderMode value;

        FlutterProviderMode(final Connect.ProviderMode value) {
            this.value = value;
        }

        @Override
        public Connect.ProviderMode getValue() {
            return this.value;
        }
    }

    public enum FlutterSTCPayVerificationOption implements FlutterEnum<STCPayVerificationOption> {
        mobilePhone(STCPayVerificationOption.MOBILE_PHONE),
        qrCode(STCPayVerificationOption.QR_CODE);

        private final STCPayVerificationOption value;

        FlutterSTCPayVerificationOption(final STCPayVerificationOption value) {
            this.value = value;
        }

        @Override
        public STCPayVerificationOption getValue() {
            return this.value;
        }
    }

    public enum FlutterTransactionType implements FlutterEnum<TransactionType> {
        sync(TransactionType.SYNC),
        async(TransactionType.ASYNC);

        private final TransactionType value;

        FlutterTransactionType(final TransactionType value) {
            this.value = value;
        }

        @Override
        public TransactionType getValue() {
            return this.value;
        }
    }

    public enum FlutterCheckoutThreeDS2Flow implements FlutterEnum<CheckoutThreeDS2Flow> {
        app(CheckoutThreeDS2Flow.APP),
        web(CheckoutThreeDS2Flow.WEB),
        disabled(CheckoutThreeDS2Flow.DISABLED);

        private final CheckoutThreeDS2Flow value;

        FlutterCheckoutThreeDS2Flow(final CheckoutThreeDS2Flow value) {
            this.value = value;
        }

        @Override
        public CheckoutThreeDS2Flow getValue() {
            return this.value;
        }
    }

    public enum FlutterYooKassaStatus implements FlutterEnum<YooKassaStatus> {
        succeeded(YooKassaStatus.SUCCEEDED),
        pending(YooKassaStatus.PENDING),
        waitingForCapture(YooKassaStatus.WAITING_FOR_CAPTURE),
        canceled(YooKassaStatus.CANCELED),
        undefined(YooKassaStatus.UNDEFINED);

        private final YooKassaStatus value;

        FlutterYooKassaStatus(final YooKassaStatus value) {
            this.value = value;
        }

        @Override
        public YooKassaStatus getValue() {
            return this.value;
        }
    }

    public enum FlutterThreeDS2Status implements FlutterEnum<ThreeDS2Info.AuthStatus> {
        authenticated(ThreeDS2Info.AuthStatus.AUTHENTICATED),
        attemptProcessingPerformed(ThreeDS2Info.AuthStatus.ATTEMPT_PROCESSING_PERFORMED),
        challengeRequired(ThreeDS2Info.AuthStatus.CHALLENGE_REQUIRED),
        decoupledConfirmed(ThreeDS2Info.AuthStatus.DECOUPLED_CONFIRMED),
        denied(ThreeDS2Info.AuthStatus.DENIED),
        rejected(ThreeDS2Info.AuthStatus.REJECTED),
        failed(ThreeDS2Info.AuthStatus.FAILED),
        informationalOnly(ThreeDS2Info.AuthStatus.INFORMATIONAL_ONLY);

        private final ThreeDS2Info.AuthStatus value;

        FlutterThreeDS2Status(final ThreeDS2Info.AuthStatus value) {
            this.value = value;
        }

        @Override
        public ThreeDS2Info.AuthStatus getValue() {
            return this.value;
        }
    }

    public enum FlutterErrorCode implements FlutterEnum<ErrorCode> {
        paymentParamsInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_INVALID),
        paymentParamsCheckoutIdInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_CHECKOUT_ID_INVALID),
        paymentParamsBrandInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_PAYMENT_BRAND_INVALID),
        paymentParamsTokenIdInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_TOKEN_INVALID),
        paymentParamsTokenizationUnsupported(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_TOKENIZATION_UNSUPPORTED),
        cardHolderInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_CARD_HOLDER_INVALID),
        cardNumberInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_CARD_NUMBER_INVALID),
        cardBrandInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_CARD_BRAND_INVALID),
        cardMonthInvalidFormat(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_CARD_MONTH_INVALID),
        cardYearInvalidFormat(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_CARD_YEAR_INVALID),
        cardExpired(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_CARD_EXPIRED),
        cardCvvInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_CARD_CVV_INVALID),
        bankAccountHolderInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_BANK_ACCOUNT_HOLDER_INVALID),
        bankAccountIbanInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_BANK_ACCOUNT_IBAN_INVALID),
        bankAccountCountryInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_BANK_ACCOUNT_COUNTRY_INVALID),
        bankAccountBankNameInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_BANK_ACCOUNT_BANK_NAME_INVALID),
        bankAccountBicInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_BANK_ACCOUNT_BIC_INVALID),
        bankAccountBankCodeInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_BANK_ACCOUNT_BANK_CODE_INVALID),
        bankAccountNumberInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_BANK_ACCOUNT_NUMBER_INVALID),
        phoneNumberInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_MOBILE_PHONE_INVALID),
        countryCodeInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_COUNTRY_CODE_INVALID),
        emailInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_EMAIL_INVALID),
        nationalIdentifierInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_NATIONAL_IDENTIFIER_INVALID),
        accountVerificationInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_ACCOUNT_VERIFICATION_INVALID),
        paymentTokenInvalid(ErrorCode.ERROR_CODE_PAYMENT_PARAMS_PAYMENT_TOKEN_MISSING),
        paymentProviderNotInitialized(ErrorCode.ERROR_CODE_PAYMENT_PROVIDER_NOT_INITIALIZED),
        paymentProviderInternalError(ErrorCode.ERROR_CODE_PAYMENT_PROVIDER_INTERNAL_ERROR),
        paymentProviderSecurityInvalidChecksum(ErrorCode.ERROR_CODE_PAYMENT_PROVIDER_SECURITY_INVALID_CHECKSUM),
        paymentProviderSecuritySslValidationFailed(ErrorCode.ERROR_CODE_PAYMENT_PROVIDER_SECURITY_SSL_VALIDATION_FAILED),
        paymentProviderConnectionFailure(ErrorCode.ERROR_CODE_PAYMENT_PROVIDER_CONNECTION_FAILURE),
        paymentProviderConnectionMalformedResponse(ErrorCode.ERROR_CODE_PAYMENT_PROVIDER_CONNECTION_MALFORMED_RESPONSE),
        noAvailablePaymentMethods(ErrorCode.ERROR_CODE_NO_AVAILABLE_PAYMENT_METHODS),
        paymentMethodNotAvailable(ErrorCode.ERROR_CODE_PAYMENT_METHOD_NOT_AVAILABLE),
        checkoutSettingsMissed(ErrorCode.ERROR_CODE_CHECKOUT_SETTINGS_MISSED),
        transactionAborted(ErrorCode.ERROR_CODE_TRANSACTION_ABORTED),
        unexpectedException(ErrorCode.ERROR_CODE_UNEXPECTED_EXCEPTION),
        googlepay(ErrorCode.ERROR_CODE_GOOGLEPAY),
        klarnaInline(ErrorCode.ERROR_CODE_KLARNA_INLINE),
        bancontactLink(ErrorCode.ERROR_CODE_BANCONTACT_LINK),
        threeds2Failed(ErrorCode.ERROR_CODE_THREEDS2_FAILED),
        threeds2Canceled(ErrorCode.ERROR_CODE_THREEDS2_CANCELED);

        private final ErrorCode value;

        FlutterErrorCode(final ErrorCode value) {
            this.value = value;
        }

        @Override
        public ErrorCode getValue() {
            return this.value;
        }
    }
}
