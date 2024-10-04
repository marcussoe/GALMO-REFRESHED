@isTest
public class ApplyVersionTest {

    static Lead testLead;

    @testSetup
    static void setup() {
        // Configuração inicial dos dados de teste para objetos regulares
        Group testGroup = new Group(Name='Descartado', Type='Queue');
        insert testGroup;
        QueueSObject queueSObject = new QueueSObject(QueueId = testGroup.Id, SObjectType = 'Lead');
        insert queueSObject;

        // Criando um lead de teste com as configurações de SLA
        BusinessSettings__c testConfig = new BusinessSettings__c(
            Name = 'Test SLA Config',
            SlaTime__c = -1, 
            Step__c = 'Novo',
            Fase_para_redirecionamento_do_Lead__c = 'Novo',
            Fila_para_redirecionamento_do_Lead__c = 'Descartado'
        );
        insert testConfig;

        DateTime dataHoraVencida = DateTime.now().addMinutes(-1); 
        testLead = new Lead(
            LastName = 'Test Lead',
            Status = 'Novo', // Lead está no status inicial
            DataHoraVencimento__c = dataHoraVencida,
            ConfiguracaoDeSLA__c = testConfig.Id
        );
        insert testLead;
    }

    @isTest
    static void testApplyVersion() {
        Test.startTest();

        // Executando a lógica da ApplyVersion para o lead de teste
        ApplyVersion scheduler = new ApplyVersion(testLead.Id);
        scheduler.execute(null); // Como não estamos usando o SchedulableContext, passamos null aqui

        Test.stopTest();

        // Verificando se o lead foi atualizado conforme esperado
        Lead updatedLead = [SELECT Id, OwnerId, Status FROM Lead WHERE Id = :testLead.Id];

        System.assertEquals('Novo', updatedLead.Status, 'Status do lead não foi atualizado corretamente.');
        System.assertNotEquals(testLead.OwnerId, updatedLead.OwnerId, 'OwnerId do lead não foi atualizado para a fila correta.');
    }
}