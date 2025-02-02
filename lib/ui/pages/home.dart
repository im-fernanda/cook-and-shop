import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cook_and_shop/services/api/api_service.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/category_button.dart';
import '../widgets/recipes/recipe_section.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ApiService _apiService;
  bool _isLoading = false;

  final Map<String, List<dynamic>> _categories = {
    "breakfast": [],
    "lunch": [],
    "desserts": [],
  };

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);

    try {
      final breakfast = await _apiService.fetchPopularRecipes("breakfast");
      final lunch = await _apiService.fetchPopularRecipes("lunch");
      final desserts = await _apiService.fetchPopularRecipes("desserts");

      setState(() {
        _categories["breakfast"] = breakfast;
        _categories["lunch"] = lunch;
        _categories["desserts"] = desserts;
      });
    } catch (e) {
      print('Erro ao carregar categorias: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Deseja realmente sair?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _apiService = context.read<ApiService>();
      _loadCategories();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Cook & Shop',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 40,
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Compre o que sua cozinha precisa',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 26),
            CategoryButtons(),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ..._buildRecipeSections(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  List<Widget> _buildRecipeSections() {
    return [
      RecipeSection(
        title: 'Café da manhã',
        categoryKey: 'breakfast',
        recipes: _categories['breakfast']!,
      ),
      RecipeSection(
        title: 'Almoço',
        categoryKey: 'lunch',
        recipes: _categories['lunch']!,
      ),
      RecipeSection(
        title: 'Sobremesas populares',
        categoryKey: 'desserts',
        recipes: _categories['desserts']!,
      ),
      const Padding(padding: EdgeInsets.only(bottom: 20)),
    ];
  }
}
