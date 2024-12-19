part of 'flutter_oppwa.dart';

class FlutterOppwaUtils {
  FlutterOppwaUtils._();
  static String normalizeCardNumber(String card) {
    return card.replaceAll("-", "").replaceAll(" ", "");
  }

  static String normalizeHolder(String holder) {
    return holder.trim();
  }

  /// Returns true if the number passes Luhn test http://en.wikipedia.org/wiki/Luhn_algorithm.
  static bool checkLuhn(String number) {
    if (!isNumberValid(number)) return false;
    var numbers = number.split("").reversed.map((e) => int.parse(e)).toList();
    var sum = 0;
    for (var i = 0; i < numbers.length; i++) {
      if (i % 2 != 0) {
        numbers[i] *= 2;
        if (numbers[i] > 9) numbers[i] -= 9;
      }
      sum += numbers[i];
    }
    return sum % 10 == 0;
  }

  /// Checks if the [holder] name is filled with sufficient data to perform a transaction.
  ///
  /// Returns true if the holder name length greater than 3 characters and less than 128 character.
  static bool isHolderValid(String holder) {
    holder = normalizeHolder(holder);
    return holder.isEmpty ||
        ((RegExp(r".{3,128}").fullyMatch(holder) &&
            !RegExp(r"^[0-9]{10,}\$").fullyMatch(holder) &&
            !RegExp(r"[0-9]{3,4}").fullyMatch(holder)));
  }

  /// Checks if the card [number] is filled with sufficient data to perform a transaction.
  ///
  /// If the [luhnCheck] is set to true, the [number] should pass Luhn test http://en.wikipedia.org/wiki/Luhn_algorithm.
  ///
  /// Returns true if the number consists of 10-19 digits and passes luhn test
  static bool isNumberValid(String number, [bool luhnCheck = false]) {
    number = normalizeCardNumber(number);
    if (RegExp("[0-9]{10,19}").fullyMatch(number)) {
      return !luhnCheck || FlutterOppwaUtils.checkLuhn(number);
    } else {
      return false;
    }
  }

  /// Checks if the card [expiryMonth] is filled with sufficient data to perform a transaction.
  ///
  /// Returns true if the card expiry month is in the format `MM`.
  static bool isExpiryMonthValid(String expiryMonth) {
    var month = int.tryParse(expiryMonth);
    return expiryMonth.length == 2 &&
        month != null &&
        month >= 1 &&
        month <= 12;
  }

  /// Checks if the card [expiryYear] is filled with sufficient data to perform a transaction.
  ///
  /// Returns true if the card expiry year is in the format `YYYY`.
  static bool isExpiryYearValid(String expiryYear) {
    var year = int.tryParse(expiryYear);
    return expiryYear.length == 4 && year != null;
  }

  /// Checks if the [countryCode] is filled with sufficient data to perform a transaction.
  ///
  /// Returns true if the country code contains digits only.
  static bool isCountryCodeValid(String countryCode) {
    return RegExp("^[0-9].*").fullyMatch(countryCode);
  }

  /// Checks if the [mobilePhone] is filled with sufficient data to perform a transaction.
  ///
  /// Returns true if the mobile phone number contains digits only.
  static bool isMobilePhoneValid(String mobilePhone) {
    return RegExp("^[0-9].*").fullyMatch(mobilePhone);
  }

  /// Checks if the [month] and [year] have been set and whether or not card is expired.
  ///
  /// Returns true if the month or the year is expired.
  static bool isExpiredWithExpiryMonth(String month, String year) {
    if (isExpiryMonthValid(month) && isExpiryYearValid(year)) {
      var m = int.tryParse(month);
      var y = int.tryParse(year);
      var n = DateTime.now();
      if (m != null && y != null) {
        return y > n.year || (y == n.year && m >= n.month);
      }
    }
    return true;
  }

  /// Checks if the card [cvv] is filled with sufficient data to perform a transaction.
  ///
  /// Returns true f 3,4-digit number is provided.
  static bool isCvvValid(String cvv) {
    return RegExp("[0-9]{3,4}").fullyMatch(cvv);
  }

  static Future<bool> get isPlayServicesWalletAvailable async =>
      await FlutterOppwa._invoke<bool>("isPlayServicesWalletAvailable") == true;

  static Future<bool> get isPlayServicesBaseAvailable async =>
      await FlutterOppwa._invoke<bool>("isPlayServicesBaseAvailable") == true;

  static Future<bool> get isApplePayAvailable async =>
      await FlutterOppwa._invoke<bool>("isApplePayAvailable") == true;
}

extension RegExpExtensions on RegExp {
  bool fullyMatch(String input) {
    var match = firstMatch(input);
    return match != null && match.group(0) == input;
  }
}
