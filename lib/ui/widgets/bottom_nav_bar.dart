import 'package:flutter/material.dart';
import 'package:cook_and_shop/ui/pages/search_page.dart';
import 'package:cook_and_shop/ui/pages/favorites_page.dart';
import 'package:cook_and_shop/ui/pages/shopping_list.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage()));
        } else if (index == 2) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FavoritesPage()));
        } else if (index == 3) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ShoppingListPage()));
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Listas'),
      ],
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Colors.grey,
    );
  }
}
