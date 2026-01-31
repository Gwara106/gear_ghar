import 'package:flutter_test/flutter_test.dart';
import 'widgets/cached_network_image_widget_test.dart' as cached_network_image;
import 'widgets/profile_screen_test.dart' as profile_screen;
import 'widgets/login_screen_test.dart' as login_screen;
import 'widgets/edit_profile_screen_test.dart' as edit_profile_screen;
import 'widgets/image_upload_widget_test.dart' as image_upload_widget;

void main() {
  group('All Widget Tests', () {
    cached_network_image.main();
    profile_screen.main();
    login_screen.main();
    edit_profile_screen.main();
    image_upload_widget.main();
  });
}
