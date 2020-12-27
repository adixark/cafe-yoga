import 'package:flutter/cupertino.dart';

class LoaderProvider with ChangeNotifier {
  bool _isApiCallProcess = false;
  bool get apiCallprocess => _isApiCallProcess;

  setLoadingStatus(bool status) {
    _isApiCallProcess = status;
    notifyListeners();
  }
}
