class GetConversionModel {
  String? amount;
  String? result;
  String? documentation;
  String? termsOfUse;
  int? timeLastUpdateUnix;
  String? timeLastUpdateUtc;
  int? timeNextUpdateUnix;
  String? timeNextUpdateUtc;
  String? baseCode;
  String? targetCode;
  double? conversionRate;
  double? conversionResult;

  GetConversionModel(
      {this.result,this.amount,
        this.documentation,
        this.termsOfUse,
        this.timeLastUpdateUnix,
        this.timeLastUpdateUtc,
        this.timeNextUpdateUnix,
        this.timeNextUpdateUtc,
        this.baseCode,
        this.targetCode,
        this.conversionRate,
        this.conversionResult
      });

  GetConversionModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    documentation = json['documentation'];
    termsOfUse = json['terms_of_use'];
    timeLastUpdateUnix = json['time_last_update_unix'];
    timeLastUpdateUtc = json['time_last_update_utc'];
    timeNextUpdateUnix = json['time_next_update_unix'];
    timeNextUpdateUtc = json['time_next_update_utc'];
    baseCode = json['base_code'];
    targetCode = json['target_code'];
    conversionRate = json['conversion_rate'];
    conversionResult = json['conversion_result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['documentation'] = documentation;
    data['terms_of_use'] = termsOfUse;
    data['time_last_update_unix'] = timeLastUpdateUnix;
    data['time_last_update_utc'] = timeLastUpdateUtc;
    data['time_next_update_unix'] = timeNextUpdateUnix;
    data['time_next_update_utc'] = timeNextUpdateUtc;
    data['base_code'] = baseCode;
    data['target_code'] = targetCode;
    data['conversion_rate'] = conversionRate;
    return data;
  }
}
