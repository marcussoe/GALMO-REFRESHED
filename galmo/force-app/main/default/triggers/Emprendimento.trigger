trigger Emprendimento on Lead (before insert) {
    
    // Map<String, List<Lead>> mapLeadStatus = new Map<String, List<Lead>>();
    // for (Lead newLead : Trigger.new) {
    //     if(mapLeadStatus.containskey(newLead.Empreendimento_de_Interesse__c)){
    //         mapLeadStatus.get(newLead.Empreendimento_de_Interesse__c).add(newLead);
    //     }else{
    //         mapLeadStatus.put(newLead.Empreendimento_de_Interesse__c, new List<Lead>{newLead});
    //     }
    // }
    
    // for(Enterprise__c empreendimento : [Select Id, Name from Enterprise__c where name =: mapLeadStatus.keyset()]){
    //     for(Lead ld : mapLeadStatus.get(empreendimento.name)){
    //         ld.InterestedEnterprise__c = empreendimento.Id;
    //     }
    // }
    
    
    
}