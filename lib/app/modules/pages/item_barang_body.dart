import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BarangBody extends StatefulWidget {
  const BarangBody({super.key, required List children});

  @override
  State<BarangBody> createState() => _BarangBodyState();
}

class _BarangBodyState extends State<BarangBody> {
  final customerIdController = TextEditingController();
  final idItemController = TextEditingController();
  final nameItemController = TextEditingController();
  final descriptionController = TextEditingController();
  final weightController = TextEditingController();
  final totalController = TextEditingController();
  final priceController = TextEditingController();

  String selectedWeightUnit = 'kg'; // Variabel untuk satuan berat
  String selectedTotalUnit = 'Pcs'; // Variabel untuk satuan pcs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 2,
          title: const Text('Daftar Barang',
              style: TextStyle(color: Colors.white)),
          centerTitle: false,
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
            Color.fromARGB(255, 112, 193, 186),
            Color(0xff2C306F)
          ], begin: Alignment.bottomRight, end: Alignment.topLeft))),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('itembarang').snapshots(),
          builder: (context, snapshotBarang) {
            // Jika tidak ada data barang
            if (snapshotBarang.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshotBarang.hasData ||
                snapshotBarang.data!.docs.isEmpty) {
              return const Center(
                  child: Text('Tidak ada data barang yang tersedia.'));
            }

            return ListView.builder(
              itemCount: snapshotBarang.data!.docs.length,
              itemBuilder: (context, index) {
                var documentSnapshotBarang = snapshotBarang.data!.docs[index];

                // Ambil ID pelanggan dari barang
                String customerId = documentSnapshotBarang['customerId'] ?? '';

                // if (customerId.isEmpty) {
                //   // Jika customerId kosong, tampilkan pesan atau lakukan hal lain
                //   return const Center(child: CircularProgressIndicator());
                // }

                // Ambil data pelanggan berdasarkan customerId
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pelanggan')
                      .doc(customerId)
                      .snapshots(),
                  builder: (context, snapshotPelanggan) {
                    // Jika sedang menunggu data
                    if (snapshotPelanggan.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Jika dokumen pelanggan tidak ditemukan
                    if (!snapshotPelanggan.hasData ||
                        !snapshotPelanggan.data!.exists) {
                      return const Center(
                          child: Text('Data pelanggan tidak ditemukan.'));
                    }

                    var documentSnapshotPelanggan = snapshotPelanggan.data!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildRow(
                                  icon: Icons.badge,
                                  label: 'Kode Pelanggan: ',
                                  value:
                                      documentSnapshotPelanggan['customerId'] ??
                                          ''.toString()),
                              buildDivider(),
                              buildRow(
                                  icon: Icons.person,
                                  label: 'Nama Pelanggan: ',
                                  value: documentSnapshotPelanggan[
                                          'customerName'] ??
                                      ''.toString()),
                              buildDivider(),
                              buildRow(
                                  icon: Icons.place,
                                  label: 'Alamat: ',
                                  value: documentSnapshotPelanggan[
                                          'customerAddress'] ??
                                      ''.toString()),
                              buildDivider(),
                              buildRow(
                                  icon: Icons.location_city,
                                  label: 'Kota: ',
                                  value: documentSnapshotPelanggan[
                                          'customerCity'] ??
                                      ''.toString()),
                              buildDivider(),
                              buildRow(
                                  icon: Icons.email,
                                  label: 'Email: ',
                                  value: documentSnapshotPelanggan[
                                          'customerEmail'] ??
                                      ''.toString()),
                              buildDivider(),
                              buildRow(
                                  icon: Icons.phone_in_talk,
                                  label: 'No. Telp: ',
                                  value: documentSnapshotPelanggan[
                                              'customerNumberHP']
                                          ?.toString() ??
                                      ''),
                              buildDivider(),
                              buildRow(
                                icon: Icons.unarchive_outlined,
                                label: 'Kode Barang: ',
                                value:
                                    documentSnapshotBarang['itemId'].toString(),
                              ),
                              buildDivider(),
                              buildRow(
                                icon: Icons.category,
                                label: 'Nama Barang: ',
                                value: documentSnapshotBarang['itemName']
                                    .toString(),
                              ),
                              buildDivider(),
                              buildRow(
                                icon: Icons.description,
                                label: 'Deskripsi: ',
                                value: documentSnapshotBarang['itemDescription']
                                    .toString(),
                                maxLines: 2,
                              ),
                              buildDivider(),
                              buildRow(
                                icon: Icons.line_weight,
                                label: 'Berat: ',
                                value: documentSnapshotBarang['itemWeight']
                                    .toString(),
                              ),
                              buildDivider(),
                              buildRow(
                                icon: Icons.production_quantity_limits,
                                label: 'Jumlah: ',
                                value: documentSnapshotBarang['itemTotal']
                                    .toString(),
                              ),
                              buildDivider(),
                              buildRow(
                                icon: Icons.price_change,
                                label: 'Harga: ',
                                value: documentSnapshotBarang['itemPrice']
                                    .toString(),
                              ),
                              buildDivider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      checkAndUpdateDataItem(
                                          documentSnapshotBarang);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: const StadiumBorder()),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.orangeAccent,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                              color: Colors.orangeAccent),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      checkAndDeleteDataItem(
                                          documentSnapshotBarang);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: const StadiumBorder()),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ));
  }

  // Fungsi untuk menampilkan form edit data
  void checkAndUpdateDataItem(DocumentSnapshot documentSnapshotBarang) {
    // Simpan nilai awal saat membuka form edit
    String initialName = documentSnapshotBarang['itemName'];
    String initialDescription = documentSnapshotBarang['itemDescription'];
    String initialWeight = documentSnapshotBarang['itemWeight'];
    String initialTotal = documentSnapshotBarang['itemTotal'];
    String initialPrice = documentSnapshotBarang['itemPrice'];

    // Set nilai awal pada controller dan dropdown
    nameItemController.text = initialName;
    descriptionController.text = initialDescription;
    priceController.text = initialPrice.toString();

    // Pisahkan nilai dan satuan
    final weightData = initialWeight.split(' ');
    final totalData = initialTotal.split(' ');

    weightController.text = weightData[0];
    selectedWeightUnit = weightData.length > 1 ? weightData[1] : 'kg';

    totalController.text = totalData[0];
    selectedTotalUnit = totalData.length > 1 ? totalData[1] : 'Pcs';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Data Barang'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameItemController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              TextFormField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Berat',
                  suffixIcon: StatefulBuilder(
                    builder: (context, setState) {
                      return DropdownButtonHideUnderline(
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
                        ),
                      );
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: totalController,
                decoration: InputDecoration(
                  labelText: 'Jumlah',
                  suffixIcon: StatefulBuilder(
                    builder: (context, setState) {
                      return DropdownButton<String>(
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
                      );
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey, // Change text color to grey
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Ambil nilai yang diubah
              final updatedName = nameItemController.text;
              final updatedDescription = descriptionController.text;
              final updatedWeight =
                  '${weightController.text} $selectedWeightUnit';
              final updatedTotal = '${totalController.text} $selectedTotalUnit';
              final updatedPrice = (priceController.text.isNotEmpty)
                  ? int.tryParse(priceController.text) ?? initialPrice
                  : initialPrice;

              // Cek perubahan
              if (updatedName != initialName ||
                  updatedDescription != initialDescription ||
                  updatedWeight != initialWeight ||
                  updatedTotal != initialTotal ||
                  updatedPrice != initialPrice) {
                // Jika ada perubahan, simpan data
                FirebaseFirestore.instance
                    .collection('itembarang')
                    .doc(documentSnapshotBarang.id)
                    .update({
                  'itemName': updatedName,
                  'itemDescription': updatedDescription,
                  'itemWeight': updatedWeight,
                  'itemTotal': updatedTotal,
                  'itemPrice': updatedPrice,
                }).then((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Barang dengan kode ${documentSnapshotBarang.id} berhasil diupdate!')),
                  );
                });
              } else {
                // Jika tidak ada perubahan, tampilkan notifikasi
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Tidak ada perubahan pada data.')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void checkAndDeleteDataItem(DocumentSnapshot documentSnapshotBarang) {
    // Implement delete item logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            'Apakah Anda yakin ingin menghapus data barang ini?',
            style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red)),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('itembarang')
                  .doc(documentSnapshotBarang.id)
                  .delete()
                  .then((_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Barang dengan kode ${documentSnapshotBarang.id} berhasil dihapus!')),
                );
              });
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

// Fungsi untuk membuat row dengan ikon dan teks
  Widget buildRow({
    required IconData icon,
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueGrey, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Fungsi untuk membuat divider dengan padding
  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(thickness: 1, color: Colors.grey),
    );
  }
}
