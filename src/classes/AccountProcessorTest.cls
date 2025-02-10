@isTest
public class AccountProcessorTest 
{
    @testSetup
    static void setupTestData() 
    {
        List<Account> accList = new List<Account>();
        
        Account acc1 = TestDataFactory.createAccount('Test Account 1');
        accList.add(acc1);

        Account acc2 = TestDataFactory.createAccount('Test Account 2');
        accList.add(acc2);

        insert accList;

        List<Contact> conList = new List<Contact>();

        Contact con1 = TestDataFactory.createContact('Contact 1');
        con1.AccountId = acc1.Id;
        conList.add(con1);

        Contact con2 = TestDataFactory.createContact('Contact 2');
		con2.AccountId = acc1.Id;
        conList.add(con2);

        Contact con3 = TestDataFactory.createContact('Contact 3');
        con3.AccountId = acc2.Id;
        conList.add(con3);

        insert conList;
    }

    @isTest
    static void testCountContacts() 
    {
        // Fetch test accounts
        List<Account> testAccounts = [SELECT Id FROM Account WHERE Name LIKE 'Test Account%'];
        
        List<Id> accountIds = new List<Id>();
        
        if(!testAccounts.isEmpty())
        {
            for (Account acc : testAccounts) 
        	{
            	accountIds.add(acc.Id);
        	}
        }

        // Call the future method
        Test.startTest();
        AccountProcessor.countContacts(accountIds);
        Test.stopTest();

        // Verify the number of contacts
        Account Account1 = [SELECT Id, Name, Number_Of_Contacts__c FROM Account WHERE Name = 'Test Account 1' LIMIT 1];
        Account Account2 = [SELECT Id, Name, Number_Of_Contacts__c FROM Account WHERE Name = 'Test Account 2' LIMIT 1];
        
        System.assertEquals(2, Account1.Number_Of_Contacts__c, 'Account 1 should have 2 contacts');
        System.assertEquals(1, Account2.Number_Of_Contacts__c, 'Account 2 should have 1 contact');
    }
}