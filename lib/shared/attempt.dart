class Attempt {
  Attempt.success();

  Attempt.failure(this._exception);

  Exception? _exception;

  bool isSuccess() => _exception == null;

  Exception? exceptionOrNull() => _exception;

  Exception exceptionOrThrow() => _exception!;

  void onSuccess(Function() function) {
    if (isSuccess()) {
      function();
    }
  }

  void onFailure(Function(Exception) function) {
    final exception = _exception;
    if (exception != null) {
      function(exception);
    }
  }
}
