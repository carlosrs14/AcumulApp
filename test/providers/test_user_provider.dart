import 'package:flutter_test/flutter_test.dart';

import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/user_provider.dart';

void main() {
  test("probando el registro", 
    () async {
      UserProvider provider = UserProvider();
      User user = User(0, "carlos rincones", "c@gmail.com", "12345678", "client");
      User? response = await provider.register(user);
      expect(response != null, true);
    },
  );
}