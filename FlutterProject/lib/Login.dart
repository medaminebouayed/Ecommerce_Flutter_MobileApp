import 'package:flutter/material.dart' ;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CartItem.dart';
class UserIdProvider extends ChangeNotifier {
  String? _userId;
  String? _userName;

  String? get userId => _userId;
  String? get userName => _userName;

  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  setUserId(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  setUserName(String? userName) {
    _userName = userName;
    notifyListeners();
  }

  Future<void> addToCart(CartItem cartItem) async {
    // Add the cart item to the local list
    _cartItems.add(cartItem);
    notifyListeners();

    try {
      // Add the cart item to Firestore
      await FirebaseFirestore.instance.collection('cart').add(cartItem.toMap());
    } catch (e) {
      // Handle Firestore write error
      print('Error adding to Firestore: $e');
    }
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool rememberMe = false;

  Future<String?> fetchUserNameFromFirebase(String? userId) async {
    try {
      // Replace 'users' with your actual Firestore collection name
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        // Assuming you have a 'firstName' field in your user document
        return userSnapshot.data()?['firstName'];
      } else {
        return null;
      }
    } catch (error) {
      print('Error fetching user name: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false ,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logos/t-store-splash-logo-black.png', // Replace with the path to your logo image
              width: 100.0,
              height: 100.0,
            ),
            const SizedBox(height: 20.0),

            // Welcome Text
            Text(
              'Welcome Back,',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),

            // Description Text
            Text(
              'Discover Limitless Choises and Unmatched Converience',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 20.0),

            // Email Input
            TextField(
              controller: _emailController,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Email',
                hintStyle:const TextStyle(color: Colors.black,fontSize: 15),
                prefixIcon:const Padding(
                  padding: EdgeInsets.only(top: 3.0,left: 6.0), // Padding for the icon
                  child: Icon(Icons.mail_outline_outlined, size: 24.0,color: Colors.grey,), // Search icon
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // Rounded border
                  borderSide: const BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // Rounded border
                  borderSide: const BorderSide(color: Colors.black), // White border for enabled state
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // Rounded border
                  borderSide:const BorderSide(color: Colors.black), // White border for focused state
                ),
                contentPadding:const EdgeInsets.symmetric(vertical: 8.0), // Padding inside the text field
              ),
            ),
            const SizedBox(height: 10.0),

            // Password Input
            TextField(
              controller: _passwordController,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Password',
                hintStyle:const TextStyle(color: Colors.black,fontSize: 15),
                prefixIcon:const Padding(
                  padding: EdgeInsets.only(top: 3.0,left: 6.0), // Padding for the icon
                  child: Icon(Icons.key_outlined, size: 24.0,color: Colors.grey,), // Search icon
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // Rounded border
                  borderSide: const BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // Rounded border
                  borderSide: const BorderSide(color: Colors.black), // White border for enabled state
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // Rounded border
                  borderSide:const BorderSide(color: Colors.black), // White border for focused state
                ),
                contentPadding:const EdgeInsets.symmetric(vertical: 8.0), // Padding inside the text field
              ),
            ),
            const SizedBox(height: 10.0),

            // Remember Me and Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.indigoAccent,
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    Text('Remember me?'),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Handle forgot password action
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent, // Change the background color to your desired color
                  ),
                  onPressed: () async {
                    try {
                      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );

                      String? userId = userCredential.user?.uid;
                      String? userName = await fetchUserNameFromFirebase(userId);
                      // Set userId using the provider
                      context.read<UserIdProvider>().setUserId(userId);
                      context.read<UserIdProvider>().setUserName(userName);
                      // Navigate to the next page
                      Navigator.pushNamed(context, '/Home');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                      // Handle other errors as needed
                    }
                  },
                  child: Container(
                    width: double.infinity, // Set width to take up the full available space
                    child: Center(
                      child: Text('Sign In',style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0), // Adjust spacing between buttons
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                    backgroundColor: Colors.white
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/Logout');
                  },
                  child: Container(
                    width: double.infinity, // Set width to take up the full available space
                    child: Center(
                      child: Text('Sign Up',style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text('You can sign in with:'),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Set border color
                      width: 2.0, // Set border width
                    ),
                    borderRadius: BorderRadius.circular(25.0), // Set border radius
                  ),
                  padding: EdgeInsets.all(6.0),
                  child: Image.asset(
                    'assets/logos/facebook-icon.png',
                    width: 25.0,
                    height: 25.0,
                  ),
                ),
                const SizedBox(width: 20.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Set border color
                      width: 2.0, // Set border width
                    ),
                    borderRadius: BorderRadius.circular(25.0), // Set border radius
                  ),
                  padding: EdgeInsets.all(6.0),
                  child: Image.asset(
                    'assets/logos/google-icon.png',
                    width: 25.0,
                    height: 25.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}