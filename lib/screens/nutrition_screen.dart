import 'package:flutter/material.dart';
import 'package:fitness_pro/theme/app_theme.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  // Inputs
  final _weightController = TextEditingController(text: '70');
  final _heightController = TextEditingController(text: '175');
  final _ageController = TextEditingController(text: '25');
  String _gender = 'male';
  String _activityLevel = 'moderate';
  String _goal = 'maintain';

  // Results
  double? _bmr;
  double? _tdee;
  double? _targetCalories;
  Map<String, double>? _macros;
  bool _calculated = false;

  // Activity levels
  static const Map<String, double> _activityMultipliers = {
    'sedentary': 1.2,
    'light': 1.375,
    'moderate': 1.55,
    'active': 1.725,
    'veryActive': 1.9,
  };

  static const Map<String, String> _activityLabels = {
    'sedentary': 'Сидячий (офис, нет тренировок)',
    'light': 'Лёгкая (1-2 тренировки/нед)',
    'moderate': 'Умеренная (3-4 тренировки/нед)',
    'active': 'Активная (5-6 тренировок/нед)',
    'veryActive': 'Очень активная (спортсмен)',
  };

  void _calculate() {
    final weight = double.tryParse(_weightController.text) ?? 70;
    final height = double.tryParse(_heightController.text) ?? 175;
    final age = double.tryParse(_ageController.text) ?? 25;

    // Mifflin-St Jeor
    double bmr;
    if (_gender == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    final tdee = bmr * (_activityMultipliers[_activityLevel] ?? 1.55);

    double target;
    switch (_goal) {
      case 'lose':
        target = tdee - 500;
        break;
      case 'gain':
        target = tdee + 300;
        break;
      default:
        target = tdee;
    }

    // Macros
    final protein = (target * 0.30) / 4; // 30% protein, 4 cal/g
    final carbs = (target * 0.40) / 4; // 40% carbs
    final fats = (target * 0.30) / 9; // 30% fats, 9 cal/g

    setState(() {
      _bmr = bmr;
      _tdee = tdee;
      _targetCalories = target;
      _macros = {'protein': protein, 'carbs': carbs, 'fats': fats};
      _calculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Питание и калории')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.goldDark, AppColors.gold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.restaurant, color: Colors.black, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Калькулятор калорий',
                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Рассчитай свою норму КБЖУ',
                          style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Gender
            const Text('Пол', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildGenderButton('Мужчина', 'male', Icons.male),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGenderButton('Женщина', 'female', Icons.female),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Weight, Height, Age
            Row(
              children: [
                Expanded(child: _buildInput('Вес (кг)', _weightController)),
                const SizedBox(width: 12),
                Expanded(child: _buildInput('Рост (см)', _heightController)),
                const SizedBox(width: 12),
                Expanded(child: _buildInput('Возраст', _ageController)),
              ],
            ),
            const SizedBox(height: 16),

            // Activity level
            const Text('Уровень активности', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _activityLevel,
                  isExpanded: true,
                  dropdownColor: AppColors.card,
                  style: const TextStyle(color: AppColors.white),
                  items: _activityLabels.entries.map((e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value, style: const TextStyle(fontSize: 13)),
                  )).toList(),
                  onChanged: (v) => setState(() => _activityLevel = v!),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Goal
            const Text('Цель', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildGoalButton('Похудеть', 'lose', Icons.trending_down)),
                const SizedBox(width: 8),
                Expanded(child: _buildGoalButton('Поддержать', 'maintain', Icons.balance)),
                const SizedBox(width: 8),
                Expanded(child: _buildGoalButton('Набрать', 'gain', Icons.trending_up)),
              ],
            ),
            const SizedBox(height: 24),

            // Calculate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Рассчитать'),
              ),
            ),
            const SizedBox(height: 24),

            // Results
            if (_calculated) ...[
              _buildResults(),
              const SizedBox(height: 24),
              _buildMealPlan(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(String label, String value, IconData icon) {
    final isSelected = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.gold : AppColors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.black : AppColors.gold, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.grey, fontSize: 12),
      ),
      style: const TextStyle(color: AppColors.white),
    );
  }

  Widget _buildGoalButton(String label, String value, IconData icon) {
    final isSelected = _goal == value;
    return GestureDetector(
      onTap: () => setState(() => _goal = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.gold : AppColors.divider),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.black : AppColors.gold, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Результаты', style: TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildResultRow('Базовый метаболизм (BMR)', '${_bmr!.round()} ккал'),
          _buildResultRow('С учётом активности (TDEE)', '${_tdee!.round()} ккал'),
          _buildResultRow('Целевая норма', '${_targetCalories!.round()} ккал', highlight: true),
          const SizedBox(height: 16),
          const Text('Макронутриенты', style: TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildMacroRow('Белки', _macros!['protein']!, AppColors.gold, 'г'),
          _buildMacroRow('Углеводы', _macros!['carbs']!, Colors.orange, 'г'),
          _buildMacroRow('Жиры', _macros!['fats']!, Colors.blue, 'г'),
          const SizedBox(height: 12),
          Text(
            'Вода: ${((_weightController.text.isNotEmpty ? double.parse(_weightController.text) : 70) * 0.033).toStringAsFixed(1)} л/день',
            style: TextStyle(color: AppColors.greyLight, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.grey, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: highlight ? AppColors.gold : AppColors.white,
              fontSize: highlight ? 18 : 14,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow(String label, double value, Color color, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.white, fontSize: 13)),
          const Spacer(),
          Text('${value.round()} $unit', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMealPlan() {
    final target = _targetCalories!.round();
    final isLose = _goal == 'lose';
    final isGain = _goal == 'gain';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Рекомендации по питанию', style: TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildMealTip('🍳 Завтрак', isLose
              ? 'Овсянка на воде, 2 яйца, овощи. ~$target ккал за день — распределяй равномерно.'
              : isGain
                  ? 'Овсянка на молоке, 3-4 яйца, банан, орехи. Калорийный завтрак важен.'
                  : 'Овсянка, 2-3 яйца, фрукт, орехи. Сбалансированный старт дня.'),
          _buildMealTip('🥗 Обед', 'Куриная грудка/рыба/говядина + рис/гречка/картофель + овощи. Основной приём пищи.'),
          _buildMealTip('🍎 Перекус', 'Творог, йогурт, орехи, фрукты, протеиновый батончик.'),
          _buildMealTip('🥩 Ужин', 'Рыба/курица + овощи + салат. Лёгкий, но белковый. За 2-3 часа до сна.'),
          const SizedBox(height: 12),
          const Text('Продукты, которые стоит есть:', style: TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Куриная грудка', 'Рыба (лосось, треска)', 'Яйца', 'Творог',
              'Гречка', 'Рис', 'Овсянка', 'Овощи', 'Фрукты', 'Орехи',
              'Авокадо', 'Оливковое масло', 'Вода 2-3 л',
            ].map((food) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gold.withOpacity(0.3)),
              ),
              child: Text(food, style: const TextStyle(color: AppColors.gold, fontSize: 11)),
            )).toList(),
          ),
          const SizedBox(height: 12),
          const Text('Избегать:', style: TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Фастфуд', 'Газировка', 'Сахар', 'Алкоголь', 'Чипсы', 'Майонез',
            ].map((food) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Text(food, style: const TextStyle(color: AppColors.error, fontSize: 11)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTip(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(text, style: TextStyle(color: AppColors.greyLight, fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}
