import 'package:careshareapp2/screens_irfan/register_screen.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final List<String> imgList = [
    'assets/lp1.png',
    'assets/lp2.png',
    'assets/lp3.png',
  ];

  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CarouselSlider(
            items: imgList
                .map((item) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(item),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ))
                .toList(),
            carouselController: _controller,
            options: CarouselOptions(
              autoPlay: false,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              aspectRatio: MediaQuery.of(context).size.aspectRatio,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 40,
            left: 0,
            right: 0,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == entry.key
                              ? Colors.black
                              : Colors.black.withOpacity(0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: _current == 2 ? 1.0 : 0.0,
              duration: Duration(seconds: 2),
              child: _current == 2
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFAAD7D9),
                          elevation: 5,
                          side: BorderSide(color: Color(0xFFAAD7D9)),
                          fixedSize: Size(283, 49),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Continue',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
