public class EinsteinVisionHttpUtility{
    
    /** This method makes HTTP POST,PUT Call from salesforce to Einstein Vision APIs
    * @param   blob , content type, endpoint ,Resquest type(POST/PUT),access Token
    * @return HttpResponse
    **/
    public static HttpResponse makeCallout(blob body,String contentType,String endPoint,String requestType,String accessToken){
        // Instantiate a new http object
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer '+accessToken);
        req.setHeader('Content-Type', contentType);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Cache-Control', 'no-cache');
        req.setEndpoint(endPoint);
        req.setBodyAsBlob(body);
        req.setMethod(requestType);
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        return res;
    }

    /** This method makes HTTP GET Call from salesforce to Einstein Vision APIs
    * @param    endpoint 
    * @return HttpResponse
    **/

    public static HttpResponse makegetCallout(String endpoint,String accessToken){
         // Instantiate a new http object
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer '+accessToken);
        req.setHeader('Cache-Control', 'no-cache');
        req.setHeader('Accept', 'application/json');
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        return res;
    }


}