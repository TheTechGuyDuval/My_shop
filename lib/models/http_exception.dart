class HttpException implements Exception{
  //implement means forced to use all functions this class possesses
  final String message;

  HttpException(this.message);
  
  @override
  String toString() {
    // TODO: implement toString
    return message;
    // return super.toString();
  }

  

}