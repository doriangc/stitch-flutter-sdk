import '../../stitch_user_identity.dart' show StitchUserIdentity;

class Fields {
  static const String ID = 'id';
  static const String PROVIDER_TYPE = 'provider_type';
}

class ApiStitchUserIdentity extends StitchUserIdentity {
  static ApiStitchUserIdentity fromJSON(Map<String, dynamic> json) {
    return ApiStitchUserIdentity(
      json[Fields.ID],
      json[Fields.PROVIDER_TYPE]
    );
  }

  ApiStitchUserIdentity(String id, String providerType) : super(id, providerType);

  Map<String, String> toJSON() {
    return {
      Fields.ID: id,
      Fields.PROVIDER_TYPE: providerType
    };
  }
}
