import './stitch_client_configuration.dart';

/// Properties representing the configuration of a client that communicates with
/// a particular MongoDB Stitch application.
class StitchAppClientConfiguration extends StitchClientConfiguration {
  // The name of the local application.
  final String localAppName;

  /// The current version of the local application.
  String localAppVersion;

  StitchAppClientConfiguration(
    StitchClientConfiguration config,
    this.localAppName,
    this.localAppVersion,
  ) : super(
          config.baseUrl,
          config.storage,
          config.dataDirectory,
          config.transport,
        );

  StitchAppClientConfigurationBuilder builder() {
    return new StitchAppClientConfigurationBuilder(this);
  }
}

/// Create or alter a [StitchAppClientConfiguration]
class StitchAppClientConfigurationBuilder
    extends StitchClientConfigurationBuilder {
  String localAppName;
  String localAppVersion;

  StitchAppClientConfigurationBuilder([StitchAppClientConfiguration config])
      : super(config) {
    if (config != null) {
      this.localAppVersion = config.localAppVersion;
      this.localAppName = config.localAppName;
    }
  }

  StitchAppClientConfigurationBuilder withLocalAppName(String localAppName) {
    this.localAppName = localAppName;
    return this;
  }

  StitchAppClientConfigurationBuilder withLocalAppVersion(
      String localAppVersion) {
    this.localAppVersion = localAppVersion;
    return this;
  }

  StitchAppClientConfiguration build() {
    StitchClientConfiguration config = super.build();
    return new StitchAppClientConfiguration(
        config, this.localAppName, this.localAppVersion);
  }
}
