class Validator {
  static String? isEmailValid(String email) {
    if (email == '') {
      return 'Email cannot be empty';
    } else if (email != '') {
      final isValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      return isValid == true ? null : 'Email is invalid';
    }
    return null;
  }

  static String? isPhoneValid(String? phone) {
    if (phone == '' || phone == null) {
      return 'Phone cannot be empty';
    } else if (phone.length > 2) {
      phone = phone.replaceFirst('++', '+');
      if (phone.length >= 11) {
        if (phone.length <= 17) {
          final validCharacters = RegExp(r'^\+(?:[0-9] ?){6,14}[0-9]$');
          return validCharacters.hasMatch(phone) == true
              ? null
              : 'Please Enter Valid Phone Number';
        } else {
          return 'Phone number is too long!';
        }
      }
    }
    return 'Phone number is invalid';
  }

  static String? isPasswordValid(String password) {
    if (password == '') {
      return 'Password cannot be empty';
    } else if (password != '') {
      // final isValid = RegExp(
      //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
      //     .hasMatch(password);
      //return isValid == true ? null : 'Passowrd must have 1 Captial letter, ';
      return password.length >= 6
          ? null
          : 'Password should be atleast 6 characters long';
    }
    return null;
  }

  static String? isNameValid(String? name) {
    final validCharacters = RegExp(r'^[a-zA-Z0-9 ]+$');

    if (name == '' || name == null) {
      return 'Name cannot be empty';
    } else if (name != '') {
      if (name.length >= 2) {
        return validCharacters.hasMatch(name) == true
            ? null
            : 'Name cannot contain any special characters';
      } else {
        return 'Name should be atleast 2 characters long';
      }
    }
    return null;
  }

  static String? isCardNumberValid(String? card) {
    if (card == null || card.isEmpty) {
      return 'Card Number cannot be empty';
    }

    // Remove spaces from the card number
    final cardWithoutSpaces = card.replaceAll(RegExp(r'\s'), '');

    if (cardWithoutSpaces.length >= 15) {
      if (cardWithoutSpaces.length > 16) {
        return "Card number is invalid";
      }

      final validCharacters = RegExp(r'^[0-9]+$');
      return validCharacters.hasMatch(cardWithoutSpaces)
          ? null
          : 'Card Number can only contain numbers';
    } else {
      return 'Card Number should be 15 to 16 characters long';
    }
  }

  static String? isCardCVVValid(String? card) {
    if (card == null || card == '') {
      return 'CVV cannot be empty';
    } else if (card != '') {
      if (card.length >= 3) {
        final validCharacters = RegExp(r'^[0-9]+$');
        return validCharacters.hasMatch(card) == true
            ? null
            : 'CVV can only contain numbers';
      }
      return 'CVV should be atleast 3 characters long';
    }
    return null;
  }

  static String? isCardExpiryDateValid(String? monthAndYear) {
    if (monthAndYear == null || monthAndYear == '') {
      return 'Expiry date cannot be empty';
    } else if (monthAndYear.isNotEmpty) {
      final validCharacters = RegExp(r'^[0-9/]+$');
      return validCharacters.hasMatch(monthAndYear) == true
          ? null
          : 'Please enter a expiry date';
    }
    return null;
  }
}
