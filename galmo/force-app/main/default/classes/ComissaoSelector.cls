public with sharing class ComissaoSelector {
    public static List<Comissao__c> obterComissaoPorId(Id serieDePagamentosId){
        return [
            SELECT 
            ValorTotalComissaoPorcentagem__c, 
            PorcentagemMaximaComissao__c 
            FROM Comissao__c 
            WHERE SeriePagamentos__c = :serieDePagamentosId
            LIMIT 1];
    }
}