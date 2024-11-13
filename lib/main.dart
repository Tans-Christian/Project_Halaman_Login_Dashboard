import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Halaman Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == 'admin' && password == '1234') {
      _showSuccessDialog(context, username);
    } else {
      _showErrorDialog(context);
    }
  }

  void _showSuccessDialog(BuildContext context, String username) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Berhasil"),
          content: Text("Selamat datang, $username!"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Gagal"),
          content: Text("Username atau password salah. Silakan coba lagi."),
          actions: [
            TextButton(
              child: Text("Coba Lagi"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color _backgroundColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: _backgroundColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.account_circle), text: 'Profile'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
      ),
      drawer: _buildSideMenu(),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomePage(),
          ProfilePage(),
          SettingsPage(onColorChange: (color) {
            setState(() {
              _backgroundColor = color;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildSideMenu() {
    return Drawer(
      child: Container(
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: _backgroundColor, size: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Username',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'user@example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.blue),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _tabController.index = 0;
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.green),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.orange),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _tabController.index = 2;
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 1; // Menyesuaikan ke halaman Profile di awal

  final List<Widget> _pages = [
    HomePage(),
    ProfileDetails(),
    SettingsPage(onColorChange: (color) {})
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Welcome to My Profile",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileItem(icon: Icons.perm_identity, label: "NPM", value: "22552011029"),
                  ProfileItem(icon: Icons.person, label: "Nama", value: "Christian Octan Kurnia Pitoyo"),
                  ProfileItem(icon: Icons.cake, label: "Tanggal Lahir", value: "12-10-2002"),
                  ProfileItem(icon: Icons.school, label: "Program Studi", value: "Teknik Informatika"),
                  ProfileItem(icon: Icons.location_city, label: "Berkuliah di", value: "Universitas Teknologi Bandung"),
                  ProfileItem(icon: Icons.class_, label: "Kelas", value: "TIF 222 CNS"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  ProfileItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final ValueChanged<Color> onColorChange;

  SettingsPage({required this.onColorChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose Theme Color",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Divider(thickness: 2),
            SizedBox(height: 20),
            // Warna Merah
            ListTile(
              leading: Icon(Icons.circle, color: Colors.red),
              title: Text("Red Theme"),
              onTap: () => onColorChange(Colors.red),
            ),
            SizedBox(height: 10),
            // Warna Hijau
            ListTile(
              leading: Icon(Icons.circle, color: Colors.green),
              title: Text("Green Theme"),
              onTap: () => onColorChange(Colors.green),
            ),
            SizedBox(height: 10),
            // Warna Biru
            ListTile(
              leading: Icon(Icons.circle, color: Colors.blue),
              title: Text("Blue Theme"),
              onTap: () => onColorChange(Colors.blue),
            ),
            SizedBox(height: 20),
            Divider(thickness: 2),
            SizedBox(height: 10),
            // Tombol Logout (contoh tambahan)
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout"),
              onTap: () {
                // Aksi logout di sini
              },
            ),
          ],
        ),
      ),
    );
  }
}
