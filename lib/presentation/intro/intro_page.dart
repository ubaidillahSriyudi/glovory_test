import 'package:flutter/material.dart';
import 'package:glovory_test/core/utils/caches.dart';
import 'package:glovory_test/presentation/all_products_page.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';
import 'package:intro_slider/slide_object.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({ Key? key }) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<Slide> slides= [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSlide();
  }

  void _initSlide() {
     slides.add(
      Slide(
        description: "Buy products easily via mobile & website inside office",
        styleDescription: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontFamily: 'Raleway',
        ),
        marginDescription:
            const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
        centerWidget: const Text("Replace this with a custom widget",
            style: const TextStyle(color: Colors.white)),
        // backgroundNetworkImage: "https://picsum.photos/200/300",
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        onCenterItemPress: () {},
        backgroundColor: Colors.white
      ),
    );
    slides.add(
      Slide(
        description: 'Simple shopping that also works without internet',
        styleDescription: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        // backgroundImage: "images/city.jpeg",
        backgroundColor: Colors.white,
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
    slides.add(
      Slide(
        description: 'Simple payment by salary deduction each month',
        styleDescription: const TextStyle(
            color: Colors.black ,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        // backgroundImage: "images/beach.jpeg",
        backgroundColor: Colors.white,
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),
    );
  }

void onDonePress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllProductsPage('All Products')),
    );
  }

  void onNextPress() {
    print("onNextPress caught");
  }

  Widget renderNextBtn() {
    return const Icon(
      Icons.navigate_next,
      color: Color(0xffF3B4BA),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
   return ElevatedButton(
      child: const Text('Get Started'),
      style: ElevatedButton.styleFrom(
        primary: Colors.red
      ),
      onPressed: () {
        LocalCaches.storeLocalCaches(true);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AllProductsPage('All Products')), 
          (route) => false
        );
      },
    );
  }

  Widget renderSkipBtn() {
    return const Icon(
      Icons.skip_next,
      color: Color(0xffF3B4BA),
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(const Color(0x33F3B4BA)),
      overlayColor: MaterialStateProperty.all<Color>(const Color(0x33FFA8B0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroSlider(
        // List slides
        slides: slides,

        // Skip button
        // renderSkipBtn: renderSkipBtn(),
        // skipButtonStyle: myButtonStyle(),

        // Next button
        renderNextBtn: renderNextBtn(),
        onNextPress: onNextPress,
        nextButtonStyle: myButtonStyle(),

        // Done button
        renderDoneBtn: renderDoneBtn(),
        onDonePress: onDonePress,
        // doneButtonStyle: myButtonStyle(),

        // Dot indicator
        colorDot: const Color(0x33FFA8B0),
        colorActiveDot: const Color(0xffFFA8B0),
        sizeDot: 13.0,

        // Show or hide status bar
        hideStatusBar: true,
        backgroundColorAllSlides: Colors.grey,

        // Scrollbar
        verticalScrollbarBehavior: scrollbarBehavior.SHOW,
      ),
    );
  }
  
}