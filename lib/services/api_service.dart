import 'dart:convert';

import 'package:currency_converter/utils/constants.dart';
import 'package:currency_converter/utils/string_asset.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'get_conversion_model.dart';

class ApiService{

  Future<GetConversionModel?> getConversionRate(String from,
      String to,
      String rate,
      BuildContext context
      ) async{
    try{
      String url = "${UrlAsset.baseUrl}${UrlAsset.apiKey}"
          "/${UrlAsset.getConversion}"
          "/$from/$to/$rate";


      Uri urlUri = Uri.parse(url);
      http.Response response = await http.get(urlUri);
      var decode = jsonDecode(utf8.decode(response.bodyBytes));

      print("Response decode is $decode AND status code : ${response.statusCode}");

      if(context.mounted && response.statusCode != 200){
        Constants.showErrorToast(
          context,
          "${decode?["result"]?.toString() ?? ""} : ${decode?["error-type"]?.toString() ?? ""}"
        );
        return null;
      }
      return GetConversionModel.fromJson(decode);
    }catch(e){
      print("Error is : $e");
      return null;
    }
  }

}