import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class VerticalImageCarousel extends StatefulWidget {
  const VerticalImageCarousel({super.key});

  @override
  _VerticalImageCarouselState createState() => _VerticalImageCarouselState();
}

class _VerticalImageCarouselState extends State<VerticalImageCarousel> {
  int _currentIndex = 0;

  final CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              height: 200.0,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(
                  () {
                    _currentIndex = index;
                  },
                );
              },
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3)),
          items: promoList
              .map(
                (item) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff3fb31e), Color(0xff267310)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            item.text,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Transform.scale(
                              scale: 1.2,
                              child: Image.asset(item.imageUrl,
                                  fit: BoxFit.cover)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        // Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: promoList.asMap().entries.map(
            (entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 6.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: _currentIndex == entry.key
                        ? Color(0xff3fb31e)
                        : Colors.grey[400],
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
