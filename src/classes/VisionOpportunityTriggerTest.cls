//This test class tests the code for vision opportunity trigger handler.
@isTest
private class VisionOpportunityTriggerTest {
    
    //This testmethod tests the case where vision opportunity has the same invoice number as one of the opportunity.
    static testMethod void testSameInvoiceNumberForInsertion() {
        
         //creating the hierarchical custom setting and setting its value.
        ValidationActivationSetting__c setting=ValidationActivationSetting__c.getInstance(Userinfo.getUserId()); 
        setting.Activate_Validation_Rule__c=true;
        insert setting;
        
        //creating and inserting opportunity test data.
        List<Opportunity> opportunityTestRecord=TestDataUtilityClass.createOpportunity(4,'Prospecting',System.Today(),1400.00);
        opportunityTestRecord[0].Invoice_Number__c=100;
        opportunityTestRecord[1].Invoice_Number__c=200;
        opportunityTestRecord[2].Invoice_Number__c=300;
        opportunityTestRecord[3].Invoice_Number__c=400;
        insert opportunityTestRecord;
        
        //creating and inserting product test data.
        List<Product2> testProductRecord=TestDataUtilityClass.createProduct(1);
        insert testProductRecord;
        
        //creating and inserting pricebookentry test data.
        List<PriceBookEntry> testPriceBookEntryRecord=TestDataUtilityClass.createPriceBookEntry(1,200.00,false);
        testPriceBookEntryRecord[0].Pricebook2Id=Test.getStandardPricebookId();
        testPriceBookEntryRecord[0].Product2Id=testProductRecord[0].Id;
        insert testPriceBookEntryRecord;
        
        //creating and inserting opportunity line item test data.
        List<OpportunityLineItem> testOpportunityLineItemRecord=TestDataUtilityClass.createOpportunityLineItem(2,opportunityTestRecord[0].Id,testPriceBookEntryRecord[0].Id,2,100.00);
        insert testOpportunityLineItemRecord;
        
        //creating and inserting account test data.
        List<Account> testAccountRecord=TestDataUtilityClass.createAccount(1,'Anjali');
        insert testAccountRecord;
        
        //creating and inserting contact test data.
        List<Contact> testContactRecord=TestDataUtilityClass.createContact(1,'Rohit','Kumar');
        testContactRecord[0].AccountId=testAccountRecord[0].Id;
        insert testContactRecord;
        
        //creating and inserting vision opportunity test data.
        List<Vision_Opportunity__c> testVisionOpportunityRecord=TestDataUtilityClass.createVisionOpportunity(3,200.00,System.today(),testContactRecord[0].Id,'Prospecting','testVision');
        testVisionOpportunityRecord[0].Invoice_Number__c=100;
        testVisionOpportunityRecord[1].Invoice_Number__c=101;
        testVisionOpportunityRecord[2].Invoice_Number__c=102;
        
        Test.startTest();
        insert testVisionOpportunityRecord;
        Test.stopTest();
        List<Opportunity> clonedRecords=[SELECT Id
                                              , Vision_Lookup__c
                                           FROM Opportunity 
                                          WHERE StageName='Closed Won'];
        List<OpportunityLineItem> lineItemRecords=[SELECT Id
                                                        , OpportunityId
                                                     FROM OpportunityLineItem
                                                    WHERE OpportunityId=:clonedRecords[0].Id];
                                                    
        system.assertEquals(1,clonedRecords.size());
        system.assertEquals(2,lineItemRecords.size());
        system.assertEquals(opportunityTestRecord[0].Id,clonedRecords[0].Vision_Lookup__c);
    }
    
    //This testmethod tests the case where invoice number of vision opportunity and existing opportunity don't match.
    static testMethod void testDifferentInvoiceNumberForInsertion() {
        
         //creating the hierarchical custom setting and setting its value.
        ValidationActivationSetting__c setting=ValidationActivationSetting__c.getInstance(Userinfo.getUserId()); 
        setting.Activate_Validation_Rule__c=true;
        insert setting;
        
        //creating and inserting opportunity test data.
        List<Opportunity> opportunityTestRecord=TestDataUtilityClass.createOpportunity(4,'Prospecting',System.Today(),1400.00);
        opportunityTestRecord[0].Invoice_Number__c=1000;
        opportunityTestRecord[1].Invoice_Number__c=200;
        opportunityTestRecord[2].Invoice_Number__c=300;
        opportunityTestRecord[3].Invoice_Number__c=400;
        insert opportunityTestRecord;
        
        //creating and inserting product test data.
        List<Product2> testProductRecord=TestDataUtilityClass.createProduct(1);
        insert testProductRecord;
        
        //creating and inserting pricebookentry test data.
        List<PriceBookEntry> testPriceBookEntryRecord=TestDataUtilityClass.createPriceBookEntry(1,200.00,false);
        testPriceBookEntryRecord[0].Pricebook2Id=Test.getStandardPricebookId();
        testPriceBookEntryRecord[0].Product2Id=testProductRecord[0].Id;
        insert testPriceBookEntryRecord;
        
        //creating and inserting opportunity line item test data.
        List<OpportunityLineItem> testOpportunityLineItemRecord=TestDataUtilityClass.createOpportunityLineItem(2,opportunityTestRecord[0].Id,testPriceBookEntryRecord[0].Id,2,100.00);
        insert testOpportunityLineItemRecord;
        
        //creating and inserting account test data.
        List<Account> testAccountRecord=TestDataUtilityClass.createAccount(1,'Anjali');
        insert testAccountRecord;
        
        //creating and inserting contact test data.
        List<Contact> testContactRecord=TestDataUtilityClass.createContact(1,'Rohit','Kumar');
        testContactRecord[0].AccountId=testAccountRecord[0].Id;
        insert testContactRecord;
        
        //creating and inserting vision opportunity test data.
        List<Vision_Opportunity__c> testVisionOpportunityRecord=TestDataUtilityClass.createVisionOpportunity(3,200.00,System.today(),testContactRecord[0].Id,'Prospecting','testVision');
        testVisionOpportunityRecord[0].Invoice_Number__c=100;
        testVisionOpportunityRecord[1].Invoice_Number__c=101;
        testVisionOpportunityRecord[2].Invoice_Number__c=102;
        
        Test.startTest();
        insert testVisionOpportunityRecord;
        Test.stopTest();
        List<Opportunity> clonedRecords=[SELECT Id
                                              , Vision_Lookup__c
                                           FROM Opportunity 
                                          WHERE StageName='Closed Won'];
        List<Opportunity> newCreatedRecords=[SELECT Id
                                                  , Invoice_Number__c
                                               FROM Opportunity
                                              WHERE Invoice_Number__c=100
                                                 OR Invoice_Number__c=101
                                                 OR Invoice_Number__c=102];
        system.assertEquals(0,clonedRecords.size());
        system.assertEquals(3,newCreatedRecords.size());
    }
    
     //This testmethod tests the case where invoice number of vision opportunity and existing opportunity don't match and customer id has no account.
    static testMethod void testCustomerHavingNoAccountForInsertion() {
        
         //creating the hierarchical custom setting and setting its value.
        ValidationActivationSetting__c setting=ValidationActivationSetting__c.getInstance(Userinfo.getUserId()); 
        setting.Activate_Validation_Rule__c=true;
        insert setting;
        
        //creating and inserting opportunity test data.
        List<Opportunity> opportunityTestRecord=TestDataUtilityClass.createOpportunity(4,'Prospecting',System.Today(),1400.00);
        opportunityTestRecord[0].Invoice_Number__c=1000;
        opportunityTestRecord[1].Invoice_Number__c=200;
        opportunityTestRecord[2].Invoice_Number__c=300;
        opportunityTestRecord[3].Invoice_Number__c=400;
        insert opportunityTestRecord;
        
        //creating and inserting product test data.
        List<Product2> testProductRecord=TestDataUtilityClass.createProduct(1);
        insert testProductRecord;
        
        //creating and inserting pricebookentry test data.
        List<PriceBookEntry> testPriceBookEntryRecord=TestDataUtilityClass.createPriceBookEntry(1,200.00,false);
        testPriceBookEntryRecord[0].Pricebook2Id=Test.getStandardPricebookId();
        testPriceBookEntryRecord[0].Product2Id=testProductRecord[0].Id;
        insert testPriceBookEntryRecord;
        
        //creating and inserting opportunity line item test data.
        List<OpportunityLineItem> testOpportunityLineItemRecord=TestDataUtilityClass.createOpportunityLineItem(2,opportunityTestRecord[0].Id,testPriceBookEntryRecord[0].Id,2,100.00);
        insert testOpportunityLineItemRecord;
        
        //creating and inserting contact test data.
        List<Contact> testContactRecord=TestDataUtilityClass.createContact(1,'Rohit','Kumar');
        insert testContactRecord;
        
        //creating and inserting vision opportunity test data.
        List<Vision_Opportunity__c> testVisionOpportunityRecord=TestDataUtilityClass.createVisionOpportunity(3,200.00,System.today(),testContactRecord[0].Id,'Prospecting','testVision');
        testVisionOpportunityRecord[0].Invoice_Number__c=100;
        testVisionOpportunityRecord[1].Invoice_Number__c=101;
        testVisionOpportunityRecord[2].Invoice_Number__c=102;
        
        Test.startTest();
        insert testVisionOpportunityRecord;
        Test.stopTest();
        List<Opportunity> clonedRecords=[SELECT Id
                                              , Vision_Lookup__c
                                           FROM Opportunity 
                                          WHERE StageName='Closed Won'];
        List<Opportunity> newCreatedRecords=[SELECT Id
                                                  , Invoice_Number__c
                                               FROM Opportunity
                                              WHERE Invoice_Number__c=100
                                                 OR Invoice_Number__c=101
                                                 OR Invoice_Number__c=102];
        system.assertEquals(0,clonedRecords.size());
        system.assertEquals(0,newCreatedRecords.size());
    }
    
    //This testmethod checks the case when invoice number matches after update.
    static testMethod void testMatchAfterUpdate() {
        
         //creating the hierarchical custom setting and setting its value.
        ValidationActivationSetting__c setting=ValidationActivationSetting__c.getInstance(Userinfo.getUserId()); 
        setting.Activate_Validation_Rule__c=true;
        insert setting;
        
        //creating and inserting opportunity test data.
        List<Opportunity> opportunityTestRecord=TestDataUtilityClass.createOpportunity(4,'Prospecting',System.Today(),1400.00);
        opportunityTestRecord[0].Invoice_Number__c=1000;
        opportunityTestRecord[1].Invoice_Number__c=200;
        opportunityTestRecord[2].Invoice_Number__c=300;
        opportunityTestRecord[3].Invoice_Number__c=400;
        insert opportunityTestRecord;
        
        //creating and inserting product test data.
        List<Product2> testProductRecord=TestDataUtilityClass.createProduct(1);
        insert testProductRecord;
        
        //creating and inserting pricebookentry test data.
        List<PriceBookEntry> testPriceBookEntryRecord=TestDataUtilityClass.createPriceBookEntry(1,200.00,false);
        testPriceBookEntryRecord[0].Pricebook2Id=Test.getStandardPricebookId();
        testPriceBookEntryRecord[0].Product2Id=testProductRecord[0].Id;
        insert testPriceBookEntryRecord;
        
        //creating and inserting opportunity line item test data.
        List<OpportunityLineItem> testOpportunityLineItemRecord=TestDataUtilityClass.createOpportunityLineItem(2,opportunityTestRecord[0].Id,testPriceBookEntryRecord[0].Id,2,100.00);
        insert testOpportunityLineItemRecord;
        
        //creating and inserting account test data.
        List<Account> testAccountRecord=TestDataUtilityClass.createAccount(1,'Anjali');
        insert testAccountRecord;
        
        //creating and inserting contact test data.
        List<Contact> testContactRecord=TestDataUtilityClass.createContact(1,'Rohit','Kumar');
        testContactRecord[0].AccountId=testAccountRecord[0].Id;
        insert testContactRecord;
        
        //creating and inserting vision opportunity test data.
        List<Vision_Opportunity__c> testVisionOpportunityRecord=TestDataUtilityClass.createVisionOpportunity(3,200.00,System.today(),testContactRecord[0].Id,'Prospecting','testVision');
        testVisionOpportunityRecord[0].Invoice_Number__c=100;
        testVisionOpportunityRecord[1].Invoice_Number__c=101;
        testVisionOpportunityRecord[2].Invoice_Number__c=102;
        
        
        insert testVisionOpportunityRecord;
       
        List<Opportunity> clonedRecords=[SELECT Id
                                              , Vision_Lookup__c
                                           FROM Opportunity 
                                          WHERE StageName='Closed Won'];
        List<Opportunity> newCreatedRecords=[SELECT Id
                                                  , Invoice_Number__c
                                               FROM Opportunity
                                              WHERE Invoice_Number__c=100
                                                 OR Invoice_Number__c=101
                                                 OR Invoice_Number__c=102];
        system.assertEquals(0,clonedRecords.size());
        system.assertEquals(3,newCreatedRecords.size());
        
        testVisionOpportunityRecord[0].Invoice_Number__c=1000;
        Test.startTest();
        update testVisionOpportunityRecord[0];
        Test.stopTest();
        clonedRecords=[SELECT Id
                            , Vision_Lookup__c
                         FROM Opportunity 
                        WHERE StageName='Closed Won'];
        List<OpportunityLineItem> lineItemRecords=[SELECT Id
                                                        , OpportunityId
                                                     FROM OpportunityLineItem
                                                    WHERE OpportunityId=:clonedRecords[0].Id];
        system.assertEquals(1,clonedRecords.size());
        system.assertEquals(2,lineItemRecords.size());
        system.assertEquals(opportunityTestRecord[0].Id,clonedRecords[0].Vision_Lookup__c);
    }
    
    //This testmethod checks the case when invoice number don't match after update.
    static testMethod void testNoMatchAfterUpdate() {
        
         //creating the hierarchical custom setting and setting its value.
        ValidationActivationSetting__c setting=ValidationActivationSetting__c.getInstance(Userinfo.getUserId()); 
        setting.Activate_Validation_Rule__c=true;
        insert setting;
        
        //creating and inserting opportunity test data.
        List<Opportunity> opportunityTestRecord=TestDataUtilityClass.createOpportunity(4,'Prospecting',System.Today(),1400.00);
        opportunityTestRecord[0].Invoice_Number__c=1000;
        opportunityTestRecord[1].Invoice_Number__c=200;
        opportunityTestRecord[2].Invoice_Number__c=300;
        opportunityTestRecord[3].Invoice_Number__c=400;
        insert opportunityTestRecord;
        
        //creating and inserting product test data.
        List<Product2> testProductRecord=TestDataUtilityClass.createProduct(1);
        insert testProductRecord;
        
        //creating and inserting pricebookentry test data.
        List<PriceBookEntry> testPriceBookEntryRecord=TestDataUtilityClass.createPriceBookEntry(1,200.00,false);
        testPriceBookEntryRecord[0].Pricebook2Id=Test.getStandardPricebookId();
        testPriceBookEntryRecord[0].Product2Id=testProductRecord[0].Id;
        insert testPriceBookEntryRecord;
        
        //creating and inserting opportunity line item test data.
        List<OpportunityLineItem> testOpportunityLineItemRecord=TestDataUtilityClass.createOpportunityLineItem(2,opportunityTestRecord[0].Id,testPriceBookEntryRecord[0].Id,2,100.00);
        insert testOpportunityLineItemRecord;
        
        //creating and inserting account test data.
        List<Account> testAccountRecord=TestDataUtilityClass.createAccount(1,'Anjali');
        insert testAccountRecord;
        
        //creating and inserting contact test data.
        List<Contact> testContactRecord=TestDataUtilityClass.createContact(1,'Rohit','Kumar');
        testContactRecord[0].AccountId=testAccountRecord[0].Id;
        insert testContactRecord;
        
        //creating and inserting vision opportunity test data.
        List<Vision_Opportunity__c> testVisionOpportunityRecord=TestDataUtilityClass.createVisionOpportunity(3,200.00,System.today(),testContactRecord[0].Id,'Prospecting','testVision');
        testVisionOpportunityRecord[0].Invoice_Number__c=1000;
        testVisionOpportunityRecord[1].Invoice_Number__c=101;
        testVisionOpportunityRecord[2].Invoice_Number__c=102;
        
        
        insert testVisionOpportunityRecord;
       
        List<Opportunity> clonedRecords=[SELECT Id
                                              , Vision_Lookup__c
                                           FROM Opportunity 
                                          WHERE StageName='Closed Won'];
       
        system.assertEquals(1,clonedRecords.size());
       
        testVisionOpportunityRecord[0].Invoice_Number__c=100;
        Test.startTest();
        update testVisionOpportunityRecord[0];
        Test.stopTest();
        
        List<Opportunity> newCreatedRecords=[SELECT Id
                                                  , Invoice_Number__c
                                               FROM Opportunity
                                              WHERE Invoice_Number__c=100
                                                 OR Invoice_Number__c=101
                                                 OR Invoice_Number__c=102];
        system.assertEquals(3,newCreatedRecords.size());
    }
    
}