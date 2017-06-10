@isTest
public class MockPredictionIOEventServerResponse implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('https://predictionioserver.herokuapp.com/events.json?accessKey=123', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{}');
        res.setStatusCode(201);
        return res;
    }
}