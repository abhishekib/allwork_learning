import 'package:app_links/app_links.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  Future<void> initialize() async {
    // Handle deep link opened app
    final Uri? initialUri = await _appLinks.getInitialLink();
    _handleLink(initialUri);

    // Listen to new deep link while app is running
    _appLinks.uriLinkStream.listen((Uri? uri) {
      _handleLink(uri);
    }, onError: (err) {
      print('Failed to handle deep link: $err');
    });
  }

  void _handleLink(Uri? uri) {
    if (uri != null) {
      // Handle your URI, perform navigation, etc.
      print('Received deep link: $uri');
    }
  }
}
