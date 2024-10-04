trigger UpdateCRECIStatus on Contact (before insert) {
    CRECIStatusHandler.updateCRECIStatus(Trigger.new);
}