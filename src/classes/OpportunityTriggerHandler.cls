//This is the handler class for the Opportunity trigger.
public class OpportunityTriggerHandler {
    
    //This is the method takes the newly created opportunity,searches for the vision opportunity and performs the required action.
    public static void createVisionOpportunity(List<Opportunity> opportunityRecords){
    	Integer counter=0;
    	Map<Id,Opportunity> existingOpportunityMap=new Map<Id,Opportunity>([SELECT Id
    													 						 , Name
    													 						 , Customer__c
    													 						 , Invoice_Number__c
    													 						 , StageName
    													 						 , CloseDate
    												  						  FROM Opportunity
    												 						 WHERE Invoice_Number__c!=Null]);
    	Map<Id,OpportunityLineItem> opportunityLineItemMap=new Map<Id,OpportunityLineItem>();
    	List<OpportunityLineItem> opportunityLineItemList=[SELECT Id
    															, Name
    															, OpportunityId
    															, Quantity
    														 FROM OpportunityLineItem];
    	for(OpportunityLineItem objLineItem: opportunityLineItemList){
    		opportunityLineItemMap.put(objLineItem.OpportunityId,objLineItem);
    	}
    	List<Opportunity> cloneRecords=new List<Opportunity>();
    	List<Opportunity> visionOpportunityRecords=new List<Opportunity>();
    	system.debug(existingOpportunityMap);
    	
    	//Creating a map of invoice number and opportunity Id.
    	Map<Decimal,Id> opportunityIdInvoiceNumberMap=new Map<Decimal,Id>();
    	for(Id objMap: existingOpportunityMap.keyset()){
    		opportunityIdInvoiceNumberMap.put(existingOpportunityMap.get(objMap).Invoice_Number__c,objMap);
    	}
    	system.debug(opportunityIdInvoiceNumberMap);

		//Extracting contacts and creating a map of contacts along with the accounts they are associated to.    	
    	List<Contact> contactsList=[SELECT Id
    									 , Name
    									 , AccountId
    								  FROM Contact];
    	Map<Id,Id> contactAccountIdMap=new Map<Id,Id>();
    	for(Contact objContact: contactsList){
    		if(objContact.AccountId!=Null){
    			contactAccountIdMap.put(objContact.Id,objContact.AccountId);
    		}
    	}
    	
		for(Opportunity objNewOpportunity: opportunityRecords){
			if(opportunityIdInvoiceNumberMap.containsKey(objNewOpportunity.Invoice_Number__c)){
				Opportunity requiredOpportunity=existingOpportunityMap.get(opportunityIdInvoiceNumberMap.get(objNewOpportunity.Invoice_Number__c));
				Opportunity objClone=requiredOpportunity.clone(false,false,true,true);
				cloneRecords.add(objClone);
				objNewOpportunity.StageName='Closed Won';
				objNewOpportunity.Vision_Lookup__c=requiredOpportunity.Id;
				requiredOpportunity.Vision_Opportunity__c=true;
				system.debug(requiredOpportunity.Vision_Opportunity__c);
				visionOpportunityRecords.add(requiredOpportunity);
			}
			else{
				if(objNewOpportunity.Customer__c!=Null){
					if(contactAccountIdMap.containsKey(objNewOpportunity.Customer__c)){
						Opportunity createNewOpportunity=new Opportunity();
						createNewOpportunity.Name=objNewOpportunity.Name+'ElseOpportunity';
						createNewOpportunity.StageName='Prospecting';
						createNewOpportunity.CloseDate=System.Today();
						createNewOpportunity.Invoice_Number__c=counter;
						counter++;
					}
				}
			}
		}
		insert cloneRecords;
		update visionOpportunityRecords;
    }
}