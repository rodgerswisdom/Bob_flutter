// ignore_for_file: unnecessary_null_comparison


class Val {
// Validations
static String? validateUserName(String val) {
  return (val != null && val != "") ? null : "User Name cannot be empty";
}

static String? validateEmail(String val) {
  return (val != null && val != "") ? null : "Email cannot be empty";
}

static String? validatePassword(String val) {
  return (val != null && val != "") ? null : "Password cannot be empty";
}

}