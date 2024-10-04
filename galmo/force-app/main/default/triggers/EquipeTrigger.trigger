trigger EquipeTrigger on MembroEquipe__c (before update, before insert) {
    new EquipeTriggerHandler().run();
}