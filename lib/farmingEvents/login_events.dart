abstract class LoginEvents {}

class NotLoggedIn extends LoginEvents {
  NotLoggedIn();
}

class LoggedIn extends LoginEvents {
  LoggedIn();
}

class LoadingLogin extends LoginEvents {
  LoadingLogin();
}

class ErrorLogin extends LoginEvents {
  ErrorLogin();
}
