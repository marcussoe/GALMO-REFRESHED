public class OpportunityContactRoleUpdater {
    public static void updateContactRoles(Set<Id> accountIds) {
        List<OpportunityContactRole> rolesToUpdate = new List<OpportunityContactRole>();
        List<OpportunityContactRole> rolesToInsert = new List<OpportunityContactRole>();

        // Obtém todas as oportunidades associadas às contas fornecidas
        List<Opportunity> opportunities = [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN :accountIds];
        
        // Mapeia a conta ao seu cônjuge
        Map<Id, Id> accountSpouseMap = new Map<Id, Id>();
        for (AccountContactRelation acr : [SELECT AccountId, ContactId FROM AccountContactRelation WHERE AccountId IN :accountIds AND Relacionamento__c = 'Cônjuge/Companheiro']) {
            accountSpouseMap.put(acr.AccountId, acr.ContactId);
        }

        for (Opportunity opp : opportunities) {
            // Obtém todos os Contact Roles existentes na Oportunidade
            List<OpportunityContactRole> existingRoles = [SELECT Id, ContactId, Role, PorcentagemParticipacao__c, IsPrimary FROM OpportunityContactRole WHERE OpportunityId = :opp.Id];
            Map<String, OpportunityContactRole> roleMap = new Map<String, OpportunityContactRole>();

            for (OpportunityContactRole ocr : existingRoles) {
                roleMap.put(ocr.Role, ocr);
            }

            // Obtém o comprador principal
            OpportunityContactRole primaryBuyerRole = null;
            for (OpportunityContactRole ocr : existingRoles) {
                if (ocr.IsPrimary) {
                    primaryBuyerRole = ocr;
                    break;
                }
            }

            Id spouseId = accountSpouseMap.get(opp.AccountId);

            // Atualiza ou insere o Contact Role para o comprador principal
            if (primaryBuyerRole != null) {
                primaryBuyerRole.PorcentagemParticipacao__c = 50;
                rolesToUpdate.add(primaryBuyerRole);
            }

            // Atualiza ou insere o Contact Role para o cônjuge
            if (spouseId != null) {
                OpportunityContactRole spouseRole = roleMap.get('Cônjuge/Companheiro');
                if (spouseRole == null) {
                    spouseRole = new OpportunityContactRole(OpportunityId = opp.Id, ContactId = spouseId, Role = 'Cônjuge/Companheiro', PorcentagemParticipacao__c = 50);
                    rolesToInsert.add(spouseRole);
                } else {
                    spouseRole.PorcentagemParticipacao__c = 50;
                    rolesToUpdate.add(spouseRole);
                }
            }
        }

        if (!rolesToInsert.isEmpty()) {
            insert rolesToInsert;
        }

        if (!rolesToUpdate.isEmpty()) {
            update rolesToUpdate;
        }
    }
}