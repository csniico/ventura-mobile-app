import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class NetworkModule {
  static final NetworkModule _instance = NetworkModule._internal();
  static NetworkModule get instance => _instance;

  late final Dio dio;

  NetworkModule._internal() {
    dio = Dio();

    //   add connect and receive timeouts
    dio.options.connectTimeout = const Duration(seconds: 100);
    dio.options.receiveTimeout = const Duration(seconds: 100);

    //   initialize cookieJar
    //   for persistent login (requires path_provider)
    //   Use .then() to handle the Future since constructors cannot be async
    getApplicationDocumentsDirectory().then((appDocDir) {
      final cookieJar = PersistCookieJar(storage: FileStorage(("${appDocDir.path}/.cookies")));

      //   add cookieManager interceptor
      dio.interceptors.add(CookieManager(cookieJar));
    });
  }
}