@isTest
private class BillingCalloutTest {
    @isTest static void testProxySuccess() {              
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        
        BillingServiceProxy.project testProject = new BillingServiceProxy.project();
            testProject.billAmount = 300;
            testProject.projectid = '123';
            testProject.username = 'test user';
            testProject.password = 'test pasword';
        
        // Call the method that invokes a callout
        BillingServiceProxy.InvoicesPortSoap11 sp = new BillingServiceProxy.InvoicesPortSoap11();
        String output = sp.billProject(testProject);
        
        // Verify that a fake result is returned
        System.assertEquals('Mock response', output); 
    }
    
     @isTest static void testProxyFailure() {              
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        
        BillingServiceProxy.project testProject = new BillingServiceProxy.project();
            testProject.billAmount = 300;
            testProject.projectid = '123';
            testProject.username = 'test user';
            testProject.password = 'test pasword';
        
        // Call the method that invokes a callout
        BillingServiceProxy.InvoicesPortSoap11 sp = new BillingServiceProxy.InvoicesPortSoap11();
        String output = sp.billProject(testProject);
        
        // Verify that a fake result is returned
        System.assertEquals('Mock failure', output); 
    }
        
    @isTest
    static void testCallBillingService() {
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

        Test.startTest();
        ServiceCredentials__c testCredentials = new ServiceCredentials__c(
            Username__c = 'testUsername',
            Password__c = 'testPassword',
            Name = 'testCredentials'
        );
        insert testCredentials;

        String projectRef = 'testProjectRef';
        Decimal amount = 100.0;
        String status = 'Billable';
        BillingCalloutService.callBillingService(status, projectRef, amount);
        Test.stopTest();
        
        
        
        System.assertEquals('Mock Status', BillingCalloutService.successStatus, 'Expected "Mock Status" status');


        Test.startTest();
        status = 'NonBillable';

        BillingCalloutService.callBillingService(status, projectRef, amount);
        Test.stopTest();
        
        System.assertEquals(null, BillingCalloutService.successStatus, 'Expected null status for non-billable project');


    }
}