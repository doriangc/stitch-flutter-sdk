class StitchException implements Exception {    
    String _message;
  
    StitchException([String message = 'Stitch Exception']) {
      this._message = message;
    }
  
    @override
    String toString() {
      return _message;
    }
  }