@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZVHC_123456789'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_VHC_123456789
  as select from ZVHC_123456789
{
  key id as ID,
  type as Type,
  brand as Brand,
  model as Model,
  doors as Doors,
  capacity as Capacity,
  passengers as Passengers,
  engine_cc as EngineCc,
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
