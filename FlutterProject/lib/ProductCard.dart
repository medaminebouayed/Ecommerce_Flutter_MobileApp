import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id ;
  final String name;
  final String mark;
  final String price;
  final String image;
  String quantity;
  String cartItemId ; 

  Product({
    required this.id ,
    required this.name,
    required this.mark,
    required this.price,
    required this.image,
    required this.quantity,
    required this.cartItemId
  });
}

class CartPage extends StatefulWidget {
  final String userId;

  CartPage({required this.userId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // List of products
   late List<Product> products = [];
  late String totalAmount = '0';

  @override
  void initState() {
    super.initState();
    // Fetch user-specific product data from Firebase
    fetchProducts();
  }

Future<void> fetchProducts() async {
  try {
    // Replace 'your_collection' with the actual name of your collection in Firestore
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: widget.userId)
        .get();

    setState(() {
      products = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: data['productId'],
          name: data['productName'],
          mark: data['productMark'],
          price: data['productPrice'],
          image: data['productImage'],
          quantity: data['quantity'].toString(),
          cartItemId: doc.id
        );
      }).toList();

      totalAmount = calculateTotalAmount();
    });
  } catch (error) {
    // Handle error
    print('Error fetching products: $error');
  }
}

Future<void> checkout() async {
    try {
      // Update product quantities and remove items from the cart
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (Product product in products) {
        DocumentReference productRef = FirebaseFirestore.instance.collection('products').doc(product.id);
        batch.update(productRef, {'quantity': FieldValue.increment(-int.parse(product.quantity))});

        DocumentReference cartItemRef = FirebaseFirestore.instance.collection('cart').doc(product.cartItemId);
        batch.delete(cartItemRef);
      }

      await batch.commit();

      // Navigate to the next screen or perform other actions after successful checkout
      Navigator.pushNamed(context, '/Home');
    } catch (error) {
      // Handle error
      print('Error during checkout: $error');
    }
  }

  String calculateTotalAmount() {
    double totalAmount = 0.0;
    for (Product product in products) {
      String price = product.price.replaceFirst("\$", "");
      totalAmount += double.parse(price) * int.parse(product.quantity);
    }
    return '\$$totalAmount';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of products
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final productName = product.name;
                  final productImage = product.image;
                  final productMark = product.mark;
                  String productQuantity = product.quantity;
                  String productPrice = product.price.replaceFirst("\$","") ;
                  return Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFD3D3D3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset("$productImage", width: 60, height: 60)),
                            Container(
                              margin: EdgeInsets.only(bottom: 12.0, left: 8.0), // Adjust left margin as needed
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        productMark,
                                        style: TextStyle(color: Colors.grey, fontSize: 14),
                                      ),
                                      const SizedBox(width: 5),
                                      Padding(
                                        padding: EdgeInsets.only(right: 6),
                                        child: Icon(Icons.verified, color: Colors.blueAccent, size: 14),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    productName,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              // Quantity Container
                              margin: EdgeInsets.only(left: 60,top: 15),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD3D3D3),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          // Decrement the quantity, ensuring it doesn't go below 0
                                          int currentQuantity = int.parse(products[index].quantity);
                                          if (currentQuantity > 0) {
                                            products[index].quantity = (currentQuantity - 1).toString();
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.minimize_outlined),
                                      padding: EdgeInsets.only(bottom: 15, top: 0),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    child: TextField(
                                      cursorColor: Colors.grey,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: '$productQuantity',
                                        hintStyle: const TextStyle(color: Colors.black, fontSize: 15),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          borderSide: const BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          borderSide: const BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          borderSide: const BorderSide(color: Colors.black),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.5),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.indigoAccent,
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          // Increment the quantity
                                          products[index].quantity =
                                              (int.parse(products[index].quantity) + 1).toString();
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                      padding: EdgeInsets.only(top: 0),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer() ,
                            Container(
                              // Price Container
                              margin : EdgeInsets.only(top : 15) ,
                              child : Text(
                                "\$" +(double.parse( (productPrice).replaceFirst("\$", "")) * int.parse(product.quantity)).toString(),
                                style:const TextStyle(fontWeight: FontWeight.bold ,fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 60,
              margin:EdgeInsets.only(top: 40) ,
              child : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,// Change the background color to your desired color
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                  ),
                ),
                onPressed: () {
                  checkout();
                  Navigator.pushNamed(context, '/Home');
                },
                child: Container(
                  width: double.infinity, // Set width to take up the full available space
                  child: Container(
                    width: double.infinity, // Set width to take up the full available space
                    child: Center(
                      child: Text('Checkout: ${calculateTotalAmount()}', style: TextStyle(color: Colors.white,fontSize: 16)),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
