public with sharing class BuscarProdutoService {
    
    public static void atualizarProdutos(List<Product2> produtos){
        List<Product2> unidadesToUpsert = new List<Product2>();
        List<Empreendimento__c> empToUpsert = new List<Empreendimento__c>();
        List<Bloco__c> blocosToUpsert = new List<Bloco__c>();
        
        HttpRequest req = new HttpRequest();
        String token = retrieveToken(); /* Criar uma classe que faz o retrive do token do mega */
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setMethod('GET');
        
        for(Product2 produto : produtos){
            req.setEndpoint('https://viacep.com.br/ws/' + produto.Id + '/json/'); /* a definir o endpoint */
                
            try{
                Http http = new Http();
                HTTPResponse res = http.send(req);
                
                if(res.getStatusCode() == 200){
                    ProdutoDTO dto = ProdutoDTO.parse(res.getBody());
                    
                    if(produtos.size() > 0){
                        Product2 unidade = dto.toProduct();
                        
                        Empreendimento__c emp = new Empreendimento__c();
                        emp.Id = produto.idEmpreendimento;
                        emp.Name = produto.empreendimento.nomeEmpreendimento;
                        emp.CNPJ__c = produto.empreendimento.cnpj;
                        emp.SPE__c = produto.empreendimento.spe;
                        emp.Status_Obra__c = produto.empreendimento.statusObra;
                        empToUpsert.add(emp);
                        
                        Bloco__c bloco = new Bloco__c();
                        bloco.Id = produto.idBloco;
                        bloco.Quantidade_Andares__c = produto.bloco.quantidadeAndares;
                        bloco.Total_Unidades__c = produto.bloco.totalUnidades;
                        bloco.Data_Inicio__c = produto.bloco.dataInício;
                        bloco.Data_Habite_Se__c = produto.bloco.dataHabiteSe;
                        bloco.Codigo_Bloco__c = produto.bloco.codigoBloco;
                        bloco.Nome_Bloco__c = produto.bloco.nomeBloco;
                        bloco.Tipo_Bloco__c = produto.bloco.tipoBloco;
                        blocosToUpsert.add(bloco);
                        
                        unidadesToUpsert.add(unidade);
                    }
                }
            }catch (Exception e) {
                throw new WebServiceException('Erro ao buscar produto: ' + e.getMessage());
            }
        }
        
        if(unidadesToUpsert.size() > 0 && empToUpsert.size() > 0 && blocosToUpsert.size() > 0){
            upsert unidadesToUpsert;
            upsert empToUpsert;
            upsert blocosToUpsert;
        }
    }
    
    public class WebServiceException extends Exception{
        public WebServiceException(String message){
            super(message);
        }
    }
}