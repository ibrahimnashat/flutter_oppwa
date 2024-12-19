import 'package:flutter/foundation.dart';

extension Parser on Map<String, dynamic> {
  DateTime? getTime(String key) => getNullableValue<DateTime>(key);

  bool getBool(String key, [bool defaultValue = false]) {
    if (_hasValue(key)) {
      var val = this[key]!;
      if (val is bool) {
        return val;
      } else if (val is String) {
        return val.toLowerCase() == "t" || val.toLowerCase() == "true";
      } else if (val is num) {
        return val.toInt() == 1;
      }
    }
    return defaultValue;
  }

  T getEnum<T extends Enum>(List<T> type, String key, T defaultValue) {
    return getNullableEnum(type, key) ?? defaultValue;
  }

  T getValue<T>(String key, T defaultValue) {
    return getNullableValue<T>(key) ?? defaultValue;
  }

  T parseValue<T>(
      String key, T Function(Map<String, dynamic> map) parser, T defaultValue) {
    return parseNullableValue<T>(key, parser) ?? defaultValue;
  }

  List<T> parseList<T>(String key,
      T Function(Map<String, dynamic> value) parser, List<T> defaultValue) {
    return parseNullableList<T>(key, parser) ?? defaultValue;
  }

  List<T> getList<T, ValueType>(
      String key, T Function(ValueType value) parser, List<T> defaultValue) {
    return getNullableList<T, ValueType>(key, parser) ?? defaultValue;
  }

  List<T> castList<T>(String key, List<T> defaultValue) {
    return castNullableList<T>(key) ?? defaultValue;
  }

  Map<String, T> getMap<T, ValueType>(String key,
      T Function(ValueType value) parser, Map<String, T> defaultValue) {
    return getNullableMap<T, ValueType>(key, parser) ?? defaultValue;
  }

  Map<K, T> getCustomMap<K, T>(String key, K Function(dynamic key) keyParser,
      T Function(dynamic value) valueParser, Map<K, T> defaultValue) {
    return getNullableCustomMap<K, T>(key, keyParser, valueParser) ??
        defaultValue;
  }

  Map<String, T> castMap<T>(String key, Map<String, T> defaultValue) {
    try {
      if (_hasValue(key)) return _getMapValue<T>(key);
    } catch (e) {
      _log("[ModelUtils] Error casting a map for key [$key] {${e.toString()}}");
    }
    return defaultValue;
  }

  T? getNullableEnum<T extends Enum>(List<T> type, String key) {
    try {
      if (_hasValue(key)) return _getEnum(type, key);
    } catch (e) {
      _log("[ModelUtils] Error getting enum for key [$key] {${e.toString()}}");
    }
    return null;
  }

  T? getNullableValue<T>(String key) {
    try {
      if (_hasValue(key)) return _getValue<T>(key);
    } catch (e) {
      _log("[ModelUtils] Error getting value for key [$key] {${e.toString()}}");
    }
    return null;
  }

  List<T> parseListFromMap<T>(
      String key,
      T Function(String key, Map<String, dynamic> value) parser,
      List<T> defaultValue) {
    return parseNullableListFromMap<T>(key, parser) ?? defaultValue;
  }

  T? parseNullableValue<T>(
      String key, T Function(Map<String, dynamic> map) parser) {
    try {
      if (_hasValue(key)) return parser(_getMapValue<dynamic>(key));
    } catch (e) {
      _log("[ModelUtils] Error parsing value for key [$key] {${e.toString()}}");
    }
    return null;
  }

  List<T>? parseNullableList<T>(
      String key, T Function(Map<String, dynamic> value) parser) {
    return getNullableList<T, Map<String, dynamic>>(key, parser);
  }

  List<T>? parseNullableListFromMap<T>(
      String key, T Function(String key, Map<String, dynamic> value) parser) {
    try {
      if (_hasValue(key)) {
        return _getMapAsList<T, Map<String, dynamic>>(key, parser);
      }
    } catch (e) {
      _log(
          "[ModelUtils] Error parsing list from map for key [$key] {${e.toString()}}");
    }
    return null;
  }

  List<T>? getNullableList<T, ValueType>(
      String key, T Function(ValueType value) parser) {
    try {
      if (_hasValue(key)) return _getList<T, ValueType>(key, parser);
    } catch (e) {
      _log("[ModelUtils] Error getting list for key [$key] {${e.toString()}}");
    }
    return null;
  }

  Map<String, List<T>>? parseNullableMapOfList<T>(
      String key, T Function(Map<String, dynamic> value) parser) {
    try {
      if (_hasValue(key)) {
        var value = _getMapValue<List<dynamic>>(key);
        //List<Map<String, dynamic>>
        Map<String, List<T>> map = {};
        for (var key in value.keys) {
          var list = List<T>.empty(growable: true);
          for (var item in value[key]!) {
            if (item is Map) {
              list.add(parser(item.cast()));
            }
          }
          map[key] = list;
        }
        return map;
      }
    } catch (e) {
      _log("[ModelUtils] Error parsing map for key [$key] {${e.toString()}}");
    }
    return null;
  }

  List<T>? castNullableList<T>(String key) {
    try {
      if (_hasValue(key)) return _getListValue<T>(key);
    } catch (e) {
      _log(
          "[ModelUtils] Error casting a list for key [$key] {${e.toString()}}");
    }
    return null;
  }

  Map<String, T>? castNullableMap<T>(String key) {
    try {
      if (_hasValue(key)) return _getMapValue<T>(key);
    } catch (e) {
      _log("[ModelUtils] Error casting a map for key [$key] {${e.toString()}}");
    }
    return null;
  }

  Map<String, T>? getNullableMap<T, ValueType>(
      String key, T Function(ValueType value) parser) {
    try {
      if (_hasValue(key)) return _getMap<T, ValueType>(key, parser);
    } catch (e) {
      _log("[ModelUtils] Error getting map for key [$key] {${e.toString()}}");
    }
    return null;
  }

  List<T>? getNullableListFromMap<T, ValueType>(
      String key, T Function(String key, ValueType value) parser) {
    try {
      if (_hasValue(key)) return _getMapAsList<T, ValueType>(key, parser);
    } catch (e) {
      _log(
          "[ModelUtils] Error getting list from map for key [$key] {${e.toString()}}");
    }
    return null;
  }

  Map<K, T>? getNullableCustomMap<K, T>(
      String key,
      K? Function(dynamic key) keyParser,
      T? Function(dynamic value) valueParser) {
    try {
      if (_hasValue(key)) {
        return _getCustomMap<K, T>(key, keyParser, valueParser);
      }
    } catch (e) {
      _log(
          "[ModelUtils] Error getting custom map for key [$key] {${e.toString()}}");
    }
    return null;
  }

  Map<K, T>? parseNullableCustomMap<K, T>(
      String key,
      K? Function(String key) keyParser,
      T? Function(Map<String, dynamic> value) valueParser) {
    try {
      if (_hasValue(key)) {
        return _parseCustomMap<K, T>(key, keyParser, valueParser);
      }
    } catch (e) {
      _log(
          "[ModelUtils] Error getting custom map for key [$key] {${e.toString()}}");
    }
    return null;
  }

  List<T> _getList<T, ValueType>(
      String key, T Function(ValueType value) parser) {
    List<ValueType> value = _getListValue<ValueType>(key);
    return value.map((e) => parser(e)).toList();
  }

  List<T> _getMapAsList<T, ValueType>(
      String key, T Function(String key, ValueType value) parser) {
    Map<String, ValueType> value = _getMapValue<ValueType>(key);
    List<T> list = List.empty(growable: true);
    value.forEach((key, value) {
      list.add(parser(key, value));
    });
    return list;
  }

  Map<String, T> _getMap<T, ValueType>(
      String key, T Function(ValueType value) valueParser) {
    try {
      Map<String, ValueType> value = _getMapValue<ValueType>(key);
      return value.map<String, T>((k, v) => MapEntry(k, valueParser(v)));
    } catch (e) {
      Map<String, dynamic> value = _getMapValue<dynamic>(key);
      Map<String, T> result = {};
      for (var entry in value.entries) {
        if (entry.value is ValueType) {
          result[entry.key] = valueParser(entry.value);
        }
      }
      return result;
    }
  }

  Map<K, T> _getCustomMap<K, T>(String key, K? Function(dynamic) keyParser,
      T? Function(dynamic) valueParser) {
    Map value = _getValue(key);
    Map<K, T> result = {};
    for (var entry in value.entries) {
      var parsedKey = keyParser(entry.key);
      var parsedValue = valueParser(entry.value);
      if (parsedKey != null && parsedValue != null) {
        result[parsedKey] = parsedValue;
      }
    }
    return result;
  }

  Map<K, T> _parseCustomMap<K, T>(String key, K? Function(String) keyParser,
      T? Function(Map<String, dynamic>) valueParser) {
    var value = castMap<Map<String, dynamic>>(key, {});
    Map<K, T> result = {};
    for (var entry in value.entries) {
      var parsedKey = keyParser(entry.key);
      var parsedValue = valueParser(entry.value);
      if (parsedKey != null && parsedValue != null) {
        result[parsedKey] = parsedValue;
      }
    }
    return result;
  }

  T? _getEnum<T extends Enum>(List<T> type, String key) {
    var value = this[key].toString();
    for (var v in type) {
      if (v.name == value) return v;
    }
    return null;
  }

  List<T> _getListValue<T>(String key) {
    var value = this[key];
    if (value is List) {
      return value.cast<T>();
    } else {
      throw Exception(
        "Error while parsing, "
        "expected type [$T], "
        "but found [${value.runtimeType}]",
      );
    }
  }

  Map<String, T> _getMapValue<T>(String key) {
    var value = this[key];
    if (value is Map) {
      return value.cast<String, T>();
    } else {
      throw Exception(
        "Error while parsing, "
        "expected type [$T], "
        "but found [${value.runtimeType}]",
      );
    }
  }

  T _getValue<T>(String key) {
    var value = this[key];
    switch (T) {
      case double:
        if (value is double) {
          return value as T;
        } else if (value is num) {
          return value.toDouble() as T;
        } else {
          return num.parse(value.toString()).toDouble() as T;
        }
      case int:
        if (value is int) {
          return value as T;
        } else if (value is num) {
          return value.toInt() as T;
        } else {
          return num.parse(value.toString()).toInt() as T;
        }
      case num:
        if (value is num) {
          return value as T;
        } else {
          return num.parse(value.toString()) as T;
        }
      case DateTime:
        if (value is DateTime) {
          return value as T;
        } else if (value is num) {
          return DateTime.fromMillisecondsSinceEpoch(value.toInt()) as T;
        }
        break;
      default:
        if (value is T) return value;
    }
    throw Exception(
      "Error while parsing, "
      "expected type [$T], "
      "but found [${value.runtimeType}]",
    );
  }

  bool _hasValue(String key) => containsKey(key) && this[key] != null;
  static void _log(String message) {
    if (kDebugMode) print(message);
  }
}
