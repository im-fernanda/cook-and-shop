import 'package:cook_and_shop/services/auth_service.dart';
import 'package:cook_and_shop/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {
    final authService = AuthService();
    final databaseService = DatabaseService();

    return ConfigureProviders(providers: [
      Provider<AuthService>.value(value: authService),
      Provider<DatabaseService>.value(value: databaseService)
    ]);
  }
}
