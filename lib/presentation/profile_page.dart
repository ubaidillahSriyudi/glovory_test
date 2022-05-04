import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('All Products', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(), 
          icon: const Icon(Icons.arrow_back, color: Colors.black)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Login'),
            SizedBox(height: 10),
            Text('Please enter your NIK and PIN'),
            SizedBox(height: 20),
            Text('NIK'),
            TextFormField(
              textInputAction: TextInputAction.go,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Please enter your NIK',
                hintStyle: TextStyle(
                  color: Colors.grey
                )
              ),
            ),
             Text('PIN'),
            TextFormField(
              textInputAction: TextInputAction.go,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Please enter your PIN',
                hintStyle: TextStyle(
                  color: Colors.grey
                )
              ),
            ),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(400, 20),
                  primary: Colors.red[400]
                ),
                onPressed: () {}, 
                child: Text('Login')
              ),
            )

          ],
        ),
      ),
    );
  }
}