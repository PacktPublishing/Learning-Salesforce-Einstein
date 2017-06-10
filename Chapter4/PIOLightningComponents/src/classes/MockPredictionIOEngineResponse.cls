@isTest
public class MockPredictionIOEngineResponse implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('https://nameless-spire-13670.herokuapp.com/queries.json', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"itemScores":[{"item":"i4","score":0.3},{"item":"i5","score":1.0}]}');
        res.setStatusCode(200);
        return res;
    }
}