import 'package:PT.RPG/app/data/item_barang.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Barang extends StatefulWidget {
  const Barang({super.key});

  @override
  State<Barang> createState() => BarangState();
}

class BarangState extends State<Barang> {
  // Controller untuk item
  final idItemController = TextEditingController();
  final nameItemController = TextEditingController();
  final descriptionController = TextEditingController();
  final weightController = TextEditingController();
  final totalController = TextEditingController();
  final priceController = TextEditingController();

  // Variabel dropdown untuk pelanggan
  String selectedCustomerId = '0'; // ID pelanggan yang dipilih
  List<Map<String, dynamic>> customers = []; // Daftar pelanggan

  String selectedWeightUnit = 'kg'; // Variabel untuk satuan berat
  String selectedTotalUnit = 'Pcs'; // Variabel untuk satuan pcs

  @override
  void initState() {
    super.initState();
    fetchCustomers(); // Ambil data pelanggan saat pertama kali widget dibuat
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

  void generateidItemId() {
    String generatedCode = generateItemId(12);
    setState(() {
      idItemController.text = generatedCode;
      itemId = generatedCode; // Simpan di variabel itemId
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
          child: Column(children: <Widget>[
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
                    final pelanggann = snapshot.data?.docs.reversed.toList();
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
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: TextFormField(
                controller: idItemController,
                validator: (id) {
                  if (id == '') {
                    return 'Kode barang tidak boleh kosong';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: 'Kode Barang',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.unarchive_outlined),
                  border: OutlineInputBorder(),
                ),
                onTap: generateidItemId,
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
                controller: nameItemController,
                validator: (name) {
                  if (name == '') {
                    return 'Nama barang tidak boleh kosong';
                  } else if (name!.length > 30) {
                    return 'Nama barang maksimal 30 karakter';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: (String name) {
                  // Memanggil validasi ulang saat ada perubahan
                  formState.currentState!.validate();
                  // Memastikan isDataEntered diperbarui
                  setState(() {
                    isDataEntered = name.isNotEmpty;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: descriptionController,
                validator: (description) {
                  if (description == '') {
                    return 'Deskripsi tidak boleh kosong';
                  } else if (description!.length > 65) {
                    return 'Deskripsi maksimal 65 karakter';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: (String description) {
                  setState(() {
                    isDataEntered = description.isNotEmpty;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: weightController,
                      validator: (weightItem) {
                        if (weightItem == '') {
                          return 'Berat barang tidak boleh kosong';
                        } else if (weightItem!.length > 12) {
                          return 'Berat barang maksimal 12 karakter';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Berat',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.line_weight),
                        border: OutlineInputBorder(),
                        suffixIcon: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedWeightUnit,
                            items: <String>['kg', 'g']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedWeightUnit = newValue!;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (String weightItem) {
                        // Memanggil validasi ulang saat ada perubahan
                        formState.currentState!.validate();
                        // Memastikan isDataEntered diperbarui
                        setState(() {
                          isDataEntered = weightItem.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: totalController,
                      validator: (total) {
                        // Buat pola regex untuk mengizinkan angka, spasi, tanda kurung, tanda hubung, dan tanda hash
                        RegExp regex = RegExp(r'^[0-9\(\)\-\#\s]+$');

                        if (total == null || total.isEmpty) {
                          return 'Jumlah barang tidak boleh kosong';
                        } else if (!regex.hasMatch(total)) {
                          return 'Jumlah barang hanya boleh mengandung angka, (), -, atau #';
                        } else if (total.length > 12) {
                          return 'Jumlah barang maksimal 12 karakter';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Jumlah',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.production_quantity_limits),
                        border: OutlineInputBorder(),
                        suffixIcon: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedTotalUnit,
                            items: <String>['Pcs', 'Pack']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTotalUnit = newValue!;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (String total) {
                        // Memanggil validasi ulang saat ada perubahan
                        formState.currentState!.validate();
                        // Memastikan isDataEntered diperbarui
                        setState(() {
                          isDataEntered = total.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: priceController,
                validator: (price) {
                  // Buat pola regex untuk mengizinkan angka, spasi, tanda kurung, tanda hubung, dan tanda hash
                  // RegExp regex = RegExp(r'^[0-9\(\)\-\#\s]+$');

                  if (price == null || price.isEmpty) {
                    return 'Total harga tidak boleh kosong';
                    // } else if (!regex.hasMatch(price)) {
                    //   return 'Total harga hanya boleh mengandung angka, (), -, atau #';
                  } else if (price.length > 20) {
                    return 'Total harga maksimal 20 karakter';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: 'Harga',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.price_change),
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (String price) {
                  // Memanggil validasi ulang saat ada perubahan
                  formState.currentState!.validate();
                  // Memastikan isDataEntered diperbarui
                  setState(() {
                    isDataEntered = price.isNotEmpty;
                  });
                },
              ),
            ),
            const SizedBox(height: 11),
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
                  if (selectedCustomerId == '0') {
                    // Tampilkan notifikasi error jika pelanggan belum dipilih
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Kode pelanggan tidak boleh kosong!')),
                    );
                  } else if (formState.currentState!.validate()) {
                    checkAndCreateDataItem(
                        context); // Panggil fungsi untuk menyimpan data
                  }
                },
                child: const Icon(Icons.save),
              ),
            )
          ]),
        ),
      ),
    )));
  }

  Future<void> checkAndCreateDataItem(BuildContext context) async {
    final itemId = idItemController.text;
    final itemName = nameItemController.text;
    final itemDescription = descriptionController.text;
    final itemWeight = '${weightController.text} $selectedWeightUnit';
    final itemTotal = '${totalController.text} $selectedTotalUnit';
    final itemPrice = 'Rp. ${priceController.text}';

    try {
      DocumentSnapshot itemSnapshot = await FirebaseFirestore.instance
          .collection('itembarang')
          .doc(itemId)
          .get();

      if (itemSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kode Barang dengan ID $itemId sudah ada')),
        );
      } else {
        // Tambahkan data baru ke Firebase
        await FirebaseFirestore.instance
            .collection('itembarang')
            .doc(itemId)
            .set({
          'customerId': selectedCustomerId,
          'itemId': itemId,
          'itemName': itemName,
          'itemDescription': itemDescription,
          'itemWeight': itemWeight,
          'itemTotal': itemTotal,
          'itemPrice': itemPrice,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data barang berhasil disimpan!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi error: $e')),
      );
    }
  }
}
