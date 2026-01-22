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

    @IsTest
    static void testExecuteWithReservedChars() {
        // Setup data
        Account acc = new Account(Name='Reserved Chars Test');
        insert acc;

        SoslInvocableMethod.Request request = new SoslInvocableMethod.Request();
        request.objectAPIName = 'Account';
        
        // Add strings containing SOSL reserved characters.
        // If these are not escaped, Search.find() will throw an exception
        request.queries = new List<String>{
            'Test?',    // Wildcard
            'Test*',    // Wildcard
            'A & B',    // Logical AND
            'A | B',    // Logical OR
            '!Test',    // Logical NOT
            '{Group}',  // Grouping
            '[Group]',  // Grouping
            '(Group)',  // Grouping
            'Name:Test',// Field reference
            'Boost^',   // Boosting
            'Fuzzy~',   // Fuzzy
            'Quote"',   // Double Quotes
            'Back\\Slash' // Backslash
        };
        request.scope = 'ALL FIELDS';
        
        // mock the result because SOSL doesn't actually search in tests
        Test.setFixedSearchResults(new Id[]{acc.Id});
        
        Test.startTest();
        // This should verify that the query string syntax is valid after our escaping process
        List<SoslInvocableMethod.Result> results = SoslInvocableMethod.execute(
            new List<SoslInvocableMethod.Request>{ request }
        );
        Test.stopTest();
        
        System.assertEquals(1, results.size(), 'Expected 1 result collection');
        System.assertEquals(1, results[0].recordIds.size(), 'Expected record to be returned despite reserved characters');
    }

    @IsTest
    static void testExecuteWithSingleQuotes() {
        // Setup data
        Account acc = new Account(Name='O\'Reilly');
        insert acc;

        SoslInvocableMethod.Request request = new SoslInvocableMethod.Request();
        request.objectAPIName = 'Account';
        
        // Input specifically testing single quote escaping (Injection prevention)
        request.queries = new List<String>{'O\'Reilly'}; 
        request.scope = 'ALL FIELDS';
        
        Test.setFixedSearchResults(new Id[]{acc.Id});
        
        Test.startTest();
        List<SoslInvocableMethod.Result> results = SoslInvocableMethod.execute(
            new List<SoslInvocableMethod.Request>{ request }
        );
        Test.stopTest();
        
        System.assertEquals(1, results.size(), 'Should handle single quotes without error');
        System.assertEquals(acc.Id, results[0].recordIds[0], 'Should return the mocked ID');
    }
}