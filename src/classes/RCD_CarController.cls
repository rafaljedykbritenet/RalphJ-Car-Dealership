public with sharing class RCD_CarController {

    @AuraEnabled public static List<CarResult> results { get; set; }

    @AuraEnabled
    public static List<CarResult> searchCars(Product2 searchedCar) {
        String brandParam, modelParam, fuelParam, doorsParam, driveParam, transmitionParam, colorParam;
        Decimal powerParam, capacityParam, priceParam;
        String query = 'SELECT Id, Name, Brand__c, Model__c, Fuel__c, Doors__c, Drive_Type__c, Transmition__c, Color__c, Power__c, Year__c, Capacity__c, Price__c, Picture__c FROM Product2';

        if (String.isNotEmpty(searchedCar.Brand__c)) {
            modelParam = ' \'%' + searchedCar.Brand__c + '%\' ';
            query += ' WHERE Brand__c LIKE ' + modelParam;
        } else {
            query += ' WHERE Brand__c != null';
        }

        if (String.isNotEmpty(searchedCar.Model__c)) {
            modelParam = ' \'%' + searchedCar.Model__c + '%\' ';
            query += ' AND Model__c LIKE ' + modelParam;
        }

        if (searchedCar.Fuel__c != null) {
            fuelParam = ' \'%' + searchedCar.Fuel__c + '%\' ';
            query += ' AND Fuel__c LIKE ' + fuelParam;
        }

        if (searchedCar.Doors__c != null) {
            doorsParam = ' \'%' + searchedCar.Doors__c + '%\' ';
            query += ' AND Doors__c LIKE ' + doorsParam;
        }

        if (searchedCar.Drive_Type__c != null) {
            driveParam = ' \'%' + searchedCar.Drive_Type__c + '%\' ';
            query += ' AND Drive_Type__c LIKE ' + driveParam;
        }

        if (searchedCar.Transmition__c != null) {
            transmitionParam = ' \'%' + searchedCar.Transmition__c + '%\' ';
            query += ' AND Transmition__c LIKE ' + transmitionParam;
        }

        if (searchedCar.Color__c != null) {
            colorParam = ' \'%' + searchedCar.Color__c + '%\' ';
            query += ' AND Color__c LIKE ' + colorParam;
        }

        if (searchedCar.Power__c != null) {
            powerParam = searchedCar.Power__c;
            query += ' AND Power__c >= ' + powerParam;
        }

        if (searchedCar.Capacity__c != null) {
            capacityParam = searchedCar.Capacity__c;
            query += ' AND Capacity__c >= ' + capacityParam;
        }

        if (searchedCar.Price__c != null) {
            priceParam = searchedCar.Price__c;
            query += ' AND Price__c <= ' + priceParam;
        }

        query += ' ORDER BY Name ASC';

        try {
            List<Product2> rcdCars = Database.query(query);
            results = new List<CarResult>();
            for (Product2 car : rcdCars) {
                CarResult tempResult = new CarResult();
                tempResult.car = car;
                results.add(tempResult);
            }
        } catch (Exception exc) {
            System.debug('Error');
        }

        return results;
    }

    public class CarResult {
        @AuraEnabled public Product2 car { get; set; }
    }

}