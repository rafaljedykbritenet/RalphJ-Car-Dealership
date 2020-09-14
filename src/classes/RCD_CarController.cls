public with sharing class RCD_CarController {

    @AuraEnabled public static List<CarResult> results { get; set; }

    @AuraEnabled
    public static void addToBasket(String siteUserId, String carId, Decimal amount, Boolean fromCart) {
        User user = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        OrderItem newOrderItem = new OrderItem();
        Order basket = [SELECT Id from order WHERE Contact__c = :user.ContactId AND Status = 'Basket'];
        newOrderItem.OrderId = basket.Id;
        newOrderItem.Product2Id = carId;

        newOrderItem.Quantity = amount;
        Product2 product = [SELECT Price__c FROM Product2 WHERE Id = :carId];
        newOrderItem.UnitPrice = product.Price__c;
        List<PricebookEntry> pricebookEntries = [SELECT Id FROM PricebookEntry WHERE Product2Id = :carId];
        Id pricebookEntry = pricebookEntries[0].Id;
        newOrderItem.PricebookEntryId = pricebookEntry;
        List<OrderItem> carsInBasket = [SELECT Id, Quantity FROM OrderItem WHERE OrderId = :basket.Id AND Product2Id = :carId LIMIT 1];
        if (carsInBasket.size() > 0) {
            if (!fromCart) {
                newOrderItem.Quantity = carsInBasket[0].Quantity;
            }
            delete carsInBasket[0];
        }
        insert newOrderItem;
    }

    @AuraEnabled
    public static void submitOrder(String siteUserId) {
        User user = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        Account account = [SELECT Id FROM account WHERE name = 'Rafal Jedyk'];
        Contact contact = [SELECT FirstName, LastName FROM Contact WHERE Id = :user.ContactId];
        Order basket = [SELECT Id, ContractId from order WHERE Contact__c = :user.ContactId AND Status = 'Basket'];
        List<OrderItem> orderItems = [SELECT Id, Quantity, Product2Id FROM OrderItem WHERE OrderId = :basket.Id];
        List<Product2> carsInOrder = new List<Product2>();
        for (OrderItem orderItem : orderItems) {
            Product2 carInBasket = [SELECT Id, Brand__c , Amount__c from Product2 WHERE Id =: orderItem.Product2Id];
            carInBasket.Amount__c = carInBasket.Amount__c - orderItem.Quantity;
            carsInOrder.add(carInBasket);
        }
        update carsInOrder;

        Contract oldContract = [SELECT Status FROM Contract WHERE Id = :basket.ContractId LIMIT 1];
        oldContract.Status = 'Activated';
        update oldContract;

        basket.Status = 'Done';
        basket.EffectiveDate = System.Date.today();
        List<Order> ordersSubmitted = [SELECT Id FROM Order WHERE EffectiveDate = :basket.EffectiveDate AND Status = 'Done' AND Contact__c = :contact.Id];
        if ( ordersSubmitted.size() == 0 ) {
            basket.name = contact.FirstName + ' ' + contact.LastName + ' ' + basket.EffectiveDate.format();
        } else {
            basket.name = contact.FirstName + ' ' + contact.LastName + ' ' + basket.EffectiveDate.format() + ' #' + ordersSubmitted.size();
        }

        update basket;

        Contract contract = new Contract();
        contract.AccountId = account.Id;
        contract.status = 'Draft';
        contract.startdate = System.Date.today();
        contract.ContractTerm = 120;
        insert(contract);

        Order order = new Order();
        order.AccountId = account.Id;
        order.status = 'Basket';
        order.Contact__c = user.ContactId;
        order.name = contact.FirstName + ' ' + contact.LastName + ' Cart';
        order.EffectiveDate = System.Date.today();
        order.ContractId = contract.Id;
        order.Pricebook2Id = '01s2X0000027BtXQAU';
        insert(order);
    }

    @AuraEnabled
    public static void submitComplain(String siteUserId, String complainSubject, String complainDescription, String complainBrand, String complainModel, String order) {
        User user = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        Account account = [SELECT Id FROM account WHERE name = 'Rafal Jedyk'];
        Contact contact = [SELECT Id, FirstName, LastName FROM Contact WHERE Id = :user.ContactId];
        Case complain = new Case();
        complain.AccountId = account.Id;
        complain.ContactId = contact.Id;
        complain.Subject = complainSubject;
        complain.ComplainCarBrand__c = complainBrand;
        complain.ComplainCarModel__c = complainModel;
        Order orderToComplain = [SELECT Id FROM Order WHERE Name = :order LIMIT 1];
        complain.Order__c = orderToComplain.Id;
        complain.Description = complainDescription;
        complain.Type = 'Car Dealership Complain';
        complain.Origin = 'Web';

        insert complain;
    }

    @AuraEnabled
    public static List<CarResult> searchBasket() {
        User user = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        List<String> productNames = new List<String>();
        List<Decimal> orderPrice = new List<Decimal>();
        List<Date> orderDate = new List<Date>();
        for (order ord : [
                SELECT Id,name, TotalAmount, EffectiveDate, (
                        select Id,
                                OrderId,
                                OrderItemNumber,
                                PricebookEntry.Product2.Name,
                                PricebookEntry.Product2.Brand__c,
                                PricebookEntry.Product2.Picture__c,
                                PricebookEntry.Product2.Year__c,
                                PricebookEntry.Product2.Price__c,
                                PricebookEntry.Product2.Power__c,
                                PricebookEntry.Product2.Amount__c,
                                PricebookEntry.Product2.id,
                                Quantity,
                                UnitPrice
                        FROM OrderItems
                )
                from order
                WHERE Contact__c = :user.ContactId AND Status = 'Basket'
        ]) {
            results = new List<CarResult>();
            for (OrderItem oi : ord.orderItems) {
                CarResult tempResult = new CarResult();
                tempResult.carItem = oi;
                tempResult.car = oi.PricebookEntry.Product2;
                tempResult.quantity = oi.Quantity;
                tempResult.unitPrice = oi.UnitPrice;
                tempResult.orderDate = ord.EffectiveDate;
                tempResult.orderPrice = ord.TotalAmount;

                results.add(tempResult);
                productNames.add(oi.PricebookEntry.Product2.name);
                productNames.add(oi.PricebookEntry.Product2.Brand__c);
                productNames.add(oi.Quantity.toPlainString());
                productNames.add(oi.UnitPrice.toPlainString());

            }
            orderPrice.add(ord.TotalAmount);
            orderDate.add(ord.EffectiveDate);
        }

        return results;
    }

    @AuraEnabled
    public static List<Order> searchOrders() {
        User user = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        List<String> productNames = new List<String>();
        List<Decimal> orderPrice = new List<Decimal>();
        List<Date> orderDate = new List<Date>();
        List<Order> resultOrders = new List<Order>();
        for (order ord : [
                SELECT Id,name, TotalAmount, EffectiveDate, (
                        select Id,
                                OrderId,
                                OrderItemNumber,
                                PricebookEntry.Product2.Name,
                                PricebookEntry.Product2.Brand__c,
                                PricebookEntry.Product2.Picture__c,
                                PricebookEntry.Product2.Year__c,
                                PricebookEntry.Product2.Price__c,
                                PricebookEntry.Product2.Power__c,
                                PricebookEntry.Product2.Amount__c,
                                PricebookEntry.Product2.id,
                                Quantity,
                                UnitPrice
                        FROM OrderItems
                )
                from order
                WHERE Contact__c = :user.ContactId AND Status = 'Done'
        ]) {
            resultOrders.add(ord);
        }
        return resultOrders;
    }

    @AuraEnabled
    public static List<CarResult> searchCars(Product2 searchedCar) {
        String brandParam, modelParam, fuelParam, doorsParam, driveParam, transmitionParam, colorParam, type;
        Decimal powerParam, capacityParam, priceParam;
        String query = 'SELECT Id, Name, Brand__c, Model__c, Fuel__c, Doors__c, Drive_Type__c, Transmition__c, Color__c, Power__c, Year__c, Capacity__c, Price__c, Picture__c, Amount__c FROM Product2';

        if (String.isNotEmpty(searchedCar.Brand__c)) {
            modelParam = ' \'%' + searchedCar.Brand__c + '%\' ';
            query += ' WHERE Brand__c LIKE ' + modelParam;
        } else {
            query += ' WHERE Brand__c != null';
        }

        type = 'Model__c';
        query = buildQuery(query, searchedCar.Model__c, type);
        type = 'Fuel__c';
        query = buildQuery(query, searchedCar.Fuel__c, type);
        type = 'Doors__c';
        query = buildQuery(query, searchedCar.Doors__c, type);
        type = 'Drive_Type__c';
        query = buildQuery(query, searchedCar.Drive_Type__c, type);
        type = 'Transmition__c';
        query = buildQuery(query, searchedCar.Transmition__c, type);
        type = 'Color__c';
        query = buildQuery(query, searchedCar.Color__c, type);
        type = 'Power__c';

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
        System.debug(query);

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
        @AuraEnabled public OrderItem carItem { get; set; }
        @AuraEnabled public Order order { get; set; }
        @AuraEnabled public Product2 car { get; set; }
        @AuraEnabled public Date orderDate { get; set; }
        @AuraEnabled public Decimal quantity { get; set; }
        @AuraEnabled public Decimal unitPrice { get; set; }
        @AuraEnabled public Decimal orderPrice { get; set; }
    }

    private static String buildQuery(String query, String param, String type) {
        if (param != null) {
            String modelParam = ' \'%' + param + '%\' ';
            query += ' AND ' + type + ' LIKE ' + modelParam;
        }
        return query;
    }
}








//public with sharing class RCD_CarController {
//
//@AuraEnabled public static List<CarResult> results { get; set; }
//
//@AuraEnabled
//public static void addToBasket(String siteUserId, String carId, Decimal amount, Boolean fromCart) {
//User user = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
//OrderItem newOrderItem = new OrderItem();
//Order basket = [SELECT Id from order WHERE Contact__c = :user.ContactId AND Status = 'Basket'];
//newOrderItem.OrderId = basket.Id;
//newOrderItem.Product2Id = carId;
//
//newOrderItem.Quantity = amount;
//Product2 product = [SELECT Price__c FROM Product2 WHERE Id = :carId];
//newOrderItem.UnitPrice = product.Price__c;
//List<PricebookEntry> pricebookEntries = [SELECT Id FROM PricebookEntry WHERE Product2Id = :carId];
//Id pricebookEntry = pricebookEntries[0].Id;
//newOrderItem.PricebookEntryId = pricebookEntry;
//List<OrderItem> carsInBasket = [SELECT Id, Quantity FROM OrderItem WHERE OrderId = :basket.Id AND Product2Id = :carId LIMIT 1];
//if (carsInBasket.size() > 0) {
//if (!fromCart) {
//newOrderItem.Quantity = carsInBasket[0].Quantity;
//}
//delete carsInBasket[0];
//}
//insert newOrderItem;
//}
//
//@AuraEnabled
//public static void submitOrder(String siteUserId) {
//User user = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
//Account account = [SELECT Id FROM account WHERE name = 'Rafal Jedyk'];
//Contact contact = [SELECT FirstName, LastName FROM Contact WHERE Id = :user.ContactId];
//Order basket = [SELECT Id, ContractId from order WHERE Contact__c = :user.ContactId AND Status = 'Basket'];
//List<OrderItem> orderItems = [SELECT Id, Quantity FROM OrderItem WHERE OrderId = :basket.Id];
//Contract oldContract = [SELECT Status FROM Contract WHERE Id = :basket.ContractId LIMIT 1];
//oldContract.Status = 'Activated';
//update oldContract;
//
//basket.Status = 'Done';
//basket.EffectiveDate = System.Date.today();
//basket.name = contact.FirstName + ' ' + contact.LastName + ' ' + basket.EffectiveDate.format();
//update basket;
//
//Contract contract = new Contract();
//contract.AccountId = account.Id;
//contract.status = 'Draft';
//contract.startdate = System.Date.today();
//contract.ContractTerm = 120;
//insert(contract);
//
//Order order = new Order();
//order.AccountId = account.Id;
//order.status = 'Basket';
//order.Contact__c = user.ContactId;
//order.name = contact.FirstName + ' ' + contact.LastName + ' Cart';
//order.EffectiveDate = System.Date.today();
//order.ContractId = contract.Id;
//order.Pricebook2Id = '01s2X0000027BtXQAU';
//insert(order);
//}
//
//@AuraEnabled
//public static void submitComplain(String siteUserId, String complainSubject, String complainDescription, String complainBrand, String complainModel) {
//User user = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
//Account account = [SELECT Id FROM account WHERE name = 'Rafal Jedyk'];
//Contact contact = [SELECT Id, FirstName, LastName FROM Contact WHERE Id = :user.ContactId];
//Case complain = new Case();
//complain.AccountId = account.Id;
//complain.ContactId = contact.Id;
//complain.Subject = complainSubject;
//complain.ComplainCarBrand__c = complainBrand;
//complain.ComplainCarModel__c = complainModel;
//complain.Description = complainDescription;
//complain.Type = 'Car Dealership Complain';
//complain.Origin = 'Web';
//
//insert complain;
//}
//
//@AuraEnabled
//public static List<CarResult> searchBasket() {
//User user = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
//List<String> productNames = new List<String>();
//List<Decimal> orderPrice = new List<Decimal>();
//List<Date> orderDate = new List<Date>();
//for (order ord : [
//SELECT Id,name, TotalAmount, EffectiveDate, (
//select Id,
//OrderId,
//OrderItemNumber,
//PricebookEntry.Product2.Name,
//PricebookEntry.Product2.Brand__c,
//PricebookEntry.Product2.Picture__c,
//PricebookEntry.Product2.Year__c,
//PricebookEntry.Product2.Price__c,
//PricebookEntry.Product2.Power__c,
//PricebookEntry.Product2.Amount__c,
//PricebookEntry.Product2.id,
//Quantity,
//UnitPrice
//FROM OrderItems
//)
//from order
//WHERE Contact__c = :user.ContactId AND Status = 'Basket'
//]) {
//results = new List<CarResult>();
//for (OrderItem oi : ord.orderItems) {
//CarResult tempResult = new CarResult();
//tempResult.carItem = oi;
//tempResult.car = oi.PricebookEntry.Product2;
//tempResult.quantity = oi.Quantity;
//tempResult.unitPrice = oi.UnitPrice;
//tempResult.orderDate = ord.EffectiveDate;
//tempResult.orderPrice = ord.TotalAmount;
//
//results.add(tempResult);
//productNames.add(oi.PricebookEntry.Product2.name);
//productNames.add(oi.PricebookEntry.Product2.Brand__c);
//productNames.add(oi.Quantity.toPlainString());
//productNames.add(oi.UnitPrice.toPlainString());
//
//}
//orderPrice.add(ord.TotalAmount);
//orderDate.add(ord.EffectiveDate);
//}
//
//return results;
//}
//
//@AuraEnabled
//public static List<Order> searchOrders() {
//User user = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
//List<String> productNames = new List<String>();
//List<Decimal> orderPrice = new List<Decimal>();
//List<Date> orderDate = new List<Date>();
//List<Order> resultOrders = new List<Order>();
//for (order ord : [
//SELECT Id,name, TotalAmount, EffectiveDate, (
//select Id,
//OrderId,
//OrderItemNumber,
//PricebookEntry.Product2.Name,
//PricebookEntry.Product2.Brand__c,
//PricebookEntry.Product2.Picture__c,
//PricebookEntry.Product2.Year__c,
//PricebookEntry.Product2.Price__c,
//PricebookEntry.Product2.Power__c,
//PricebookEntry.Product2.Amount__c,
//PricebookEntry.Product2.id,
//Quantity,
//UnitPrice
//FROM OrderItems
//)
//from order
//WHERE Contact__c = :user.ContactId AND Status = 'Done'
//]) {
//resultOrders.add(ord);
//}
//return resultOrders;
//}
//
//@AuraEnabled
//public static List<CarResult> searchCars(Product2 searchedCar) {
//String brandParam, modelParam, fuelParam, doorsParam, driveParam, transmitionParam, colorParam, type;
//Decimal powerParam, capacityParam, priceParam;
//String query = 'SELECT Id, Name, Brand__c, Model__c, Fuel__c, Doors__c, Drive_Type__c, Transmition__c, Color__c, Power__c, Year__c, Capacity__c, Price__c, Picture__c, Amount__c FROM Product2';
//
//if (String.isNotEmpty(searchedCar.Brand__c)) {
//modelParam = ' \'%' + searchedCar.Brand__c + '%\' ';
//query += ' WHERE Brand__c LIKE ' + modelParam;
//} else {
//query += ' WHERE Brand__c != null';
//}
//
//type = 'Model__c';
//query = buildQuery(query, searchedCar.Model__c, type);
//type = 'Fuel__c';
//query = buildQuery(query, searchedCar.Fuel__c, type);
//type = 'Doors__c';
//query = buildQuery(query, searchedCar.Doors__c, type);
//type = 'Drive_Type__c';
//query = buildQuery(query, searchedCar.Drive_Type__c, type);
//type = 'Transmition__c';
//query = buildQuery(query, searchedCar.Transmition__c, type);
//type = 'Color__c';
//query = buildQuery(query, searchedCar.Color__c, type);
//type = 'Power__c';
//
//if (searchedCar.Power__c != null) {
//powerParam = searchedCar.Power__c;
//query += ' AND Power__c >= ' + powerParam;
//}
//
//if (searchedCar.Capacity__c != null) {
//capacityParam = searchedCar.Capacity__c;
//query += ' AND Capacity__c >= ' + capacityParam;
//}
//
//if (searchedCar.Price__c != null) {
//priceParam = searchedCar.Price__c;
//query += ' AND Price__c <= ' + priceParam;
//}
//
//query += ' ORDER BY Name ASC';
//System.debug(query);
//
//try {
//List<Product2> rcdCars = Database.query(query);
//results = new List<CarResult>();
//for (Product2 car : rcdCars) {
//CarResult tempResult = new CarResult();
//tempResult.car = car;
//results.add(tempResult);
//}
//} catch (Exception exc) {
//System.debug('Error');
//}
//
//return results;
//}
//
//public class CarResult {
//@AuraEnabled public OrderItem carItem { get; set; }
//@AuraEnabled public Order order { get; set; }
//@AuraEnabled public Product2 car { get; set; }
//@AuraEnabled public Date orderDate { get; set; }
//@AuraEnabled public Decimal quantity { get; set; }
//@AuraEnabled public Decimal unitPrice { get; set; }
//@AuraEnabled public Decimal orderPrice { get; set; }
//}
//
//private static String buildQuery(String query, String param, String type) {
//if (param != null) {
//String modelParam = ' \'%' + param + '%\' ';
//query += ' AND ' + type + ' LIKE ' + modelParam;
//}
//return query;
//}
//}