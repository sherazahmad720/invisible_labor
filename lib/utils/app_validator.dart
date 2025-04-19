import 'package:form_field_validator/form_field_validator.dart';

class AppValidator {
  static final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'email is required'),
    EmailValidator(errorText: 'enter a valid email'),
  ]);

  static final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(
      8,
      errorText: 'password must be at least 8 characters long',
    ),
    MaxLengthValidator(30, errorText: 'password must be at most 30 character'),
    PatternValidator(
      r'^(?=.*?[A-Z])',
      errorText: 'passwords must have at least one UPPER character',
    ),
  ]);

  static final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'name is required'),
    MinLengthValidator(3, errorText: 'name must be at least 3 characters long'),
    MaxLengthValidator(
      30,
      errorText: 'name must not be more than 30 characters',
    ),
  ]);
}
