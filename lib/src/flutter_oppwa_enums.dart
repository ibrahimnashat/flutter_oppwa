enum PaymentType {
  ///A stand-alone authorisation that will also trigger optional risk management and validation. A Capture (CP) with reference to the Preauthorisation (PA) will confirm the payment..
  preauthorization("PA"),

  ///Debits the account of the end customer and credits the merchant account.
  debit("DB"),

  ///Credits the account of the end customer and debits the merchant account.
  credit("CD"),

  ///Captures a preauthorized (PA) amount.
  capture("CP"),

  ///Reverses an already processed Preauthorization (PA), Debit (DB) or Credit (CD) transaction. As a consequence, the end customer will never see any booking on his statement. A Reversal is only possible until a connector specific cut-off time. Some connectors don't support Reversals.
  reversal("RV"),

  ///Credits the account of the end customer with a reference to a prior Debit (DB) or Credit (CD) transaction. The end customer will always see two bookings on his statement. Some connectors do not support Refunds.
  refund("RF");

  final String value;
  const PaymentType(this.value);
}

// OPP Enums
/// An enumeration of possible 3-D Secure 2 flows.
enum CheckoutThreeDS2Flow {
  /// 3-D Secure 2 native application flow.
  app,

  /// 3-D Secure 2 native browser flow.
  web,

  /// Fallback to  3-D Secure 1 flow.
  disabled,
}

/// An enumeration for the various provider modes.
enum ProviderMode {
  /// Sandbox environment for testing integration.
  test,

  /// Live server for real transactions.
  live,
}

/// An enumeration for server endpoint domain.
enum ProviderDomain {
  /// oppwa.com for Live server mode, test.oppwa.com for Sandbox mode.
  defaultDomain,

  /// eu-prod.oppwa.com for Live server mode, eu-test.oppwa.com for Sandbox mode.
  euDomain,
}

/// An enumeration for the various types of transaction.
enum TransactionType {
  /// The synchronous transaction.
  sync,

  /// The asynchronous transaction.
  async,

  /// The transaction is undefined.
  undefined,
}

/// Enumeration of possible statuses of YooKassa payment.
enum YooKassaStatus {
  /// Payment is successfully completed.
  succeeded,

  /// Payment is created, waiting for user confirmation.
  pending,

  /// Payment is made, funds are authorized and waiting for capture.
  waitingForCapture,

  /// Payment is canceled.
  canceled,

  /// Status is not defined.
  undefined,
}

///An enumeration of possible options to proceed STC Pay payment.
enum STCPayVerificationOption {
  /// Mobile phone number option.
  mobilePhone,

  /// QR-Code option.
  qrCode,
}

/// Enumeration of possible statuses for 3-D Secure 2 authentication.
enum ThreeDS2Status {
  /// Authentication/verification successful.
  authenticated,

  /// Not authentication/not verified, but a proof of attempted authentication/verification is provided.
  attemptProcessingPerformed,

  /// In-app challenge required; additional authentication is required using in-app challenge screens.
  challengeRequired,

  /// External challenge required; decoupled authentication confirmed.
  decoupledConfirmed,

  /// Not authenticated or account not verified, transaction denied.
  denied,

  /// Issuer is rejecting authentication/verification and request that authorization not attempted.
  rejected,

  /// Authentication/verification cannot be performed due to some technical or other problems.
  failed,

  /// Informational only; 3DS Requestor challenge preference acknowledged.
  informationalOnly,

  /// [iOS Only] Authentication parameters are required.
  authParamsRequired,

  /// [iOS Only] Status is not defined.
  undefined
}

enum CVVMode {
  none,
  optional,
  required,
}

enum ErrorCode {
  /// Unsupported transaction payment params.
  paymentParamsUnsupported,
  paymentParamsInvalid,

  /// Transaction checkout ID is not valid.
  paymentParamsCheckoutIdInvalid,

  /// Brand doesn't match payment params class.
  paymentParamsBrandInvalid,

  /// The token identifier is invalid. Must be alpha-numeric string of length 32.
  paymentParamsTokenIdInvalid,

  /// Tokenization is not supported for chosen payment brand.
  paymentParamsTokenizationUnsupported,

  /// Holder must at least contain first and last name.
  cardHolderInvalid,

  /// Invalid card number. Does not pass the Luhn check.
  cardNumberInvalid,

  /// Unsupported card brand.
  cardBrandInvalid,

  /// Month must be in the format MM.
  cardMonthInvalidFormat,

  /// Year must be in the format YYYY.
  cardYearInvalidFormat,

  /// Card is expired.
  cardExpired,

  /// CVV invalid. Must be three or four digits.
  cardCvvInvalid,

  /// Holder of the bank account is not valid.
  bankAccountHolderInvalid,

  /// IBAN is not valid.
  bankAccountIbanInvalid,

  /// The country code of the bank is invalid. Should match ISO 3166-1 two-letter standard.
  bankAccountCountryInvalid,

  /// The name of the bank which holds the account is invalid.
  bankAccountBankNameInvalid,

  /// The BIC (Bank Identifier Code (SWIFT)) number of the bank account is invalid.
  bankAccountBicInvalid,

  /// The code associated with the bank account is invalid.
  bankAccountBankCodeInvalid,

  /// The account number of the bank account is invalid.
  bankAccountNumberInvalid,

  /// The Apple Pay payment token data is invalid. To perform this type of transaction a valid payment token data is needed.
  applePayTokenDataInvalid,

  /// The phone number is not valid.
  phoneNumberInvalid,

  /// The country code is not valid.
  countryCodeInvalid,

  /// The email is not valid.
  emailInvalid,

  /// The national identifier is not valid.
  nationalIdentifierInvalid,

  /// The account verification is not valid.
  accountVerificationInvalid,

  /// The payment token is invalid. To perform this type of transaction a valid payment token is needed.
  paymentTokenInvalid,

  paymentProviderNotInitialized,
  paymentProviderInternalError,
  paymentProviderSecurityInvalidChecksum,
  paymentProviderSecuritySslValidationFailed,
  paymentProviderConnectionFailure,
  paymentProviderConnectionMalformedResponse,

  /// There are no available payment methods in checkout.
  noAvailablePaymentMethods,

  /// Payment method is not available.
  paymentMethodNotAvailable,

  checkoutSettingsMissed,

  /// The transaction was aborted.
  transactionAborted,

  unexpectedException,
  googlepay,

  /// Klarna Payments specific error.
  klarnaInline,

  /// Bancontact Link specific error.
  bancontactLink,

  threeds2Failed,
  threeds2Canceled,

  /// Checkout info cannot be loaded.
  checkoutInfoCannotBeLoaded,

  /// Brand validation rules cannot be loaded from.
  brandValidationCannotBeLoaded,

  /// The transaction was declined. Please contact the system administrator of the merchant server to get the reason of failure.
  transactionProcessingFailure,

  /// The сheckout configuration is not valid.
  invalidCheckoutConfiguration,

  /// Unexpected connection error. Please contact the system administrator of the server.
  connectionFailure,

  /// Invalid input parameters for the request.
  requestParametersInvalid,

  /// Invalid response from the Server.
  serverResponseInvalid,

  /// File loaded from resources does not have valid checksum. Make sure you installed the framework correctly and no one has been tampering with the application.
  securityXmlManipulation,

  /// Vipps Link specific error.
  vippsLink,

  /// 3-D Secure 2 transaction error.
  threeDs2Failure,

  /// 3-D Secure 2 transaction was cancelled.
  threeDs2ChallengeCanceled,

  /// Card Scanning general error.
  cardScanningGeneralError,
}
