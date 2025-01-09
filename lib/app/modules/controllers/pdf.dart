import 'package:PT.RPG/app/data/customer.dart';
import 'package:PT.RPG/app/data/item_barang.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_document/my_files/init.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> getImageBytesFromAsset(String assetPath) async {
  final ByteData data = await rootBundle.load(assetPath);
  return data.buffer.asUint8List();
}

Future<void> getFilePdf(String fakturId) async {
  final pdf = pw.Document();

  // Ambil data faktur dari Firestore
  DocumentSnapshot documentSnapshotFaktur =
      await FirebaseFirestore.instance.collection('faktur').doc(fakturId).get();
  DocumentSnapshot documentSnapshotPelanggan = await FirebaseFirestore.instance
      .collection('pelanggan')
      .doc(customerId)
      .get();
  DocumentSnapshot documentSnapshotBarang = await FirebaseFirestore.instance
      .collection('itembarang')
      .doc(itemId)
      .get();

  if (!documentSnapshotFaktur.exists) {
    // Jika data tidak ada, beri notifikasi
    print("Data faktur tidak ditemukan.");
    return;
  }

  if (!documentSnapshotPelanggan.exists) {
    print("Data pelanggan tidak ditemukan.");
    return; // atau lakukan tindakan lain jika data tidak ditemukan
  }

  if (!documentSnapshotBarang.exists) {
    print("Data Barang tidak ditemukan.");
    return; // atau lakukan tindakan lain jika data tidak ditemukan
  }

  // Ambil logo dari asset
  Uint8List imageBytes =
      await getImageBytesFromAsset('assets/icon/logo_pt_rpg.png');

  // Menambahkan halaman PDF
  pdf.addPage(pw.Page(
    build: (pw.Context context) => pw.Center(
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          // Header Faktur
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(pw.MemoryImage(imageBytes), height: 105, width: 105),
              pw.Text(
                'PT. RICKY PUTRA GLOBALINDO',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.SizedBox(height: 10),

          // Informasi Faktur
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('No. Faktur: ${documentSnapshotFaktur['fakturId']}'),
              pw.Row(children: [
                // pw.Text('Tanggal: '),
                // pw.Text(DateFormat('yyyy-MM-dd').format(dateSelected)),
              ])
            ],
          ),
          pw.SizedBox(height: 10),

          // Informasi Pelanggan
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                  'Kode Pelanggan: ${documentSnapshotPelanggan['customerId']}'),
              pw.Text(
                  'Nama Pelanggan: ${documentSnapshotPelanggan['customerName']}'),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                  'Alamat: ${documentSnapshotPelanggan['customerAddress']}'),
              pw.Text(
                  'No. Telp: ${documentSnapshotPelanggan['customerNumberHP']}'),
            ],
          ),
          pw.SizedBox(height: 20),

          // Tabel Barang
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              // Header Tabel
              pw.TableRow(
                children: [
                  'Kode Barang',
                  'Nama Barang',
                  'Berat Barang',
                  'Jumlah Pcs',
                  'Jenis Pembayaran'
                ]
                    .map((e) => pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(e,
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ))
                    .toList(),
              ),
              // Isi Tabel
              pw.TableRow(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('${documentSnapshotBarang['itemIdFaktur']}'),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child:
                        pw.Text('${documentSnapshotBarang['itemNameFaktur']}'),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                        '${documentSnapshotBarang['itemWeightFaktur']}'),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child:
                        pw.Text('${documentSnapshotBarang['itemTotalFaktur']}'),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child:
                        pw.Text('${documentSnapshotBarang['typeOfPayment']}'),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),

          // Total Harga
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                children: [
                  pw.Text(
                    'Harga: ${documentSnapshotBarang['itemPriceFaktur']}',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  ));

  // Dapatkan direktori sementara untuk menyimpan PDF
  final dir = await getTemporaryDirectory();
  final filePath = '${dir.path}/Faktur_Penjualan.pdf';
  final file = File(filePath);

  // Simpan PDF ke file
  await file.writeAsBytes(await pdf.save());

  // Buka PDF
  await OpenFile.open(file.path);
}

void checkAndGeneratePdf(
    BuildContext context, DocumentSnapshot documentSnapshotFaktur) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Konfirmasi Buat PDF',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Apakah Anda yakin ingin membuat PDF untuk data faktur ini?',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            // Pastikan dialog ditutup sebelum menjalankan fungsi pembuatan PDF
            Navigator.pop(context);

            // Panggil fungsi untuk membuat dan membuka PDF
            getFilePdf(
              documentSnapshotFaktur.id,
              // documentSnapshotFaktur['date']
              // .toDate(), // Ubah sesuai nama atribut tanggal di Firebase
            ).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PDF berhasil dibuat dan dibuka!'),
                ),
              );
            }).catchError((error) {
              // Tampilkan error jika terjadi masalah saat membuat PDF
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $error'),
                ),
              );
            });
          },
          child: const Text('Buat PDF'),
        ),
      ],
    ),
  );
}
