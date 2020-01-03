@isTest
public class AddPrimaryContactTest {
    @testSetup    
    static void setup() {
        List<Account> accounts = new List<Account>();
        // Add 50 accounts for BillingState "NY"
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account(Name = 'Account' + i, 
                            First_Name__c = 'Astro', 
                             Last_Name__c = 'Salesforce',
                             BillingState = 'NY'));
        }
        // Add 50 accounts for BillingState "CA"
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account(Name = 'Account1' + i, 
                            First_Name__c = 'Astro', 
                             Last_Name__c = 'Salesforce',
                             BillingState = 'CA'));
        }
        insert accounts;

        List<Contact> contacts = new List<Contact>();
        // Insert a contact for NY
        contacts.add(new Contact(FirstName = 'John', LastName = 'NewYork'));
        // Insert a contact for CA
        contacts.add(new Contact(FirstName = 'Jane', LastName = 'California'));
        insert contacts;
    }

    @isTest
    static void testQueueable() {
        // Query for test data to pass queueable class
        Contact caCon = [SELECT Id 
                           FROM Contact
                          WHERE LastName = 'California'][0];
        String ca = 'CA';

        // Create queueable instance
        AddPrimaryContact apcJob = new AddPrimaryContact(caCon, ca);

        // Queue the job inside of a startTest/stopTest block
        Test.startTest();
        System.enqueueJob(apcJob);
        Test.stopTest();

        // Validate the job ran. Check if all accounts have a primary contact now
        System.assertEquals(50, [SELECT count()
                                   FROM Contact
                                  WHERE Account.BillingState = :ca], 
                                    'The number of contacts with a parent account of CA is not equal to 50! :(');
    }
}
