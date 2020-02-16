
class OperationType {
  static const String Insert = 'insert';
  static const String Delete = 'delete';
  static const String Replace = 'replace';
  static const String Update = 'update';
  static const String Unknown = 'unknown';
}

String operationTypeFromRemote(String type) {
	switch (type) {
		case "insert":
			return OperationType.Insert;
		case "delete":
			return OperationType.Delete;
		case "replace":
			return OperationType.Replace;
		case "update":
			return OperationType.Update;
		default:
			return OperationType.Unknown;
	}
}
