@isTest
private class LeadProcessorTest {
    
    @testSetup
    static void setup() {
        List<Lead> leads = new List<Lead>();
        // Insert 200 leads
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(FirstName = 'Lead',
                                LastName = 'Number' + i,
                                 Company = 'Salesforce',
                              LeadSource = 'Web'));
        }
        insert leads;        
    }

    @isTest
    static void updateLeadsTest() {
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest();
        // After the testing stops, assert records were updated properly
        System.assertEquals(200, [SELECT count()
                                    FROM Lead
                                   WHERE LeadSource = 'Dreamforce'], 
                                    'The number of leads does not equal 200');
    }
}
