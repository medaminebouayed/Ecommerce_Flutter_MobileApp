import 'package:flutter/material.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CartItem.dart';
import 'Login.dart';
import 'package:provider/provider.dart';
class ProductGrid extends StatefulWidget {
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late Future<List<Map<String, dynamic>>> productsFuture;
  bool shouldFetchData = true;

  @override
  void initState() {
    super.initState();
    productsFuture = fetchProducts();
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    // Fetch all data including productId from Firebase here
    final snapshot = await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return {'productId': doc.id, ...data};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: shouldFetchData ? productsFuture : null,
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final products = snapshot.data ?? [];
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              mainAxisExtent: 260,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                productId: product['productId'],
                productName: product['name'],
                productMark: product['mark'],
                productPrice: product['price'],
                productImage: product['image'],
              );
            },
          );
        }
      },
    );
  }
}


class ProductCard extends StatelessWidget {
  final String productId;
  final String productName;
  final String productMark;
  final String productPrice;
  final String productImage;

  ProductCard({required this.productId,required this.productName, required this.productMark, required this.productPrice, required this.productImage,});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Image.asset(
                productImage,
                width: double.infinity,
                height: 160.0,
                fit: BoxFit.fitHeight,
              ),
              Container(
                height: 50,width: 50,
                margin: EdgeInsets.only(right: 2,top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: IconButton(
                  icon: Icon(Icons.favorite_outline_outlined ,color: Colors.black),
                  onPressed: () {
                    // Handle favorite button press
                  },
                ),
              ) ,
            ],
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style:const TextStyle(fontWeight: FontWeight.bold , fontSize: 14),
                    ),
                    Container(
                      height: 26,
                      child: Row(
                        children: [
                          Text(productMark,style:const TextStyle(color: Colors.grey,fontSize: 14),) ,
                          IconButton(
                            iconSize: 14,
                            icon:const Icon(Icons.verified ,color: Colors.blueAccent),
                            onPressed: () {
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child : Text(
                        productPrice,
                        style:const TextStyle(fontWeight: FontWeight.bold ,fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 50,width: 50,
                margin: EdgeInsets.only(left: 140 ,top: 42),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                ),
                child: IconButton(
                  icon: Icon(Icons.add_circle_outline ,color: Colors.white),
                  onPressed: () {
                    // Get product details
                    String productId = this.productId; // Replace with actual product ID
                    String productName = this.productName;
                    String productMark = this.productMark;
                    String productPrice = this.productPrice;
                    String productImage = this.productImage;

                    // Get user ID from UserIdProvider
                    String? userId = context.read<UserIdProvider>().userId;

                      print('Product ID: $productId');
                      print('Product Name: $productName');
                      print('Product Mark: $productMark');
                      print('Product Price: $productPrice');
                      print('Product Image: $productImage');
                      print('User ID: $userId');

                    // Create a CartItem with the user ID and quantity
                    CartItem cartItem = CartItem(
                      userId: userId,
                      productId: productId,
                      productName: productName,
                      productMark: productMark,
                      productPrice: productPrice,
                      productImage: productImage,
                      quantity: 1, // Set the desired quantity
                    );

                    // Add the item to the cart using the provider
                    context.read<UserIdProvider>().addToCart(cartItem);
                  },
                ),
              ) ,
            ],
          )
        ],
      ),
    );
  }
}