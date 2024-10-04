global class ApplyVersion implements Schedulable {
    public Id leadId;

    public ApplyVersion(Id leadId) {
        this.leadId = leadId;
    }

    global void execute(SchedulableContext SC) {
        Lead ld = [Select Id,
                           Status,
                           DataHoraVencimento__c,
                           ConfiguracaoDeSLA__c,
                           ConfiguracaoDeSLA__r.Fase_para_redirecionamento_do_Lead__c,
                           ConfiguracaoDeSLA__r.Step__c,
                           ConfiguracaoDeSLA__r.Fila_para_redirecionamento_do_Lead__c
                       FROM Lead
                       Where Id = :this.leadId
                      ];

        if (ld.Status.equalsIgnoreCase(ld.ConfiguracaoDeSLA__r.Step__c) && ld.DataHoraVencimento__c < DateTime.now()) {
            ld.OwnerId = [Select Id from Group where Name = :ld.ConfiguracaoDeSLA__r.Fila_para_redirecionamento_do_Lead__c LIMIT 1].Id;
            ld.Status = ld.ConfiguracaoDeSLA__r.Fase_para_redirecionamento_do_Lead__c;

          
            TriggerHandler.bypass('LeadTriggerHandler');
            update ld;
            TriggerHandler.clearBypass('LeadTriggerHandler');
        }
    }
}