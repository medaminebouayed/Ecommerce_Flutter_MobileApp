
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:testing/Login.dart';
import 'package:testing/Products.dart';
import 'package:testing/Logout.dart';
import 'package:testing/Cart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  runApp(
     ChangeNotifierProvider(
      create: (context) => UserIdProvider(),
      child:const MyApp(),
    ),
  ) ;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce App',
      theme : ThemeData (
      useMaterial3:true ,
      fontFamily: 'Poppins' ,
    ),
      initialRoute: "/Login" ,
      routes: {
        "/Login" :(context) => LoginPage() ,
        "/Home" :(context) => MyHomePage(title: 'Home Page',imgList: [{'image':'assets/bowling-ball.png','title':'Sports'},{'image':'assets/lamp.png','title':'Fournitures'},{'image':'assets/mobile-phone.png','title':'SmartPhones'},{'image':'assets/dress.png','title':'Clothing'},{'image':'assets/paw.png','title':'Animals'}],bannersList: ['assets/images/products/promo-banner-1.png','assets/images/products/promo-banner-2.png','assets/images/products/promo-banner-3.png'] ,secondBannersList: ['assets/images/banners/banner_2.jpg','assets/images/banners/banner_6.jpg','assets/images/banners/banner_8.jpg']) ,
        "/Logout" :(context) => LogoutPage() ,
        "/Cart" :(context) => Cart() ,
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  final String title ;
  final List<Map<String, String>> imgList ;
  final List<String> bannersList ;
  final List<String> secondBannersList ;
  const MyHomePage({super.key , required this.title,required this.imgList,required this.bannersList,required this.secondBannersList}) ;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {

    final userName = Provider.of<UserIdProvider>(context).userName ?? 'Guest';
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 73, 186, 238),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true ,
            leading: IconButton(
              icon: Icon(Icons.add ,color: Colors.transparent),
              onPressed: () {
                // Handle home button press
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bluetheme.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14.0, top: 6.0, left: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'good day for shopping !',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
                                ),
                                Text(
                                  userName,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                              ],
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                IconButton(
                                  padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
                                  icon: const Icon(Icons.shopping_cart),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.pushNamed(context,'/Cart') ;
                                  },
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '0',
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 0.0, top: 16.0),
                          child: TextField(
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Search in Store',
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(top: 3.0, left: 6.0),
                                child: Icon(Icons.search, size: 24.0, color: Colors.grey),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Popular Categories",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 14.0),
                              CarouselSlider(
                                options: CarouselOptions(
                                  aspectRatio: 4,
                                  enlargeCenterPage: false,
                                  autoPlay: true,
                                  viewportFraction: 0.2,
                                ),
                                items: widget.imgList.map((item) => Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          child: ClipRRect(
                                            child: Image.asset(
                                              item['image']!,
                                              fit: BoxFit.cover,
                                              width: 60,
                                              height: 60,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          item['title']!,
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                )).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 16 / 8,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        items: widget.bannersList.map((item) => Container(
                          margin: const EdgeInsets.all(5.0),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      item,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.bannersList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == entry.key ? Colors.blue : Colors.grey,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(right: 14.0, top: 30.0, left: 14.0, bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Popular Products", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            Text("View All", style: TextStyle(fontSize: 10, color: Colors.blue)),
                          ],
                        )),
                    ProductGrid(),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 16 / 8,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        items: widget.secondBannersList.map((item) => Container(
                          margin: const EdgeInsets.all(5.0),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      item,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.secondBannersList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == entry.key ? Colors.blue : Colors.grey,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar:BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined, color: Colors.grey),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_checkout_outlined, color: Colors.grey),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/Home');
              break;
            case 1:
              Navigator.pushNamed(context, '/Store');
              break;
            case 2:
              Navigator.pushNamed(context, '/Cart');
              break;
            case 3:
              Navigator.pushNamed(context, '/Profile');
              break;
          }
        },
      ),
    );
  }
}