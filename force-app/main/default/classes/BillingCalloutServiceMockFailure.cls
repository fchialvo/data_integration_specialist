@isTest
global class BillingCalloutServiceMockFailure implements WebServiceMock {
    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {

        // Simulate a failure scenario
        BillingServiceProxy.billProjectResponse_element respElement = 
            new BillingServiceProxy.billProjectResponse_element();
        respElement.Status = 'Mock failure'; // Set a status indicating failure
        response.put('response_x', respElement);
    }
}