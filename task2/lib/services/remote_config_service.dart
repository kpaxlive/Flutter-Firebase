import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  Future<Map<String, dynamic>> initializeConfig() async {


    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 3),
    ));
    await remoteConfig.fetchAndActivate();
    remoteConfig.setDefaults(
      {
      'year_number': 2022,
      'eurovision_string': "Eurovision Song Contest",
      'asset_string': "assets/images/eurovision2022.png",
      }
    );

    final bool isHidden = remoteConfig.getBool('isHidden');
    final String eurovisionString = remoteConfig.getString('eurovision_string');
    final String assetString = remoteConfig.getString('asset_string');
    final int yearNumber = remoteConfig.getInt('year_number');

    return {
      'isHidden': isHidden,
      'eurovisionString': eurovisionString,
      'assetString': assetString,
      'yearNumber': yearNumber,
    };
  }
}
