enum ApiEnvironment { debug, profile, production }

enum MediaEnvironment { debug, profile, production }

class ApiConfig {
  static const ApiEnvironment apiCurrentEnv = ApiEnvironment.debug;
  static const MediaEnvironment mediaCurrentEnv = MediaEnvironment.production;

  static const bool encryptRequests = false;
  static const bool decryptResponses = false;
  static const bool isAddCompanyInfo = false;

  static const bool useHttps = false;

  static String get protocol => useHttps ? "https" : "http";

  static const _devApiDomain = "192.168.201.157:3690";
  static const _profileApiDomain = "";
  static const _prodApiDomain = "";

  // static const _devMediaCdn = "cdn.softample.com";
  // static const _profileMediaCdn = "cdn.softample.com";
  // static const _prodMediaCdn = "cdn.softample.com";

  static const String companyId = "";
  static const String fernetKey = "";
  static const String apiKey = "";
  static const String mediaApiKey = "";
  static const String mediaApiEncKey = " ";

  static String get domain {
    switch (apiCurrentEnv) {
      case ApiEnvironment.debug:
        return _devApiDomain;
      case ApiEnvironment.profile:
        return _profileApiDomain;
      case ApiEnvironment.production:
        return _prodApiDomain;
    }
  }

  // static String get cdnDomain {
  //   switch (mediaCurrentEnv) {
  //     case MediaEnvironment.debug:
  //       return _devMediaCdn;
  //     case MediaEnvironment.profile:
  //       return _profileMediaCdn;
  //     case MediaEnvironment.production:
  //       return _prodMediaCdn;
  //   }
  // }

  static String get baseUrl => "$protocol://$domain";
  // static String get cdnUrl => "$protocol://$cdnDomain";
}

class ApiEndpoints {
  static String get refresh => "NOT USED";
  static String get login => "${ApiConfig.baseUrl}/login/";
  static String get getData => "${ApiConfig.baseUrl}/getData/";
  static String get getPradeshItems => "${ApiConfig.baseUrl}/getPradeshItems/";
  static String get getDefaultPradeshItems => "${ApiConfig.baseUrl}/getDefaultPradeshItems/";
  static String get createNewEvent => "${ApiConfig.baseUrl}/createNewEvent/";

}
