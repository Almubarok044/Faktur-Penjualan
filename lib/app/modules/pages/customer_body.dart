import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerBody extends StatefulWidget {
  const CustomerBody({super.key, required List<Padding> children});

  @override
  State<CustomerBody> createState() => _CustomerBodyState();
}

class _CustomerBodyState extends State<CustomerBody> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 2,
        title: const Text('Daftar Pelanggan',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromARGB(255, 112, 193, 186), Color(0xff2C306F)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('pelanggan').snapshots(),
        builder: (context, snapshotPelanggan) {
          // Jika tidak ada data barang
          if (snapshotPelanggan.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshotPelanggan.hasData ||
              snapshotPelanggan.data!.docs.isEmpty) {
            return const Center(
                child: Text('Tidak ada data barang yang tersedia.'));
          }

          return ListView.builder(
            itemCount: snapshotPelanggan.data!.docs.length,
            itemBuilder: (context, index) {
              var documentSnapshot = snapshotPelanggan.data!.docs[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                          value: documentSnapshot['customerId'].toString(),
                        ),
                        buildDivider(),
                        buildRow(
                          icon: Icons.person,
                          label: 'Nama Pelanggan: ',
                          value: documentSnapshot['customerName'].toString(),
                        ),
                        buildDivider(),
                        buildRow(
                          icon: Icons.place,
                          label: 'Alamat: ',
                          value: documentSnapshot['customerAddress'].toString(),
                          maxLines: 2,
                        ),
                        buildDivider(),
                        buildRow(
                          icon: Icons.location_city,
                          label: 'Kota: ',
                          value: documentSnapshot['customerCity'].toString(),
                        ),
                        buildDivider(),
                        buildRow(
                          icon: Icons.email,
                          label: 'Email: ',
                          value: documentSnapshot['customerEmail'].toString(),
                        ),
                        buildDivider(),
                        buildRow(
                          icon: Icons.phone_in_talk,
                          label: 'No. Telp: ',
                          value:
                              documentSnapshot['customerNumberHP'].toString(),
                        ),
                        buildDivider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                checkAndUpdateDataCustomer(documentSnapshot);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const StadiumBorder()),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    // <-- Icon
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.orangeAccent,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Edit',
                                    style:
                                        TextStyle(color: Colors.orangeAccent),
                                  ), // <-- Text
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                checkAndDeleteDataCustomer(documentSnapshot);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const StadiumBorder()),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    // <-- Icon
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
                                  ), // <-- Text
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
      ),
    );
  }

  void checkAndUpdateDataCustomer(DocumentSnapshot documentSnapshot) {
    // Simpan nilai awal saat membuka form edit
    String initialName = documentSnapshot['customerName'];
    String initialAddress = documentSnapshot['customerAddress'];
    String initialCity = documentSnapshot['customerCity'];
    String initialEmail = documentSnapshot['customerEmail'];
    String initialNumber = documentSnapshot['customerNumberHP'].toString();

    // Set nilai awal pada controller
    nameController.text = initialName;
    addressController.text = initialAddress;
    cityController.text = initialCity;
    emailController.text = initialEmail;
    numberController.text = initialNumber;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Data Pelanggan'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
              ),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'Kota'),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'No. Telp'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Ambil nilai yang diubah
              final updatedName = nameController.text;
              final updatedAddress = addressController.text;
              final updatedCity = cityController.text;
              final updatedEmail = emailController.text;
              final updatedNumber = numberController.text;

              // Cek perubahan
              if (updatedName != initialName ||
                  updatedAddress != initialAddress ||
                  updatedCity != initialCity ||
                  updatedEmail != initialEmail ||
                  updatedNumber != initialNumber) {
                // Jika ada perubahan, simpan data
                FirebaseFirestore.instance
                    .collection('pelanggan')
                    .doc(documentSnapshot.id)
                    .update({
                  'customerName': updatedName,
                  'customerAddress': updatedAddress,
                  'customerCity': updatedCity,
                  'customerEmail': updatedEmail,
                  'customerNumberHP': int.tryParse(updatedNumber) ?? 0,
                }).then((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Pelanggan dengan ID ${documentSnapshot.id} berhasil diupdate!')),
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

  // Fungsi untuk menghapus data pelanggan
  void checkAndDeleteDataCustomer(DocumentSnapshot documentSnapshot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            'Apakah Anda yakin ingin menghapus data pelanggan ini?',
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
                  .collection('pelanggan')
                  .doc(documentSnapshot.id)
                  .delete()
                  .then((_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Pelanggan dengan ID ${documentSnapshot.id} berhasil dihapus!')),
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
