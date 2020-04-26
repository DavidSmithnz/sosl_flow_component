public with sharing class SoslInvocableMethod {

    @InvocableMethod
    public static List<Result> execute(List<Request> requestList) {
        // Init the response
        List<Result> response = new List<Result>();

        // For each request
        for (Request req : requestList) {

            System.debug('### SoslInvocableMethod execute req >>>'+req);

            // Build Query String
            String queryString = '\'' + String.join(req.queries, ' OR ') + '\'';
            System.debug('### SoslInvocableMethod execute queryString >>>'+queryString);

            // Build SOSL
            String sosl = String.format('FIND {0}{1} RETURNING {2}(Id{3})', new String[]{
                queryString,
                String.isNotBlank(req.scope) ? ' IN ' + req.scope : '',
                req.objectAPIName,
                String.isNotBlank(req.whereClause) ? ' WHERE ' + req.whereClause : ''
            });
            System.debug('### SoslInvocableMethod execute sosl >>>'+sosl);

            // Execute the SOSL search
            Search.SearchResults searchResults = Search.find(sosl);
            
            // Get the list of SObject results
            List<Search.SearchResult> recordList = searchResults.get(req.objectAPIName);

            // Get the record Id's if any
            Result res = new Result();
            res.recordIds = new List<Id>();
            for (Search.SearchResult searchResult : recordList) {
                SObject record = searchResult.getSObject();
                res.recordIds.add(record.Id);
            } 

            // Add the response
            response.add(res);
        }

        return response;
    }

    public class Request {
        @InvocableVariable(label='SObjectType' description='The SObjectType to execute the SOSL for' required=true)
        public String objectAPIName;
        @InvocableVariable(label='Queries' description='A list of queries / search terms to apply to the SOSL search' required=true)
        public List<String> queries;
        @InvocableVariable(label='Scope' description='The scope of the SOSL search (default ALL FIELDS)')
        public String scope;
        @InvocableVariable(label='Where Clause' description='Include a custom where clause codition to filter the records even further')
        public String whereClause;
    }

    public class Result {
        @InvocableVariable(label='Record Ids' description='The list of record Ids found relating to the search')
        public List<Id> recordIds;
    }
}