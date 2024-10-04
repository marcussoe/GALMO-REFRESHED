trigger CreateRegisterContactRoleTrigger on AccountContactRelation (after insert, after update) {
    Set<Id> accountIds = new Set<Id>();

    for (AccountContactRelation acr : Trigger.new) {
        if (acr.Relacionamento__c == 'Cônjuge/Companheiro') {
            accountIds.add(acr.AccountId);
        }
    }

    if (!accountIds.isEmpty()) {
        OpportunityContactRoleUpdater.updateContactRoles(accountIds);
    }
}