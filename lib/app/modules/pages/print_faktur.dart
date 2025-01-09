import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/print_faktur.dart';

class Faktur extends StatefulWidget {
  const Faktur({super.key});

  @override
  State<Faktur> createState() => FakturState();
}

class FakturState extends State<Faktur> {
  final idFakturController = TextEditingController();
  final dateController = TextEditingController();
  final paymentController = TextEditingController();
  final customerIdController = TextEditingController();
  final idItemController = TextEditingController();

  DateTime dateSelected = DateTime.now();
  final dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  Future<void> selectedDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateSelected,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != dateSelected) {
      setState(() {
        dateSelected = DateTime(
          picked.year,
          picked.month,
          picked.day,
          dateSelected.hour,
          dateSelected.minute,
          dateSelected.second,
        );
        dateController.text = dateFormat.format(dateSelected);
      });
    }
  }

  // Variabel dropdown untuk pelanggan
  String selectedCustomerId = '0'; // ID pelanggan yang dipilih
  List<Map<String, dynamic>> customers = []; // Daftar pelanggan

  // Variabel dropdown untuk barang
  String selectedItemId = '0'; // ID barang yang dipilih
  String selectedWeightUnit = 'kg'; // Variabel untuk satuan berat
  String selectedTotalUnit = 'Pcs'; // Variabel untuk satuan pcs
  List<Map<String, dynamic>> items = []; // Daftar barang

  // Variabel Data Faktur
  String selectedPaymentType =
      'Pilih Jenis Pembayaran'; // Variabel untuk satuan pembayaran

  @override
  void initState() {
    super.initState();
    fetchCustomers(); // Ambil data pelanggan saat pertama kali widget dibuat
    fetchItems(); // Ambil data barang saat pertama kali widget dibuat
  }

  // Fungsi untuk mengambil data pelanggan dari Firebase
  Future<void> fetchCustomers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('pelanggan').get();
      final List<Map<String, dynamic>> customerList =
          snapshot.docs.map((pelanggan) {
        return {
          'customerId': pelanggan.id, // ID pelanggan yang acak
          'customerName': (pelanggan['customerName'] ?? 'Unknown')
              .toString(), // Cast name ke String
        };
      }).toList();

      setState(() {
        customers =
            customerList; // Simpan daftar pelanggan di variabel customers
      });
    } catch (e) {
      // Tampilkan error jika gagal mengambil data pelanggan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data pelanggan: $e')),
      );
    }
  }

  // Fungsi untuk mengambil data barang dari Firebase
  Future<void> fetchItems() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('itembarang').get();
      final List<Map<String, dynamic>> itemList =
          snapshot.docs.map((itembarang) {
        return {
          'itemId': itembarang.id, // ID barang yang acak
          'itemName': (itembarang['itemName'] ?? 'Unknown')
              .toString(), // Cast name ke String
        };
      }).toList();

      setState(() {
        items = itemList; // Simpan daftar barang di variabel items
      });
    } catch (e) {
      // Tampilkan error jika gagal mengambil data barang
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data barang: $e')),
      );
    }
  }

  void generateidFakturId() {
    String generatedCode = generateFakturId(12);
    setState(() {
      idFakturController.text = generatedCode;
      idFaktur = generatedCode; // Simpan di variabel itemId
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formState,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: TextFormField(
                      controller: idFakturController,
                      validator: (id) {
                        if (id == '') {
                          return 'No. Faktur tidak boleh kosong';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: 'No. Faktur',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.mark_as_unread_outlined),
                          border: OutlineInputBorder()),
                      onTap: generateidFakturId,
                      onChanged: (String id) {
                        setState(() {
                          isDataEntered = id.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: dateController,
                      validator: (picked) {
                        if (picked == '') {
                          return 'Tanggal tidak boleh kosong';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: 'Tanggal',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.date_range_sharp),
                          border: OutlineInputBorder()),
                      readOnly: true,
                      onTap: () {
                        selectedDate();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Jenis Pembayaran',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.wallet),
                        border: OutlineInputBorder(),
                      ),
                      value: selectedPaymentType,
                      items: [
                        DropdownMenuItem(
                          value: 'Pilih Jenis Pembayaran',
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 3),
                                Text('Pilih Jenis Pembayaran'),
                                SizedBox(height: 3),
                                Divider(
                                  thickness: 1,
                                  color: Colors.cyan,
                                ),
                              ],
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Cash',
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cash'),
                                SizedBox(height: 3),
                                Divider(
                                  thickness: 1,
                                  color: Colors.cyan,
                                ),
                              ],
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Credit',
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Credit'),
                                SizedBox(height: 3),
                                Divider(
                                  thickness: 1,
                                  color: Colors.cyan,
                                ),
                              ],
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Debit',
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Debit'),
                                SizedBox(height: 3),
                                Divider(
                                  thickness: 1,
                                  color: Colors.cyan,
                                ),
                              ],
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'E-Money',
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('E-Money'),
                                SizedBox(height: 3),
                                Divider(
                                  thickness: 1,
                                  color: Colors.cyan,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      onChanged: (nilaiPelanggan) {
                        setState(() {
                          selectedPaymentType = nilaiPelanggan!;
                        });
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value == 'Pilih Jenis Pembayaran') {
                          return 'Jenis Pembayaran tidak boleh kosong!';
                        }
                        return null;
                      },
                      isExpanded:
                          true, // Membuat dropdown mengisi seluruh field
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('pelanggan')
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<DropdownMenuItem> idPelanggan = [];
                        if (!snapshot.hasData) {
                          // return Center(child: CircularProgressIndicator());
                        } else {
                          final pelanggann =
                              snapshot.data?.docs.reversed.toList();
                          idPelanggan.add(
                            DropdownMenuItem(
                              value: '0',
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 3),
                                    Text('Pilih Kode Pelanggan'),
                                    SizedBox(height: 3),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.cyan,
                                    ), // Menambahkan garis pemisah
                                  ],
                                ),
                              ),
                            ),
                          );
                          for (var pelanggan in pelanggann!) {
                            idPelanggan.add(DropdownMenuItem(
                              value: pelanggan.id,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(pelanggan['customerId']),
                                    SizedBox(height: 3),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.cyan,
                                    ), // Menambahkan garis pemisah
                                  ],
                                ),
                              ),
                            ));
                          }
                        }
                        return DropdownButtonFormField(
                          items: idPelanggan,
                          onChanged: (nilaiPelanggan) {
                            // // Memanggil validasi ulang saat ada perubahan
                            // formState.currentState!.validate();
                            // Memastikan isDataEntered diperbarui
                            setState(() {
                              selectedCustomerId = nilaiPelanggan;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Kode Pelanggan',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == '') {
                              return 'Kode pelanggan tidak boleh kosong!';
                            }
                            return null;
                          },
                          value: selectedCustomerId,
                          isExpanded: false,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('itembarang')
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<DropdownMenuItem> idItem = [];
                        if (!snapshot.hasData) {
                          // return Center(child: CircularProgressIndicator());
                        } else {
                          final itemm = snapshot.data?.docs.reversed.toList();
                          idItem.add(
                            DropdownMenuItem(
                              value: '0',
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 3),
                                    Text('Pilih Kode Barang'),
                                    SizedBox(height: 3),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.cyan,
                                    ), // Menambahkan garis pemisah
                                  ],
                                ),
                              ),
                            ),
                          );
                          for (var itembarang in itemm!) {
                            idItem.add(DropdownMenuItem(
                              value: itembarang.id,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(itembarang['itemId']),
                                    SizedBox(height: 3),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.cyan,
                                    ), // Menambahkan garis pemisah
                                  ],
                                ),
                              ),
                            ));
                          }
                        }
                        return DropdownButtonFormField(
                          items: idItem,
                          onChanged: (nilaibarang) {
                            // // Memanggil validasi ulang saat ada perubahan
                            // formState.currentState!.validate();
                            // Memastikan isDataEntered diperbarui
                            setState(() {
                              selectedItemId = nilaibarang!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Kode Barang',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == '') {
                              return 'Kode barang tidak boleh kosong!';
                            }
                            return null;
                          },
                          value: selectedItemId.isEmpty ? null : selectedItemId,
                          isExpanded: false,
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 112, 193, 186),
                          Color(0xff2C306F) // Warna ketiga
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle, // Membuatnya bulat
                    ),
                    child: FloatingActionButton(
                      backgroundColor:
                          Colors.transparent, // Buat latar belakang transparan
                      onPressed: () {
                        if (selectedPaymentType == 'Pilih Jenis Pembayaran') {
                          // Tampilkan notifikasi error jika Jenis Pembayaran belum dipilih
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Jenis Pembayaran tidak boleh kosong!')),
                          );
                        } else if (selectedCustomerId == '0') {
                          // Tampilkan notifikasi error jika ID pelanggan belum dipilih
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Kode pelanggan tidak boleh kosong!')),
                          );
                        } else if (selectedItemId == '0') {
                          // Tampilkan notifikasi error jika ID barang belum dipilih
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Kode Barang tidak boleh kosong!')),
                          );
                        } else if (formState.currentState!.validate()) {
                          checkAndCreateDataFaktur(
                              context); // Panggil fungsi untuk menyimpan data
                        }
                      },
                      child: const Icon(Icons.save),
                    ),
                  ),
                  const SizedBox(width: 7),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkAndCreateDataFaktur(BuildContext context) async {
    final fakturId = idFakturController.text;

    try {
      DocumentSnapshot itemSnapshot = await FirebaseFirestore.instance
          .collection('faktur')
          .doc(fakturId)
          .get();

      if (itemSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No. Faktur dengan ID $fakturId sudah ada.')),
        );
      } else {
        // Tambahkan data baru ke Firebase
        await FirebaseFirestore.instance
            .collection('faktur')
            .doc(fakturId)
            .set({
          'customerId': selectedCustomerId,
          'itemId': selectedItemId,
          'fakturId': fakturId,
          // 'date': dateSelected,
          'date': Timestamp.fromDate(
              dateSelected), // Menyimpan date sebagai Timestamp
          'typeofPayment': selectedPaymentType
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Faktur berhasil disimpan!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi error: $e')),
      );
    }
  }
}
