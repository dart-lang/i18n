// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_application/src/my_app_messages.g.dart';
import 'package:my_shopping_cart/my_shopping_cart.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<MyAppMessages>(
          future: initMyMessages(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LinearProgressIndicator();
            }
            final myAppMessages = snapshot.data!;
            return FutureBuilder<MyShoppingCart>(
                future: initShoppingCart(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final myShoppingCart = snapshot.data!;

                  return Scaffold(
                    floatingActionButton: FloatingActionButton(
                        onPressed: () => setState(() => counter++)),
                    body: Center(
                      child: Text(
                          'Currently: ${sale(myAppMessages)}. ${myShoppingCart.itemsInCart(counter)}!'),
                    ),
                  );
                });
          }),
    );
  }

  Future<MyShoppingCart> initShoppingCart() async {
    var myShoppingCart = MyShoppingCart();
    await myShoppingCart.loadLocales();
    return myShoppingCart;
  }

  Future<MyAppMessages> initMyMessages() async {
    var myAppMessages = MyAppMessages((id) =>
        rootBundle.loadString(id.substring('packages/my_application/'.length)));
    await myAppMessages.loadLocale('en_US');
    return myAppMessages;
  }

  String sale(MyAppMessages myAppMessages) {
    return myAppMessages.current_sale_name(
      DateTime.now().month < 4 || DateTime.now().month > 10
          ? 'winter'
          : 'summer',
    );
  }
}
