final emailRegExp = RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter your email address.";
  }
  if (!emailRegExp.hasMatch(value)) {
    return "The email address format is invalid.";
  }
  return null;
}
