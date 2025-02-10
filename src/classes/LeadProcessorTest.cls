@isTest
public class LeadProcessorTest 
{
    @testSetup
    static void setupData()
    {
        List<Lead> newLeads = new List<Lead>();
        
        for(Integer i=1 ; i<=200 ; i++)
        {
            Lead ld = TestDataFactory.createLead('Test '+i);
            ld.Company = 'Company '+i;
            ld.Status = 'Open - Not Contacted';
            newLeads.add(ld);
        }

        insert newLeads;
    }
    
	@isTest
    public static void testLeadProcess()
    {
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchID = Database.executeBatch(lp,200);
        Test.stopTest();

        List<Lead> leadList = [SELECT Id FROM Lead WHERE LeadSource = 'Dreamforce'];
        
        Assert.areEqual(200,leadList.size(),'Records were not inserted');
    }
}