public with sharing class EquipeTriggerHandler extends TriggerHandler {
    public override void beforeUpdate() {
        EquipeService.validarMembroDeEquipeDuplicado(Trigger.new);
    }

    public override void beforeInsert(){
        EquipeService.validarMembroDeEquipeDuplicado(Trigger.new);
    }
}