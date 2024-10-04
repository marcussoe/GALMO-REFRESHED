trigger LeadTrigger on Lead (before update, before insert,after update,after insert) {
    new LeadTriggerHandler().run();
}