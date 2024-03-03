import 'package:flutter/material.dart';

class OnboardingCard extends StatefulWidget {
  const OnboardingCard({super.key, required this.index});
  final int index;

  @override
  State<OnboardingCard> createState() => _OnboardingCardState();
}

class _OnboardingCardState extends State<OnboardingCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 80),
          child: Image.asset(
            "assets/images/intro${widget.index + 1}.png",
          ),
        ),
        _buildIntroductionText(widget.index),
        _buildLoremText(widget.index),
      ],
    );
  }

  Widget _buildIntroductionText(int index) {
    switch (index) {
      case 0:
        return const Text(
          "Welcome to Your Comfort Zone",
          style: TextStyle(fontSize: 20),
        );
      case 1:
        return const Text(
          "Unforgettable Experiences Await",
          style: TextStyle(fontSize: 20),
        );
      case 2:
        return const Text(
          "Your Home for Every Occasion",
          style: TextStyle(fontSize: 20),
        );
      default:
        return const Text("Introduction");
    }
  }

  Widget _buildLoremText(int index) {
    switch (index) {
      case 0:
        return const Text(

            "Step into a cozy retreat. Enjoy personalized comfort and exceptional service at our hotel. Whether for relaxation, exploration, or business, we provide the perfect space for you to thrive."        );
      case 1:
        return const Text(
            "Immerse yourself in unique experiences within and beyond our doors. Explore renowned landmarks, indulge in exquisite dining, or simply soak up the atmosphere. Our hotel is your gateway to unforgettable memories."        );
      case 2:
        return const Text(
            "Whether you're planning a romantic getaway, family vacation, business trip, or solo adventure, our hotel caters to your every need. Discover tailored experiences, exceptional service, and amenities that cater to your unique goals."        );
      default:
        return const Text("Lorem");
    }
  }
}
