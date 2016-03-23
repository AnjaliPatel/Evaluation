//This class creates the data required for CampaignMemberTriggerTestClass
public class CampaignMemberTriggerUtilityClass{
    //This method generates the records for campaign members.
    public static List<CampaignMember> createCampaignMembers(Id TRYCampaignId){
        List<Contact> contactRecord=createContacts();
        List<Lead> leadRecord=createLeads();
        system.debug(contactRecord[0].Id);
        CampaignMember objMember1=new CampaignMember(Campaign_Awareness_Type__c='Health Issues',ContactID=contactRecord[0].Id,Participation_Role__c='Volunteer',CampaignId=TRYCampaignId);
        CampaignMember objMember2=new CampaignMember(Campaign_Awareness_Type__c='Health Issues',ContactID=contactRecord[1].Id,Participation_Role__c='Volunteer',CampaignId=TRYCampaignId);
        CampaignMember objMember3=new CampaignMember(Campaign_Awareness_Type__c='Blood Donation',ContactID=contactRecord[2].Id,Participation_Role__c='Volunteer',CampaignId=TRYCampaignId);
        CampaignMember objMember4=new CampaignMember(Campaign_Awareness_Type__c='Organ Donation',LeadId=leadRecord[0].Id,Participation_Role__c='Volunteer',CampaignId=TRYCampaignId);
        CampaignMember objMember5=new CampaignMember(Campaign_Awareness_Type__c='Under Nourishment',LeadId=leadRecord[1].Id,Participation_Role__c='Volunteer',CampaignId=TRYCampaignId);
        List<CampaignMember> campaignRecord=new List<CampaignMember>();
        campaignRecord.add(objMember1);
        campaignRecord.add(objMember2);
        campaignRecord.add(objMember3);
        campaignRecord.add(objMember4);
        campaignRecord.add(objMember5);
        insert campaignRecord;
        system.debug(campaignRecord);
        return campaignRecord;
    } 
    
    public static List<Contact> createContacts(){
        Contact objContact1=new Contact(FirstName='Ashish',LastName='Agarwal',MailingCity='Pune');
        Contact objContact2=new Contact(FirstName='Tushar',LastName='Kakade',MailingCity='Nashik');
        Contact objContact3=new Contact(FirstName='Bhushan',LastName='Patil',MailingCity='Pune');
        List<Contact> ListContact=new List<Contact>();
        ListContact.add(objContact1);
        ListContact.add(objContact2);
        ListContact.add(objContact3);
        insert ListContact;
        return ListContact;
    } 
    
    public static List<Lead> createLeads(){
        Lead objLead1=new Lead(FirstName='Varsha',LastName='Gupta',City='Pune',Status='Open',Company='Eternus');
        Lead objLead2=new Lead(FirstName='Shunali',LastName='Mehra',City='Bhopal',Status='Open',Company='Eternus');
        List<Lead> ListLead=new List<Lead>();
        ListLead.add(objLead1);
        ListLead.add(objLead2);
        insert ListLead;
        return ListLead;
    }
}