@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZUSR_123456789'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_USR_123456789
  as select from ZUSR_123456789
{
  key uuid as UUID,
  id as ID,
  username as Username,
  firstname as Firstname,
  lastname as Lastname,
  email as Email,
  password as Password,
  phone as Phone,
  userstatus as Userstatus,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
