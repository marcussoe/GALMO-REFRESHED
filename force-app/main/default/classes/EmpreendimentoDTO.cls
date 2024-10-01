public without sharing class EmpreendimentoDTO {
    public String IdEmpreendimento;
    public String nomeEmpreendimento;
    public String cnpj;
    public String spe;
    public String statusObra;

    public static Enterprise__c toEnterprise(){
        Enterprise__c enterprise = new Enterprise__c();
        enterprise.Id = this.IdEmpreendimento;
        enterprise.Name = this.nomeEmpreendimento;
        enterprise.CNPJ__c = this.cnpj;
        enterprise.SPE__c = this.spe;
        enterprise.Status_Obra__c = this.statusObra;

        return enterprise;
    }

    public static List<Enterprise__c> parse(String json){
        List<EmpreendimentoDTO> list = (List<EmpreendimentoDTO>) System.JSON.deserialize(json, List<EmpreendimentoDTO>.class);
    }
}