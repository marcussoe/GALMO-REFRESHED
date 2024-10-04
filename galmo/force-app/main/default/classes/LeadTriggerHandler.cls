public with sharing class LeadTriggerHandler extends TriggerHandler {
    public override void beforeUpdate() {
        LeadHelper.verifyLeadControlSLA(Trigger.new);
        LeadHelper.statusValidate(Trigger.new, (Map<Id, Lead>) Trigger.oldMap);
        LeadHelper.additionalValidations(Trigger.new, (Map<Id, Lead>) Trigger.oldMap);
        LeadHelper.setFirstDevelopment(Trigger.new);
        LeadHelper.setOriginalMedia(Trigger.new);
    }

    public override void beforeInsert() {
        LeadHelper.verifyLeadControlSLA(Trigger.new);
        LeadHelper.setInterestedEnterprise(Trigger.new);
        LeadHelper.validacaoComecarLeadComoNovo(Trigger.new);         
    }

    public override void afterUpdate() {
        LeadHelper.scheduleLeadChange(Trigger.new, (Map<Id, Lead>) Trigger.oldMap);
        DistribuirLeadsService.distribuirLeads((List<Lead>)Trigger.new);
    }

    public override void afterInsert() {
        LeadHelper.scheduleLeadChange(Trigger.new, (Map<Id, Lead>)Trigger.oldMap);
        DistribuirLeadsService.distribuirLeads((List<Lead>)Trigger.new);
    }

    public static void scheduleLeadChange(List<Lead> leadList, Map<Id, Lead> oldLeads) {
        LeadHelper.scheduleLeadChange(leadList, oldLeads);
    }
}