public class AccountProcessor 
{
    @future
    public static void countContacts(List<Id> accIds) 
    {
        // Query to get contact counts for each account
        AggregateResult[] aggResult =  [SELECT AccountId, COUNT(Id) contactCount 
                                        FROM Contact 
                                        WHERE AccountId IN :accIds 
                                        GROUP BY AccountId];
		
        //Map to Count Number of Contacts for each Account in AggregateResult
        Map<Id, Integer> contactCountMap = new Map<Id, Integer>();        
        
        if(!aggResult.isEmpty())
        {
         	for(AggregateResult agg : aggResult)
        	{
            	contactCountMap.put((Id)agg.get('AccountId'), (Integer)agg.get('contactCount'));
        	}
		}
        
        // Prepare a list of accounts to update
        List<Account> accountsToUpdate = new List<Account>();
        
        if(!accIds.isEmpty())
        {
         	for (Id accountId : accIds) 
        	{
            	Integer contactCount = contactCountMap.containsKey(accountId) ? contactCountMap.get(accountId) : 0;
            	Account acc = new Account();
            	acc.Id = accountId;
            	acc.Number_Of_Contacts__c = contactCount;
            	accountsToUpdate.add(acc);
        	}
        }
        
        // Update accounts with contact counts
        if (!accountsToUpdate.isEmpty()) 
        {
            update accountsToUpdate;
        }
    }
}