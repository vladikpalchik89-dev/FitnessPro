import 'package:flutter/material.dart';
import 'package:fitness_pro/theme/app_theme.dart';
import 'package:fitness_pro/models/exercise.dart';
import 'package:fitness_pro/data/exercises_data.dart';
import 'package:fitness_pro/screens/workout_screen.dart';
import 'package:fitness_pro/screens/nutrition_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Атлет';

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FITNESS PRO',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Твой персональный тренер',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 2),
                    ),
                    child: const Icon(Icons.person, color: AppColors.gold),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Greeting
              Text(
                '$greeting, $_userName! 💪',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Готов к тренировке? Выбери упражнение или начни программу.',
                style: TextStyle(color: AppColors.greyLight, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Today's workout card
              _buildWorkoutOfDayCard(),
              const SizedBox(height: 24),

              // Quick actions
              const Text(
                'Быстрый старт',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActions(context),
              const SizedBox(height: 24),

              // Categories
              const Text(
                'Категории',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildCategories(context),
              const SizedBox(height: 24),

              // Stats
              _buildStatsCard(),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 6) return 'Доброй ночи';
    if (hour < 12) return 'Доброе утро';
    if (hour < 18) return 'Добрый день';
    return 'Добрый вечер';
  }

  Widget _buildWorkoutOfDayCard() {
    final exercise = allExercises[0];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.goldDark, AppColors.gold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fitness_center, color: Colors.black, size: 24),
              const SizedBox(width: 8),
              Text(
                'Тренировка дня',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            exercise.nameRu,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${exercise.muscleName} • ${exercise.difficultyName}',
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: AppColors.gold,
            ),
            child: const Text('Начать тренировку'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      ('Начать тренировку', Icons.play_arrow_rounded, AppColors.gold, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutScreen(exercises: allExercises.take(5).toList())));
      }),
      ('Каталог упражнений', Icons.menu_book_rounded, AppColors.goldDark, () {
        // Switch to exercises tab
      }),
      ('Мои программы', Icons.assignment_rounded, AppColors.gold, () {}),
      ('Питание и калории', Icons.restaurant_rounded, AppColors.goldDark, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const NutritionScreen()));
      }),
      ('Мой прогресс', Icons.bar_chart_rounded, AppColors.gold, () {}),
      ('Избранное', Icons.favorite_rounded, AppColors.goldDark, () {}),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: actions.map((a) => _buildActionCard(a.$1, a.$2, a.$3, a.$4)).toList(),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      ('Грудь', Icons.accessibility_new, MuscleGroup.chest),
      ('Спина', Icons.accessibility, MuscleGroup.back),
      ('Плечи', Icons.sports_gymnastics, MuscleGroup.shoulders),
      ('Бицепс', Icons.fitness_center, MuscleGroup.biceps),
      ('Трицепс', Icons.sports_martial_arts, MuscleGroup.triceps),
      ('Ноги', Icons.directions_run, MuscleGroup.legs),
      ('Ягодицы', Icons.self_improvement, MuscleGroup.glutes),
      ('Пресс', Icons.sports, MuscleGroup.abs),
      ('Кардио', Icons.favorite, MuscleGroup.cardio),
      ('Растяжка', Icons.spa, MuscleGroup.stretching),
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final cat = categories[i];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cat.$2, color: AppColors.gold, size: 28),
                  const SizedBox(height: 6),
                  Text(
                    cat.$1,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Тренировок', '0'),
          _buildStatItem('Упражнений', '${allExercises.length}'),
          _buildStatItem('Минут', '0'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: AppColors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
