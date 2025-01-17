public class AccountSupportScoreBatch implements Database.Batchable<sObject>
{            
    static Integer Count = 0;
    static Set<Id> accIds = new Set<Id>();    
    static Map<Id, Account> accMap;
    
    public Database.queryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT Id, CreatedDate, Priority, AccountId FROM Case WHERE AccountId != null AND Status != \'Closed\'';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Case> caseList)
    {
        //Check the records received
        System.debug('@@@ List of Case Records : ' + caseList);
        
        if(!caseList.isEmpty())
        {
            //Get set of Account IDs from Cases
            for(Case c : caseList)
            {
                if(c.AccountId != null)
                {
                    accIds.add(c.AccountId);
                }
            }
            
            System.debug('@@@ Set of Account IDs : ' + accIds);
            
            //Get Map of AccountId, Account Instance
            if(accIds != null)
            {
                accMap = new Map<Id, Account>([SELECT Id, Support_Score__c 
                                               FROM Account 
                                               WHERE Id IN : accIds]);
            }
            
            //Check Account records retrieved
            System.debug('@@@ Map of Account Records : ' + accMap);
            
            //Check all cases and Count Score
            for(Case c : caseList)
            {
                //To re-count each instance of Case
                Count = 0;
                
                if(c.Priority == 'High')
                {
                    Count += 3;
                }            
                if(c.Priority == 'Medium')
                {
                    Count += 2;
                }
                if(c.Priority == 'Low')
                {
                    Count += 1;
                }
                if(c.CreatedDate.Date() < System.today().addDays(30))
                {
                    Count += 1;
                }
                if(c.CreatedDate.Date() > System.today().addDays(60))
                {
                    Count -= 1;
                }
                
                //Check current instance count
                System.debug('@@@ Current Count : ' + Count);
                
                //if AccountId of the case is already in Map, we'll update previous score
                if(accMap.containsKey(c.AccountId))
                {
                    System.debug('@@@ Condiiton True');
                    accMap.get(c.AccountId).Support_Score__c += Count;
                }
                else
                {
                    System.debug('@@@Condition False');
                }                
            }
        }
        
        System.debug('@@@ accMap keyset : ' + accMap.keyset());
        
        System.debug('@@@ accMap values : ' + accMap.values());
        
        if(!(accMap.values()).isEmpty())
        {
            System.debug('@@@ Condition True');
            try
            {
                update accMap.values();
                System.debug('@@@ Updated Account records without any error');
            }
            catch(Exception e)
            {
                System.debug('@@@ Ooops! Error Occured : ' + e.getMessage());                
            }
        }
        else
        {
            System.debug('@@@ Condition False');
        }
    }
    public void finish(Database.BatchableContext bc)
    {
        
    }
}