@IsTest
private class SoslInvocableMethodTest {
    
    @IsTest
    static void testExecute() {
        List<Account> accounts = new List<Account>{
            new Account(Name='United 1'),
            new Account(Name='United 2'),
            new Account(Name='United 3', Type='Test')
        };
        insert accounts;
        SoslInvocableMethod.Request request = new SoslInvocableMethod.Request();
        request.objectAPIName = 'Account';
        request.queries = new List<String>{'United'};
        request.scope = 'ALL FIELDS';
        request.whereClause = 'Type = \'Test\'';
        Test.setFixedSearchResults(new Id[]{accounts[2].Id});
        Test.startTest();
        List<SoslInvocableMethod.Result> results = SoslInvocableMethod.execute(
            new List<SoslInvocableMethod.Request>{ request }
        );
        Test.stopTest();
        System.assertEquals(3, [SELECT COUNT() FROM Account], 'Expected to have 3 accounts');
        System.assertEquals(1, results.size(), 'Expected only 1 result collection returned');
        System.assertEquals(1, results[0].recordIds.size(), 'Expected only 1 record Id returned');
    }

}