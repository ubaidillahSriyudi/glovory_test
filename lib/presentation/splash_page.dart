import 'package:flutter/material.dart';
import 'package:glovory_test/core/utils/caches.dart';
import 'package:glovory_test/presentation/all_products_page.dart';
import 'package:glovory_test/presentation/intro/intro_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({ Key? key }) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  void _init() {
    Future.delayed(const Duration(milliseconds: 1000), (){
      LocalCaches.getLocal().then((value) {
        if (value == true) {
          return Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (_) => const AllProductsPage('All Products')), 
            (route) => false
          );
        } else {
          return Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (_) => const IntroPage()), 
            (route) => false
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('logo.png', width: 200),
      ),
    );
  }
}