import 'package:stitch_core/stitch_core.dart' show CoreStitchServiceClient;

import './core_remote_mongo_database.dart' show CoreRemoteMongoDatabase;

abstract class CoreRemoteMongoClient {
  final CoreStitchServiceClient service;

  CoreRemoteMongoClient(this.service);

  CoreRemoteMongoDatabase db(String name);
}