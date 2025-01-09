import 'package:PT.RPG/app/modules/controllers/pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FakturBody extends StatefulWidget {
  const FakturBody({super.key, required List children});

  @override
  State<FakturBody> createState() => FakturBodyState();
}

class FakturBodyState extends State<FakturBody> {
  final customerIdController = TextEditingController();
  final idItemController = TextEditingController();
  final dateController = TextEditingController();

  final paymentController = TextEditingController();

  // Variabel Data Faktur
  String? selectedPaymentType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 2,
          title: const Text('Daftar Faktur',
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
          stream: FirebaseFirestore.instance.collection('faktur').snapshots(),
          builder: (context, snapshotfaktur) {
            if (snapshotfaktur.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshotfaktur.hasError) {
              return Center(child: Text('Error: ${snapshotfaktur.error}'));
            } else if (!snapshotfaktur.hasData ||
                snapshotfaktur.data!.docs.isEmpty) {
              return const Center(
                  child: Text('Tidak ada data faktur yang tersedia.'));
            }

            return ListView.builder(
                itemCount: snapshotfaktur.data!.docs.length,
                itemBuilder: (context, index) {
                  var documentSnapshotFaktur = snapshotfaktur.data!.docs[index];

                  String customerId =
                      documentSnapshotFaktur['customerId'] ?? '';
                  String itemId = documentSnapshotFaktur['itemId'] ?? '';

                  // Ambil data pelanggan berdasarkan customerId
                  return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('pelanggan')
                        .doc(customerId)
                        .snapshots(),
                    builder: (context, snapshotPelanggan) {
                      if (!snapshotPelanggan.hasData) {
                        return const Text('');
                      }

                      var documentSnapshotPelanggan = snapshotPelanggan.data!;

                      // Ambil data barang berdasarkan itemId
                      return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('itembarang')
                            .doc(itemId)
                            .snapshots(),
                        builder: (context, snapshotBarang) {
                          if (!snapshotBarang.hasData) {
                            return const Center(child: Text(''));
                          }

                          var documentSnapshotBarang = snapshotBarang.data!;

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
                                        icon: Icons.mark_as_unread_outlined,
                                        label: 'No. Faktur: ',
                                        value: documentSnapshotFaktur[
                                                'fakturId'] ??
                                            ''.toString()),
                                    buildDivider(),
                                    buildRow(
                                        icon: Icons.date_range_sharp,
                                        label: 'Tanggal: ',
                                        value: DateFormat('yyyy-MM-dd HH:mm:ss')
                                            .format(dateSelected)
                                            .toString()),
                                    buildDivider(),
                                    buildRow(
                                        icon: Icons.date_range_sharp,
                                        label: 'Jenis Pembayaran: ',
                                        value: documentSnapshotFaktur[
                                            'typeofPayment']),
                                    buildDivider(),
                                    buildRow(
                                        icon: Icons.badge,
                                        label: 'Kode Pelanggan: ',
                                        value: documentSnapshotPelanggan[
                                                'customerId'] ??
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
                                      value: documentSnapshotBarang['itemId']
                                          .toString(),
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
                                      value: documentSnapshotBarang[
                                              'itemDescription']
                                          .toString(),
                                      maxLines: 2,
                                    ),
                                    buildDivider(),
                                    buildRow(
                                      icon: Icons.line_weight,
                                      label: 'Berat: ',
                                      value:
                                          documentSnapshotBarang['itemWeight']
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            checkAndUpdateDataFaktur(
                                                documentSnapshotFaktur);
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
                                        Container(
                                          width: 56.0, // Ukuran tombol
                                          height: 56.0, // Ukuran tombol
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.indigo, // Warna tombol
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              // Aksi yang ingin dilakukan saat tombol ditekan
                                              checkAndGeneratePdf(context,
                                                  documentSnapshotFaktur);
                                            },
                                            child: const Icon(
                                              Icons.picture_as_pdf,
                                              color: Colors.white, // Warna ikon
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            checkAndDeleteDataFaktur(
                                                documentSnapshotFaktur);
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
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        ),
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
                });
          },
        ));
  }

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

  // Fungsi untuk menampilkan form edit data
  void checkAndUpdateDataFaktur(DocumentSnapshot documentSnapshotFaktur) {
    // Simpan nilai awal saat membuka form edit
    String initialDate = documentSnapshotFaktur['date'].toString();
    String initialPayment = documentSnapshotFaktur['typeofPayment'] ?? '';

    // Set controller dan dropdown value ke nilai awal dari data faktur
    dateController.text = initialDate;
    selectedPaymentType = initialPayment;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Data Faktur'),
        content: SingleChildScrollView(
          child: Column(children: [
            TextFormField(
              controller: dateController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Tanggal',
              ),
              readOnly: true,
              onTap: () {
                selectedDate();
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Jenis Pembayaran'),
              value: selectedPaymentType,
              items: ['Cash', 'Credit', 'Debit', 'E-Money']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPaymentType = value!;
                });
              },
              isExpanded: true, // Membuat dropdown mengisi seluruh field
            ),
          ]),
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
              final updatedDate = dateController.text;
              final updatedPayment = selectedPaymentType ?? initialPayment;

              // Cek perubahan
              if (updatedDate != initialDate ||
                  updatedPayment != initialPayment) {
                // Jika ada perubahan, simpan data
                FirebaseFirestore.instance
                    .collection('faktur')
                    .doc(documentSnapshotFaktur.id)
                    .update({
                  'date': updatedDate,
                  'typeofPayment': updatedPayment,
                }).then((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Faktur dengan No. ${documentSnapshotFaktur.id} berhasil diupdate!')),
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

  void checkAndDeleteDataFaktur(DocumentSnapshot documentSnapshotFaktur) {
    // Implement delete item logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            'Apakah Anda yakin ingin menghapus data faktur ini?',
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
                  .collection('faktur')
                  .doc(documentSnapshotFaktur.id)
                  .delete()
                  .then((_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Faktur dengan kode ${documentSnapshotFaktur.id} berhasil dihapus!')),
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
