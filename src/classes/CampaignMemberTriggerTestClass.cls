@isTest
public class CampaignMemberTriggerTestClass{
    //This testmethod checks for the existing records of campaign members.
    static testmethod void testExistingRecords(){
        Campaign objCampaign=new Campaign(Name='TRY Health Campaign');
        insert objCampaign;
        
        //List<CampaignMember> CampaignRecords=CampaignMemberTriggerUtilityClass.createCampaignMembers(objCampaign.Id);
        List<CampaignMember> CampaignRecords = [select id, city,Contactid,leadid from CampaignMember where campaignid = :objCampaign.Id];
        for(CampaignMember cm : CampaignRecords){
        system.debug('cm-->'+cm);
        }
        Contact objNewContact=new Contact(FirstName='rohit',LastName='kumar',MailingCity='Pune');
        insert objNewContact;
        CampaignMember objNewCampaignMember=new CampaignMember(Campaign_Awareness_Type__c='Health Issues',ContactID=objNewContact.Id,Participation_Role__c='Volunteer',CampaignId=objCampaign.Id);
        Test.startTest();
        insert objNewCampaignMember;
        Test.stopTest();
    }
}