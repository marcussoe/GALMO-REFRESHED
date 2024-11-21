public class ChecklistHelper {
    public static void updateOpportunityChecklistStatus(List<Checklist_de_Documentos__c> checklists) {
        Set<Id> opportunityIds = new Set<Id>();

        
        for (Checklist_de_Documentos__c checklist : checklists) {
            if (checklist.Oportunidade__c != null) {
                opportunityIds.add(checklist.Oportunidade__c);
            }
        }

        if (opportunityIds.isEmpty()) {
            return;
        }

       
        Map<Id, List<Checklist_de_Documentos__c>> checklistDocsMap = ChecklistDA.getChecklistDocumentsWithDetails(opportunityIds);

        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

        for (Id oppId : opportunityIds) {
            List<Checklist_de_Documentos__c> docs = checklistDocsMap.get(oppId);

            Boolean anyMandatoryNotDelivered = false;
            Boolean allMandatoryDelivered = true;
            Boolean allDocumentsDelivered = true;

            if (docs != null && !docs.isEmpty()) {
                for (Checklist_de_Documentos__c checklist : docs) {
                    if(checklist.Documenta_o__c != null){
                      if(checklist.Documenta_o__r.Obrigatorio__c && !checklist.Documenta_o__r.Entregue_c__c){
                        anyMandatoryNotDelivered = true;
                        allMandatoryDelivered = false;
                        allDocumentsDelivered = false;
                      }
                    }
                }
            }

            String newFarolStatus = 'Vermelho';
            if (!anyMandatoryNotDelivered) {
                if (allDocumentsDelivered) {
                    newFarolStatus = 'Azul';
                } else {
                    newFarolStatus = 'Verde';
                }
            }

            Opportunity opp = new Opportunity(Id = oppId, FarolChecklistDocumento__c = newFarolStatus);
            opportunitiesToUpdate.add(opp);
        }

        if (!opportunitiesToUpdate.isEmpty()) {
            update opportunitiesToUpdate;
        }
    }
}