part of 'flutter_oppwa.dart';

const String _testUrl = "eu-test.oppwa.com";
const String _liveUrl = "eu-prod.oppwa.com";
const String _defaultTestEntityId = "ff80808138516ef4013852936ec200f2";
const String _defaultTestUserId = "ff80808138516ef4013852936ec500f6";
const String _defaultTestPassword = "8XJXcsjM";

const Map<String, String> _registrations = {
  "registrations[0].id": "8a82944a622a196201622a4b01ca3dc7",
  "registrations[1].id": "8a8294495896823b01589b3a7efb4313",
  "registrations[2].id": "8a82944a57c3d6610157d710b38a37ed",
  "registrations[3].id": "8ac7a49f774dc63f01774e2425b723d3",
  "registrations[4].id": "8ac7a49f774dc63f01775d84d7c31812",
};

class FlutterOppwaTest {
  static const String visa = "4200000000000000";
  static const String master = "5454545454545454";
  static const String amex = "377777777777770";
  static const String visa3dEnrolled = "4711100000000000";
  static const String master3dEnrolled = "5212345678901234";
  static const String amex3dEnrolled = "375987000000005";
  static final Map<String, _RequestData> _cache = {};
  FlutterOppwaTest._();
  static Future<String> _sendCheckoutIdRequest(ProviderMode mode,
      String? authorizationBearer, Map<String, String> parameters) async {
    var client = http.Client();
    try {
      var baseUrl = mode == ProviderMode.test ? _testUrl : _liveUrl;
      var url = Uri.https(baseUrl, "v1/checkouts");
      var response = await http.post(
        url,
        body: parameters,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          "Accept": "application/json",
          if (authorizationBearer != null) "Authorization": authorizationBearer,
        },
      );
      print(response.body);
      if (response.statusCode >= 400) {
        throw FlutterOppwaException(
          errorCode: "request_failed",
          errorMessage:
              "response ended with status code '${response.statusCode}'",
        );
      } else {
        return utf8.decode(response.bodyBytes);
      }
    } on FlutterOppwaException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw FlutterOppwaException(
          errorCode: "request_failed", errorMessage: e.toString());
    } finally {
      client.close();
    }
  }

  static Future<String> _sendPaymentStatusRequest(
      String resourcePath,
      ProviderMode mode,
      String? authorizationBearer,
      Map<String, String> parameters) async {
    var client = http.Client();
    try {
      var baseUrl = mode == ProviderMode.test ? _testUrl : _liveUrl;
      var url = Uri.https(baseUrl, resourcePath, parameters);
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          "Accept": "application/json",
          if (authorizationBearer != null) "Authorization": authorizationBearer,
        },
      );
      print(response.body);
      if (response.statusCode >= 400) {
        throw FlutterOppwaException(
          errorCode: "request_failed",
          errorMessage:
              "response ended with status code '${response.statusCode}'",
        );
      } else {
        return utf8.decode(response.bodyBytes);
      }
    } on FlutterOppwaException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw FlutterOppwaException(
          errorCode: "request_failed", errorMessage: e.toString());
    } finally {
      client.close();
    }
  }

  static Future<String?> requestCheckoutId(
    num amount,
    String currency, {
    ProviderMode serverMode = ProviderMode.test,
    PaymentType? type,
    Map<String, String>? extraParameters,
  }) async {
    var sendRegistrations =
        extraParameters?.remove("sendRegistrations") == "true";
    var parameters = _prepareParameters(amount.toString(), currency,
        type?.value, extraParameters, sendRegistrations);
    var authorizationBearer = _getAuthorizationBearer(
      parameters.remove("authentication.userId"),
      parameters.remove("authentication.password"),
    );
    var result = await _sendCheckoutIdRequest(
      serverMode,
      authorizationBearer,
      parameters,
    );
    var json = jsonDecode(result) as Map<String, dynamic>;
    var checkoutId = json.getNullableValue<String>("id");
    var entityId = parameters["entityId"];
    if (checkoutId != null && entityId != null) {
      _cache[checkoutId] =
          _RequestData(serverMode, authorizationBearer, entityId);
    }
    return checkoutId;
  }

  static Future<bool> requestPaymentStatus(String resourcePath) async {
    _RequestData? request;
    for (var data in _cache.entries) {
      if (resourcePath.contains(data.key)) {
        request = data.value;
        break;
      }
    }
    if (request == null) {
      throw FlutterOppwaException(
        errorCode: "not_found",
        errorMessage: "No related checkout id request found.",
      );
    }
    var result = await _sendPaymentStatusRequest(
      resourcePath,
      request.mode,
      request.authorizationBearer,
      {"entityId": request.entityId},
    );
    var json = jsonDecode(result) as Map<String, dynamic>;
    var status = json
        .castNullableMap<dynamic>("result")
        ?.getNullableValue<String>("code");
    if (status != null) {
      return RegExp("^(000.000.|000.100.1|000.[36]|000.400.[1][12]0)")
          .hasMatch(status);
    }
    return false;
  }

  static String _getAuthorizationBearer([String? userId, String? password]) {
    userId ??= _defaultTestUserId;
    password ??= _defaultTestPassword;
    return "Bearer ${base64.encode(utf8.encode(userId + "|" + password))}";
  }

  static Map<String, String> _prepareParameters(
    String amount,
    String currency,
    String? paymentType,
    Map<String, String>? extraParameters,
    bool sendRegistrations,
  ) {
    Map<String, String> parameters = {};
    parameters["amount"] = amount;
    parameters["currency"] = currency;
    if (paymentType != null) parameters["paymentType"] = paymentType;
    if (extraParameters != null && extraParameters.isNotEmpty) {
      parameters.addAll(extraParameters);
    }
    if (!parameters.containsKey("entityId")) {
      parameters["entityId"] = _defaultTestEntityId;
    }
    if (sendRegistrations && _defaultTestEntityId == parameters["entityId"]) {
      parameters.addAll(_registrations);
    }
    return parameters;
  }
}

class _RequestData {
  final ProviderMode mode;
  final String authorizationBearer;
  final String entityId;

  _RequestData(this.mode, this.authorizationBearer, this.entityId);
}
