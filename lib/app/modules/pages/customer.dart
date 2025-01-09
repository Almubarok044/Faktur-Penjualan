import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:PT.RPG/app/data/customer.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  // Controller untuk input
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();

  void generateidCustomerCode() {
    String generatedCode = generateCustomerCode(8);
    setState(() {
      idController.text = generatedCode;
      customerId = generatedCode; // Simpan di variabel customerId
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom * 1),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formState,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: TextFormField(
                        controller: idController,
                        validator: (id) {
                          if (id == '') {
                            return 'Kode pelanggan tidak boleh kosong';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            labelText: 'Kode Pelanggan',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.badge),
                            border: OutlineInputBorder()),
                        onTap: generateidCustomerCode,
                        onChanged: (String id) {
                          getId(id);
                          setState(() {
                            isDataEntered = id.isNotEmpty;
                            isDataEntered2 = id.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: nameController,
                        validator: (name) {
                          if (name == '') {
                            return 'Nama pelanggan tidak boleh kosong';
                          } else if (name!.length > 30) {
                            return 'Nama pelanggan maksimal 30 karakter';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            labelText: 'Nama Pelanggan',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (String name) {
                          getCustomerName(name);
                          setState(() {
                            isDataEntered = name.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: addressController,
                        validator: (address) {
                          if (address == '') {
                            return 'Alamat tidak boleh kosong';
                          } else if (address!.length > 60) {
                            return 'Alamat maksimal 60 karakter';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            labelText: 'Alamat',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.place),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (String address) {
                          getAddress(address);
                          setState(() {
                            isDataEntered = address.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: cityController,
                        validator: (city) {
                          if (city == '') {
                            return 'Kota tidak boleh kosong';
                          } else if (!RegExp(r'^[a-zA-Z\s]+$')
                              .hasMatch(city!)) {
                            return 'Kota hanya boleh diisi dengan huruf';
                          } else if (city.length > 20) {
                            return 'Nama kota maksimal 20 karakter';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: 'Kota',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.location_city),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (String city) {
                          getCity(city);
                          setState(() {
                            isDataEntered = city.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: emailController,
                        validator: validateEmail,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String email) {
                          getEmail(email);
                          setState(() {
                            isDataEntered = email.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: numberController,
                        validator: (number) {
                          // Buat pola regex untuk mengizinkan angka, spasi, tanda kurung, tanda hubung, dan tanda hash
                          RegExp regex = RegExp(r'^[0-9\(\)\-\#\s]+$');

                          if (number == null || number.isEmpty) {
                            return 'No. Telp tidak boleh kosong';
                          } else if (!regex.hasMatch(number)) {
                            return 'No. Telp hanya boleh mengandung angka, (), -, atau #';
                          } else if (number.length > 13) {
                            return 'No. Telp maksimal 13 karakter';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            labelText: 'No. Telp',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.phone_in_talk),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.phone,
                        onChanged: (String number) {
                          getNoHp(number);
                          setState(() {
                            isDataEntered = number.isNotEmpty;
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
                        backgroundColor: Colors
                            .transparent, // Buat latar belakang transparan
                        onPressed: () {
                          if (formState.currentState!.validate()) {
                            checkAndCreateDataCustomer(context);
                          } else {}
                        },
                        child: const Icon(Icons.save),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkAndCreateDataCustomer(BuildContext context) async {
    // Controller untuk input
    // final idController = TextEditingController();
    // final nameController = TextEditingController();
    // final addressController = TextEditingController();
    // final cityController = TextEditingController();
    // final emailController = TextEditingController();
    // final numberController = TextEditingController();

    // Mengambil data dari input
    final customerId = idController.text;
    final customerName = nameController.text;
    final customerAddress = addressController.text;
    final customerCity = cityController.text;
    final customerEmail = emailController.text;
    final customerNumberHp = int.tryParse(numberController.text);

    // Mengecek apakah pelanggan dengan ID tersebut sudah ada
    DocumentSnapshot customerSnapshot =
        await firestore.collection('pelanggan').doc(customerId).get();

    if (customerSnapshot.exists) {
      // Tampilkan pesan jika data sudah ada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pelanggan dengan ID $customerId sudah ada')),
      );
    } else {
      // Tambahkan data baru ke Firebase
      await firestore.collection('pelanggan').doc(customerId).set({
        'customerId': customerId,
        'customerName': customerName,
        'customerAddress': customerAddress,
        'customerCity': customerCity,
        'customerEmail': customerEmail,
        'customerNumberHP': customerNumberHp,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pelanggan berhasil disimpan!')),
        );
      });
    }
  }
}
