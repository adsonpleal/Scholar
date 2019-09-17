import 'dart:async';
import 'dart:convert';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:http/http.dart' as http;
import 'ufsc_decoders.dart';
// ignore: uri_does_not_exist
import 'dart:js' as js;

const _clientId = 'tccleal';
const _redirectUri = 'tccleal://tccleal.setic_oauth.ufsc.br';
const _responseType = 'code';
const _state = 'E3ZYKC1T6H2yP4z';
const _clientSecret = 'midMosocIbCenodnoiclUtItsyoirs';
const _ufscCas = 'https://sistemas.ufsc.br';
const _authorizationUrl =
    "$_ufscCas/oauth2.0/authorize?client_id=$_clientId&redirect_uri=$_redirectUri&response_type=$_responseType&state=$_state";
const _accessTokenUrl = "$_ufscCas/oauth2.0/accessToken";
const _apiUrl = 'https://ws.ufsc.br/rest/CAGRUsuarioService/';
const _userTimeGrid = 'getGradeHorarioAluno';
const _userInfo = 'getInformacaoAluno';

class UfscService {
  final UserDataRepository _userData = inject();

  Stream<bool> launchAuthorization() async* {
    yield true;
    js.context['location'].callMethod('replace', [_authorizationUrl]);
  }

  Stream<bool> checkAuthentication() async* {
    final code = _getCodeFromUrl();
    if (code != null) {
      yield true;
      try {
        await _fetchSubjects(code);
      } catch (e, stacktrace) {
        print("$e: $stacktrace");
      }
      yield false;
    }
  }

  Uri _buildAccessTokenUri(String code) => Uri.parse(
      "$_accessTokenUrl?grant_type=authorization_code&code=$code&client_id=$_clientId&redirect_uri=$_redirectUri&client_secret=$_clientSecret");

  Future<dynamic> _performGet(String path, String authToken) async {
    final response = await http.get(Uri.parse("https://scholar-cors.herokuapp.com/$_apiUrl$path"), headers: {
      'Authorization': "Bearer $authToken",
    });
    return json.decode(response.body);
  }

  Future<void> _saveUserInformation(String accessToken) async {
    final userInformation = await _performGet(_userInfo, accessToken);
    await _userData.saveInformation(userInformation);
  }

  String _getCodeFromUrl() {
    final paramsString = js.context['location']['search'];
    final params =
        paramsString.substring(1).split("&").fold({}, (newMap, param) {
      final paramArray = param.split('=');
      newMap[paramArray[0]] = paramArray[1];
      return newMap;
    });
    return params['code'];
  }

  Future<void> _fetchSubjects(String code) async {
    final accessUri = _buildAccessTokenUri(code);
    final response = await http.get("https://scholar-cors.herokuapp.com/$accessUri");
    response.headers.addAll({});
    final accessToken = _parseAccessToken(response.body);
    final timeGrid = await _performGet(_userTimeGrid, accessToken);
    final settings = await _userData.settings;
    try {
      final subjects = decodeSubjects(timeGrid);
      await _userData.replaceSubjects(subjects);
      await _saveUserInformation(accessToken);
    } catch (e, stacktrace) {
      print("$e: $stacktrace");
    }
    await _userData.saveSettings(
      settings.rebuild((b) => b
        ..restaurantId = 'trindade'
        ..accessToken = accessToken
        ..connected = true),
    );
  }

  String _parseAccessToken(String str) =>
      RegExp(r"access_token=(.*)&").firstMatch(str)?.group(1);
}
