global class AtualizarProdutosBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, ExternalId FROM Product2 WHERE IsActive = true';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<Product2> produtos = new List<Product2>();
        
        for (SObject s : scope) {
            Product2 produto = (Product2) s;
            produtos.add(produto);
        }

        if(!produtos.isEmpty()){
            try {
                BuscarProdutoService.atualizarProdutos(produtos);
            } catch (Exception e) {
                System.debug('Erro ao atualizar produtos: ' + e.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch de atualização de produtos concluído.');
    }
}
