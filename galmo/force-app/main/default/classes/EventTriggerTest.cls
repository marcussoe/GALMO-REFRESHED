@isTest
private class EventTriggerTest {
    @TestSetup
    static void makeData() {
        doCreateData();
    }

    @isTest
    private static void doCreateData() {
        List<BusinessSettings__c> configs = new List<BusinessSettings__c>{
            new BusinessSettings__c(
                SlaTime__c = 1440,
                Step__c = 'Agendamento de Visita'
            )
        };
        insert configs;

 

        Event eventsVisit = new Event(
            Subject = 'Visita',
            ActivityDate = Date.today().addDays(5),
            DurationInMinutes = 30,
            ActivityDateTime = Datetime.now()
           
        );
        insert eventsVisit;

        System.assertNotEquals(null, eventsVisit.Id, 'Evento de visita não foi inserido corretamente');
    }
}