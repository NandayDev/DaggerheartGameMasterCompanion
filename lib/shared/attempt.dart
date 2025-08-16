class Attempt {
  Attempt.success();

  Attempt.failure(this._exception);

  Exception? _exception;

  bool isSuccess() => _exception == null;

  Exception? exceptionOrNull() => _exception;

  Exception exceptionOrThrow() => _exception!;

  Attempt onSuccess(Function() function) {
    if (isSuccess()) {
      function();
    }
    return this;
  }

  Attempt onFailure(Function(Exception) function) {
    final exception = _exception;
    if (exception != null) {
      function(exception);
    }
    return this;
  }
}
