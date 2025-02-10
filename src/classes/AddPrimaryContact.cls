public class AddPrimaryContact implements Queueable 
{
    private Contact con;
    private String billingState;
    
    public AddPrimaryContact(Contact conObj, String state)
    {
        con = conObj;
        billingState = state;
    }
    
    public void execute(QueueableContext qc)
    {
		List<Account> accList = [SELECT Id, Name, BillingState FROM Account WHERE BillingState =: billingstate];
        
        List<Contact> contactsToInsert = new List<Contact>();
        
        for (Account acc : accList) 
		{
            con.AccountId = acc.Id;
            Contact newContact = con.clone(false, false, false, false);
            contactsToInsert.add(newContact);
        }
        
        insert contactsToInsert;
    }
}