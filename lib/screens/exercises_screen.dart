import 'package:flutter/material.dart';
import 'package:fitness_pro/theme/app_theme.dart';
import 'package:fitness_pro/models/exercise.dart';
import 'package:fitness_pro/data/exercises_data.dart';
import 'package:fitness_pro/screens/exercise_detail_screen.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  MuscleGroup? _selectedMuscle;
  Difficulty? _selectedDifficulty;

  List<Exercise> get _filteredExercises {
    var list = allExercises;
    if (_searchQuery.isNotEmpty) {
      list = list.where((e) =>
        e.nameRu.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        e.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    if (_selectedMuscle != null) {
      list = list.where((e) => e.primaryMuscle == _selectedMuscle).toList();
    }
    if (_selectedDifficulty != null) {
      list = list.where((e) => e.difficulty == _selectedDifficulty).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Упражнения'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск упражнений...',
                prefixIcon: const Icon(Icons.search, color: AppColors.gold),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          // Active filters
          if (_selectedMuscle != null || _selectedDifficulty != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (_selectedMuscle != null)
                    _buildFilterChip(
                      _selectedMuscle!.name,
                      () => setState(() => _selectedMuscle = null),
                    ),
                  if (_selectedDifficulty != null)
                    _buildFilterChip(
                      _selectedDifficulty!.name,
                      () => setState(() => _selectedDifficulty = null),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedMuscle = null;
                      _selectedDifficulty = null;
                    }),
                    child: const Text('Сбросить', style: TextStyle(color: AppColors.gold)),
                  ),
                ],
              ),
            ),

          // Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Найдено: ${_filteredExercises.length}',
                  style: TextStyle(color: AppColors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: _filteredExercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: AppColors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Ничего не найдено',
                          style: TextStyle(color: AppColors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredExercises.length,
                    itemBuilder: (context, index) {
                      final ex = _filteredExercises[index];
                      return _buildExerciseCard(context, ex);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: AppColors.gold, fontSize: 12)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: AppColors.gold),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Exercise ex) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exercise: ex)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Container(
                width: 100,
                height: 100,
                color: AppColors.surface,
                child: ex.imageUrl.isNotEmpty
                    ? Image.network(
                        ex.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.fitness_center,
                          color: AppColors.gold,
                          size: 40,
                        ),
                      )
                    : const Icon(Icons.fitness_center, color: AppColors.gold, size: 40),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ex.nameRu,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ex.muscleName,
                      style: TextStyle(color: AppColors.gold, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildTag(ex.difficultyName),
                        const SizedBox(width: 6),
                        _buildTag(ex.equipmentName),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: AppColors.greyLight, fontSize: 10),
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Фильтры',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Мышечная группа', style: TextStyle(color: AppColors.grey)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MuscleGroup.values.map((m) {
                final isSelected = _selectedMuscle == m;
                return FilterChip(
                  label: Text(m.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedMuscle = selected ? m : null);
                    Navigator.pop(context);
                  },
                  selectedColor: AppColors.gold,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : AppColors.white,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Сложность', style: TextStyle(color: AppColors.grey)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Difficulty.values.map((d) {
                final isSelected = _selectedDifficulty == d;
                return FilterChip(
                  label: Text(d.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedDifficulty = selected ? d : null);
                    Navigator.pop(context);
                  },
                  selectedColor: AppColors.gold,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : AppColors.white,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
