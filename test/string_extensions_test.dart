import 'package:test/test.dart';
import 'package:thunder_cli/src/core/extensions/string_extensions.dart';
import 'package:thunder_cli/src/features/convert_api_collection_to_code/models/variable_model.dart';

void main() {
  group('StringConversion', () {
    test('words splits every naming style', () {
      for (final input in [
        'user_profile',
        'user-profile',
        'user profile',
        'UserProfile',
        'userProfile'
      ]) {
        expect(input.words, ['user', 'profile'], reason: input);
      }
    });

    test('case conversions', () {
      expect('contact_us'.toCamelCaseFirstLetterForEachWord(), 'ContactUs');
      expect('contact_us'.toCamelCase(), 'contactUs');
      expect('ContactUs'.toSnakeCase(), 'contact_us');
      expect('contactUs'.toConstantCase(), 'CONTACT_US');
      expect(''.lowerCaseFirstLetter(), '');
    });

    test('toDartIdentifier makes any key a valid name', () {
      expect('first-name'.toDartIdentifier(), 'firstName');
      expect('class'.toDartIdentifier(), 'classValue');
      expect('2fa'.toDartIdentifier(), 'field2fa');
      expect('_id'.toDartIdentifier(), 'id');
      expect('***'.toDartIdentifier(), 'field');
    });

    test('escapeForDartString', () {
      expect(r"it's $5".escapeForDartString(), r"it\'s \$5");
    });

    test('convertVariableToValue replaces known variables only', () {
      final vars = [VariableModel(key: 'base_url', value: 'https://api.com/')];
      expect('{{base_url}}users/{{id}}'.convertVariableToValue(vars),
          'https://api.com/users/{{id}}');
    });
  });
}
