import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_baetles_chord_play/data/source/remote_data_source.dart';

class AuthRepository {
  static final AuthRepository _instance = AuthRepository._internal();
  late final RemoteDataSource _remoteDataSource;

  factory AuthRepository() {
    return _instance;
  }

  AuthRepository._internal() {
    _remoteDataSource = RemoteDataSource();
  }

  Future<bool> login(String idToken) async {
    return (await _remoteDataSource.login(idToken));
  }

  Future<String?>? fetchIdToken({bool forceRefresh = false}) async {
    return await FirebaseAuth.instance.currentUser?.getIdToken(forceRefresh);
  }

  String? fetchUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<bool> isNicknameValid(String nickname) async {
    return await _remoteDataSource.checkNicknameValid((await fetchIdToken())!, nickname); // dummy data
  }

  Future<String> getNicknameSuggestion() async {
    return await _remoteDataSource.getNicknameSuggestion((await fetchIdToken())!);
  }
}
