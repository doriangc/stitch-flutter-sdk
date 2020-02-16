import './internal/common/storage.dart' show Storage;
import './internal/net/transport.dart' show Transport;

class StitchClientConfiguration {
  // The base URL of the Stitch server that the client will communicate with.
  final String baseUrl;

  // The underlying storage for persisting authentication and app state.
  final Storage storage;

  // The local directory in which Stitch can store any data (e.g. embedded MongoDB data directory).
  final String dataDirectory;

  //The `Transport` that the client will use to make HTTP round trips to the Stitch server.
  final Transport transport;

  StitchClientConfiguration(
      this.baseUrl, this.storage, this.dataDirectory, this.transport);

  StitchClientConfiguration clone() {
    return StitchClientConfiguration(
        this.baseUrl, this.storage, this.dataDirectory, this.transport);
  }

  StitchClientConfigurationBuilder builder() {
    return StitchClientConfigurationBuilder(this);
  }
}

/// Create or alter a [StitchClientConfiguration]
class StitchClientConfigurationBuilder {
  String baseUrl;
  Storage storage;
  String dataDirectory;
  Transport transport;

  StitchClientConfigurationBuilder([StitchClientConfiguration config]) {
    if (config != null) {
      this.baseUrl = config.baseUrl;
      this.storage = config.storage;
      this.dataDirectory = config.dataDirectory;
      this.transport = config.transport;
    }
  }

  StitchClientConfigurationBuilder withBaseUrl(String baseUrl) {
    this.baseUrl = baseUrl;
    return this;
  }

  StitchClientConfigurationBuilder withStorage(Storage storage) {
    this.storage = storage;
    return this;
  }

  StitchClientConfigurationBuilder withDataDirectory(String dataDirectory) {
    this.dataDirectory = dataDirectory;
    return this;
  }

  StitchClientConfigurationBuilder withTransport(Transport transport) {
    this.transport = transport;
    return this;
  }

  StitchClientConfiguration build() {
    return new StitchClientConfiguration(
        this.baseUrl, this.storage, this.dataDirectory, this.transport);
  }
}
