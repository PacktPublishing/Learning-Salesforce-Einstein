public with sharing class HttpUtil {

  public HttpResponse invokePostRequest(String endPoint,String requestbody) {
    // Instantiate a new http object
    Http h = new Http();
     // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endPoint);
    req.setMethod('POST');
    req.setBody(requestbody);
    req.setHeader('Content-Type','application/json');
    // Send the request, and return a response
    HttpResponse res = h.send(req);
    return res ;
  }

}