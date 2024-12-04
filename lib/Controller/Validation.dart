
//Validation for phone number
bool validatePhoneNumber(String phone) {
  final RegExp egyptianPhoneRegex = RegExp(r'^(01[0-2,5]{1}[0-9]{8})$');
  return phone.isNotEmpty && egyptianPhoneRegex.hasMatch(phone);
}

//To validate email format
bool isValidEmail(String email) {
  final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
  );
  return email.isNotEmpty && emailRegex.hasMatch(email);
}