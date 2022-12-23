@isTest
public class ProductSummaryController_Test {
    @testSetup
    public static void setUp()
    {
        Product2 p = new Product2(Name = 'Metal', IsActive = true);
        insert p;

        List<Service__c> servList = new List<Service__c>();
        Service__c s1 =new Service__c(Name = 'Cost per Calendar Month');
        servList.add(s1);
        Service__c s2 =new Service__c(Name = 'Card Replacement Cost');
        servList.add(s2);        
        
        insert servList;
        List<Service_Product__c> splist = new List<Service_Product__c>();
            
        Service_Product__c sp1 = new Service_Product__c(
                Product__c = p.Id,
                Service__c = s1.Id,
                Price__c = 106.87,
                Is_Free__c = false,
                Currency_Type__c = 'EUR',
                Country_Code__c = 'ES');

        splist.add(sp1);
        Service_Product__c sp2 = new Service_Product__c(
            Product__c = p.Id,
            Service__c = s2.Id,
            Is_Free__c = true,
            Currency_Type__c = 'EUR',
            Country_Code__c = 'ES');
        
        splist.add(sp2);
        insert splist; 
            
        Contact  c = new Contact(FirstName = 'Test',
                                LastName = 'User',
                                 Product__c = p.Id,
                                Home_Country__c = 'ES',
                                email = 'test@gmail.com' );
        insert c;
        
        Case cs = new Case(Subject = 'caseTest',
                          ContactId = c.Id,
                          Status = 'New',
                          Origin = 'Email');
        insert cs;
        
    }
    
    @isTest
    public static void getServiceProductsTest(){
        Id caseId = [Select Id from Case where Status ='New'].Id;        
        Test.startTest();
        Case c = ProductSummaryController.getCase(caseId);
        List<Service_Product__c> serviceProd = ProductSummaryController.getServiceProducts(c);
        Test.stopTest();
        System.assertEquals(serviceProd.size(), 2);
    }
    
}