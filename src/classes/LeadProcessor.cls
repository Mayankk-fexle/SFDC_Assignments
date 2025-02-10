public class LeadProcessor implements Database.Batchable<sObject>, Database.stateful
{
    public Integer recordCount = 0;
    
	public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator([SELECT Id, Name FROM Lead]);
    }
    
    public void execute(Database.BatchableContext bc, List<Lead> leadList)
    {
        if(!leadList.isEmpty())
        {
            for(Lead l : leadList)
            {
                l.LeadSource = 'Dreamforce';
            }
            update leadList;
            recordCount = recordCount + leadList.size(); 
        }
    }
    
    public void finish(Database.BatchableContext bc)
    {
        System.debug('@@@@ Total Records Processed : ' + recordCount);
    }
}