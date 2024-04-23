class LoginValidation {
  static String? validateTextField(String? input, String type){
    if(input != null) {
      if(input.isEmpty) {
            return 'Enter the $type' ;
      }
    } else {
      return null;
    }
  }
}