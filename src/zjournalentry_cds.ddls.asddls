@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry CDS for GST Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZJOURNALENTRY_CDS
  as select from I_JournalEntryItem as JournalItem
{
  key JournalItem.AccountingDocument                                      as AccountingDocument,
      //  key JournalItem.AccountingDocumentItem      as AccountingDocumentItem,
  key JournalItem.PurchasingDocument                                      as PurchasingDocument,
  key JournalItem.FiscalYear                                              as FiscalYear,
      JournalItem.ReferenceDocumentItem                                   as ReferenceDocumentItem,
      JournalItem.PostingDate                                             as PostingDate,
      JournalItem.DocumentDate                                            as Doc_date,
      sum(cast(JournalItem.AmountInCompanyCodeCurrency as abap.dec( 13, 2 ) ) ) as amcomp

}
where
       JournalItem.Ledger                       =  '0L'
  and  JournalItem.OffsettingAccount            <> ''
//  and  JournalItem.PurchasingDocument           <> ''
  and(
       JournalItem.AccountingDocumentType       =  'KR'
    or JournalItem.AccountingDocumentType       =  'KG'
    or JournalItem.AccountingDocumentType       =  'RE'
    or JournalItem.AccountingDocumentType       =  'KD'  //Add by Krishna 24/10
  )
  and  JournalItem.AmountInCompanyCodeCurrency  <> 0
  and  JournalItem.ReferenceDocumentItem        <> '000000'
//  and  JournalItem.FinancialAccountType         =  'S'
  and  JournalItem.TransactionTypeDetermination <> 'WIT'
  and JournalItem.TransactionTypeDetermination <> 'JII'
  and JournalItem.TransactionTypeDetermination <> 'JIS'
  and JournalItem.TransactionTypeDetermination <> 'JIC'
//  and JournalItem.TransactionTypeDetermination <> 'JRC'
//  and JournalItem.TransactionTypeDetermination <> 'JRS'
//  and JournalItem.TransactionTypeDetermination <> 'JRI'
group by
  JournalItem.AccountingDocument,
  JournalItem.PurchasingDocument,
  JournalItem.FiscalYear,
  JournalItem.ReferenceDocumentItem,
  JournalItem.PostingDate,
  JournalItem.DocumentDate
