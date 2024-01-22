public class BillingCalloutService {
    public static String successStatus; // Variable to store the success status

    @future(callout=true)
    public static void callBillingService(String Status, String ProjectRef, Decimal Amount){
        if(Status == 'Billable'){
            BillingServiceProxy.project newProject = new BillingServiceProxy.project();
            ServiceCredentials__c sc = ServiceCredentials__c.getOrgDefaults();
            newProject.billAmount = Amount;
            newProject.projectid = ProjectRef;
            newProject.username = sc.Username__c;
            newProject.password = sc.Password__c;
            
            BillingServiceProxy.InvoicesPortSoap11 invoices = new BillingServiceProxy.InvoicesPortSoap11();
            String newProjectStatus = invoices.billProject(newProject);
            if(newProjectStatus == 'Billed'){
                successStatus = 'Billed successfully';
            }
            else if(newProjectStatus == 'Mock Response'){
                successStatus = 'Mock Status';
            }
        }
    }
}