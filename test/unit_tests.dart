/// Unit test runner
/// This file can be used to run all unit tests together
library;

import 'package:flutter_test/flutter_test.dart';
import 'unit/upload_service_test.dart' as upload_service;
import 'unit/profile_picture_service_test.dart' as profile_picture_service;
import 'unit/auth_provider_test.dart' as auth_provider;
import 'unit/api_user_model_test.dart' as api_user_model;
import 'unit/image_display_util_test.dart' as image_display_util;

void main() {
  group('All Unit Tests', () {
    upload_service.main();
    profile_picture_service.main();
    auth_provider.main();
    api_user_model.main();
    image_display_util.main();
  });
}
