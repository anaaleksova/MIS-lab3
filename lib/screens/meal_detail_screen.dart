import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_detail.dart';
import '../models/favorite_meal.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({Key? key, required this.mealId}) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final FavoritesService _favoritesService = FavoritesService();
  MealDetail? _meal;
  bool _isLoading = true;
  bool _isFavorite = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loadMealDetails();
    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadMealDetails() async {
    try {
      final meal = await _apiService.getMealDetails(widget.mealId);
      setState(() {
        _meal = meal;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final isFavorite = await _favoritesService.isFavorite(widget.mealId);
      setState(() => _isFavorite = isFavorite);
    } catch (e) {
    }
  }

  Future<void> _toggleFavorite() async {
    if (_meal == null) return;

    _animationController.forward().then((_) => _animationController.reverse());

    final wasAlreadyFavorite = _isFavorite;
    setState(() => _isFavorite = !_isFavorite);

    try {
      if (wasAlreadyFavorite) {
        await _favoritesService.removeFavorite(widget.mealId);
      } else {
        final favoriteMeal = FavoriteMeal(
          idMeal: _meal!.idMeal,
          strMeal: _meal!.strMeal,
          strMealThumb: _meal!.strMealThumb,
          strCategory: _meal!.strCategory,
          addedAt: DateTime.now(),
        );
        await _favoritesService.addFavorite(favoriteMeal);
      }
    } catch (e) {
      setState(() => _isFavorite = wasAlreadyFavorite);
    }
  }

  Future<void> _launchYouTube(String url) async {
    if (url.isEmpty) return;

    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
        throw Exception('Could not launch YouTube');
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.orange.shade400,
          strokeWidth: 3,
        ),
      )
          : _meal == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Recipe not found!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded,
                    color: Colors.grey[900]),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: IconButton(
                    icon: Icon(
                      _isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _isFavorite
                          ? Colors.red.shade400
                          : Colors.grey[700],
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: _meal!.idMeal,
                    child: Image.network(
                      _meal!.strMealThumb,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _meal!.strMeal,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius:
                                BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.orange.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.category_rounded,
                                    size: 16,
                                    color: Colors.orange.shade700,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _meal!.strCategory,
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius:
                                BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.blue.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.public_rounded,
                                    size: 16,
                                    color: Colors.blue.shade700,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _meal!.strArea,
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_basket_rounded,
                              color: Colors.orange.shade400,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Ingredients',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._meal!.ingredients.entries.map((entry) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green.shade600,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                ),
                                Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Icon(
                              Icons.restaurant_menu_rounded,
                              color: Colors.orange.shade400,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Instructions',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border:
                            Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            _meal!.strInstructions,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.8,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        if (_meal!.strYoutube.isNotEmpty) ...[
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _launchYouTube(_meal!.strYoutube),
                              icon: const Icon(
                                  Icons.play_circle_rounded,
                                  size: 24),
                              label: const Text(
                                'Watch on YouTube',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(16),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}