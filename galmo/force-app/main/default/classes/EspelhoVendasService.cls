public with sharing class EspelhoVendasService {

    @AuraEnabled(cacheable=true)
    public static List<Enterprise__c> getEmpreendimentosDisponiveis() {
        return [
            SELECT Id, Name
            FROM Enterprise__c
            WHERE DisponivelEspelho__c = TRUE
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Product2> getUnidades(String empreendimentoId, String bloco, String andar, String status, String finalUnidade) {
        List<Product2> unidades = new List<Product2>();

        String query = 'SELECT Id, Name, ProductCode, Description, Family, PrecoLista__c, Situacao__c, Andar__c FROM Product2';
        List<String> conditions = new List<String>();
        Map<String, Object> params = new Map<String, Object>();

        if (!String.isEmpty(empreendimentoId)) {
            conditions.add('Empreendimento__c = :empreendimentoId');
            params.put('empreendimentoId', empreendimentoId);
        }
        
        if (!String.isEmpty(bloco)) {
            conditions.add('Bloco__c = :bloco');
            params.put('bloco', bloco);
        }

        if (!String.isEmpty(andar)) {
            conditions.add('Andar__c = :andar');
            params.put('andar', andar);
        }

        if (!String.isEmpty(status)) {
            conditions.add('Situacao__c = :status');
            params.put('status', status);
        }

        if (!String.isEmpty(finalUnidade)) {
            conditions.add('Final_da_Unidade__c = :finalUnidade');
            params.put('finalUnidade', finalUnidade);
        }

        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }
        
        query += ' ORDER BY Andar__c, Name';

        unidades = Database.query(query);
        
        return unidades;
    }
}