trigger OpportunityContactRoleTrigger on OpportunityContactRole (before insert, after insert) {
    (new OpportunityContactRoleTriggerHandler()).run();
}