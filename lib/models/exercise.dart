enum MuscleGroup {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  legs,
  glutes,
  abs,
  cardio,
  stretching,
}

enum Difficulty { beginner, intermediate, advanced }

enum Equipment {
  none,
  dumbbells,
  barbell,
  kettlebell,
  resistanceBand,
  pullUpBar,
  bench,
  cable,
  machine,
  mat,
}

class Exercise {
  final String id;
  final String name;
  final String nameRu;
  final MuscleGroup primaryMuscle;
  final List<MuscleGroup> secondaryMuscles;
  final Difficulty difficulty;
  final Equipment equipment;
  final String description;
  final List<String> steps;
  final List<String> commonMistakes;
  final List<String> safetyTips;
  final String imageUrl;
  final List<String> phaseImages;
  final String videoUrl;
  final int defaultSets;
  final int defaultReps;
  final int defaultRestSeconds;

  const Exercise({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.primaryMuscle,
    this.secondaryMuscles = const [],
    this.difficulty = Difficulty.beginner,
    this.equipment = Equipment.none,
    required this.description,
    this.steps = const [],
    this.commonMistakes = const [],
    this.safetyTips = const [],
    this.imageUrl = '',
    this.phaseImages = const [],
    this.videoUrl = '',
    this.defaultSets = 3,
    this.defaultReps = 12,
    this.defaultRestSeconds = 60,
  });

  String get muscleName {
    switch (primaryMuscle) {
      case MuscleGroup.chest: return 'Грудь';
      case MuscleGroup.back: return 'Спина';
      case MuscleGroup.shoulders: return 'Плечи';
      case MuscleGroup.biceps: return 'Бицепс';
      case MuscleGroup.triceps: return 'Трицепс';
      case MuscleGroup.legs: return 'Ноги';
      case MuscleGroup.glutes: return 'Ягодицы';
      case MuscleGroup.abs: return 'Пресс';
      case MuscleGroup.cardio: return 'Кардио';
      case MuscleGroup.stretching: return 'Растяжка';
    }
  }

  String get difficultyName {
    switch (difficulty) {
      case Difficulty.beginner: return 'Начинающий';
      case Difficulty.intermediate: return 'Средний';
      case Difficulty.advanced: return 'Продвинутый';
    }
  }

  String get equipmentName {
    switch (equipment) {
      case Equipment.none: return 'Без оборудования';
      case Equipment.dumbbells: return 'Гантели';
      case Equipment.barbell: return 'Штанга';
      case Equipment.kettlebell: return 'Гиря';
      case Equipment.resistanceBand: return 'Резинка';
      case Equipment.pullUpBar: return 'Турник';
      case Equipment.bench: return 'Скамья';
      case Equipment.cable: return 'Тренажёр (блок)';
      case Equipment.machine: return 'Тренажёр';
      case Equipment.mat: return 'Коврик';
    }
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'name_ru': nameRu,
    'primary_muscle': primaryMuscle.index,
    'secondary_muscles': secondaryMuscles.map((m) => m.index).join(','),
    'difficulty': difficulty.index,
    'equipment': equipment.index,
    'description': description,
    'steps': steps.join('||'),
    'mistakes': commonMistakes.join('||'),
    'safety': safetyTips.join('||'),
    'image_url': imageUrl,
    'phase_images': phaseImages.join('||'),
    'video_url': videoUrl,
    'default_sets': defaultSets,
    'default_reps': defaultReps,
    'default_rest': defaultRestSeconds,
  };

  factory Exercise.fromMap(Map<String, dynamic> m) => Exercise(
    id: m['id'],
    name: m['name'],
    nameRu: m['name_ru'],
    primaryMuscle: MuscleGroup.values[m['primary_muscle']],
    secondaryMuscles: (m['secondary_muscles'] as String).isEmpty
        ? []
        : (m['secondary_muscles'] as String).split(',').map((e) => MuscleGroup.values[int.parse(e)]).toList(),
    difficulty: Difficulty.values[m['difficulty']],
    equipment: Equipment.values[m['equipment']],
    description: m['description'],
    steps: (m['steps'] as String).isEmpty ? [] : (m['steps'] as String).split('||'),
    commonMistakes: (m['mistakes'] as String).isEmpty ? [] : (m['mistakes'] as String).split('||'),
    safetyTips: (m['safety'] as String).isEmpty ? [] : (m['safety'] as String).split('||'),
    imageUrl: m['image_url'],
    phaseImages: (m['phase_images'] as String).isEmpty ? [] : (m['phase_images'] as String).split('||'),
    videoUrl: m['video_url'],
    defaultSets: m['default_sets'],
    defaultReps: m['default_reps'],
    defaultRestSeconds: m['default_rest'],
  );
}
