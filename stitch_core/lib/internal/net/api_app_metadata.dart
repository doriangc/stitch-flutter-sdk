class Fields {
  static const String DEPLOYMENT_MODEL = 'deployment_model';
  static const String LOCATION = 'location';
  static const String HOSTNAME = 'hostname';
}

/// A class representing a Stitch application's metadata.
class ApiAppMetadata {
  static ApiAppMetadata fromJSON(Map<String, dynamic> json) {
    return ApiAppMetadata(
      json[Fields.DEPLOYMENT_MODEL],
      json[Fields.LOCATION],
      json[Fields.HOSTNAME]
    );
  }

  final String deploymentModel;
  final String location;
  final String hostname;

  ApiAppMetadata(
    this.deploymentModel,
    this.location,
    this.hostname,
    );

  Map<String, dynamic> toJSON() {
    return {
      Fields.DEPLOYMENT_MODEL: this.deploymentModel,
      Fields.LOCATION: this.location,
      Fields.HOSTNAME: this.hostname
    };
  }
}