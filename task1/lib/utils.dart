import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:task_2/firebase_options.dart';
import 'package:task_2/services/auth_service.dart';
import 'package:task_2/services/database_service.dart';
import 'package:task_2/services/media_service.dart';
import 'package:task_2/services/navigation_service.dart';
import 'package:task_2/services/storage_service.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;

  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<MediaService>(MediaService());
  getIt.registerSingleton<StorageService>(StorageService());
  getIt.registerSingleton<DatabaseService>(DatabaseService());
}
