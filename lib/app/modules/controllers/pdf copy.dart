// // ignore_for_file: file_names, depend_on_referenced_packages

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:intl/intl.dart';
// import 'package:open_document/my_files/init.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;

// import '../../data/print_faktur.dart';

// Future<Uint8List> getImageBytesFromAsset(String assetPath) async {
//   final ByteData data = await rootBundle.load(assetPath);
//   return data.buffer.asUint8List();
// }

// Future<void> getFilePdf() async {
//   // Var untuk fungsi
//   final pdf = pw.Document();

//   // Ambil satu data dari Firebase
//   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//       .collection('faktur')
//       .doc(
//         fakturId,
//       )
//       .get();

//   // Ambil gambar dari aset
//   Uint8List imageBytes =
//       await getImageBytesFromAsset('assets/icon/logo_pt_rpg.png');

//   // Ambil semua data dari Firebase
//   // QuerySnapshot querySnapshot =
//   //     await FirebaseFirestore.instance.collection('faktur').get();

//   // Tambahkan data ke PDF
//   // for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//   pdf.addPage(pw.Page(
//     build: (pw.Context context) => pw.Center(
//         child: pw.Column(
//       mainAxisAlignment: pw.MainAxisAlignment.start,
//       children: [
//         // Header Faktur
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Image(pw.MemoryImage(imageBytes), height: 105, width: 105),
//             pw.Text('PT. RICKY PUTRA GLOBALINDO',
//                 style:
//                     pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
//           ],
//         ),
//         pw.SizedBox(height: 10),
//         // Informasi Faktur
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Text('No. Faktur : ${documentSnapshot['fakturId']}'),
//             pw.Row(children: [
//               pw.Text('Tanggal : '),
//               pw.Text(DateFormat('yyyy-MM-dd').format(dateSelected))
//             ])
//           ],
//         ),
//         pw.SizedBox(height: 10),
//         // Informasi Pelanggan
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Text('Kode Pelanggan : ${documentSnapshot['customerId']}'),
//             pw.Text('Nama Pelanggan : ${documentSnapshot['customerName']}'),
//           ],
//         ),
//         pw.SizedBox(height: 10),
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Text('Alamat : ${documentSnapshot['customerAddress']}'),
//             pw.Text('No. Telp : ${documentSnapshot['customerNumberHP']}')
//           ],
//         ),
//         pw.SizedBox(height: 20),
//         // Tabel Barang
//         pw.Table(
//           border: pw.TableBorder.all(),
//           children: [
//             // Header Tabel
//             pw.TableRow(
//               children: [
//                 'Kode Barang',
//                 'Nama Barang',
//                 'Berat Barang',
//                 'Jumlah Pcs',
//                 'Jenis Pembayaran'
//               ]
//                   .map((e) => pw.Container(
//                       padding: const pw.EdgeInsets.all(5),
//                       child: pw.Text(e,
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold))))
//                   .toList(),
//             ),
//             // Isi Tabel
//             pw.TableRow(
//               children: [
//                 pw.Container(
//                   padding: const pw.EdgeInsets.all(5),
//                   child: pw.Text('${documentSnapshot['itemIdFaktur']}'),
//                 ),
//                 pw.Container(
//                   padding: const pw.EdgeInsets.all(5),
//                   child: pw.Text('${documentSnapshot['itemNameFaktur']}'),
//                 ),
//                 pw.Container(
//                   padding: const pw.EdgeInsets.all(5),
//                   child: pw.Text('${documentSnapshot['itemWeightFaktur']}'),
//                 ),
//                 pw.Container(
//                   padding: const pw.EdgeInsets.all(5),
//                   child: pw.Text('${documentSnapshot['itemTotalFaktur']}'),
//                 ),
//                 pw.Container(
//                     padding: const pw.EdgeInsets.all(5),
//                     child: pw.Text('${documentSnapshot['typeOfPayment']}')),
//               ],
//             ),
//           ],
//         ),
//         pw.SizedBox(height: 20),
//         // Total Harga
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.end,
//           children: [
//             pw.Column(children: [
//               pw.Text('Harga : ${documentSnapshot['itemPriceFaktur']}',
//                   style: pw.TextStyle(
//                       fontSize: 16, fontWeight: pw.FontWeight.bold)),
//             ])
//           ],
//         ),
//       ],
//     )),
//   ));
//   // }

//   final dir = await getTemporaryDirectory();
//   // final dir = await getApplicationSupportDirectory();
//   // final dir = await getApplicationCacheDirectory();
//   final files = File('${dir.path}/Faktur_Penjualan.pdf');

//   // Simpan PDF ke penyimpanan perangkat
//   await files.writeAsBytes(await pdf.save());
//   await files.readAsBytes();

//   // // open pdf
//   await OpenFile.open(files.path);
//   // await OpenDocument.openDocument(filePath: files.path);
// }

// void checkAndPDFData() {
//   DocumentReference documentReference =
//       FirebaseFirestore.instance.collection('faktur').doc(fakturId);

//   documentReference.get().then((DocumentSnapshot documentSnapshot) {
//     if (documentSnapshot.exists) {
//       // Hapus dokumen menggunakan DocumentSnapshot
//       getFilePdf().then((value) => pdfToast());
//       // documentReference.delete().then((value) => deleteToast());
//     } else {
//       // CustomerId tidak ditemukan, tampilkan pesan kesalahan
//       checkPDFToast();
//     }
//   }).catchError((error) {
//     // Penanganan kesalahan saat mengambil data
//     if (kDebugMode) {
//       print('Error: $error');
//     }
//   });
// }
