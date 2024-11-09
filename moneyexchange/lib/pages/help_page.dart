import 'package:flutter/material.dart';
import 'main.dart';

class HelpCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help Center',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HelpPage(), // The page with the Exit button
    );
  }
}

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("We are here to help you")),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add Image
            Image.asset(
              'assets/images/customerserv.jpeg', // Path to the image asset
              width: 1000, // You can adjust the width or height of the image
              height: 300,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20), // Add some space between the image and the text
            // Add RichText with bold and italic style
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'We are happy to help you.\n',
                    style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                  TextSpan(
                    text: 'Please contact this number: 01092585350',
                    style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20, right: 20), // Adjust position
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MoneyExchangeApp()),
            );
          },
          child: Text(
            'Exit',
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
