final Map<String, Function> EJSON_KEYWORDS = {
  '\$date': (double data) => DateTime.fromMillisecondsSinceEpoch(data.round()),
  '\$numberLong': (String data) => double.parse(data),
  '\$numberDouble': (String data) => double.parse(data),
  '\$numberInt': (String data) => int.parse(data),
  '\$oid': (String data) => data
};

dynamic eJsonDecode(dynamic src) {
  if (src is Map) {
    if (src.length == 1 && EJSON_KEYWORDS.containsKey(src.keys.elementAt(0))) { // check if it is special EJSON keyword
      return EJSON_KEYWORDS[src.keys.elementAt(0)](eJsonDecode(src.values.elementAt(0))); // Parse it and return value
    } else {
      Map<String, dynamic> newMap = {};
      src.forEach((key, value) {
        newMap[key] = eJsonDecode(value);
      });
      return newMap;
    }
  } else if (src is List) {
    List<dynamic> newList = [];
    src.forEach((item) {
      newList.add(eJsonDecode(item));
    });

    return newList;
  }
  return src;
}