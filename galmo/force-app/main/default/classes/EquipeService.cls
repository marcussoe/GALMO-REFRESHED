public class EquipeService {
    
    public static void validarMembroDeEquipeDuplicado(List<MembroEquipe__c> membroEquipe) {
        Set<Id> idUsuario = new Set<Id>();
        Set<Id> idEquipe = new Set<Id>();
        
        for (MembroEquipe__c membro : (List<MembroEquipe__c>)Trigger.new) {
            idUsuario.add(membro.Usuario__c);
            idEquipe.add(membro.Equipe__c);
        }

        List<MembroEquipe__c> membrosEquipe = MembroEquipeSelector.obterMembrosPorIds(IdUsuario, idEquipe);
    
        if(!membrosEquipe.isEmpty()) {
            for (MembroEquipe__c membro : membroEquipe) {
                membro.addError('Membro de equipe já existe. Não é permitido adicionar membros duplicados.');
            }
        }
    }
}