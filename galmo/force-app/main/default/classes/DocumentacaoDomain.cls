public class DocumentacaoDomain {
    public static Map<Id, List<Documentacao__c>> obterDocumentacaoPorIdContato(List<Documentacao__c> documentacoes) {
        Map<Id, List<Documentacao__c>> documentacaoPorIdContato = new Map<Id, List<Documentacao__c>>();

        for(Documentacao__c documentacao : documentacoes) {
            if(!documentacaoPorIdContato.containsKey(documentacao.Contato__c)) {
                documentacaoPorIdContato.put(documentacao.Contato__c, new List<Documentacao__c>());
            }

            documentacaoPorIdContato.get(documentacao.Contato__c).add(documentacao);
        }

        return documentacaoPorIdContato;
    }
}