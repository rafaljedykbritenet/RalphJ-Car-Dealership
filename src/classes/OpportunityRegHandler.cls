global class OpportunityRegHandler implements Auth.RegistrationHandler{

    global User createUser(Id portalId, Auth.UserData data){
        Account account = [SELECT Id FROM account WHERE name='Rafal Jedyk'];

        Contact contact = new Contact();
        contact.accountId = account.Id;
        contact.email = data.email;
        contact.firstName = data.firstName;
        contact.lastName = data.lastName;
        insert(contact);

        Contract contract = new Contract();
        contract.AccountId = account.Id;
        contract.status = 'Draft';
        contract.startdate = System.Date.today();
        contract.ContractTerm = 120;
        insert(contract);

        Order order = new Order();
        order.AccountId = account.Id;
        order.status = 'Basket';
        order.Contact__c = contact.Id;
        order.name = data.firstName + ' ' + data.lastName + ' Cart';
        order.EffectiveDate = System.Date.today();
        order.ContractId = contract.Id;
        order.Pricebook2Id = '01s2X0000027BtXQAU';
        insert(order);

        Opportunity oppty = new Opportunity();
        oppty.name = 'Car Dealership Engagement';
        oppty.stageName = 'Registered';
        oppty.closeDate = System.Date.today() + 90;
        insert(oppty);

        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.opportunityid = oppty.id;
        ocr.contactId = contact.id;
        ocr.isPrimary = true;
        insert(ocr);

        User user = new User();
        Profile p = [SELECT Id FROM profile WHERE name='Car Dealership Community User'];
        user.username = data.email;
        user.email = data.email;
        user.lastName = data.lastName;
        user.firstName = data.firstName;
        user.CommunityNickname = data.firstName + ' ' + data.lastName;
        String alias = data.email;
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        user.alias = alias;
        user.languagelocalekey = 'en_US';
        user.localesidkey = 'en_IE_EURO';
        user.emailEncodingKey = 'ISO-8859-1';
        user.timeZoneSidKey = 'Europe/Dublin';
        user.profileId = p.Id;
        user.contactId = contact.Id;
        return user;

    }

    global void updateUser(Id userId, Id portalId, Auth.UserData data){

        User user = [select firstName, lastName, email, contactId from User where id =: userId];
        user.email = data.email;
        user.lastName = data.lastName;
        user.firstName = data.firstName;
        user.CommunityNickname = data.firstName + ' ' + data.lastName;
        update(user);
        
        Contact contact = [select firstName, lastName, email from Contact where id =: user.contactId];
        contact.email = data.email;
        contact.lastName = data.lastName;
        contact.firstName = data.firstName;
        update(contact);
    }
}