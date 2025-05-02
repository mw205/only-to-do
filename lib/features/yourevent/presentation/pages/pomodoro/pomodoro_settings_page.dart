import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/pomodoro/pomodoro_cubit.dart';
import '../../cubits/pomodoro/pomodoro_state.dart';

class PomodoroSettingsPage extends StatefulWidget {
  const PomodoroSettingsPage({super.key});

  @override
  State<PomodoroSettingsPage> createState() => _PomodoroSettingsPageState();
}

class _PomodoroSettingsPageState extends State<PomodoroSettingsPage> {
  late int _focusDuration;
  late int _shortBreakDuration;
  late int _longBreakDuration;
  late int _longBreakAfter;
  late int _targetSessions;

  @override
  void initState() {
    super.initState();

    // Get current settings from Cubit state
    final state = context.read<PomodoroCubit>().state;
    _focusDuration = state.focusDuration;
    _shortBreakDuration = state.shortBreakDuration;
    _longBreakDuration = state.longBreakDuration;
    _longBreakAfter = state.longBreakAfter;
    _targetSessions = state.targetSessions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Settings')),
      body: BlocBuilder<PomodoroCubit, PomodoroState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Focus Duration
              _buildSliderSetting(
                title: 'Focus Duration',
                value: _focusDuration.toDouble(),
                min: 1,
                max: 60,
                divisions: 59,
                label: '$_focusDuration min',
                onChanged: (value) {
                  setState(() {
                    _focusDuration = value.round();
                  });
                },
              ),

              const Divider(),

              // Short Break Duration
              _buildSliderSetting(
                title: 'Short Break Duration',
                value: _shortBreakDuration.toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                label: '$_shortBreakDuration min',
                onChanged: (value) {
                  setState(() {
                    _shortBreakDuration = value.round();
                  });
                },
              ),

              const Divider(),

              // Long Break Duration
              _buildSliderSetting(
                title: 'Long Break Duration',
                value: _longBreakDuration.toDouble(),
                min: 5,
                max: 45,
                divisions: 40,
                label: '$_longBreakDuration min',
                onChanged: (value) {
                  setState(() {
                    _longBreakDuration = value.round();
                  });
                },
              ),

              const Divider(),

              // Long Break After
              _buildSliderSetting(
                title: 'Long Break After',
                subtitle: 'Number of sessions before a long break',
                value: _longBreakAfter.toDouble(),
                min: 1,
                max: 8,
                divisions: 7,
                label: '$_longBreakAfter sessions',
                onChanged: (value) {
                  setState(() {
                    _longBreakAfter = value.round();
                  });
                },
              ),

              const Divider(),

              // Target Sessions
              _buildSliderSetting(
                title: 'Target Sessions',
                subtitle: 'Daily goal of completed focus sessions',
                value: _targetSessions.toDouble(),
                min: 1,
                max: 12,
                divisions: 11,
                label: '$_targetSessions sessions',
                onChanged: (value) {
                  setState(() {
                    _targetSessions = value.round();
                  });
                },
              ),

              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Build slider setting
  Widget _buildSliderSetting({
    required String title,
    String? subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        Row(
          children: [
            Text(
              min.round().toString(),
              style: TextStyle(color: Colors.grey[600]),
            ),
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                label: label,
                onChanged: onChanged,
              ),
            ),
            Text(
              max.round().toString(),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Save settings
  void _saveSettings() {
    context.read<PomodoroCubit>().saveSettings(
      focusDuration: _focusDuration,
      shortBreakDuration: _shortBreakDuration,
      longBreakDuration: _longBreakDuration,
      longBreakAfter: _longBreakAfter,
      targetSessions: _targetSessions,
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Settings saved')));
  }
}
