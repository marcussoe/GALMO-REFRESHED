public class DistribuicaoComissaoService {

    public static void atualizarComissoes(List<DistribuicaoComissao__c> distribuicoes) {
        System.debug('Updating comissoes with distribuicoes: ' + distribuicoes);

        Set<Id> comissaoIds = new Set<Id>();
        for (DistribuicaoComissao__c distrib : distribuicoes) {
            if (distrib.Comissao__c != null) {
                comissaoIds.add(distrib.Comissao__c);
            }
        }

        Map<Id, List<DistribuicaoComissao__c>> distribMap = new Map<Id, List<DistribuicaoComissao__c>>();
        List<DistribuicaoComissao__c> todasDistribuicoes = DistribuicaoComissaoSelector.obterDistribuicoes(comissaoIds);

        for (DistribuicaoComissao__c distrib : todasDistribuicoes) {
            if (!distribMap.containsKey(distrib.Comissao__c)) {
                distribMap.put(distrib.Comissao__c, new List<DistribuicaoComissao__c>());
            }
            distribMap.get(distrib.Comissao__c).add(distrib);
        }

        Map<Id, Decimal> comissaoMap = new Map<Id, Decimal>();

        for (Id comissaoId : distribMap.keySet()) {
            Decimal valorTotal = 0;
            for (DistribuicaoComissao__c distrib : distribMap.get(comissaoId)) {
                valorTotal += distrib.ValorComissaoPorcentagem__c;
            }
            comissaoMap.put(comissaoId, valorTotal);
        }

        Map<Id, Comissao__c> comissaoRecords = DistribuicaoComissaoSelector.obterComissoes(comissaoMap.keySet());

        for (Id comissaoId : comissaoMap.keySet()) {
            Comissao__c comissao = comissaoRecords.get(comissaoId);
            if (comissao != null) {
                comissao.ValorTotalComissaoPorcentagem__c = comissaoMap.get(comissaoId);
            }
        }

        if (!comissaoRecords.isEmpty()) {
            update comissaoRecords.values();
            System.debug('Comissoes updated in database');
        }
    }

    public static void diminuiComissoes(List<DistribuicaoComissao__c> distribuicoes) {
        System.debug('Decreasing comissoes with distribuicoes: ' + distribuicoes);

        Set<Id> comissaoIds = new Set<Id>();
        for (DistribuicaoComissao__c distrib : distribuicoes) {
            if (distrib.Comissao__c != null) {
                comissaoIds.add(distrib.Comissao__c);
            }
        }

       
        Map<Id, Decimal> comissaoMap = new Map<Id, Decimal>();
        for (Id comissaoId : comissaoIds) {
          
            Decimal valorTotal = 0;
            List<DistribuicaoComissao__c> distribuicoesRestantes = [
                SELECT ValorComissaoPorcentagem__c
                FROM DistribuicaoComissao__c
                WHERE Comissao__c = :comissaoId
            ];
            for (DistribuicaoComissao__c distrib : distribuicoesRestantes) {
                valorTotal += distrib.ValorComissaoPorcentagem__c;
            }
            comissaoMap.put(comissaoId, valorTotal);
        }

      
        Map<Id, Comissao__c> comissaoRecords = DistribuicaoComissaoSelector.obterComissoes(comissaoMap.keySet());

        for (Id comissaoId : comissaoMap.keySet()) {
            Comissao__c comissao = comissaoRecords.get(comissaoId);
            if (comissao != null) {
              
                comissao.ValorTotalComissaoPorcentagem__c = comissaoMap.get(comissaoId) > 0 ? comissaoMap.get(comissaoId) : 0;
            }
        }

        if (!comissaoRecords.isEmpty()) {
            update comissaoRecords.values();
            System.debug('Comissoes updated in database');
        }
    }
}