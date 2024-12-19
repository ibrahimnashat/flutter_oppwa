import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_oppwa/src/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_oppwa/flutter_oppwa.dart';

part 'flutter_oppwa_utils.dart';
part 'flutter_oppwa_test.dart';

// TODO(OG): things to implement
// com.oppwa.mobile.connect.payment.bankaccount
// com.oppwa.mobile.connect.payment.card
// com.oppwa.mobile.connect.payment.googlepay
// com.oppwa.mobile.connect.payment.applepay
// com.oppwa.mobile.connect.payment.stcpay
// com.oppwa.mobile.connect.payment.token
// com.oppwa.mobile.connect.connect.utils
class FlutterOppwa {
  static const MethodChannel _channel = MethodChannel('flutter_oppwa');
  FlutterOppwa._();
  static Future<T?> _invoke<T>(String method,
      [Map<String, dynamic>? data]) async {
    try {
      return await _channel.invokeMethod<T>(method, data);
    } on PlatformException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<T?> _invokeMap<T>(
    String method,
    T Function(Map<String, dynamic> data) parser,
    Map<String, dynamic>? data,
  ) async {
    try {
      var result =
          await _channel.invokeMapMethod<String, dynamic>(method, data);
      print(result);
      if (result != null) {
        return parser(result);
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<bool> initialize(ProviderMode mode) async {
    return await _invoke("initialize", {"mode": mode.name}) == true;
  }

  /// Submitting means that the transaction is sent to the server, where it will cause a debit of the given amount on the account specified in the [PaymentParams].
  static Future<Transaction?> submitTransaction(
      BaseTransaction transaction) async {
    return _invokeMap(
        "submit_transaction", Transaction.fromMap, transaction.toMap());
  }

  /// On storing a payment data. The method creates a just registration separate from any later payment.
  static Future<Transaction?> registerTransaction(
      BaseTransaction transaction) async {
    return _invokeMap(
        "register_transaction", Transaction.fromMap, transaction.toMap());
  }

  /// Depending on the endpoint the transaction will be submitted or registered only without making the payment.
  ///
  /// [transaction] The transaction to be sent.
  ///
  /// [endpoint] The endpoint which will be used for processing transaction. The endpoint must start with a `"/"`.
  static Future<Transaction?> sendTransaction(
      BaseTransaction transaction, String endpoint) async {
    return _invokeMap("send_transaction", Transaction.fromMap,
        {"endpoint": endpoint, ...transaction.toMap()});
  }

  static Future<CheckoutInfo?> requestCheckoutInfo(String checkoutId) async {
    return _invokeMap(
      "checkout_info_request",
      CheckoutInfo.fromMap,
      {"checkoutId": checkoutId},
    );
  }

  static FlutterOppwaException _handleError(PlatformException exception) {
    PaymentError? error;
    if (exception.details is Map) {
      error = PaymentError.fromMap(
        (exception.details as Map).cast<String, dynamic>(),
      );
    }
    return FlutterOppwaException(
      errorCode: exception.code,
      errorMessage: exception.message,
      paymentError: error,
    );
  }
}
