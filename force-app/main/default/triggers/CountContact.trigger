trigger CountContact on Contact(after insert,after update,after delete,after undelete)
{
    ContactCountHandler.countcontactforAccount(Trigger.New,Trigger.oldMap,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete,Trigger.isUndelete);
}