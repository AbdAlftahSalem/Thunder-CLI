import '../extensions/string_extensions.dart';

class ConstStrings {
  // create singleton for ConstStrings
  static final ConstStrings instance = ConstStrings._internal();

  factory ConstStrings() => instance;

  ConstStrings._internal();

  String main = '''
import 'package:crypto_new/app/modules/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/data/local/hive.dart';
import 'app/data/local/my_shared_pref.dart';
import 'config/translations/localization_service.dart';
import 'utils/awesome_notifications_helper.dart';
import 'utils/fcm_helper.dart';

Future<void> main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();

  // initialize local db (hive) and register our custom adapters
  await MyHive.init(registerAdapters: (hive) {});

  // init shared preference
  await MySharedPref.init();

  // inti fcm services
  await FcmHelper.initFcm();

  // initialize local notifications service
  await AwesomeNotificationsHelper.init();

  runApp(
    ScreenUtilInit(
      // todo add your (Xd / Figma) artboard size
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
        return GetMaterialApp(
          // todo add your app name
          title: "GetXSkeleton",
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            bool themeIsLight = MySharedPref.getThemeIsLight();
            return Theme(
              data: MyTheme.getThemeData(isLight: themeIsLight),
              child: MediaQuery(
                // prevent font from scalling (some people use big/small device fonts)
                // but we want our app font to still the same and dont get affected
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              ),
            );
          },
          // app screens
          locale: MySharedPref.getCurrentLocal(),
          // app language
          translations: LocalizationService.getInstance(),
          // localization services in app (controller app language)
          home: const HomeScreen(),
        );
      },
    ),
  );
}

  ''';

  String sharedPrefs = '''
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/translations/localization_service.dart';

class MySharedPref {
  // prevent making instance
  MySharedPref._();

  // get storage
  static late SharedPreferences _sharedPreferences;

  // STORING KEYS
  static const String _fcmTokenKey = 'fcm_token';
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';

  /// init get storage services
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// set theme current type as light theme
  static Future<void> setThemeIsLight(bool lightTheme) =>
      _sharedPreferences.setBool(_lightThemeKey, lightTheme);

  /// get if the current theme type is light
  static bool getThemeIsLight() =>
      _sharedPreferences.getBool(_lightThemeKey) ??
      true; // todo set the default theme (true for light, false for dark)

  /// save current locale
  static Future<void> setCurrentLanguage(String languageCode) =>
      _sharedPreferences.setString(_currentLocalKey, languageCode);

  /// get current locale
  static Locale getCurrentLocal() {
    String? langCode = _sharedPreferences.getString(_currentLocalKey);
    // default language is english
    if (langCode == null) {
      return LocalizationService.defaultLanguage;
    }
    return LocalizationService.supportedLanguages[langCode]!;
  }

  /// save generated fcm token
  static Future<void> setFcmToken(String token) =>
      _sharedPreferences.setString(_fcmTokenKey, token);

  /// get authorization token
  static String? getFcmToken() => _sharedPreferences.getString(_fcmTokenKey);

  /// clear all data from shared pref
  static Future<void> clear() async => await _sharedPreferences.clear();
}

  ''';

  String hive = '''
import 'package:hive_flutter/hive_flutter.dart';

class MyHive {
  // prevent making instance
  MyHive._();

  // box name its like table name
  static const String _userBoxName = 'user';

  // store current user as (key => value)
  static const String _currentUserKey = 'local_user';

  /// initialize local db (HIVE)
  /// pass testPath only if you are testing hive
  static Future<void> init(
      {Function(HiveInterface)? registerAdapters, String? testPath}) async {
    if (testPath != null) {
      Hive.init(testPath);
    } else {
      await Hive.initFlutter();
    }
    await registerAdapters?.call(Hive);
  }

  // setup your methods for local db here
}

  ''';

  String apiCallStatus = '''
enum ApiCallStatus {
  loading,
  success,
  error,
  empty,
  holding,
  cache,
  refresh,
}    ''';

  String apiException = '''
import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String url;
  final String message;
  final int? statusCode;
  final Response? response;

  ApiException({
    required this.url,
    required this.message,
    this.response,
    this.statusCode,
  });

  /// IMPORTANT NOTE
  /// here you can take advantage of toString() method to display the error for user
  /// lets make an example
  /// so in onError method when you make api you can just user apiExceptionInstance.toString() to get the error message from api
  @override
  toString() {
    String result = '';

    // TODO add error message field which is coming from api for you (For ex: response.data['error']['message']
    result += response?.data?['error'] ?? '';

    if(result.isEmpty){
      result += message; // message is the (dio error message) so usualy its not user friendly
    }

    return result;
  }
}        
        ''';

  String baseClient = '''
import 'dart:async';
import 'dart:io';

import 'package:crypto_new/app/components/custom_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../config/translations/strings.dart';
import 'api_exceptions.dart';

enum RequestType {
  get,
  post,
  put,
  delete,
}

class BaseClient {
  static final Dio _dio = Dio(BaseOptions(headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }))
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));

  // request timeout (default 10 seconds)
  static const int _timeoutInSeconds = 10;

  /// dio getter (used for testing)
  static get dio => _dio;

  /// perform safe api request
  static safeApiCall(
    String url,
    RequestType requestType, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ApiException)? onError,
    Function(int value, int progress)? onReceiveProgress,
    Function(int total, int progress)?
        onSendProgress, // while sending (uploading) progress
    Function? onLoading,
    dynamic data,
  }) async {
    try {
      // 1) indicate loading state
      await onLoading?.call();
      // 2) try to perform http request
      late Response response;
      if (requestType == RequestType.get) {
        response = await _dio.get(
          url,
          onReceiveProgress: onReceiveProgress,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ),
        );
      } else if (requestType == RequestType.post) {
        response = await _dio.post(
          url,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      } else if (requestType == RequestType.put) {
        response = await _dio.put(
          url,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      } else {
        response = await _dio.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      }
      // 3) return response (api done successfully)
      await onSuccess(response);
    } on DioException catch (error) {
      // dio error (api reach the server but not performed successfully
      _handleDioError(error: error, url: url, onError: onError);
    } on SocketException {
      // No internet connection
      _handleSocketException(url: url, onError: onError);
    } on TimeoutException {
      // Api call went out of time
      _handleTimeoutException(url: url, onError: onError);
    } catch (error, stackTrace) {
      // print the line of code that throw unexpected exception
      Logger().e(stackTrace);
      // unexpected error for example (parsing json error)
      _handleUnexpectedException(url: url, onError: onError, error: error);
    }
  }

  /// download file
  static download(
      {required String url, // file url
      required String savePath, // where to save file
      Function(ApiException)? onError,
      Function(int value, int progress)? onReceiveProgress,
      required Function onSuccess}) async {
    try {
      await _dio.download(
        url,
        savePath,
        options: Options(
            receiveTimeout: const Duration(seconds: _timeoutInSeconds),
            sendTimeout: const Duration(seconds: _timeoutInSeconds)),
        onReceiveProgress: onReceiveProgress,
      );
      onSuccess();
    } catch (error) {
      var exception = ApiException(url: url, message: error.toString());
      onError?.call(exception) ?? _handleError(error.toString());
    }
  }

  /// handle unexpected error
  static _handleUnexpectedException(
      {Function(ApiException)? onError,
      required String url,
      required Object error}) {
    if (onError != null) {
      onError(ApiException(
        message: error.toString(),
        url: url,
      ));
    } else {
      _handleError(error.toString());
    }
  }

  /// handle timeout exception
  static _handleTimeoutException(
      {Function(ApiException)? onError, required String url}) {
    if (onError != null) {
      onError(ApiException(
        message: Strings.serverNotResponding.tr,
        url: url,
      ));
    } else {
      _handleError(Strings.serverNotResponding.tr);
    }
  }

  /// handle timeout exception
  static _handleSocketException(
      {Function(ApiException)? onError, required String url}) {
    if (onError != null) {
      onError(ApiException(
        message: Strings.noInternetConnection.tr,
        url: url,
      ));
    } else {
      _handleError(Strings.noInternetConnection.tr);
    }
  }

  /// handle Dio error
  static _handleDioError(
      {required DioException error,
      Function(ApiException)? onError,
      required String url}) {
    // 404 error
    if (error.response?.statusCode == 404) {
      if (onError != null) {
        return onError(ApiException(
          message: Strings.urlNotFound.tr,
          url: url,
          statusCode: 404,
        ));
      } else {
        return _handleError(Strings.urlNotFound.tr);
      }
    }

    // no internet connection
    if (error.message != null &&
        error.message!.toLowerCase().contains('socket')) {
      if (onError != null) {
        return onError(ApiException(
          message: Strings.noInternetConnection.tr,
          url: url,
        ));
      } else {
        return _handleError(Strings.noInternetConnection.tr);
      }
    }

    // check if the error is 500 (server problem)
    if (error.response?.statusCode == 500) {
      var exception = ApiException(
        message: Strings.serverError.tr,
        url: url,
        statusCode: 500,
      );

      if (onError != null) {
        return onError(exception);
      } else {
        return handleApiError(exception);
      }
    }

    var exception = ApiException(
        url: url,
        message: error.message ?? 'Un Expected Api Error!',
        response: error.response,
        statusCode: error.response?.statusCode);
    if (onError != null) {
      return onError(exception);
    } else {
      return handleApiError(exception);
    }
  }

  /// handle error automaticly (if user didnt pass onError) method
  /// it will try to show the message from api if there is no message
  /// from api it will show the reason (the dio message)
  static handleApiError(ApiException apiException) {
    String msg = apiException.toString();
    CustomSnackBar.showCustomErrorToast(message: msg);
  }

  /// handle errors without response (500, out of time, no internet,..etc)
  static _handleError(String msg) {
    CustomSnackBar.showCustomErrorToast(message: msg);
  }
}
 
 ''';

  String binding(String bindingName) {
    String bindingClassName = bindingName.toCamelCase();

    return '''
import 'package:get/get.dart';

import '../controller/${bindingName}_controller.dart';

class ${"${bindingClassName}Binding"} extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${bindingName}Controller>(
      () => ${bindingName}Controller(),
    );
  }
}
''';
  }

  String controller(String controllerName) {
    controllerName = controllerName.toCamelCase();
    return '''
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../data/remote/api_call_status.dart';
import '../../data/remote/base_client.dart';


class $controllerName extends GetxController {
  // hold data coming from api
  List<dynamic>? data;

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  // getting data from api
  getData() async {
    // *) perform api call
    await BaseClient.safeApiCall(
      Constants.todosApiUrl, // url
      RequestType.get, // request type (get,post,delete,put)
      onLoading: () {
        // *) indicate loading state
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) {
        // api done successfully
        data = List.from(response.data);
        // *) indicate success state
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      // if you don't pass this method base client
      // will automaticly handle error and show message to user
      onError: (error) {
        // show error message to user
        BaseClient.handleApiError(error);
        // *) indicate error status
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
''';
  }

  String view(String viewName) {
    String viewClassName = viewName.toCamelCase();

    return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';

class $viewClassName extends StatelessWidget {
  const $viewClassName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<${viewName.replaceAll("Screen", "")}Controller>(
        builder: (controller) {
          return const Text("$viewName");
        },
      ),
    );
  }
}
    ''';
  }

  String apiErrorWidget = '''
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/translations/strings.dart';

class ApiErrorWidget extends StatelessWidget {
  const ApiErrorWidget(
      {super.key,
      required this.message,
      required this.retryAction,
      this.padding});

  final String message;
  final Function retryAction;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            10.verticalSpace,
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => retryAction(),
                  child: Text(Strings.retry.tr),
                )),
          ],
        ),
      ),
    );
  }
}

  ''';

  String snackbar = '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  static showCustomSnackBar({required String title, required String message,Duration? duration})
  {
    Get.snackbar(
      title,
      message,
      duration: duration ?? const Duration(seconds: 3),
      margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
      colorText: Colors.white,
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check_circle, color: Colors.white,),
    );
  }


  static showCustomErrorSnackBar({required String title, required String message,Color? color,Duration? duration})
  {
    Get.snackbar(
      title,
      message,
      duration: duration ?? const Duration(seconds: 3),
      margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
      colorText: Colors.white,
      backgroundColor: color ?? Colors.redAccent,
      icon: const Icon(Icons.error, color: Colors.white,),
    );
  }



  static showCustomToast({String? title, required String message,Color? color,Duration? duration}){
    Get.rawSnackbar(
      title: title,
      duration: duration ?? const Duration(seconds: 3),
      snackStyle: SnackStyle.GROUNDED,
      backgroundColor: color ?? Colors.green,
      onTap: (snack){
        Get.closeAllSnackbars();
      },
      //overlayBlur: 0.8,
      message: message,
    );
  }


  static showCustomErrorToast({String? title, required String message,Color? color,Duration? duration}){
    Get.rawSnackbar(
      title: title,
      duration: duration ?? const Duration(seconds: 3),
      snackStyle: SnackStyle.GROUNDED,
      backgroundColor: color ?? Colors.redAccent,
      onTap: (snack){
        Get.closeAllSnackbars();
      },
      //overlayBlur: 0.8,
      message: message,
    );
  }
}
 ''';

  String animatedWidget = '''
import 'package:crypto_new/app/data/remote/api_call_status.dart';
import 'package:flutter/cupertino.dart';

// switch between different widgets with animation
// depending on api call status
class MyWidgetsAnimator extends StatelessWidget {
  final ApiCallStatus apiCallStatus;
  final Widget Function() loadingWidget;
  final Widget Function() successWidget;
  final Widget Function() errorWidget;
  final Widget Function()? emptyWidget;
  final Widget Function()? holdingWidget;
  final Widget Function()? refreshWidget;
  final Duration? animationDuration;
  final Widget Function(Widget, Animation<double>)? transitionBuilder;

  // this will be used to not hide the success widget when refresh
  // if its true success widget will still be shown
  // if false refresh widget will be shown or empty box if passed (refreshWidget) is null
  final bool hideSuccessWidgetWhileRefreshing;

  const MyWidgetsAnimator({
    Key? key,
    required this.apiCallStatus,
    required this.loadingWidget,
    required this.errorWidget,
    required this.successWidget,
    this.holdingWidget,
    this.emptyWidget,
    this.refreshWidget,
    this.animationDuration,
    this.transitionBuilder,
    this.hideSuccessWidgetWhileRefreshing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetMap = {
      ApiCallStatus.success: successWidget,
      ApiCallStatus.error: errorWidget,
      ApiCallStatus.holding: holdingWidget ?? (() => const SizedBox()),
      ApiCallStatus.loading: loadingWidget,
      ApiCallStatus.empty: emptyWidget ?? (() => const SizedBox()),
      ApiCallStatus.refresh: refreshWidget ??
          (hideSuccessWidgetWhileRefreshing
              ? successWidget
              : () => const SizedBox()),
      ApiCallStatus.cache: successWidget,
    };

    final selectedWidget = widgetMap[apiCallStatus];

    return AnimatedSwitcher(
      duration: animationDuration ?? const Duration(milliseconds: 300),
      transitionBuilder:
          transitionBuilder ?? AnimatedSwitcher.defaultTransitionBuilder,
      child: selectedWidget!(),
    );
  }
}

  ''';

  String constsApp = '''
class Constants {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';
  static const todosApiUrl = baseUrl + '/todos';
}
    ''';

  String awesomeNotifications = '''
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class AwesomeNotificationsHelper {
  // prevent making instance
  AwesomeNotificationsHelper._();

  // Notification lib
  static AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  /// initialize local notifications service, create channels and groups
  /// setup notifications button actions handlers
  static init() async {
    // initialize local notifications
    await _initNotification();

    // request permission to show notifications
    awesomeNotifications.requestPermissionToSendNotifications();

    // list when user click on notifications
    listenToActionButtons();
  }

  /// when user click on notification or click on button on the notification
  static listenToActionButtons() {
    // Only after at least the action method is set, the notification events are delivered
    awesomeNotifications.setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
  }

  ///init notifications channels
  static _initNotification() async {
    await awesomeNotifications.initialize(
        null,
        // null mean it will show app icon on the notification (status bar)
        [
          NotificationChannel(
            channelGroupKey: NotificationChannels.generalChannelGroupKey,
            channelKey: NotificationChannels.generalChannelKey,
            channelName: NotificationChannels.generalChannelName,
            groupKey: NotificationChannels.generalGroupKey,
            channelDescription: NotificationChannels.generalChannelDescription,
            defaultColor: Colors.green,
            ledColor: Colors.white,
            channelShowBadge: true,
            playSound: true,
            importance: NotificationImportance.Max,
          ),
          NotificationChannel(
              channelGroupKey: NotificationChannels.chatChannelGroupKey,
              channelKey: NotificationChannels.chatChannelKey,
              channelName: NotificationChannels.chatChannelName,
              groupKey: NotificationChannels.chatGroupKey,
              channelDescription: NotificationChannels.chatChannelDescription,
              defaultColor: Colors.green,
              ledColor: Colors.white,
              channelShowBadge: true,
              playSound: true,
              importance: NotificationImportance.Max)
        ], channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: NotificationChannels.generalChannelGroupKey,
        channelGroupName: NotificationChannels.generalChannelGroupName,
      ),
      NotificationChannelGroup(
        channelGroupKey: NotificationChannels.chatChannelGroupKey,
        channelGroupName: NotificationChannels.chatChannelGroupName,
      )
    ]);
  }

  //display notification for user with sound
  static showNotification(
      {required String title,
      required String body,
      required int id,
      String? channelKey,
      String? groupKey,
      NotificationLayout? notificationLayout,
      String? summary,
      List<NotificationActionButton>? actionButtons,
      Map<String, String>? payload,
      String? largeIcon}) async {
    awesomeNotifications.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        awesomeNotifications.requestPermissionToSendNotifications();
      } else {
        // u can show notification
        awesomeNotifications.createNotification(
          content: NotificationContent(
            id: id,
            title: title,
            body: body,
            groupKey: groupKey ?? NotificationChannels.generalGroupKey,
            channelKey: channelKey ?? NotificationChannels.generalChannelKey,
            showWhen: true,
            // Hide/show the time elapsed since notification was displayed
            payload: payload,
            // data of the notification (it will be used when user clicks on notification)
            notificationLayout:
                notificationLayout ?? NotificationLayout.Default,
            // notification shape (message,media player..etc) For ex => NotificationLayout.Messaging
            autoDismissible: true,
            // dismiss notification when user clicks on it
            summary: summary,
            // for ex: New message (it will be shown on status bar before notificaiton shows up)
            largeIcon:
                largeIcon, // image of sender for ex (when someone send you message his image will be shown)
          ),
          actionButtons: actionButtons,
        );
      }
    });
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    Map<String, String?>? payload = receivedAction.payload;
    // TODO handle clicking on notification
    // example
    // String routeToGetTo = payload['route'];
    // normal navigation (Get.toNamed) will throw error
  }
}

class NotificationChannels {
  // chat channel (for messages only)
  static String get chatChannelKey => "chat_channel";

  static String get chatChannelName => "Chat channel";

  static String get chatGroupKey => "chat group key";

  static String get chatChannelGroupKey => "chat_channel_group";

  static String get chatChannelGroupName => "Chat notifications channels";

  static String get chatChannelDescription => "Chat notifications channels";

  // general channel (for all other notifications)
  static String get generalChannelKey => "general_channel";

  static String get generalGroupKey => "general group key";

  static String get generalChannelGroupKey => "general_channel_group";

  static String get generalChannelGroupName => "general notifications channel";

  static String get generalChannelName => "general notifications channels";

  static String get generalChannelDescription =>
      "Notification channel for general notifications";
}

  ''';

  String fcmHelper = '''
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import '../app/data/local/my_shared_pref.dart';
import 'awesome_notifications_helper.dart';

class FcmHelper {
  // prevent making instance
  FcmHelper._();

  // FCM Messaging
  static late FirebaseMessaging messaging;

  /// this function will initialize firebase and fcm instance
  static Future<void> initFcm() async {
    try {
      // initialize fcm and firebase core
      await Firebase.initializeApp(
          // TODO: uncomment this line if you connected to firebase via cli
          //options: DefaultFirebaseOptions.currentPlatform,
          );

      // initialize firebase
      messaging = FirebaseMessaging.instance;

      // notification settings handler
      await _setupFcmNotificationSettings();

      // generate token if it not already generated and store it on shared pref
      await _generateFcmToken();

      // background and foreground handlers
      FirebaseMessaging.onMessage.listen(_fcmForegroundHandler);
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
    } catch (error) {
      // if you are connected to firebase and still get error
      // check the todo up in the function else ignore the error
      // or stop fcm service from main.dart class
      Logger().e(error);
    }
  }

  ///handle fcm notification settings (sound,badge..etc)
  static Future<void> _setupFcmNotificationSettings() async {
    //show notification with sound and badge
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    //NotificationSettings settings
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
  }

  /// generate and save fcm token if its not already generated (generate only for 1 time)
  static Future<void> _generateFcmToken() async {
    try {
      var token = await messaging.getToken();
      if (token != null) {
        MySharedPref.setFcmToken(token);
        _sendFcmTokenToServer();
      } else {
        // retry generating token
        await Future.delayed(const Duration(seconds: 5));
        _generateFcmToken();
      }
    } catch (error) {
      Logger().e(error);
    }
  }

  /// this method will be triggered when the app generate fcm
  /// token successfully
  static _sendFcmTokenToServer() {
    var token = MySharedPref.getFcmToken();
    // TODO SEND FCM TOKEN TO SERVER
  }

  ///handle fcm notification when app is closed/terminated
  /// if you are wondering about this annotation read the following
  /// https://stackoverflow.com/a/67083337
  @pragma('vm:entry-point')
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    AwesomeNotificationsHelper.showNotification(
      id: 1,
      title: message.notification?.title ?? 'Tittle',
      body: message.notification?.body ?? 'Body',
      payload: message.data
          .cast(), // pass payload to the notification card so you can use it (when user click on notification)
    );
  }

  //handle fcm notification when app is open
  static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
    AwesomeNotificationsHelper.showNotification(
      id: 1,
      title: message.notification?.title ?? 'Tittle',
      body: message.notification?.body ?? 'Body',
      payload: message.data
          .cast(), // pass payload to the notification card so you can use it (when user click on notification)
    );
  }
}

  ''';

  String darkTheme = '''
import 'package:flutter/material.dart';

// TODO add your dark theme colors palette
class DarkThemeColors
{
  // PRIMARY
  static const Color primaryColor = Color(0xFFFF8C00);

  // SECONDARY
  static Color accentColor = Colors.blueAccent;

  //Appbar
  static const Color appbarColor = Colors.black;

  //SCAFFOLD
  static const Color scaffoldBackgroundColor = Color(0xff2D2D2D);
  static const Color backgroundColor = Color(0xff2D2D2D);
  static const Color dividerColor = Color(0xff686868);
  static const Color cardColor = Color(0xff1e2336);

  //ICONS
  static const Color appBarIconsColor = Colors.white;
  static const Color iconColor = primaryColor;

  //BUTTON
  static const Color buttonColor = primaryColor;
  static const Color buttonTextColor = Colors.black;
  static const Color buttonDisabledColor = Colors.grey;
  static const Color buttonDisabledTextColor = Colors.black;

  //TEXT
  static const Color bodyTextColor = Colors.white70;
  static const Color displayTextColor = Colors.white;
  static const Color bodySmallTextColor =  Color(0xff7C7C7C);
  static const Color hintTextColor = Color(0xff686868);

  //chip
  static const Color chipBackground = primaryColor;
  static const Color chipTextColor = Colors.black87;

  // progress bar indicator
  static const Color progressIndicatorColor = Color(0xFF40A76A);

  // list tile
  static const Color listTileTitleColor = Colors.white;
  static const Color listTileSubtitleColor = Colors.white;
  static const Color listTileBackgroundColor = Color(0xFF414141);
  static const Color listTileIconColor = Colors.white;

  //------------------- custom theme (extensions) ------------------- //
  // header containers
  static const Color headerContainerBackgroundColor = Color(0XFFf8a319);

  // employee list item
  static const Color employeeListItemBackgroundColor = Color(0xFF393939);
  static const Color employeeListItemNameColor = Colors.white;
  static const Color employeeListItemSubtitleColor = Color(0xFFEDEDED);
  static const Color employeeListItemIconsColor = Color(0xFFEDEDED);

}        
        ''';

  String lightTheme = '''
import 'package:flutter/material.dart';

// TODO add your light theme colors palette
class LightThemeColors
{
  // PRIMARY
  static const Color primaryColor = Color(0xFF42A7DE);

  // SECONDARY COLOR
  static const Color accentColor = Color(0xFFD9EDE1);

  //APPBAR
  static const Color appBarColor = primaryColor;

  //SCAFFOLD
  static const Color scaffoldBackgroundColor = Colors.white;
  static const Color backgroundColor = Colors.white;
  static const Color dividerColor = Color(0xff686868);
  static const Color cardColor = Color(0xfffafafa);

  //ICONS
  static const Color appBarIconsColor = Colors.white;
  static const Color iconColor = Colors.black;

  //BUTTON
  static const Color buttonColor = primaryColor;
  static const Color buttonTextColor = Colors.white;
  static const Color buttonDisabledColor = Colors.grey;
  static const Color buttonDisabledTextColor = Colors.black;

  //TEXT
  static const Color bodyTextColor = Colors.black;
  static const Color displayTextColor = Color(0xFF1E2432);
  static const Color bodySmallTextColor = Color(0xff7C7C7C);
  static const Color hintTextColor =  Color(0xff686868);

  //chip
  static const Color chipBackground = primaryColor;
  static const Color chipTextColor = Colors.white;

  // progress bar indicator
  static const Color progressIndicatorColor = Color(0xFF40A76A);

  // list tile
  static const Color listTileTitleColor = Color(0xFF575757);
  static const Color listTileSubtitleColor = Color(0xFF575757);
  static const Color listTileBackgroundColor = Color(0xFFF8F8F8);
  static const Color listTileIconColor = Color(0xFF575757);

  //------------------- custom theme (extensions) ------------------- //
  // header containers
  static const Color headerContainerBackgroundColor = Color(0XFF38B6F0);

  // employee list item
  static const Color employeeListItemBackgroundColor = Colors.white;
  static const Color employeeListItemNameColor = Color(0xFF4A4A4A);
  static const Color employeeListItemSubtitleColor = Color(0xFFA1A4B1);
  static const Color employeeListItemIconsColor = Color(0xFFA1A4B1);
}        
        ''';

  String localizationService = '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/data/local/my_shared_pref.dart';
import 'ar_Ar_translation.dart';
import 'ar_En_translation.dart';

class LocalizationService extends Translations {
  // prevent creating instance
  LocalizationService._();

  static LocalizationService? _instance;

  static LocalizationService getInstance() {
    _instance ??= LocalizationService._();
    return _instance!;
  }

  // default language
  // todo change the default language
  static Locale defaultLanguage = supportedLanguages['en']!;

  // supported languages
  static Map<String, Locale> supportedLanguages = {
    'en': const Locale('en', 'US'),
    'ar': const Locale('ar', 'AR'),
  };

  // supported languages fonts family (must be in assets & pubspec yaml) or you can use google fonts
  static Map<String, TextStyle> supportedLanguagesFontsFamilies = {
    // todo add your English font families (add to assets/fonts, pubspec and name it here) default is poppins for english and cairo for arabic
    'en': const TextStyle(fontFamily: 'Poppins'),
    'ar': const TextStyle(fontFamily: 'Cairo'),
  };

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'ar_AR': arAR,
      };

  /// check if the language is supported
  static isLanguageSupported(String languageCode) =>
      supportedLanguages.keys.contains(languageCode);

  /// update app language by code language for example (en,ar..etc)
  static updateLanguage(String languageCode) async {
    // check if the language is supported
    if (!isLanguageSupported(languageCode)) return;
    // update current language in shared pref
    await MySharedPref.setCurrentLanguage(languageCode);
    if (!Get.testMode) {
      Get.updateLocale(supportedLanguages[languageCode]!);
    }
  }

  /// check if the language is english
  static bool isItEnglish() =>
      MySharedPref.getCurrentLocal().languageCode.toLowerCase().contains('en');

  /// get current locale
  static Locale getCurrentLocal() => MySharedPref.getCurrentLocal();
}

  ''';

  String strings = '''
class Strings {
  static const String hello = 'Hello';
  static const String retry = 'Retry';
  static const String serverNotResponding = 'Server not responding';
  static const String noInternetConnection = 'No internet connection';
  static const String urlNotFound = 'Url not found';
  static const String serverError = "Server error";
}

  ''';

  String enUs = '''
import 'strings.dart';

final Map<String, String> enUs = {
  Strings.hello: 'Hello!',
};


        ''';

  String arAr = '''
import 'strings.dart';
  
final Map<String, String> arAR = {
  Strings.hello : 'مرحباً!',
};
        ''';
}
