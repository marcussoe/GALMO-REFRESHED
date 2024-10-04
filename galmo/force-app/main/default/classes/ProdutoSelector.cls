public class ProdutoSelector {
    public static Product2 getProdutosById(Id id){
        return [SELECT Enterprise__r.Name, Name, Andar__c, MetragemTotal__c, NumeroUnidade__c , NumeroQuartos__c  from Product2 where id =: id];
    }

    public static Map<Id, Product2> CoeficienteProdutoPorId(List<Id> produtoIds) {
        Map<Id, Product2> produtoMap = new Map<Id, Product2>([
            SELECT Id, Coeficiente__c 
            FROM Product2 
            WHERE Id IN :produtoIds
        ]);
        return produtoMap;
    }
}