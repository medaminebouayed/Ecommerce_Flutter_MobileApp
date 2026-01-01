import 'package:flutter/material.dart';
import 'package:testing/ProductCard.dart';
import 'package:provider/provider.dart';
import 'Login.dart';
class Cart extends StatelessWidget {

  @override
  Widget build (BuildContext context){
    var userId = Provider.of<UserIdProvider>(context).userId.toString();
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title:const Text("Cart" ,style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.w900)),
        leading: IconButton(
          icon:const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the login page
            Navigator.pushNamed(context,"/Home");
          },
        ),
      ),
      body: Container(
        child: CartPage(userId: userId),
      ),
    ) ;
  }
}