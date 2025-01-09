dynamic userEmail;
dynamic userPassword;

void getEmail(email) {
  userEmail = email;
}

void getPassword(password) {
  userPassword = password;
}

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email tidak boleh kosong';
  }
  RegExp emailRegExp = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
  final isEmailValid = emailRegExp.hasMatch(email);
  if (!isEmailValid) {
    return 'Tolong masukkan email yang benar';
  }
  return null;
}
