import 'package:flutter/material.dart';

/**
 * The enter-point of a dart App
 */
void main() {
  // runApp takes a Widget
  // Flutter framework expands and displays to the screen at run time.
  runApp(
    // The MaterialApp widget becomes the root of your app's widget tree.
    MaterialApp(
      title: 'FriendlyChat',
      // The home argument specifies the default screen that users see in your app.
      home: Scaffold(
        appBar: AppBar(
          title: Text('FriendlyChat'),
        ),
      ),
    ),
  );
}