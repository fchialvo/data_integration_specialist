global class ProjectCalloutServiceMock implements HttpCalloutMock {
    private static HttpRequest lastRequest;
    private static HttpResponse lastResponse;
    global HttpResponse respond(HttpRequest request){
        lastRequest = request;
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"status": "Success", "message": "Mock response"}');
        response.setStatusCode(201);

          // Save the response for later assertions
        lastResponse = response;

        return response;
    }

    public static HttpRequest getLastRequest() {
        return lastRequest;
    }

    public static HttpResponse getLastResponse() {
        return lastResponse;
    }
}