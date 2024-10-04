@isTest
public class RoletaLeadsHelperTest {

    @isTest
    static void testScheduleRoletaCleanUp() {
        // Criação de dados de teste para RoletaLeads__c
        List<RoletaLeads__c> roletas = new List<RoletaLeads__c>();
        RoletaLeads__c roleta1 = new RoletaLeads__c(Name = 'Roleta Teste 1', HoraInicio__c = Time.newInstance(10, 0, 0, 0), HoraFim__c = Time.newInstance(10, 15, 0, 0));
        RoletaLeads__c roleta2 = new RoletaLeads__c(Name = 'Roleta Teste 2', HoraInicio__c = Time.newInstance(12, 0, 0, 0), HoraFim__c = Time.newInstance(12, 30, 0, 0));
        roletas.add(roleta1);
        roletas.add(roleta2);
        insert roletas;

        Test.startTest();

        // Chama o método da RoletaLeadsHelper
        RoletaLeadsHelper.scheduleRoletaCleanUp(roletas);

        Test.stopTest();

        // Verifica se os participantes foram excluídos conforme esperado
        List<ParticipanteRoleta__c> participantesRoleta1 = [SELECT Id FROM ParticipanteRoleta__c WHERE RoletaLeads__c = :roleta1.Id];
        List<ParticipanteRoleta__c> participantesRoleta2 = [SELECT Id FROM ParticipanteRoleta__c WHERE RoletaLeads__c = :roleta2.Id];

        System.assertEquals(0, participantesRoleta1.size(), 'Participantes da Roleta 1 deveriam ser excluídos.');
        System.assertEquals(0, participantesRoleta2.size(), 'Participantes da Roleta 2 deveriam ser excluídos.');
    }
}