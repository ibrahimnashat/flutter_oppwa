import 'dart:typed_data';
import 'flutter_oppwa_enums.dart';
import 'parser.dart';

/// Class to encapsulate the parameters related to the checkout.
class CheckoutInfo {
  /// The amount of the transaction in the specified currency
  final double? amount;

  /// {Android Only}
  final List<String>? brands;

  /// ISO 4217 currency code
  final String? currencyCode;

  /// The endpoint where the transaction will be sent to.
  final String? endpoint;

  /// The merchant IDs related to Klarna Invoice and Klarna Installments.
  final List<String>? klarnaMerchantIds;

  /// Relative path to get status of transaction.
  final String? resourcePath;

  /// Payment brands for which 3-D Secure 2 is enabled.
  final List<String>? threeDs2Brands;

  /// 3-D Secure 2 integration flow.
  final CheckoutThreeDS2Flow? threeDs2Flow;

  /// Tokens related to the checkout.
  final List<Token>? tokens;

  /// {iOS Only} Shows if ReD Shield Device Id collecting is enabled or disabled.
  final bool? collectRedShieldDeviceId;

  /// {iOS Only} A flag that specifies if browser parameters should be collected for 3-D Secure 2.
  final bool? browserParamsRequired;

  /// {iOS Only} Brand configuration parameters from the Server.
  final PaymentBrandsConfig? paymentBrandsConfig;

  CheckoutInfo.fromMap(Map<String, dynamic> map)
      : amount = map.getNullableValue("amount"),
        brands = map.castNullableList("brands"),
        currencyCode = map.getNullableValue("currencyCode"),
        endpoint = map.getNullableValue("endpoint"),
        klarnaMerchantIds = map.castNullableList("klarnaMerchantIds"),
        resourcePath = map.getNullableValue("resourcePath"),
        threeDs2Brands = map.castNullableList("threeDs2Brands"),
        threeDs2Flow =
            map.getNullableEnum(CheckoutThreeDS2Flow.values, "threeDs2Flow"),
        tokens = map.parseNullableList("tokens", Token.fromMap),
        collectRedShieldDeviceId =
            map.getNullableValue("collectRedShieldDeviceId"),
        browserParamsRequired = map.getNullableValue("browserParamsRequired"),
        paymentBrandsConfig = map.parseNullableValue(
            "paymentBrandsConfig", PaymentBrandsConfig.fromMap);
}

/// Class to encapsulate the parameters needed for performing transaction.
class Transaction {
  /// Constant for a key to get Klarna Payments client token value from the transaction response.
  static const String klarnaInlineClientTokenKey = "clientToken";

  /// Constant for a key to get Klarna Payments callback URL value from the transaction response.
  static const String klarnaInlineClientCallbackUrlKey = "callbackUrl";

  /// Constant for a key to get Klarna Payments failure callback URL from the transaction response.
  static const String klarnaInlineClientFailureCallbackUrlKey =
      "failureCallbackUrl";

  /// Constant for a key to get Klarna Payments initial transaction id from the transaction response.
  static const String klarnaInlineInitialTransactionIdKey = "connectorId";

  /// Constant for a key to get Alipay seller's order information which should be forwarded to Alipay native SDK.
  static const String alipaySignedOrderInfoKey = "alipaySignedOrderInfo";

  /// Constant for a key to get Bancontact app scheme URL to redirect to the Bancontact app.
  static const String bancontactLinkAppSchemeUrlKey = "secureTransactionId";

  /// The type of the transaction.
  final TransactionType? transactionType;

  /// The parameters representing a specific payment method.
  final PaymentParams? paymentParams;

  /// The URL to the receiver system (e.g. 3-D Secure, PayPal) that the shopper should be forwarded to. The property has `nil` value on synchronous transaction.
  final String? redirectUrl;

  /// 3-D Secure 2 response parameters.
  final ThreeDS2Info? threeDS2Info;

  /// YooKassa response parameters.
  final YooKassaInfo? yooKassaInfo;

  /// The URL which posts threeDSMethodData to the ACS. It should be opened in a hidden i-frame.
  final String? threeDS2MethodRedirectUrl;

  /// Dictionary for holding brand-specific parameters like:
  /// See [Transaction.klarnaInlineClientTokenKey], [Transaction.klarnaInlineClientCallbackUrlKey], [Transaction.klarnaInlineClientFailureCallbackUrlKey], [Transaction.klarnaInlineInitialTransactionIdKey], [Transaction.alipaySignedOrderInfoKey].
  final Map<String, String>? brandSpecificInfo;

  Transaction.fromMap(Map<String, dynamic> map)
      : transactionType =
            map.getNullableEnum(TransactionType.values, "transactionType"),
        brandSpecificInfo = map.castNullableMap("brandSpecificInfo"),
        paymentParams =
            map.parseNullableValue("paymentParams", PaymentParams.parse),
        threeDS2Info =
            map.parseNullableValue("threeDS2Info", ThreeDS2Info.fromMap),
        yooKassaInfo =
            map.parseNullableValue("yooKassaInfo", YooKassaInfo.fromMap),
        redirectUrl = map.getNullableValue("redirectUrl"),
        threeDS2MethodRedirectUrl =
            map.getNullableValue("threeDS2MethodRedirectUrl");
}

/// Class to encapsulate the payment brand configuration parameters from the Server.
class PaymentBrandsConfig {
  /// A flag that specifies whether payment brands from the Server are enabled or not.
  final bool? enabled;

  /// Payment brand list from the Server.
  final List<String>? paymentBrands;

  /// A flag that specifies whether override checkout payment brands with brands from the Server or not.
  final bool? shouldOverride;

  PaymentBrandsConfig.fromMap(Map<String, dynamic> map)
      : enabled = map.getNullableValue("enabled"),
        paymentBrands = map.castNullableList("paymentBrands"),
        shouldOverride = map.getNullableValue("shouldOverride");
}

/// Class to represent a set of parameters needed for performing an e-commerce transaction.
class PaymentParams {
  /// A property that can be set with a value from initial checkout request (mandatory). This value is required in the next steps.
  final String? checkoutId;

  /// The payment brand of the transaction.
  final String? paymentBrand;

  /// This URL will receive the result of an asynchronous payment. Must be sent URL encoded.
  final String? shopperResultUrl;

  /// {iOS Only} Dictionary of custom parameters that will be sent to the server.
  final Map<String, String>? customParams;

  PaymentParams.fromMap(Map<String, dynamic> map)
      : checkoutId = map.getNullableValue("checkoutId"),
        paymentBrand = map.getNullableValue("paymentBrand"),
        shopperResultUrl = map.getNullableValue("shopperResultUrl"),
        customParams = map.castNullableMap("customParams");

  static PaymentParams parse(Map<String, dynamic> map) {
    var typename = map.getNullableValue("__typename__");
    if (typename == "CardPaymentParams") {
      return CardPaymentParams.fromMap(map);
    } else if (typename == "STCPayPaymentParams") {
      return STCPayPaymentParams.fromMap(map);
    } else if (typename == "TokenPaymentParams") {
      return TokenPaymentParams.fromMap(map);
    } else if (typename == "ApplePayPaymentParams") {
      return ApplePayPaymentParams.fromMap(map);
    } else {
      return PaymentParams.fromMap(map);
    }
    // TODO add other types
  }
}

/// Class to represent a set of base parameters for common and tokenized cards.
class BaseCardPaymentParams extends PaymentParams {
  /// The CVV code found on the card. Property should be set, if CVV check is required for transaction processing.
  final String? cvv;

  /// The number of installments the payment should be split into.
  final int? numberOfInstallments;

  /// The params needed for 3-D Secure 2 authentication request.
  final String? threeDS2AuthParams;

  BaseCardPaymentParams.fromMap(Map<String, dynamic> map)
      : cvv = map.getNullableValue("cvv"),
        numberOfInstallments = map.getNullableValue("numberOfInstallments"),
        threeDS2AuthParams = map.getNullableValue("threeDS2AuthParams"),
        super.fromMap(map);
}

///  Class to encapsulate all necessary transaction parameters for performing an STC Pay transaction.
class STCPayPaymentParams extends PaymentParams {
  /// Shopper's mobile phone number
  final String? mobilePhoneNumber;

  /// {Android Only} The verification option to proceed STC Pay transaction
  final STCPayVerificationOption? verificationOption;

  STCPayPaymentParams.fromMap(Map<String, dynamic> map)
      : mobilePhoneNumber = map.getNullableValue("mobilePhoneNumber"),
        verificationOption = map.getNullableEnum(
            STCPayVerificationOption.values, "verificationOption"),
        super.fromMap(map);
}

///  Class to encapsulate all necessary transaction parameters for performing an Apple Pay transaction.
class ApplePayPaymentParams extends PaymentParams {
  /// UTF-8 encoded JSON dictionary of encrypted payment data.  Ready for transmission to merchant's e-commerce backend for decryption and submission to a payment processor's gateway.
  final Uint8List? tokenData;

  ApplePayPaymentParams.fromMap(Map<String, dynamic> map)
      : tokenData = map.getNullableValue("tokenData"),
        super.fromMap(map);
}

/// Class to represent a set of card parameters needed for performing an e-commerce card transaction.
///
/// After getting an authorization for the transaction the parameters are masked in accordance to PCI PA DSS requirements.
class CardPaymentParams extends BaseCardPaymentParams {
  /// Holder of the card account. The length must be greater than 3 characters and less then 128 character.
  final String? holder;

  /// The card number. It may contain spaces `" "` and dashes `"-"`.
  final String? number;

  /// The card expiry month in the format `MM`.
  final String? expiryMonth;

  /// The card expiry year in the format `YYYY`.
  final String? expiryYear;

  /// The customer's country code.
  final String? countryCode;

  /// The customer's mobile number.
  final String? mobilePhone;

  /// {iOS Only} Default is [false]. If [true], the payment information will be stored for future use.
  final bool? tokenizationEnabled;

  /// The customer's billing address.
  final BillingAddress? billingAddress;

  CardPaymentParams.fromMap(Map<String, dynamic> map)
      : holder = map.getNullableValue("holder"),
        number = map.getNullableValue("number"),
        expiryMonth = map.getNullableValue("expiryMonth"),
        expiryYear = map.getNullableValue("expiryYear"),
        countryCode = map.getNullableValue("countryCode"),
        mobilePhone = map.getNullableValue("mobilePhone"),
        tokenizationEnabled = map.getNullableValue("tokenizationEnabled"),
        billingAddress =
            map.parseNullableValue("billingAddress", BillingAddress.fromMap),
        super.fromMap(map);
}

/// Class to encapsulate all necessary transaction parameters for performing a token transaction.
class TokenPaymentParams extends BaseCardPaymentParams {
  /// The identifier of the token that can be used to reference the token later.
  final String? tokenId;

  TokenPaymentParams.fromMap(Map<String, dynamic> map)
      : tokenId = map.getNullableValue("tokenId"),
        super.fromMap(map);
}

/// Class to hold billing address of the customer.
class BillingAddress {
  /// The country of the billing address.
  final String? country;

  /// The county, state or region of the billing address.
  final String? state;

  /// The city of the billing address.
  final String? city;

  /// The postal code or zip code of the billing address.
  final String? postCode;

  /// The door number, floor, building number, building name, and/or street name of the billing address.
  ///
  /// Mandatory for 3D Secure v2.
  final String? street1;

  /// The adjoining road or locality (if required) of the billing address.
  ///
  /// The combination of street1 and street2 can't contain numbers only, it should also include characters.
  final String? street2;

  BillingAddress.fromMap(Map<String, dynamic> map)
      : country = map.getNullableValue("country"),
        state = map.getNullableValue("state"),
        city = map.getNullableValue("city"),
        postCode = map.getNullableValue("postCode"),
        street1 = map.getNullableValue("street1"),
        street2 = map.getNullableValue("street2");
}

/// Class to represent 3-D Secure 2 parameters.
class ThreeDS2Info {
  /// Status of 3-D Secure 2 authentication.
  final ThreeDS2Status? authStatus;

  /// Authentication response as json string required for launching in-app challenge screens.
  final String? authResponse;

  /// Protocol version of 3-D Secure 2.
  final String? protocolVersion;

  /// The callback URL string to send the params needed for 3-D Secure 2 authentication request.
  final String? callbackUrl;

  /// The challenge completion callback URL string to inform Mastercard Payment Gateway Services that the challenge has been completed.
  final String? challengeCompletionCallbackUrl;

  /// Text provided by the ACS/Issuer to Cardholder during a Frictionless or Decoupled transaction.
  final String? cardHolderInfo;

  ThreeDS2Info.fromMap(Map<String, dynamic> map)
      : authStatus = map.getNullableEnum(ThreeDS2Status.values, "authStatus"),
        authResponse = map.getNullableValue("authResponse"),
        protocolVersion = map.getNullableValue("protocolVersion"),
        callbackUrl = map.getNullableValue("callbackUrl"),
        challengeCompletionCallbackUrl =
            map.getNullableValue("challengeCompletionCallbackUrl"),
        cardHolderInfo = map.getNullableValue("cardHolderInfo");
}

/// Class to represent YooKassa parameters needed for performing transaction.
class YooKassaInfo {
  /// Status of YooKassa payment.
  final YooKassaStatus? status;

  /// The URL string to redirect the user to confirm payment.
  final String? confirmationUrl;

  /// The URL string to notify backend about payment completion.
  final String? callbackUrl;

  YooKassaInfo.fromMap(Map<String, dynamic> map)
      : status = map.getNullableEnum(YooKassaStatus.values, "status"),
        confirmationUrl = map.getNullableValue("confirmationUrl"),
        callbackUrl = map.getNullableValue("callbackUrl");
}

/// Class to encapsulate shopper’s payment details that have been tokenized.
class Token {
  /// The identifier of the token that can be used to reference the token later.
  final String? tokenId;

  /// The payment brand of the transaction.
  final String? paymentBrand;

  /// Shopper’s bank account details.
  final BankAccount? bankAccount;

  /// Shopper’s card details.
  final Card? card;

  /// Shopper’s virtual account details.
  final VirtualAccount? virtualAccount;

  Token.fromMap(Map<String, dynamic> map)
      : tokenId = map.getNullableValue("tokenId"),
        paymentBrand = map.getNullableValue("paymentBrand"),
        bankAccount =
            map.parseNullableValue("bankAccount", BankAccount.fromMap),
        card = map.parseNullableValue("card", Card.fromMap),
        virtualAccount =
            map.parseNullableValue("virtualAccount", VirtualAccount.fromMap);
}

/// Class to encapsulate shopper’s bank account details that have been tokenized.
class BankAccount {
  /// The name of the bank account holder.
  final String? holder;

  /// The IBAN (International Bank Account Number) associated with the bank account.
  final String? iban;

  BankAccount.fromMap(Map<String, dynamic> map)
      : holder = map.getNullableValue("holder"),
        iban = map.getNullableValue("iban");
}

/// Class to encapsulate shopper’s card details that have been tokenized.
class Card {
  /// Name of card holder.
  final String? holder;

  /// The last 4 digits of the card number.
  final String? last4Digits;

  /// The card’s expiration month.
  final String? expiryMonth;

  /// The card’s expiration year.
  final String? expiryYear;

  Card.fromMap(Map<String, dynamic> map)
      : holder = map.getNullableValue("holder"),
        last4Digits = map.getNullableValue("last4Digits"),
        expiryMonth = map.getNullableValue("expiryMonth"),
        expiryYear = map.getNullableValue("expiryYear");
}

/// Class to encapsulate shopper’s payment details that have been tokenized.
class VirtualAccount {
  /// The name of virtual account holder.
  final String? holder;

  /// The identifier of the virtual account.
  final String? accountId;

  VirtualAccount.fromMap(Map<String, dynamic> map)
      : holder = map.getNullableValue("holder"),
        accountId = map.getNullableValue("accountId");
}

class FlutterOppwaException {
  final String errorCode;
  final String? errorMessage;
  final PaymentError? paymentError;

  FlutterOppwaException({
    required this.errorCode,
    this.errorMessage,
    this.paymentError,
  });

  @override
  String toString() {
    return "[$errorCode] $errorMessage";
  }
}

class PaymentError {
  final ErrorCode? code;
  final String? message;
  final String? info;
  final Transaction? transaction;

  PaymentError.fromMap(Map<String, dynamic> map)
      : code = map.getNullableEnum(ErrorCode.values, "code"),
        message = map.getNullableValue("message"),
        info = map.getNullableValue("info"),
        transaction =
            map.parseNullableValue("transaction", Transaction.fromMap);
}
