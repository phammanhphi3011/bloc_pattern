enum EnvType {
  dev,
  prod,
}

class Env {
  final EnvType envType;
  final String apiBaseUrl;
  final String apiLoginUrl;
  final String clientId;
  final String clientSecret;
  final String resource;
  final String endPoint;
  final String actionPlugin;
  final String tenantId;

  Env._(
      {required this.tenantId,
        required this.envType,
        required this.apiBaseUrl,
        required this.apiLoginUrl,
        required this.clientId,
        required this.clientSecret,
        required this.resource,
        required this.endPoint,
        required this.actionPlugin});

  //dev
  factory Env.dev() {
    return Env._(
        envType: EnvType.dev,
        //apiBaseUrl: 'http://antrealestatemobliesales.azurewebsites.net/api',
        apiLoginUrl: 'https://login.microsoftonline.com/common/oauth2/token',
        apiBaseUrl: '/api/data/v9.0/',
        actionPlugin: 'ant_mobileservice',
        // resource: 'http://103.15.51.60:8889/api/',
        resource: 'http://103.15.51.60:7771/api/',
        endPoint: '103.15.51.60:7771',
        clientId: '1270c272-1ab3-4b86-9a34-8681e36dba68',
        clientSecret: '1o-o~.RDc81x1M.3R-W8TqoN7Kd2mA3_D.',
        tenantId: "6ba76517-0700-4532-a9a1-414139f50dc2");
  }

  factory Env.prod() {
    return Env._(
        envType: EnvType.prod,
        //apiBaseUrl: 'http://antrealestatemobliesales.azurewebsites.net/api',
        apiLoginUrl: 'https://login.microsoftonline.com/common/oauth2/token',
        apiBaseUrl: '/api/data/v9.0/',
        actionPlugin: 'ant_mobileservice',
        resource: 'https://ant-test.crm5.dynamics.com',
        endPoint: 'https://ant-test.crm5.dynamics.com',
        clientId: '1270c272-1ab3-4b86-9a34-8681e36dba68',
        clientSecret: '1o-o~.RDc81x1M.3R-W8TqoN7Kd2mA3_D.',
        tenantId: "6ba76517-0700-4532-a9a1-414139f50dc2");
  }
}

// Config env
// class AppConfig {
//   factory AppConfig({Env? env, AppTheme? theme}) {
//     if (env != null) {
//       I.env = env;
//     }
//     if (theme != null) {
//       I.theme = theme;
//     }
//     return I;
//   }
//
//   AppConfig._private();
//
//   static final AppConfig I = AppConfig._private();
//   Env env = Env.dev();
//   AppTheme theme = AppTheme.origin();
// }