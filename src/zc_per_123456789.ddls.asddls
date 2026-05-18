@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZPER_123456789'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_PER_123456789
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_PER_123456789
  association [1..1] to ZR_PER_123456789 as _BaseEntity on $projection.UUID = _BaseEntity.UUID
{
  key UUID,
  Uname,
  Firstname,
  Lastname,
  Birthdate,
  @Semantics: {
    User.Createdby: true
  }
  LocalCreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  LocalCreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LocalLastChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  _BaseEntity
}
