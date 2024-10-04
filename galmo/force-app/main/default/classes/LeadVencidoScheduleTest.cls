@isTest
public class LeadVencidoScheduleTest {
    static Lead lead;

    @testSetup
    static void setup() {
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Group testGroup = new Group(Name='Descartado', Type='Queue');
            insert testGroup;
            insert new QueueSObject(QueueID = testGroup.id, SObjectType = 'Lead');
        }

        List<BusinessSettings__c> configs = new List<BusinessSettings__c> {
            new BusinessSettings__c(
                SlaTime__c = -1, 
                Step__c = 'Novo',
                Fase_para_redirecionamento_do_Lead__c = 'Novo',
                Fila_para_redirecionamento_do_Lead__c = 'Descartado'
            )
        };
        insert configs;

        DateTime dataHoraVencida = DateTime.now().addMinutes(-1); 
        lead = new Lead(
            LastName = 'Silva Salada',
            Company = 'Empresa XYZSantiagoSaladaWIll',
            LeadSource = 'Chat',
            Email = 'silvaSaladaSantiago@xyz.com',
            CanalAtendimento__c = 'Telefone',
            MobilePhone = '11952187488',
            Status = 'Novo',
            ConfiguracaoDeSLA__c = configs[0].Id,
            DataHoraVencimento__c = dataHoraVencida
        );
        insert lead;
    }

    @isTest
    static void testLeadVencidoSchedule() {
        Test.startTest();
    
        LeadVencidoSchedule scheduler = new LeadVencidoSchedule();
        String sch = '0 0 23 * * ?';
        System.schedule('Test Lead Vencido Schedule', sch, scheduler);

        Test.stopTest();
    }
}