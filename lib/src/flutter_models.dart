import 'dart:typed_data';

import 'package:flutter_oppwa/flutter_oppwa.dart';

class BaseTransaction {
  /// The checkout id of the transaction. Must not be empty.
  final String checkoutId;

  BaseTransaction._(this.checkoutId)
      : assert(
            checkoutId.trim().isNotEmpty, "The checkout id must not be empty");

  Map<String, dynamic> toMap() {
    return {
      "checkoutId": checkoutId,
    };
  }
}

/// Class to represent a set of card parameters needed for performing an e-commerce card transaction.
///
/// Will become [CardPaymentParams] when it comes back from the native side
class CardTransaction extends BaseTransaction {
  /// The card number of the transaction.
  final String number;

  /// The payment brand of the card.
  final String? brand;

  /// The name of the card holder.
  final String? holder;

  /// The expiration year. It is expected in the format `YYYY`.
  final String? expiryMonth;

  /// The expiration month of the card. It is expected in the format `MM`.
  final String? expiryYear;

  /// The CVV code associated with the card. Set to `null` if CVV is not required.
  final String? cvv;

  /// If the payment information should be stored for future use.
  final bool? tokenize;

  /// [checkoutId] The checkout id of the transaction. Must not be empty.
  ///
  /// [number] The card number of the transaction.
  ///
  /// [brand] The payment brand of the card.
  ///
  /// [holder] The name of the card holder.
  ///
  /// [expiryMonth] The expiration year. It is expected in the format `YYYY`.
  ///
  /// [expiryYear] The expiration month of the card. It is expected in the format `MM`.
  ///
  /// [cvv] The CVV code associated with the card. Set to `null` if CVV is not required.
  ///
  /// [tokenize] If the payment information should be stored for future use.
  CardTransaction({
    required String checkoutId,
    required this.number,
    this.brand,
    this.holder,
    this.expiryMonth,
    this.expiryYear,
    this.cvv,
    this.tokenize,
  }) : super._(checkoutId);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      "type": "card",
      "number": number,
      "brand": brand,
      "holder": holder,
      "expiryMonth": expiryMonth,
      "expiryYear": expiryYear,
      "cvv": cvv,
      "tokenize": tokenize,
    }..removeWhere((key, value) => value == null);
  }
}

/// Class to represent all necessary transaction parameters for performing an STC Pay transaction.
///
/// Will become [STCPayPaymentParams] when it comes back from the native side
class STCTransaction extends BaseTransaction {
  /// The mobile phone number.
  final String? mobile;

  /// The verification option to proceed STC Pay transaction
  final STCPayVerificationOption verificationOption;

  /// [checkoutId] The checkout id of the transaction. Must not be empty.
  ///
  /// [verificationOption] The card number of the transaction.
  ///
  /// [mobile] The mobile phone number.
  STCTransaction({
    required String checkoutId,
    required this.verificationOption,
    this.mobile,
  }) : super._(checkoutId);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      "type": "stc",
      "mobile": mobile,
      "verificationOption": verificationOption.name,
    }..removeWhere((key, value) => value == null);
  }
}

class TokenTransaction extends BaseTransaction {
  final String tokenId;
  final String brand;
  final String? cvv;

  TokenTransaction({
    required String checkoutId,
    required this.tokenId,
    required this.brand,
    this.cvv,
  }) : super._(checkoutId);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      "type": "token",
      "tokenId": tokenId,
      "brand": brand,
      "cvv": cvv,
    }..removeWhere((key, value) => value == null);
  }
}

/// Class to represent all necessary transaction parameters for performing an Apple Pay transaction.
///
/// Will become [ApplePayPaymentParams] when it comes back from the native side
class AppleTransaction extends BaseTransaction {
  /// UTF-8 encoded JSON dictionary of encrypted payment data.  Ready for transmission to merchant's e-commerce backend for decryption and submission to a payment processor's gateway.
  final Uint8List tokenData;

  /// [checkoutId] The checkout id of the transaction. Must not be empty.
  ///
  /// [tokenData] UTF-8 encoded JSON dictionary of encrypted payment data.
  AppleTransaction({
    required String checkoutId,
    required this.tokenData,
  }) : super._(checkoutId);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      "type": "apple",
      "tokenData": tokenData,
    }..removeWhere((key, value) => value == null);
  }
}

// class BrandInfo {
//   final String? label;
//   final String? renderType;
//   final String? brand;
//   final CardBrandInfo? cardBrandInfo;
//   BrandInfo.fromMap(Map<String, dynamic> map)
//       : label = map.getNullableValue("label"),
//         renderType = map.getNullableValue("renderType"),
//         brand = map.getNullableValue("brand"),
//         cardBrandInfo =
//             map.parseNullableValue("cardBrandInfo", CardBrandInfo.fromMap);
// }

// class CardBrandInfo {
//   final int? cvvLength;
//   final CVVMode? cvvMode;
//   final String? detection;
//   final String? pattern;
//   final String? validation;
//   CardBrandInfo.fromMap(Map<String, dynamic> map)
//       : cvvLength = map.getNullableValue("cvvLength"),
//         cvvMode = map.getNullableEnum(CVVMode.values, "cvvMode"),
//         detection = map.getNullableValue("detection"),
//         pattern = map.getNullableValue("pattern"),
//         validation = map.getNullableValue("validation");
// }
