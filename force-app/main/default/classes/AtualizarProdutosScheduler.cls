global class AtualizarProdutosScheduler implements System.Schedulable { 
    global void execute( System.SchedulableContext context) {
        AtualizarProdutosBatch atualizacaoBatch = new AtualizarProdutosBatch(); 
        Database.executeBatch(atualizacaoBatch, 1);
    }
}