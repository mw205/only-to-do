// lib/presentation/widgets/countdown_timer.dart
// lib/presentation/widgets/countdown_timer.dart
import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetDate;
  final TextStyle? digitStyle;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onFinished;
  final bool showLabels;

  const CountdownTimer({
    super.key,
    required this.targetDate,
    this.digitStyle,
    this.labelStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.onFinished,
    this.showLabels = true,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remainingTime;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    if (widget.targetDate.isAfter(now)) {
      _remainingTime = widget.targetDate.difference(now);
      _isFinished = false;
    } else {
      _remainingTime = Duration.zero;
      _isFinished = true;
      if (widget.onFinished != null) {
        widget.onFinished!();
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _calculateRemainingTime();
        if (_isFinished) {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours.remainder(24);
    final minutes = _remainingTime.inMinutes.remainder(60);
    final seconds = _remainingTime.inSeconds.remainder(60);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTimeUnit(days, 'DAYS'),
          _buildSeparator(),
          _buildTimeUnit(hours, 'HOURS'),
          _buildSeparator(),
          _buildTimeUnit(minutes, 'MINS'),
          _buildSeparator(),
          _buildTimeUnit(seconds, 'SECS'),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(int value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style:
              widget.digitStyle ??
              TextStyle(
                color:
                    widget.foregroundColor ??
                    Theme.of(context).colorScheme.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
        ),
        if (widget.showLabels)
          Text(
            label,
            style:
                widget.labelStyle ??
                TextStyle(
                  color:
                      widget.foregroundColor?.withValues(alpha: .7) ??
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: .7),
                  fontSize: 12,
                ),
          ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Text(
      ':',
      style: TextStyle(
        color: widget.foregroundColor ?? Theme.of(context).colorScheme.primary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
