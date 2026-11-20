import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_pro/theme/app_theme.dart';
import 'package:fitness_pro/models/exercise.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                exercise.nameRu,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              background: exercise.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: exercise.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.gold),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.surface,
                        child: const Icon(Icons.fitness_center, color: AppColors.gold, size: 64),
                      ),
                    )
                  : Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.fitness_center, color: AppColors.gold, size: 64),
                    ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: AppColors.gold),
                onPressed: () {},
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag(exercise.muscleName, AppColors.gold),
                      _buildTag(exercise.difficultyName, AppColors.goldDark),
                      _buildTag(exercise.equipmentName, AppColors.grey),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  _buildSection('Описание', exercise.description),
                  const SizedBox(height: 20),

                  // Muscles
                  _buildSection('Основные мышцы', exercise.muscleName),
                  if (exercise.secondaryMuscles.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildSection(
                      'Дополнительные мышцы',
                      exercise.secondaryMuscles.map((m) => m.name).join(', '),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Steps
                  if (exercise.steps.isNotEmpty) ...[
                    _buildStepsSection(exercise.steps),
                    const SizedBox(height: 20),
                  ],

                  // Mistakes
                  if (exercise.commonMistakes.isNotEmpty) ...[
                    _buildListSection('Типичные ошибки', exercise.commonMistakes, Icons.error_outline, AppColors.error),
                    const SizedBox(height: 20),
                  ],

                  // Safety
                  if (exercise.safetyTips.isNotEmpty) ...[
                    _buildListSection('Безопасность', exercise.safetyTips, Icons.shield, AppColors.success),
                    const SizedBox(height: 20),
                  ],

                  // Parameters
                  _buildParameters(exercise),
                  const SizedBox(height: 20),

                  // Video button
                  if (exercise.videoUrl.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.play_circle_filled),
                        label: const Text('Смотреть видеоинструкцию'),
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStepsSection(List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Техника выполнения',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...steps.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildListSection(String title, List<String> items, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(color: AppColors.white, fontSize: 14, height: 1.4),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildParameters(Exercise exercise) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Параметры',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildParamRow('Подходы', '${exercise.defaultSets}'),
          _buildParamRow('Повторения', '${exercise.defaultReps}'),
          _buildParamRow('Отдых', '${exercise.defaultRestSeconds} сек'),
        ],
      ),
    );
  }

  Widget _buildParamRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
