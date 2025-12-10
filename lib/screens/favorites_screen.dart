import 'package:flutter/material.dart';
import '../models/favorite_meal.dart';
import '../services/favorites_service.dart';
import '../widgets/favorite_meal_card.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  List<FavoriteMeal> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _favoritesService.getFavorites();
      setState(() {
        _favorites = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFavorite(String mealId) async {
    try {
      await _favoritesService.removeFavorite(mealId);
      _loadFavorites();
    } catch (e) {
    }
  }

  Future<void> _clearAllFavorites() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear All Favorites?'),
        content: const Text(
          'Are you sure you want to remove all favorite recipes? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _favoritesService.clearAllFavorites();
        _loadFavorites();
      } catch (e) {
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text('My Favorites'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.deepOrange.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          if (_favorites.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.delete_sweep_rounded),
                onPressed: _clearAllFavorites,
                tooltip: 'Clear all',
              ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.orange.shade400,
          strokeWidth: 3,
        ),
      )
          : _favorites.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start adding recipes you love!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Explore Recipes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.favorite_rounded,
                  color: Colors.orange.shade400,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_favorites.length} favorite ${_favorites.length == 1 ? 'recipe' : 'recipes'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                return FavoriteMealCard(
                  meal: _favorites[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailScreen(
                          mealId: _favorites[index].idMeal,
                        ),
                      ),
                    ).then((_) => _loadFavorites());
                  },
                  onRemove: () => _removeFavorite(_favorites[index].idMeal),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}