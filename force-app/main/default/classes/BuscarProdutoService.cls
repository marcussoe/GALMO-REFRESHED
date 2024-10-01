public with sharing class BuscarProdutoService {

    @AuraEnabled
    public static void atualizarProdutos(List<Product2> produtos){       
        List<Product2> unidadesToUpsert = new List<Product2>();
        HttpRequest req = new HttpRequest();
        String token = retrieveToken(); /* Criar uma classe que faz o retrive do token do mega */
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setMethod('GET');

        for(Product2 produto : produtos){
            req.setEndpoint('https://viacep.com.br/ws/' + produtoId + '/json/'); /* a definir o endpoint */
            
            try{
                Http http = new Http();
                HTTPResponse res = http.send(req);

                if(res.getStatusCode() == 200){
                    List<ProdutoDTO> produtos = ProdutoDTO.parse(res.getBody());

                    if(produtos.size() > 0){
                        Product2 unidade = ProdutoDTO.toProduct(produtos[0]);

                        unidadesToUpsert.add(unidade);
                    }

                    if(unidadesToUpsert.size() > 0){
                        upsert unidadesToUpsert;
                    }
                }else{
                    return '';
                }
            }catch (Exception e) {
                throw new WebServiceException('Erro ao buscar produto: ' + e.getMessage());
            }
        }
    }

    public class WebServiceException extends Exception{
        public WebServiceException(String message){
            super(message);
        }
    }
}