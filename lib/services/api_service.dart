import 'dart:convert';

import 'package:currency_converter/utils/constants.dart';
import 'package:currency_converter/utils/string_asset.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiService{

  Future<dynamic> getConversionRate(String from,
      String to,
      String rate,
      BuildContext context
      ) async{
    try{
      String url = "${UrlAsset.baseUrl}${UrlAsset.getConversion}"
          "?access_key=${UrlAsset.apiKey}"
          "&symbols = GBP,JPY,EUR"
          "&base=USD";

      Uri urlUri = Uri.parse(url);
      http.Response response = await http.get(urlUri);

      print("Response is $response AND status code : ${response.statusCode}");
      var decode = jsonDecode(utf8.decode(response.bodyBytes));

      if(context.mounted && response.statusCode != 200){
        Constants.showErrorToast(context, decode?["error"]?["message"]?.toString() ?? "");
        return;
      }
      return decode["info"]["rate"];
    }catch(e){
      print("Error is : $e");
      return e;
    }
  }

}