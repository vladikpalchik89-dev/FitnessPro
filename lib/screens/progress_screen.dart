import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fitness_pro/theme/app_theme.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Прогресс')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Calendar
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              padding: const EdgeInsets.all(8),
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: const TextStyle(color: AppColors.white),
                  weekendTextStyle: TextStyle(color: AppColors.grey),
                  outsideTextStyle: TextStyle(color: AppColors.grey.withOpacity(0.5)),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                  leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.gold),
                  rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.gold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stats
            Row(
              children: [
                Expanded(child: _buildStatCard('Тренировок', '0', Icons.fitness_center)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Минут', '0', Icons.timer)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Упражнений', '0', Icons.list)),
              ],
            ),
            const SizedBox(height: 20),

            // Recent workouts
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Последние тренировки',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.history, size: 48, color: AppColors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'Пока нет записей',
                          style: TextStyle(color: AppColors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Начни первую тренировку!',
                          style: TextStyle(color: AppColors.greyLight, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.gold, size: 24),
          const SizedBox(height: 8),
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
            style: TextStyle(color: AppColors.grey, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
