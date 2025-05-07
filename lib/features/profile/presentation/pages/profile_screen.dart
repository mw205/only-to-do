import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static String id = "/profile";
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool alarm = true;
  bool timeToBed = true;
  bool smartAlarm = false;
  bool darkMood = true;
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 254, 254, 255),
            ),
            child: Column(
              children: [
                const Text(
                  "Profile",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 24,
                  ),
                ),
                const Gap(10),
                CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  child: Text("👋", style: TextStyle(fontSize: 40)),
                ),
                const Gap(8),
                const Text(
                  "Lujyy",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const Text(
                  "Lujaina646@gmail.com",
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ],
            ),
          ),

          // Settings Container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF5F33E1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.nights_stay,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    title: const Text("Sleeping Setting"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  Gap(10),
                  buildSwitchTile("Alarm", Icons.alarm, alarm, (val) {
                    setState(() => alarm = val);
                  }),
                  buildSwitchTile(
                    "Time to bed",
                    Icons.bed,
                    timeToBed,
                    (val) {
                      setState(() => timeToBed = val);
                    },
                    subtitle: "Remind me 30 min before bedtime",
                  ),
                  buildSwitchTile("Smart alarm", Icons.lock_clock, smartAlarm, (
                    val,
                  ) {
                    setState(() => smartAlarm = val);
                  }),
                  buildSwitchTile("Dark mood", Icons.dark_mode, darkMood, (
                    val,
                  ) {
                    setState(() => darkMood = val);
                  }),
                  buildSwitchTile(
                    "Notifications",
                    Icons.notifications,
                    notifications,
                    (val) {
                      setState(() => notifications = val);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSwitchTile(
    String title,
    IconData icon,
    bool value,
    Function(bool) onChanged, {
    String? subtitle,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: const Color.fromARGB(255, 255, 255, 255)),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      activeColor: Colors.white,
      activeTrackColor: Color(0xFF81D4FA),
    );
  }
}
