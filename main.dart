import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Makets',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Выберите макет")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMenuItem(context, "1. 3D Design Basic", const Screen1_3D()),
          _buildMenuItem(context, "2. Secrets of Atlantis", const Screen2Atlantis()),
          _buildMenuItem(context, "3. Meditate", const Screen3Meditate()),
          _buildMenuItem(context, "4. Popular Menu", const Screen4Menu()),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, Widget screen) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
      ),
    );
  }
}

class Screen1_3D extends StatelessWidget {
  const Screen1_3D({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F3FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF3B5998)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text("3D Design Basic",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/3d_abstract.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(height: 200, color: Colors.blue[100]),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  _buildTag1(Icons.people, "4.569", const Color(0xFFF0F3FF), Colors.blue),
                  const SizedBox(width: 8),
                  _buildTag1(Icons.star, "4.9", const Color(0xFFF0F3FF), Colors.blue),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFF3B5998), borderRadius: BorderRadius.circular(20)),
                    child: const Text("Best Seller", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("3D Design Basic", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(
                "In this course you will learn how to build a space to a 3-dimensional product. There are 24 premium learning videos for you.",
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("24 Lessons (20 hours)", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  Text("See all", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(colors: [Colors.purple, Colors.blue]),
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Introduction to 3D", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text("20 mins", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.check_circle_outline, color: Colors.blue),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C6EF5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {},
                  child: const Text("Enroll - \$24.99", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag1(IconData icon, String text, Color bg, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: iconColor, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class Screen2Atlantis extends StatelessWidget {
  const Screen2Atlantis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 350,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6C8EEF),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                    child: Image.asset(
                      'assets/whale.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (c, o, s) => const Center(child: Icon(Icons.image, size: 50, color: Colors.white)),
                    ),
                  ),
                ),
                Positioned(
                  top: 50, left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(color: Color(0xFFF57C00), shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow, size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Text("Secrets of Atlantis", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFF57C00)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Follow", style: TextStyle(color: Color(0xFFF57C00))),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF2C2C54), borderRadius: BorderRadius.circular(25)),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/avatar1.png'),
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Text("Codin", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                SizedBox(width: 5),
                                Text("Host", style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              "The Secrets of Atlantis podcast is designed for all fantasy enthusiasts...",
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.notifications_none, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildDarkTag2("4.8", Icons.star),
                          const SizedBox(width: 10),
                          _buildDarkTag2("Fantasy", null),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.graphic_eq, color: Color(0xFFFF5252), size: 16),
                          SizedBox(width: 5),
                          Text("Live", style: TextStyle(color: Color(0xFFFF5252), fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFFFFD600), borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  SizedBox(
                    width: 80, height: 40,
                    child: Stack(
                      children: const [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage('assets/avatar2.png'),
                          backgroundColor: Colors.grey,
                        ),
                        Positioned(
                          left: 20,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage('assets/avatar3.png'),
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        Positioned(
                          left: 40,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage('assets/avatar4.png'),
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text("Invite your\nfriends to join", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const Icon(Icons.share, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkTag2(String text, IconData? icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, color: Colors.white, size: 14), const SizedBox(width: 5)],
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

class Screen3Meditate extends StatelessWidget {
  const Screen3Meditate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/meditate_bg.png',
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => Container(height: 220, color: const Color(0xFFF2C94C)),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      backgroundImage: const AssetImage('assets/avatar6.png'),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text("Peter Mach", style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 5),
              const Text("Mind Deep Relax", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(
                "Join the Community as we prepare over 33 days to relax and feel joy with the mind and happiness session across the World.",
                style: TextStyle(color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009688),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: const Text("Play Next Session", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
              _buildSessionItem3("Sweet Memories", "December 29 Pre-Launch", const Color(0xFF4C6EF5)),
              _buildSessionItem3("A Day Dream", "December 29 Pre-Launch", const Color(0xFF009688)),
              _buildSessionItem3("Mind Explore", "December 29 Pre-Launch", const Color(0xFFF57C00)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionItem3(String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.play_arrow, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.more_horiz, color: Colors.grey),
        ],
      ),
    );
  }
}

class Screen4Menu extends StatefulWidget {
  const Screen4Menu({super.key});
  @override
  State<Screen4Menu> createState() => _Screen4MenuState();
}

class _Screen4MenuState extends State<Screen4Menu> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFFFF0F3), borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFFFF5252)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text("Popular Menu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(15)),
                      child: const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search",
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFFFF0F3), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.filter_list, color: Color(0xFFFF5252)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildFoodItem4("Original Salad", "Lovy Food", "\$8", 'assets/food1.png'),
                    _buildFoodItem4("Fresh Salad", "Cloudy Resto", "\$10", 'assets/food2.png'),
                    _buildFoodItem4("Yummie Ice Cream", "Circlo Resto", "\$6", 'assets/food3.png'),
                    _buildFoodItem4("Vegan Special", "Haty Food", "\$11", 'assets/food4.png'),
                    _buildFoodItem4("Mixed Pasta", "Recto Food", "\$13", 'assets/food5.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFFF5252),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Fav"),
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: "Ticket"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem4(String name, String restaurant, String price, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              width: 60, height: 60, fit: BoxFit.cover,
              errorBuilder: (c, o, s) => Container(width: 60, height: 60, color: Colors.grey[200], child: const Icon(Icons.fastfood)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text(restaurant, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(color: Color(0xFFFF5252), fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}
