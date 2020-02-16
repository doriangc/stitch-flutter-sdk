const stitchPrefixKey = "__stitch.client";

abstract class Storage {
  Future<String> gets(String key);

  Future<void> sets(String key, String value);

  Future<void> remove(String key);
}

class MemoryStorage implements Storage {
  Map<String, String> _storage = {};
  final String _suiteName;

  MemoryStorage(suitename) : _suiteName = suitename;

  Future<String> gets(String key) async {
    return _storage['${this._suiteName}.$key'];
  }

  sets(String key, String value) async {
    _storage['${this._suiteName}.$key'] = value;
  }

  remove(String key) async {
    _storage['${this._suiteName}.$key'] = null;
  }
}