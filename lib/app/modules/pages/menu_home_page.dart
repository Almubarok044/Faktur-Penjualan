import 'package:PT.RPG/app/modules/pages/customer_body.dart';
import 'package:PT.RPG/app/modules/pages/item_barang_body.dart';
import 'package:PT.RPG/app/modules/pages/log_in_page.dart';
import 'package:PT.RPG/app/modules/pages/print_faktur.dart';
import 'package:PT.RPG/app/modules/pages/print_faktur_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'customer.dart';
import 'item_barang.dart';

class MenuHome extends StatefulWidget {
  const MenuHome({super.key});

  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String appBarTitle = 'Pelanggan'; // Judul awal

  final List<Widget> myTabs = <Widget>[
    const Tab(icon: Icon(Icons.people_alt_outlined)), // Ikon untuk Pelanggan
    const Tab(icon: Icon(Icons.category_outlined)), // Ikon untuk Barang
    const Tab(icon: Icon(Icons.receipt_long)), // Ikon untuk Faktur
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);

    // Menambahkan listener untuk mendeteksi perubahan tab
    _tabController.addListener(() {
      setState(() {
        // Mengubah judul sesuai dengan tab yang dipilih
        switch (_tabController.index) {
          case 0:
            appBarTitle = 'Pelanggan';
            break;
          case 1:
            appBarTitle = 'Barang';
            break;
          case 2:
            appBarTitle = 'Faktur';
            break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 112, 193, 186),
            Color(0xff2C306F)
          ], begin: Alignment.bottomRight, end: Alignment.topLeft)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DrawerHeader(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Image.asset(
                          'assets/icon/logo_pt_rpg.png',
                          height: 75,
                          width: 75,
                        ),
                        const Text(
                          'PT. RICKY PUTRA GLOBALINDO',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 1, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  selectedColor: Colors.white,
                  tileColor: Colors.white,
                  title: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  leading: const Icon(Icons.exit_to_app, color: Colors.white),
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.signOut();

                      // Navigasi kembali ke halaman login
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogInPage(),
                        ),
                        (route) => false,
                      );
                      // Menampilkan dialog logout
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          content: Text('Logout success'),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                      // Menampilkan error jika ada
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(e.message.toString()),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 2,
        title: Text(
          appBarTitle, // Menggunakan judul dinamis
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 112, 193, 186), Color(0xff2C306F)],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        actions: [
          if (_tabController.index == 0) // Icon khusus halaman Pelanggan
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CustomerBody(children: []),
                ));
              },
              icon: const Icon(Icons.article_outlined,
                  size: 30, color: Colors.white),
            )
          else if (_tabController.index == 1) // Icon khusus halaman Barang
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const BarangBody(children: []),
                ));
              },
              icon:
                  const Icon(Icons.inventory_2, size: 30, color: Colors.white),
            )
          else if (_tabController.index == 2) // Icon khusus halaman Faktur
            IconButton(
              onPressed: () {
                // Tambahkan aksi untuk halaman Faktur, misalnya: cetak faktur
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FakturBody(
                    children: [],
                  ),
                ));
              },
              icon: const Icon(Icons.print, size: 30, color: Colors.white),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Customer(),
          Barang(),
          Faktur(),
        ],
      ),
    );
  }
}
