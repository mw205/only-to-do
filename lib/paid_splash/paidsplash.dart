import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                OnBoardingPage(
                  imagePath: 'assets/images/onboarding1.svg', // ضع صورة هنا
                  title: 'Track your sleep cycle',
                  description:
                      'Track your sleep cycles, monitors dreams and improve your sleeping habits',
                ),
                OnBoardingPage(
                  imagePath: 'assets/images/onboarding2.svg', // ضع صورة هنا
                  title: 'Track your sleep cycle',
                  description:
                      'Track your sleep cycles, monitors dreams and improve your sleeping habits',
                ),
                OnBoardingPage(
                  imagePath: 'assets/images/onboarding3.svg', // ضع صورة هنا
                  title: 'Track your sleep cycle',
                  description:
                      'Track your sleep cycles, monitors dreams and improve your sleeping habits',
                  showButton: true,
                  buttonText: 'Get Started',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => WelcomeScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => buildDot(index, context),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 8,
      width: _currentPage == index ? 24 : 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}

// ...

class OnBoardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool showButton;
  final String? buttonText;
  final VoidCallback? onPressed;

  const OnBoardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
    this.showButton = false,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(imagePath, height: 250),
          const SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: ColorName.purple),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (showButton) ...[
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(
                buttonText ?? "Get Started",
                style: TextStyle(
                    color: ColorName.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                iconSize: 24,
                minimumSize: Size(220, 60),
                backgroundColor: ColorName.purple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/logo.svg', height: 170),
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: ColorName.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorName.purple,
                  iconSize: 24,
                  minimumSize: Size(220, 60),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Anonymous',
                  style: TextStyle(
                      color: ColorName.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorName.purple,
                  iconSize: 24,
                  minimumSize: Size(220, 60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
