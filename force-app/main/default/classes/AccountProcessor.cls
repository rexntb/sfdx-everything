global class AccountProcessor {
  @future
  public static void countContacts(List<Id> recordIds) {
    List<Account> accounts = [SELECT Id, Name 
                                FROM Account 
                               WHERE Id 
                                  IN :recordIds];
    // Count the number of contacts in each account
    for (Account acc : accounts) {
        // Update the Number_of_Contacts__c field with the number of contacts
        acc.Number_of_Contacts__c = [SELECT count() 
                                         FROM Contact
                                        WHERE AccountId = :acc.Id];
    }
    update accounts;
  }
}
