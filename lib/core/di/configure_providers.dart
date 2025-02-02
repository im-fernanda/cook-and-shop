import 'package:cook_and_shop/services/auth_service.dart';
import 'package:cook_and_shop/services/favorites_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../services/api/api_service.dart';
import '../../services/firestore_service.dart';
import '../../services/pdf_service.dart';
import '../../services/shopping_list_service.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {
    final authService = AuthService();
    final apiService = ApiService();
    final firestoreService = FirestoreService();
    final favoritesService = FavoritesService();
    final shoppingListService = ShoppingListService();
    final pdfService = PdfService();

    return ConfigureProviders(providers: [
      Provider<AuthService>.value(value: authService),
      Provider<ApiService>.value(value: apiService),
      Provider<FirestoreService>.value(value: firestoreService),
      Provider<FavoritesService>.value(value: favoritesService),
      Provider<ShoppingListService>.value(value: shoppingListService),
      Provider<PdfService>.value(value: pdfService),
    ]);
  }
}
