public with sharing class LeadVencidoSchedule implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Lead> leads = [SELECT Id,
            ConfiguracaoDeSLA__c,
            ConfiguracaoDeSLA__r.Step__c,
            ConfiguracaoDeSLA__r.MotivoPerda__c,
            ConfiguracaoDeSLA__r.Fase_para_redirecionamento_do_Lead__c,
            ConfiguracaoDeSLA__r.Fila_para_redirecionamento_do_Lead__c,
            OwnerId
            FROM Lead
            WHERE Vencido__c = true];

        Map<String, Id> filaNameToIdMap = new Map<String, Id>();
        for (Group fila : [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Descartado']) {
            filaNameToIdMap.put(fila.Name, fila.Id);
        }

        for (Lead lead : leads) {
            if (filaNameToIdMap.containsKey(lead.ConfiguracaoDeSLA__r.Fila_para_redirecionamento_do_Lead__c)) {
                lead.OwnerId = filaNameToIdMap.get(lead.ConfiguracaoDeSLA__r.Fila_para_redirecionamento_do_Lead__c);
            }

            if (!String.isEmpty(lead.ConfiguracaoDeSLA__c)) {
                lead.Status = lead.ConfiguracaoDeSLA__r.Step__c;
                lead.MotivoPerda__c = lead.ConfiguracaoDeSLA__r.MotivoPerda__c;
            }
        }

        update leads;
    }
}