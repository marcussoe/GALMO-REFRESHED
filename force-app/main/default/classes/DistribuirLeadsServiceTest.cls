@isTest
private class DistribuirLeadsServiceTest {
    private static final String ALIAS_USUARIO_1 = 'standt';
    private static final String ALIAS_USUARIO_2 = 'teste';
    private static final String EMAIL_USUARIO_1 = 'standarduser@testorg.com';
    private static final String EMAIL_USUARIO_2 = 'teste@testorg.com';
    private static final String LAST_NAME_USUARIO_1 = 'Testing';
    private static final String LAST_NAME_USUARIO_2 = 'Testing1';
    private static final String USERNAME_USUARIO_1 = 'ksaoidsjadosajoidasjiokdaso@rsis.com';
    private static final String USERNAME_USUARIO_2 = 'a28301@rsis.com';

    @TestSetup
    static void makeData() {
        TriggerHandler.bypass('LeadTriggerHandler');

        Id perfilAdministradorSistema = [SELECT Id FROM Profile WHERE Name = 'Administrador do sistema' OR Name = 'System Administrator'].id;

        List<User> usuarios = new List<User>{
            new User(
                Alias = ALIAS_USUARIO_1,
                Email = EMAIL_USUARIO_1,
                EmailEncodingKey = 'UTF-8',
                LastName = LAST_NAME_USUARIO_1,
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = USERNAME_USUARIO_1,
                ProfileId = perfilAdministradorSistema,
                Situacao__c = 'Online'
            ),
            new User(
                Alias = ALIAS_USUARIO_2,
                Email = EMAIL_USUARIO_2,
                EmailEncodingKey = 'UTF-8',
                LastName = LAST_NAME_USUARIO_2,
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = USERNAME_USUARIO_2,
                ProfileId = perfilAdministradorSistema,
                Situacao__c = 'Online'
            )
        };
        insert usuarios;

        Equipe__c equipe = new Equipe__c();

        insert equipe;

        List<MembroEquipe__c> membrosEquipes = new List<MembroEquipe__c>{
            new MembroEquipe__c(
                Equipe__c = equipe.Id,
                Usuario__c = usuarios.get(0).Id
            ),
            new MembroEquipe__c(
                Equipe__c = equipe.Id,
                Usuario__c = usuarios.get(1).Id
            )
        };
        insert membrosEquipes;

        RoletaLeads__c roletaLeads = new RoletaLeads__c(
            Name = 'Roleta - Equipe 0',
            Ativa__c = true,
            HoraInicio__c = Datetime.now().time(),
            CanaisAtendimento__c = 'WhatsApp',
            Equipe__c = equipe.Id,
            DiasSemana__c = 'Domingo;Segunda-feira;Terça-feira;Quarta-feira;Quinta-feira;Sexta-feira;Sábado'
        );
        insert roletaLeads;

        ParticipanteRoleta__c participante = new ParticipanteRoleta__c(
            Entrada__c = System.now(),
            MembroEquipe__c = membrosEquipes.get(0).Id,
            RoletaLeads__c = roletaLeads.Id
        );
        insert participante;

        Lead lead = new Lead(
            OwnerId = usuarios.get(1).Id,
            LastName = 'Raposo',
            Company = 'porao',
            Status = 'Novo',
            CanalAtendimento__c = 'Whatsapp'
        );
        insert lead;
    }

    @isTest
    static void testarDistribuirLeads() {
        Lead lead = [SELECT CanalAtendimento__c, RoletaLeads__c, Corretor__c FROM Lead LIMIT 1];

        DistribuirLeadsService.distribuirLeads(new List<Lead>{ lead });

        User usuario = [SELECT Id FROM User WHERE Username = 'ksaoidsjadosajoidasjiokdaso@rsis.com'];

        Assert.areEqual(lead.Corretor__c, usuario.Id, 'Lead distribuído corretamente');
    }
}