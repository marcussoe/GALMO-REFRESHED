public class EspelhoVendasController {
    @AuraEnabled(cacheable = true)
    public static List<Product2> unidadePesquisada(Decimal searchKey, Id idBloco) {
        return searchKey != null 
            ? UnidadeSelector.pesquisarUnidadesPorBloco(searchKey, idBloco)
            : UnidadeSelector.obterUnidadesPorBloco(idBloco);
    }

    @AuraEnabled(cacheable = true)
    public static List<Product2> buscarUnidades(String idBloco){
        return UnidadeSelector.buscarUnidades(idBloco);
    }

    @AuraEnabled(cacheable = true)
    public static List<Enterprise__c> getEmpreendimentoRecords() {
        return EmpreendimentoSelector.getEmpreendimentoRecords();
    }

    @AuraEnabled(cacheable = true)
    public static List<Bloco__c> obterBlocosPorIdsEmpreendimentos(List<Id> idsEmpreendimentos){
        return BlocoSelector.obterBlocosPorIdsEmpreendimentos(new Set<Id>(idsEmpreendimentos));
    }
}