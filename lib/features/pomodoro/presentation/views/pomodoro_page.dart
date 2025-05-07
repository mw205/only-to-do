import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:gap/gap.dart';

import '../cubit/pomodoro_cubit.dart';
import '../cubit/pomodoro_state.dart';
import 'pomodoro_settings_page.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});
  static const String id = '/pomodoro';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PomodoroCubit, PomodoroState>(
        builder: (context, state) {
          final totalSeconds = state.isBreak
              ? _getBreakDuration(state) * 60
              : state.focusDuration * 60;

          final percentage = state.remainingSeconds / totalSeconds;

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.isBreak
                                ? (state.completedSessions %
                                                state.longBreakAfter ==
                                            0 &&
                                        state.completedSessions > 0)
                                    ? 'Long Break'
                                    : 'Short Break'
                                : 'Focus Time',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: state.isBreak
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const Gap(24),
                      CircularPercentIndicator(
                        radius: 130,
                        lineWidth: 15,
                        percent: percentage.clamp(0.0, 1.0),
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Gap(20),
                            Text(
                              _formatTime(state.remainingSeconds),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${state.completedSessions}/${state.targetSessions} sessions',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.settings,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () => navigateToSettings(context),
                            ),
                          ],
                        ),
                        progressColor: state.isBreak
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.grey[300]!,
                        animation: true,
                        animateFromLastPercent: true,
                      ),
                      const Gap(40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            iconSize: 32,
                            onPressed: () =>
                                context.read<PomodoroCubit>().reset(),
                          ),
                          const Gap(24),
                          FloatingActionButton(
                            onPressed: () {
                              if (state.status == PomodoroStatus.running) {
                                context.read<PomodoroCubit>().pause();
                              } else {
                                context.read<PomodoroCubit>().start();
                              }
                            },
                            child: Icon(
                              state.status == PomodoroStatus.running
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 32,
                            ),
                          ),
                          const Gap(24),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            iconSize: 32,
                            onPressed: () =>
                                context.read<PomodoroCubit>().skipToNext(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Session progress indicator
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Text(
                      'Session Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const Gap(8),
                    _buildSessionIndicators(context, state),
                    const Gap(24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Format seconds into MM:SS
  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Build session progress indicators
  Widget _buildSessionIndicators(BuildContext context, PomodoroState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(state.targetSessions, (index) {
        final isCompleted = index < state.completedSessions;
        final isCurrentSession =
            index == state.completedSessions && !state.isBreak;

        return Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Colors.green
                : isCurrentSession
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
            border: Border.all(
              color: isCurrentSession
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: isCurrentSession ? 2 : 0,
            ),
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        );
      }),
    );
  }

  // Navigate to settings page
  void navigateToSettings(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PomodoroSettingsPage()),
    );
  }

  // Get current break duration
  int _getBreakDuration(PomodoroState state) {
    final isLongBreak = (state.completedSessions % state.longBreakAfter == 0) &&
        state.completedSessions > 0;

    return isLongBreak ? state.longBreakDuration : state.shortBreakDuration;
  }
}
