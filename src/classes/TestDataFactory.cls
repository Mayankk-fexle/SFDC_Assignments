public class TestDataFactory 
{
    public static Account createAccount(String Name)
    {
        Account acc = new Account();
        acc.Name = Name;
        return acc;
    }
    public static Contact createContact(String lastName)
    {
        Contact con = new Contact();
        con.LastName = lastName;
        return con;
    }
    
    public static Training_Session__c createTrainingSession(String Name)
    {
        Training_Session__c tss = new Training_Session__c();
        tss.Name = Name;
        return tss; 
    }

}