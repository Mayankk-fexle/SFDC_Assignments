@isTest
public class AddPrimaryContactTest 
{
    @testSetup
    public static void setupMethod() 
    {
        List<Account> accounts = new List<Account>();
        
        // Insert 20 Account records for NY
        for (Integer i = 0; i < 50; i++) 
        {
            Account accNY = TestDataFactory.createAccount('Account NY ' + i);
            accNY.BillingState = 'NY';
            accounts.add(accNY);
        }
        
        // Insert 30 Account records for CA
        for (Integer i = 0; i < 50; i++) 
        {
            Account accCA = TestDataFactory.createAccount('Account CA ' + i);
            accCA.BillingState = 'CA';
            accounts.add(accCA);
        }
        
        insert accounts;
    }
	
    @isTest
    static void testAddPrimaryContact()
    {
        Test.startTest();
        AddPrimaryContact job1 = new AddPrimaryContact(new Contact(LastName = 'Contact 1'), 'NY');
		System.enqueueJob(job1);
        AddPrimaryContact job2 = new AddPrimaryContact(new Contact(LastName = 'Contact 2'), 'CA');
		System.enqueueJob(job2);
        Test.stopTest();
                
        List<Contact> newContacts1 = [SELECT Id FROM Contact WHERE Account.BillingState = 'NY']; 
                
        List<Contact> newContacts2 = [SELECT Id FROM Contact WHERE Account.BillingState = 'CA']; 
		
        System.assertEquals(50, newContacts1.size());
        
		System.assertEquals(50, newContacts2.size());
    }
}