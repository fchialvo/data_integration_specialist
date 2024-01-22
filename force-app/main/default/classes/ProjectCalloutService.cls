global class ProjectCalloutService{
    @InvocableMethod(label='Post Opportunity To PMS' category='Opportunity')
	public static void postOpportunityToPMS(List<Id> oppIds){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
		request.setEndpoint('callout:ProjectService');
        request.setMethod('POST');
     	request.setHeader('Authorization', 'Bearer ' + ServiceTokens__c.Token__c);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        
        List<Opportunity> opps = [SELECT Id, Name, AccountId, CloseDate, Amount FROM Opportunity WHERE Id =: oppIds];
        
        String body = '[';
        
        for(Opportunity opp: opps){
            body+= '{"opportunityId": '+JSON.serialize(opp.Id)+', "opportunityName": ' + JSON.serialize(opp.Name) + ', "accountName": ' + JSON.serialize(opp.AccountId) + ', "closeDate": ' + JSON.serialize(opp.CloseDate) + ', "amount": ' + JSON.serialize(opp.Amount) +'}';
        }
        
        body+=']';

        // Set the body as a JSON object
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
    }
    public class QueueablePMSCall implements Queueable , Database.AllowsCallouts{
        public void execute(QueueableContext context) {
            ID jobID = System.enqueueJob(new ProjectCalloutService());
        }
	}
}