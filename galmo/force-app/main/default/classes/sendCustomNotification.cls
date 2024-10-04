public class sendCustomNotification {
public static void sendCustomNotification(Set<String> recipientsIds, String targetId) {
    List<CustomNotificationType> notificationTypes = 
        [SELECT Id, DeveloperName 
         FROM CustomNotificationType 
         WHERE DeveloperName = 'CotacaoAprovada'];

    if (notificationTypes.isEmpty()) {
        System.debug('Nenhum tipo de notificação encontrado com o DeveloperName: CotacaoAprovada');
        return; // Saia da função se não houver tipos de notificação
    }

    // Use o primeiro tipo de notificação encontrado
    CustomNotificationType notificationType = notificationTypes[0];

    // Cria uma nova notificação personalizada
    Messaging.CustomNotification notification = new Messaging.CustomNotification();
    notification.setTitle('Cotação Aprovada e Sincronizada');
    notification.setBody('A cotação foi aprovada e sincronizada com a oportunidade.');
    notification.setNotificationTypeId(notificationType.Id);
    notification.setTargetId(targetId);
    
    // Envia a notificação
    notification.send(recipientsIds);
}

}