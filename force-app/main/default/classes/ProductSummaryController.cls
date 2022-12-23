public with sharing class ProductSummaryController {
    
    /**
     * @description  make query to get case record
     * @author       Mikel Nieto 
     * @date         Dec, 2022
     * @param        Id caseId
     * @return       Case caseAct
     **/
    @AuraEnabled(cacheable=true)
    public static Case getCase(Id caseId){
        Case caseAct;
        List<Case> caseList = [SELECT Id, ContactId, Contact.Product__c,
                        Contact.Product__r.name, Contact.Home_Country__c                       
                       FROM Case
                       WHERE Id =:caseId];

        if(!caseList.isEmpty())
        {
            caseAct = caseList.get(0);
        }

        return caseAct;
    }

    /**
     * @description  make query to get Service Products records
     * @author       Mikel Nieto 
     * @date         Apr, 2022
     * @param        Case c
     * @return       List<Service_Charge__c>  serviceProducts
     **/
    @AuraEnabled
    public static List<Service_Product__c> getServiceProducts(Case c){
        List<Service_Product__c> serviceProducts = new List<Service_Product__c>();
        if(c != null && c.ContactId != null &&  c.Contact.Home_Country__c != null && c.Contact.Product__c != null){
            serviceProducts = [SELECT Id, Price__c, Country_Code__c, Is_Free__c, Currency_Type__c,
                                Service__c, Service__r.Name, Product__c, Product__r.Name
                                FROM Service_Product__c
                                WHERE Product__c =: c.Contact.Product__c
                                AND Product__r.IsActive = true
                                AND Country_Code__c =: c.Contact.Home_Country__c];
        }
        return serviceProducts;
    }

}