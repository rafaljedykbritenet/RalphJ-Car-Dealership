public with sharing class RCD_DivisionController {

    @AuraEnabled public static List<DivisionResult> results { get; set; }

    @AuraEnabled
    public static List<DivisionResult> searchDivisions(Division__c searchedDivision) {
        System.debug('Zaczynam w apex');
        String nameParam, emailParam, cityParam;
        String query = 'SELECT Id, Name, Street__c, Country__c, City__c FROM Division__c WHERE Country__c = \'' + searchedDivision.Country__c + '\'';

        if (String.isNotEmpty(searchedDivision.Name)) {
            nameParam = ' \'%' + searchedDivision.Name + '%\' ';
            query += ' AND Name LIKE ' + nameParam;
        }

        if (String.isNotEmpty(searchedDivision.City__c)) {
            cityParam = ' \'%' + searchedDivision.City__c + '%\' ';
            query += ' AND City__c LIKE ' + cityParam;
        }

        try {
            List<Division__c> rcdDivisions = Database.query(query);
            results = new List<DivisionResult>();
            for (Division__c dvsn : rcdDivisions) {
                DivisionResult tempResult = new DivisionResult();
                tempResult.division = dvsn;
                results.add(tempResult);
            }
        } catch (Exception exc) {
         System.debug('Error');
        }
        System.debug('Resulty => ' + results);
        return results;
    }
   
    public class DivisionResult {
        @AuraEnabled public Division__c division { get; set; }
    } 

}