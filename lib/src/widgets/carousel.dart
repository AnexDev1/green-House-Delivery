import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../models/promo_item.dart';

class VerticalImageCarousel extends StatefulWidget {
  const VerticalImageCarousel({super.key});

  @override
  _VerticalImageCarouselState createState() => _VerticalImageCarouselState();
}

class _VerticalImageCarouselState extends State<VerticalImageCarousel> {
  int _currentIndex = 0;
  final List<PromoItem> promoList = [
    PromoItem(
      text: "You get 20% discount on every order",
      imageUrl:
          "https://img.freepik.com/free-psd/fresh-beef-burger-isolated-transparent-background_191095-9018.jpg?w=740&t=st=1721111253~exp=1721111853~hmac=095f0ed553bca81f5528220891cad1e6514a96c14993671776ab697550741cd8",
    ),
    PromoItem(
      text: "You get 20% discount on every order",
      imageUrl:
          "https://w7.pngwing.com/pngs/369/24/png-transparent-hamburger-chicken-sandwich-veggie-burger-fast-food-burger-king-food-recipe-fast-food-restaurant-thumbnail.png",
    ),
    PromoItem(
      text: "You get 20% discount on every order",
      imageUrl:
          "https://w7.pngwing.com/pngs/369/24/png-transparent-hamburger-chicken-sandwich-veggie-burger-fast-food-burger-king-food-recipe-fast-food-restaurant-thumbnail.png",
    ),
    // Add more items here
  ];
  final CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              height: 150.0,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(
                  () {
                    _currentIndex = index;
                  },
                );
              },
              viewportFraction: 1.0),
          items: promoList
              .map(
                (item) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
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
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child:
                              Image.network(item.imageUrl, fit: BoxFit.cover),
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
                        ? Colors.amber
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
