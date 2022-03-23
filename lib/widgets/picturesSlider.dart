import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PicturesSlider extends StatefulWidget {
  const PicturesSlider({Key? key}) : super(key: key);

  @override
  _PicturesSliderState createState() => _PicturesSliderState();
}

class _PicturesSliderState extends State<PicturesSlider> {
  final pictures = [
    'assets/images/trackAssets.png',
    'assets/images/trackAssets2.png',
    'assets/images/trackAssets3.png',
    'assets/images/trackAssets4.png',
    'assets/images/trackAssets5.png',
    'assets/images/trackAssets6.png',
    'assets/images/trackAssets1.jpg',
    //'assets/images/LED.png',
    //'assets/images/LEDBUS.png',
    //'assets/images/LCD.png',
    //'assets/images/GPS.png',
    //'assets/images/GAUGE.png',
  ];
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Container(
        margin: const EdgeInsets.only(top: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider.builder(
              itemCount: pictures.length,
              itemBuilder: (context, index, realIndex) {
                final picture = pictures[index];
                return buildPicture(picture, index);
              },
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.18,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 4),
                onPageChanged: (index, reason) =>
                    setState(() => activeIndex = index),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            buildIndicator(),
          ],
        ));
  }

  Widget buildPicture(String picture, int index) => Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      color: Colors.transparent,
      child: Image.asset(picture));
  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: pictures.length,
        effect: SlideEffect(
            activeDotColor: Colors.white,
            dotColor: Colors.black26,
            dotHeight: 6,
            dotWidth: 6),
      );
}
