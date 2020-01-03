@isTest
private class AccountProcessorTest {
    @isTest
    private static void accountWithContactsTest() {
        Account acc = new Account();
        acc.Name = 'Trailhead';
        acc.First_Name__c = 'Astro';
        acc.Last_Name__c = 'Salesforce';
        insert acc;

        List<Contact> childContacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            Contact con = new Contact();
            con.FirstName = 'Marc';
            con.LastName = 'Benioff ' + i;
            con.AccountId = acc.Id;
            childContacts.add(con);
        }
        insert childContacts;

        List<Id> accountIds = new List<Id>();
        accountIds.add(acc.Id);

        Test.startTest();
            AccountProcessor.countContacts(accountIds);
        Test.stopTest();

        for (Account updatedAcc : [SELECT Id, Number_of_Contacts__c
                                     FROM Account
                                    WHERE Id
                                       IN :accountIds]) {
            System.assertEquals(childContacts.size(), 
                                updatedAcc.Number_of_Contacts__c, 
                                'The number of contacts field doesn\'t match the size of the child contacts list! :(');
        }
    }
}
