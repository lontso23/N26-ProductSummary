@isTest
public class WS_REST_ServiceProducts_Test {
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
                                email = 'test@gmail.com',
                                UUID__c = '123456' );
        insert c;

        Contact  c1 = new Contact(FirstName = 'Test1',
                                LastName = 'User1',
                                Home_Country__c = 'ES',
                                email = 'test1@gmail.com',
                                UUID__c = '014789' );
        insert c1;
        
        Case cs = new Case(Subject = 'caseTest',
                          ContactId = c.Id,
                          Status = 'New',
                          Origin = 'Email');
        insert cs;
        
    }
    
    
    @isTest
    public static void productInfoHttpGet() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ServiceProductsRest/123456'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        WS_REST_ServiceProducts.WS_Response response = WS_REST_ServiceProducts.getServiceProductsByClient();
        Test.stopTest();
        
        System.assertEquals(response.message, 'success');
        System.assertEquals(response.product, 'Metal');
        System.assertEquals(response.services.size(), 2);
    }

    @isTest
    public static void noProductInfoHttpGet() {

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ServiceProductsRest/014789'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        WS_REST_ServiceProducts.WS_Response response = WS_REST_ServiceProducts.getServiceProductsByClient();
        Test.stopTest();
        
        System.assertEquals(response.status, 'KO');
        System.assertEquals(response.message, 'There are no products for this client');
    }

    @isTest
    public static void missingUUIDHttpGet() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ServiceProductsRest/'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        WS_REST_ServiceProducts.WS_Response response = WS_REST_ServiceProducts.getServiceProductsByClient();
        Test.stopTest();
        
        System.assertEquals(response.status, 'KO');
        System.assertEquals(response.message, 'UUID is missing');
    }

    @isTest
    public static void noCustomerFoundHttpGet() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ServiceProductsRest/0000'; 
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        WS_REST_ServiceProducts.WS_Response response = WS_REST_ServiceProducts.getServiceProductsByClient();
        Test.stopTest();
        
        System.assertEquals(response.status, 'KO');
        System.assertEquals(response.message, 'Customer not found ');
    }
}
