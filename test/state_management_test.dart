import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:thunder_cli/thunder_cli.dart';

import 'postman_collection_test.dart' show collection;

void main() {
  group('StateManagement', () {
    test('tryParse', () {
      expect(StateManagement.tryParse('GetX'), StateManagement.getx);
      expect(StateManagement.tryParse(' bloc '), StateManagement.bloc);
      expect(StateManagement.tryParse('cubit'), StateManagement.cubit);
      expect(StateManagement.tryParse('riverpod'), isNull);
      expect(StateManagement.tryParse(null), isNull);
    });
  });

  group('ProjectService.stateManagement', () {
    late Directory dir;

    setUp(() {
      dir = Directory.systemTemp.createTempSync('thunder_test_');
      File(p.join(dir.path, 'pubspec.yaml')).writeAsStringSync(
          'name: demo\ndependencies:\n  flutter:\n    sdk: flutter\n');
    });
    tearDown(() => dir.deleteSync(recursive: true));

    void touch(String path) => File(p.join(dir.path, path))
      ..createSync(recursive: true)
      ..writeAsStringSync('');

    test('reads thunder.json', () {
      File(p.join(dir.path, 'thunder.json'))
          .writeAsStringSync('{"state_management": "cubit"}');
      expect(ProjectService.find(dir.path)!.stateManagement,
          StateManagement.cubit);
    });

    test('defaults to GetX', () {
      expect(
          ProjectService.find(dir.path)!.stateManagement, StateManagement.getx);
    });

    test('detects BLoC and Cubit projects', () {
      touch('lib/core/di/injection.dart');
      touch('lib/app/features/home/bloc/home_bloc.dart');
      expect(
          ProjectService.find(dir.path)!.stateManagement, StateManagement.bloc);
      touch('lib/app/features/home/cubit/home_cubit.dart');
      expect(ProjectService.find(dir.path)!.stateManagement,
          StateManagement.cubit);
    });
  });

  group('BlocStrings', () {
    test('bloc feature files', () {
      final bloc =
          BlocStrings.instance.bloc('order_details', packageName: 'shop');
      expect(
          bloc,
          contains(
              'class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState>'));
      expect(bloc, contains("part 'order_details_event.dart';"));
      expect(
          bloc,
          contains(
              "import 'package:shop/app/repositories/order_details_repo.dart';"));
      expect(
          BlocStrings.instance.event('order_details'),
          contains(
              'final class OrderDetailsStarted extends OrderDetailsEvent'));
      expect(BlocStrings.instance.state('order_details', cubit: false),
          contains("part of 'order_details_bloc.dart';"));
      final view = BlocStrings.instance
          .view('order_details', packageName: 'shop', cubit: false);
      expect(
          view, contains('sl<OrderDetailsBloc>()..add(OrderDetailsStarted())'));
      expect(view, contains("CustomText(txt: 'Order Details')"));
    });

    test('cubit feature files', () {
      expect(BlocStrings.instance.cubit('profile', packageName: 'shop'),
          contains('class ProfileCubit extends Cubit<ProfileState>'));
      expect(BlocStrings.instance.state('profile', cubit: true),
          contains("part of 'profile_cubit.dart';"));
      expect(
          BlocStrings.instance
              .view('profile', packageName: 'shop', cubit: true),
          contains('BlocBuilder<ProfileCubit, ProfileState>'));
    });
  });

  group('ApiCodeGenerator (BLoC / Cubit)', () {
    final parsed = PostmanCollectionParser.parse(collection());
    final auth = parsed.requests.where((r) => r.group == 'auth').toList();
    final products =
        parsed.requests.where((r) => r.group == 'products').toList();

    test('one event per request', () {
      final events = ApiCodeGenerator.blocEvents('products', products);
      expect(events,
          contains('final class GetProductRequested extends ProductsEvent'));
      expect(events, contains('final String id;'));
      final bloc = ApiCodeGenerator.bloc('products', products, 'shop');
      expect(bloc, contains('on<GetProductRequested>(_onGetProduct);'));
      expect(bloc, contains('productsRepo.getProduct(event.id)'));
    });

    test('state keeps the typed responses', () {
      final state = ApiCodeGenerator.blocState('auth', auth, cubit: true);
      expect(state, contains("part of 'auth_cubit.dart';"));
      expect(state, contains('final LoginResponseModel? loginResponse;'));
      expect(state, contains('AuthState copyWith({'));
    });

    test('cubit has one method per request', () {
      final cubit = ApiCodeGenerator.cubit('auth', auth, 'shop');
      expect(cubit, contains('Future<void> login(LoginBodyModel body) async'));
      expect(cubit,
          contains('loginResponse: LoginResponseModel.fromJson(result.data)'));
    });
  });

  group('LocalizationFiles for BLoC / Cubit', () {
    test('local.dart without GetX', () {
      final local = LocalizationFiles.localFile(['en', 'fr'], getx: false);
      expect(local, isNot(contains('package:get')));
      expect(local, contains('class MyLocal {'));
      expect(local, isNot(contains('@override')));
    });

    test('supportedLocales follows the languages', () {
      const service =
          'static const supportedLocales = [Locale(\'en\'), Locale(\'ar\')];';
      expect(
        LocalizationFiles.updateSupportedLocales(
            service, ['en', 'ar', 'zh_cn']),
        "static const supportedLocales = [Locale('en'), Locale('ar'), Locale('zh', 'CN')];",
      );
    });
  });
}
