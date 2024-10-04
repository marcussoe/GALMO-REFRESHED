trigger OportunidadeTrigger on Opportunity  (before insert) {
    new OpportunityTriggerHandler().run();
}