class Result<T> {
  Result.success(this._result);

  Result.failure(this._exception);

  T? _result;
  Exception? _exception;

  bool isSuccess() => _result != null;

  T? getOrNull() => _result;

  T getOrThrow() => _result!;

  Exception? exceptionOrNull() => _exception;

  Exception exceptionOrThrow() => _exception!;

  void onSuccess(Function(T) function) {
    final result = _result;
    if (result != null) {
      function(result);
    }
  }

  void onFailure(Function(Exception) function) {
    final exception = _exception;
    if (exception != null) {
      function(exception);
    }
  }
}
