import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../screens/screens.dart';
import '../../blocs/blocs.dart';
import '../../data/models/sharing.dart';
import '../services/services.dart';
import './partials/no_internet_dialog.dart';
import './partials/new_mirror_dialog.dart';
import './partials/searching_dialog.dart';
import './partials/no_mirror.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await PreferencesService().initPrefs();
  DependenciesService().init();
  final getIt = GetIt.instance;
  getIt<PreferencesService>().deepLink = message.data['link'];
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late final WebViewController _controller;
  final _storage = const FlutterSecureStorage();
  final getIt = GetIt.instance;
  late PackageInfo packageInfo;
  bool _isLoaded = false;
  bool _allowDeveloperMode = true;
  bool _webViewInitialized = false;
  String token = '';
  String _mirror = '';
  String _fcmtoken = '';
  String _params = '';
  File? uploadingImage;

  @override
  void initState() {
    _initNotifications();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if(!_isLoaded){
      packageInfo = await PackageInfo.fromPlatform();
      await Future.delayed(const Duration(milliseconds: 2000));
      final osType = Platform.isAndroid ? 'android' : 'ios';
      token = (await _storage.read(key: "token"))??'';
      _params = '?app_name=apretaste&app_os_type=$osType&app_version=${packageInfo.version}&token=${token.toString()}';
      setState(() { _allowDeveloperMode = false; });
      // ignore: use_build_context_synchronously
      if(!context.read<MirrorsBloc>().state.developerMode){
        // ignore: use_build_context_synchronously
        context.read<MirrorsBloc>().add(OnConnectToMirrorEvent());
      }
      try{
        _fcmtoken = await FirebaseMessaging.instance.getToken()??'';
        // ignore: use_build_context_synchronously
        context.read<AuthBloc>().add(OnStoreFirebaseToken(_fcmtoken));
      }catch(e){
        // ignore: avoid_print
        print(e);
      }
      _isLoaded = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        body: BlocConsumer<MirrorsBloc, MirrorsState>(
          listener: (context, state) {
            if(ModalRoute.of(context)?.isCurrent != true){
              Navigator.of(context, rootNavigator: true).pop();
            }
            if(state.mirrorStatus == MirrorStatus.active
              && !state.developerMode
              && !_webViewInitialized){
              _initWebView();
            }
            if(state.mirrorStatus == MirrorStatus.noInternet){
              showNoInternetDialog(context: context);
            }
            if(state.mirrorStatus == MirrorStatus.noMirror){
              showNoMirrorDialog(context: context);
            }
            if(state.mirrorStatus == MirrorStatus.devMode){
              showNewMirrorDialog(context: context);
            }
            if(state.mirrorStatus == MirrorStatus.searching){
              showSearchingDialog(context: context);
            }
          },
          builder: (context, state) {
            if(state.mirrorStatus == MirrorStatus.ready){
              return SafeArea(
                child: WebViewWidget(controller: _controller)
              );
            }
            return Stack(
              children: [
                const SplashScreen(),
                if(_allowDeveloperMode)
                Positioned(
                  top: 0,
                  left: 0,
                  child: GestureDetector(
                    onDoubleTap: (){
                      context.read<MirrorsBloc>().add(
                        const OnDeveloperModeChanged(true)
                      );
                      context.read<MirrorsBloc>().add(
                        const OnMirrorStatusChanged(MirrorStatus.devMode)
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width*0.4,
                      width: MediaQuery.of(context).size.width*0.4,
                      color: Colors.transparent,
                    ),
                  ),
                )
              ],
            );
          },
        )
      ),
    );
  }

  void _initWebView() async {
    _mirror = context.read<MirrorsBloc>().state.preferredMirror??'';
    await Future.delayed(const Duration(microseconds: 1000));
    late NavigationDelegate navigationDelegate  = NavigationDelegate(
      onPageFinished: (url) => setState((){
        context.read<MirrorsBloc>().add(
          const OnMirrorStatusChanged(MirrorStatus.ready)
        );
      }),
      onNavigationRequest: (request) {
        if(request.url.contains("mailto:")) {
          _launchUrl(request.url);
          return NavigationDecision.prevent;
        }
        else if (request.url.contains("tel:")) {
          _launchUrl(request.url);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    );
    final deepLink = getIt<PreferencesService>().deepLink;
    _controller = WebViewController()
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(navigationDelegate)
      ..addJavaScriptChannel(
        'TokenService',
        onMessageReceived: (JavaScriptMessage jsMessage){
          context.read<AuthBloc>().add(OnTokenReceivedEvent(jsMessage.message));
          context.read<AuthBloc>().add(OnStoreFirebaseToken(_fcmtoken));
        }
      )..addJavaScriptChannel(
        'RemoveToken',
        onMessageReceived: (JavaScriptMessage jsMessage){
          context.read<AuthBloc>().add(OnRemoveToken());
        }
      )..addJavaScriptChannel(
        'UploadImage',
        onMessageReceived: (JavaScriptMessage jsMessage) async {
          File? image = await pickImage();
          if(image != null){
            List<int> imageBytes = image.readAsBytesSync();
            String imageString = base64Encode(imageBytes);
            final extension = p.extension(image.path).replaceAll('.', '');
            final imageData = {
              'name': image.path.split('/').last,
              'type':  'image/$extension',
              'content': 'data:image/$extension;base64,$imageString',
            };
            final imagejson = jsonEncode(imageData);
            _controller.runJavaScript("window.saveImageFromApp('$imagejson')");
          }
        }
      )..addJavaScriptChannel(
        'ApretasteShare',
        onMessageReceived: (JavaScriptMessage jsMessage){
          final sharing = Sharing.fromJson(jsMessage.message);
          Share.share('${sharing.text} ${sharing.link}');
        }
      )..loadRequest(
        Uri.parse('https://$_mirror$deepLink$_params'),
      );
    _webViewInitialized = true;
    getIt<PreferencesService>().deepLink = '';
    final identifier = await _getId();
    _controller.runJavaScript("window.saveAppDeviceIdentifier('$identifier')");
  }

  void _initNotifications(){
    FirebaseMessaging fbm = FirebaseMessaging.instance;
    fbm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      getIt<PreferencesService>().deepLink = message.data['link'];
      setState(() {
        _controller.loadRequest(Uri.parse('https://$_mirror${message.data['link']}'));
      });
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Future<File?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640
      );
      if(image == null) return null;
      final imageTemp = File(image.path);
      uploadingImage = imageTemp;
      return uploadingImage;
    } on PlatformException catch(e) {
      throw Exception(['pickImage', e,]);
    }
  }

  Future<void> _launchUrl(url) async {
    final Uri parsedUrl = Uri.parse(url);
    if (!await launchUrl(parsedUrl)) {
      throw Exception('Could not launch $parsedUrl');
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }
    return "";
  }
}
