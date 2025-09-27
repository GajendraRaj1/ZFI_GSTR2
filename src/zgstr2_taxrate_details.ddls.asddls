@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 Tax Code Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR2_TAXRATE_DETAILS
  as select from I_BillingDocument as a

  association [0..1] to I_JournalEntry                 as Jeheader on  a.DocumentReferenceID = Jeheader.DocumentReferenceID

  association [0..1] to I_BillingDocItemPrcgElmntBasic as b        on  a.BillingDocument = b.BillingDocument
                                                                   and b.ConditionType   = 'JOIG'
{
  key a.BillingDocument,
      Jeheader.AccountingDocument,
      a.DocumentReferenceID,
      a.BillingDocumentType,
      b.ConditionRateAmount

}
where
  a.BillingDocumentType = 'JSTO'
