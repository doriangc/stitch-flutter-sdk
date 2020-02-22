class StitchError extends Error {    
  String _message;

  StitchError([String message = 'Stitch Exception']) {
    this._message = message;
  }

  @override
  String toString() {
    return _message;
  }
}