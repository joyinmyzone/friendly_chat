// Copyright 2017, 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(FriendlyChatApp());
}

/**
 * final ThemeData for IOS
 */
final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

/**
 * final ThemeData default
 */
final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

String _name = 'Mengjiao Wu';

/**
 * Friendly Chat App
 */
class FriendlyChatApp extends StatelessWidget {

  // override build, returns an app as a Widget
  @override
  Widget build(BuildContext context) {
    // a Material App
    // home: ChatScreen
    return MaterialApp(
      title: 'FriendlyChat',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: ChatScreen(), // ChatScreen extends StatefulWidget
    );
  }
}

/**
 * ChatScreen as the home of the MaterialApp.
 *    ChatScreen is a StatefulWidget,
 *    -> a _ChatScreenState peer
 */
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
// When creating an AnimationController, you must pass it a vsync argument.
// The vsync is the source of heartbeats (the Ticker) that drives the animation forward.
// This example uses ChatScreenState as the vsync,
// so it adds a TickerProviderStateMixin mixin to the ChatScreenState class definition.
class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          // Scaffold:
          //  1. appBar
          //  2. body
          appBar: AppBar(
              // 1. title
              // 2. elevation: The z-coordinate at which to place this app bar relative to its parent.
              title: Text('FriendlyChat'),
              elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          ),
          body: Container(
              // 1. child
              // 2. decoration
              child: Column(
                  // Column creates a vertical array of children
                  children: [
                      // 1. Flexible
                      // 2. Divider
                      // 3. Container
                      Flexible(
                          child: ListView.builder(
                              padding: EdgeInsets.all(8.0),
                              reverse: true,
                              itemBuilder: (_, int index) => _messages[index],
                              itemCount: _messages.length,
                          ),
                      ),
                      Divider(height: 1.0),
                      Container(
                        decoration: BoxDecoration(color: Theme.of(context).cardColor),
                        child: _buildTextComposer(), // => _buildTextComposer(): return a Widget
                      ),
                  ],
              ),
              decoration: Theme.of(context).platform == TargetPlatform.iOS
                          ? BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey[200]),
                                ),
                            )
                          : null),
      );
  }

    /*
    * Build text composer.
    */
    Widget _buildTextComposer() {
        return IconTheme(
            data: IconThemeData(color: Theme.of(context).accentColor),
            child: Container(
                // a Row is wrapped in a Container
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                    children: [
                        // Creates a widget that controls how a child of a Row, Column, or Flex flexes.
                        Flexible(
                            child: TextField(
                                controller: _textController,
                                onChanged: (String text) {
                                    setState(() {
                                            _isComposing = text.length > 0;
                                        }
                                    );
                                },
                                onSubmitted: _isComposing ? _handleSubmitted : null,
                                decoration: InputDecoration.collapsed(hintText: 'Send a message'),
                                focusNode: _focusNode,
                            ),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Theme.of(context).platform == TargetPlatform.iOS
                                ? CupertinoButton(
                              child: Text('Send'),
                              onPressed: _isComposing
                                  ? () => _handleSubmitted(_textController.text)
                                  : null,
                            )
                                : IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: _isComposing
                                  ? () => _handleSubmitted(_textController.text)
                                  : null,
                            )
                        )
                    ],
                ),
            ),
        );
    }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: Theme.of(context).textTheme.headline4),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/***
 * StatefulWidget & StatelessWidget
 *
 *  StatefulWidget is dynamic.
 *     it can change its appearance in response to events triggered by user interactions or when it receives data.
 *     ex:  Checkbox, Radio, Slider, InkWell, Form, TextField
 *
 *  StatelessWidget never change.
 *    ex: Icon, IconButton, Text
 */

/**
 * Mixin
 *
 *  Adding features to a class
 */

/**
 * ListView
 *
 * The ListView.builder factory method builds a list on demand by providing a function that is called once per item in the list.
 * The function returns a new widget at each call.
 * The builder also automatically detects mutations of its children parameter and initiates a rebuild.
 * The parameters passed to the ListView.builder constructor customize the list contents and appearance:
 *    1. padding creates whitespace around the message text.
 *    2. itemCount specifies the number of messages in the list.
 *    3. itemBuilder provides the function that builds each widget in [index].
 *       Because you don't need the current build context, you can ignore the first argument of IndexedWidgetBuilder.
 *       Naming the argument with an underscore (_) and nothing else is a convention indicating that the argument won't be used.
 */