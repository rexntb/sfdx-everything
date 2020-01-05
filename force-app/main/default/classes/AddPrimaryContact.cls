public class AddPrimaryContact implements Queueable {
    
    private Contact contact;
    private String state;
    
    public AddPrimaryContact(Contact con, String abbrev) {
        this.contact = con;
        this.state = abbrev;
    }

    public void execute(QueueableContext context) {
        // Get all accounts with the specified state abbreviation
        List<Account> accounts = [SELECT Id
                                    FROM Account
                                   WHERE BillingState = :state
                                   LIMIT 200];
        Contact primCon = [SELECT Id, FirstName, LastName
                             FROM Contact
                            WHERE Id = :contact.Id];
        // Insert contact for each account
        List<Contact> contacts = new List<Contact>();
        for (Account account : accounts) {
            Contact clonedCon = primCon.clone();
            clonedCon.AccountId = account.Id;
            contacts.add(clonedCon);
        }
        insert contacts;
    }
}
