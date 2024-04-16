enum Method {
  HEAD,
  GET,
  POST,
  PUT,
  PATCH,
  DELETE,
}

Method methodFromString(String method) {
  switch (method.toLowerCase()) {
    case "head":
      return Method.HEAD;
    case "get":
      return Method.GET;
    case "post":
      return Method.POST;
    case "put":
      return Method.PUT;
    case "patch":
      return Method.PATCH;
    case "delete":
      return Method.DELETE;
    default:
      throw ArgumentError('Invalid HTTP method: $method');
  }
}
