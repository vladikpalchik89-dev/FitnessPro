import 'package:flutter/material.dart';
import 'package:fitness_pro/theme/app_theme.dart';
import 'package:fitness_pro/models/exercise.dart';
import 'package:fitness_pro/models/workout.dart';

class WorkoutScreen extends StatefulWidget {
  final List<Exercise> exercises;
  final String workoutName;

  const WorkoutScreen({
    super.key,
    required this.exercises,
    this.workoutName = 'Тренировка',
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int _currentIndex = 0;
  int _currentSet = 1;
  bool _isResting = false;
  int _restSeconds = 60;
  int _restRemaining = 0;
  bool _workoutFinished = false;
  final List<WorkoutExercise> _completedExercises = [];
  DateTime _startedAt = DateTime.now();

  Exercise get _currentExercise => widget.exercises[_currentIndex];
  bool get _isLastExercise => _currentIndex >= widget.exercises.length - 1;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
  }

  void _completeSet() {
    final ex = _currentExercise;
    final completedSets = List<WorkoutSet>.from(
      _completedExercises.isNotEmpty && _completedExercises.last.exercise.id == ex.id
          ? _completedExercises.last.completedSets
          : [],
    );
    completedSets.add(WorkoutSet(
      setNumber: _currentSet,
      reps: ex.defaultReps,
      weight: 0,
    ));

    // Update or add exercise
    final existingIndex = _completedExercises.indexWhere((e) => e.exercise.id == ex.id);
    if (existingIndex >= 0) {
      _completedExercises[existingIndex] = _completedExercises[existingIndex].copyWith(completedSets: completedSets);
    } else {
      _completedExercises.add(WorkoutExercise(
        exercise: ex,
        sets: ex.defaultSets,
        reps: ex.defaultReps,
        restSeconds: ex.defaultRestSeconds,
        completedSets: completedSets,
      ));
    }

    if (_currentSet >= ex.defaultSets) {
      // Move to next exercise
      _nextExercise();
    } else {
      setState(() {
        _currentSet++;
        _isResting = true;
        _restRemaining = ex.defaultRestSeconds;
      });
      _startRestTimer();
    }
  }

  void _nextExercise() {
    if (_isLastExercise) {
      _finishWorkout();
    } else {
      setState(() {
        _currentIndex++;
        _currentSet = 1;
        _isResting = false;
        _restRemaining = 0;
      });
    }
  }

  void _finishWorkout() {
    setState(() => _workoutFinished = true);
  }

  void _startRestTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || !_isResting) return;
      if (_restRemaining <= 0) {
        setState(() => _isResting = false);
        return;
      }
      setState(() => _restRemaining--);
      _startRestTimer();
    });
  }

  void _skipRest() {
    setState(() {
      _isResting = false;
      _restRemaining = 0;
    });
  }

  int get _totalDuration {
    return DateTime.now().difference(_startedAt).inMinutes;
  }

  @override
  Widget build(BuildContext context) {
    if (_workoutFinished) {
      return _buildFinishScreen();
    }

    final ex = _currentExercise;
    final progress = (_currentIndex + 1) / widget.exercises.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutName),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surface,
            valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            minHeight: 4,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Exercise counter
                  Text(
                    'Упражнение ${_currentIndex + 1} из ${widget.exercises.length}',
                    style: TextStyle(color: AppColors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 16),

                  // Exercise image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: AppColors.surface,
                      child: ex.imageUrl.isNotEmpty
                          ? Image.network(ex.imageUrl, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.fitness_center, color: AppColors.gold, size: 64))
                          : const Icon(Icons.fitness_center, color: AppColors.gold, size: 64),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Exercise name
                  Text(
                    ex.nameRu,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ex.muscleName,
                    style: TextStyle(color: AppColors.gold, fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  // Sets info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem('Подход', '$_currentSet / ${ex.defaultSets}'),
                        _buildInfoItem('Повторы', '${ex.defaultReps}'),
                        _buildInfoItem('Отдых', '${ex.defaultRestSeconds} сек'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Rest timer
                  if (_isResting)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.gold),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Отдых',
                            style: TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_restRemaining',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _skipRest,
                            child: const Text('Пропустить', style: TextStyle(color: AppColors.gold)),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Technique (collapsible)
                  ExpansionTile(
                    title: const Text('Техника выполнения', style: TextStyle(color: AppColors.white)),
                    iconColor: AppColors.gold,
                    collapsedIconColor: AppColors.grey,
                    children: ex.steps.map((step) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check, color: AppColors.gold, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(step, style: const TextStyle(color: AppColors.greyLight, fontSize: 13))),
                        ],
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isResting ? null : _completeSet,
                    icon: const Icon(Icons.check_circle),
                    label: Text(_currentSet >= ex.defaultSets && _isLastExercise
                        ? 'Завершить'
                        : 'Подход выполнен'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isResting ? AppColors.grey : AppColors.gold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _isResting ? null : _nextExercise,
                  child: const Text('Далее'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishScreen() {
    final duration = _totalDuration;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: AppColors.gold, size: 80),
              const SizedBox(height: 24),
              const Text(
                'Тренировка завершена! 🎉',
                style: TextStyle(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildStatRow('Упражнений', '${widget.exercises.length}'),
                    _buildStatRow('Подходов', '${_completedExercises.fold(0, (s, e) => s + e.completedSetsCount)}'),
                    _buildStatRow('Время', '$duration мин'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Вернуться на главную'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: AppColors.gold, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: AppColors.grey, fontSize: 12)),
      ],
    );
  }
}
