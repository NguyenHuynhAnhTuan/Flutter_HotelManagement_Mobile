import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travel_app/components/onboadring/onboardingcard.dart';
import 'package:travel_app/screens/logiinscreen.dart';


class Onboardingslider extends StatefulWidget {
  const Onboardingslider({Key? key});

  @override
  State<Onboardingslider> createState() => _OnboardingsliderState();
}

class _OnboardingsliderState extends State<Onboardingslider> {
  final CarouselController buttonCarouselController = CarouselController();
  int _currentIndex = 0;
  final List<String> images = ["intro1.png", "intro2.png", "intro3.png"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            CarouselSlider(
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                initialPage: _currentIndex,
                aspectRatio: 2 / 3,
                enableInfiniteScroll: false,
                enlargeFactor: 0.4,
                viewportFraction: 1,
              ),
              items: [0, 1, 2].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return OnboardingCard(index: i);
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (int i = 0; i < 3; i++)
                  Text(
                    "●",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: _currentIndex == i ? Colors.black : Colors.grey,
                    ),
                  ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {
                  if (_currentIndex == 2) {
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                      builder: (context) {
                        return const LoginScreen();
                      },
                    ));
                  }
                  buttonCarouselController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                },
                child: Text(
                  _currentIndex == 2 ? "Get started" : "NEXT",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ));
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
