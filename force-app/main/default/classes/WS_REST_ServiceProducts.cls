@RestResource(urlMapping='/ServiceProductsRest/*')
global class WS_REST_ServiceProducts {
    
    /**
     * @description  web service to get clients service products information
     * @author       Mikel Nieto 
     * @date         Dec, 2022
     * @param        
     * @return       WS_Response
     **/
    @HttpGet
    global static WS_Response getServiceProductsByClient() {
        RestRequest request = RestContext.request;
        String uuid = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        system.debug('# URI ' + request.requestURI);
        system.debug('# uuid' + uuid);
        WS_Response response = getServiceProductsByClient_Response(uuid);
        return response;
    }

    /**
     * @description  generate ws response with the results and checking if the ws parameters are not missed, if there is 
     * customers with the UUID external ID and if the customer has products releated
     * @author       Mikel Nieto 
     * @date         Dec, 2022
     * @param        String uuid
     * @return       WS_Response
     **/
    private static WS_Response getServiceProductsByClient_Response(String uuid){

        WS_Response ws_response = new WS_Response();
        if(uuid == null || String.isEmpty(uuid))
        {
            ws_response.message = 'UUID is missing';
            ws_response.status = 'KO';
        }
        else
        {
            ws_response.uuid = uuid;                
            List<Contact> contacts = [SELECT Id, Name, Product__c, Product__r.Name,
                                        Home_Country__c, UUID__c  
                                        FROM Contact 
                                        WHERE UUID__c  =: uuid];
            
            if(contacts.isEmpty())
            {
                ws_response.message = 'Customer not found ';
                ws_response.status = 'KO';
            }
            else
            {
                
                if(contacts.get(0).Product__c != null && contacts.get(0).Home_Country__c != null){
                    ws_response.product = contacts.get(0).Product__r.Name;
                    ws_response.services = new List<Service_Product__c>();
                    ws_response.services = [SELECT Id, Price__c, Country_Code__c, Is_Free__c, Currency_Type__c,
                                                Service__c, Service__r.Name, Product__c, Product__r.Name
                                                FROM Service_Product__c
                                                WHERE Product__c =: contacts.get(0).Product__c
                                                AND Product__r.IsActive = true 
                                                AND Country_Code__c =: contacts.get(0).Home_Country__c];
                    ws_response.client = contacts.get(0);
                    ws_response.message = 'success';
                    ws_response.status = 'OK';
                }else
                {
                    ws_response.message = 'There are no products for this client';
                    ws_response.status = 'KO';
                }
            }
        }

        return ws_response;
    }

    global class WS_Response {
    
        public Contact client {get; set;}
        public string product { get; set; }
        public List<Service_Product__c> services { get; set; }       
        public String uuid { get; set; }
        public String status {get; set;}
        public string message { get; set; }
    }
}
