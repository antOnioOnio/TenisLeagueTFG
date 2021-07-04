import 'package:flutter_test/flutter_test.dart';
import 'package:tenisleague100/application/Auth/validators.dart';

void main() {
  //---------------------------------------------------------
  //            UNIT TEST FOR SIGNIN
  //---------------------------------------------------------
  group('SIGN IN', (){
    test('Usuario vacio debe darnos error', () {
      var result = EmailFieldValidator.validate('');
      expect(result, 'Provide a valid email');
    });
    test('Usuario con formato erroneo debe darnos error', () {
      var result = EmailFieldValidator.validate('a@aaaaa');
      expect(result, 'Provide a valid email');
    });
    test('Usuario con formato correcto no debe darnos error', () {
      var result = EmailFieldValidator.validate('a@a.com');
      expect(result, null);
    });

    test('Contraseña vacia debe darnos error', () {
      var result = PasswordFieldValidator.validate('');
      expect(result, 'Provide a valid password');
    });

    test('Contraseña menor de 3 caracteres debe darnos error', () {
      var result = PasswordFieldValidator.validate('aa');
      expect(result, 'Provide a valid password');
    });
    test('Contraseña de mas de 3 caracteres no debe darnos error', () {
      var result = PasswordFieldValidator.validate('asvb');
      expect(result, null);
    });
  });

  //---------------------------------------------------------
  //            UNIT TEST FOR VALIDATION SCORES
  //---------------------------------------------------------
  group('validation Scores', (){
    test('Set  0 1 debe ser invalido', () {
      var result = ValidateMatchResult.validateWinUser2('05');
      expect(result, false);
    });
    test('Set  0 2 debe ser invalido', () {
      var result = ValidateMatchResult.validateWinUser2('02');
      expect(result, false);
    });
    test('Set  0 3 debe ser invalido', () {
      var result = ValidateMatchResult.validateWinUser2('03');
      expect(result, false);
    });
    test('Set  0 4 debe ser invalido', () {
      var result = ValidateMatchResult.validateWinUser2('04');
      expect(result, false);
    });
    test('Set  0 5 debe ser invalido', () {
      var result = ValidateMatchResult.validateWinUser2('05');
      expect(result, false);
    });
    test('Set  0 6 debe ser valido', () {
      var result = ValidateMatchResult.validateWinUser2('06');
      expect(result, true);
    });
    test('Set 0 7 debe ser invalido', () {
      var result = ValidateMatchResult.validateWinUser2('07');
      expect(result, false);
    });
    test('Set  5 7 debe ser valido', () {
      var result = ValidateMatchResult.validateWinUser2('57');
      expect(result, true);
    });
    test('Set  6 7 debe ser valido', () {
      var result = ValidateMatchResult.validateWinUser2('67');
      expect(result, true);
    });

  });

}
