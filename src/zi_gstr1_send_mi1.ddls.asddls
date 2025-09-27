@AbapCatalog.sqlViewName: 'ZI_GSTR1_SEND_MI'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for sending data to MI Portal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZI_GSTR1_SEND_MI1
  as select distinct from I_JournalEntryItem as JournalItem
  association [0..1] to I_JournalEntryItem        as GetSupplier  on  JournalItem.CompanyCode          =  GetSupplier.CompanyCode
                                                                  and JournalItem.FiscalYear           =  GetSupplier.FiscalYear
                                                                  and JournalItem.AccountingDocument   =  GetSupplier.AccountingDocument
                                                                  and GetSupplier.FinancialAccountType =  'K'
                                                                  and GetSupplier.Supplier             <> ''

  //  association [1] to  I_OperationalAcctgDocItem as Acctgdoc on JournalItem.accountingdocument = Acctgdoc.AccountingDocument
  //                                                                and Acctgdoc.BusinessPlace <> ''
  //                                                             and Acctgdoc.FinancialAccountType = 'K'
  //  association [0..1] to zdb_org_gstin as gstin on gstin.business_place = Acctgdoc.BusinessPlace
  //                                              and gstin.comp_code = '1000'
  //                                              and gstin.palnt = '1000'

  association [0..1] to I_ProductPlantBasic       as HSNcode      on  HSNcode.Product = JournalItem.Product
                                                                  and HSNcode.Plant   = JournalItem.Plant

  association [0..1] to I_OperationalAcctgDocItem as HSN          on  JournalItem.AccountingDocument     = HSN.AccountingDocument
                                                                  and JournalItem.FiscalYear             = HSN.FiscalYear
                                                                  and JournalItem.AccountingDocumentItem = HSN.AccountingDocumentItem

  association [0..1] to ZJOURNALENTRY_CDS         as JOURNAL_Spec on  $projection.AccountingDocument             = JOURNAL_Spec.AccountingDocument
                                                                  and JournalItem.PurchasingDocument             = JOURNAL_Spec.PurchasingDocument
                                                                  and JournalItem.ReferenceDocumentItem          = JOURNAL_Spec.ReferenceDocumentItem
                                                                  and (
                                                                     JournalItem.TransactionTypeDetermination    = 'KBS'
                                                                     or JournalItem.TransactionTypeDetermination = 'WRX'
                                                                   )
   
{
  key JournalItem.AccountingDocument                       as AccountingDocument,
  key JournalItem.AccountingDocumentItem                   as AccountingDocumentItem,
  key JournalItem.PurchasingDocument                       as PurchasingDocument,
  key JournalItem.FiscalYear                               as FiscalYear,
      JournalItem.PostingDate                              as PostingDate,
      JournalItem.DocumentDate                             as Doc_date,
      substring( JournalItem.AccountingDocument , 1 ,  2 ) as DocNum,
          JournalItem.OffsettingAccount           as OffsettingAccount,

      JournalItem.PurchasingDocumentItem                   as PurchasingDocumentItem,
      JournalItem.DebitCreditCode                          as DebitCreditCode,
      //      case when JournalItem.DebitCreditCode = 'H' then 'CREDIT' end as CreditCode,
      //      case when JournalItem.DebitCreditCode = 'S' then 'DEBIT'  end as  DebitCode,

      JournalItem.ReferenceDocument                        as ReferenceDocumentMIRO,
      JournalItem.ReferenceDocumentItem                    as ReferenceDocumentItem,
      JournalItem.TaxCode                                  as TaxCode,

      JournalItem.TransactionTypeDetermination             as TransactionTypeDetermination,

      //      case when JournalItem.AmountInCompanyCodeCurrency < 0 then
      //      JournalItem.AmountInCompanyCodeCurrency * -1 else
      //      JournalItem.AmountInCompanyCodeCurrency end as Amcomp,

      //      case when JournalItem.TransactionTypeDetermination = ' ' and JournalItem.AmountInCompanyCodeCurrency < 0 then
      //      JournalItem.AmountInCompanyCodeCurrency * -1 else
      //      case when JournalItem.TransactionTypeDetermination = 'KBS' or JournalItem.TransactionTypeDetermination = 'WRX' and JOURNAL_Spec.amcomp < 0 then
      //      JOURNAL_Spec.amcomp * -1 else

      @Semantics.amount.currencyCode: 'Compcurr'
      case when JournalItem.TransactionTypeDetermination = ' ' then
      JournalItem.AmountInCompanyCodeCurrency
      else
      case when  JournalItem.TransactionTypeDetermination = 'KBS' or
                 JournalItem.TransactionTypeDetermination = 'WRX' then
      JOURNAL_Spec.amcomp
      else
      JournalItem.AmountInCompanyCodeCurrency end end      as AMCOMP,

      JOURNAL_Spec.amcomp                                  as AMCOMP_SPEC,

      //      JournalItem.CreditAmountInCoCodeCrcy   as Crdcomp,
      //
      //      JournalItem.DebitAmountInCoCodeCrcy    as Debcomp,

      JournalItem.AccountingDocumentItem                   as AccItem,

      JournalItem.FinancialAccountType                     as Acctype,

      //      JournalItem.GLAccountType    as GLAcctype,

      JournalItem.GLAccount                                as GLCode,
      JournalItem.CompanyCodeCurrency                      as Compcurr,
      // JournalItem. as Refdoc,
      JournalItem.PostingDate                              as PostData,
      //  gstin.gstin as orggstin,
      //  JournalItem.
      //            @Semantics: { amount : {currencyCode: 'AmountInFunctionalCurrency'} }
      //      @Semantics.amount.currencyCode:'AmountInFunctionalCurrency'
      //      @Semantics.currencyCode: true
      //      JournalItem.AmountInFunctionalCurrency as AmountInFunctionalCurrency,
      GetSupplier.Supplier                                 as Supplier,
      substring( HSNcode.ConsumptionTaxCtrlCode , 1 , 8 )  as HSN_Code,
      HSN.IN_HSNOrSACCode                                  as hsncode,
      JournalItem.Product                                  as Product,
      JournalItem.BaseUnit                                 as Baseunit,
      JournalItem.AccountingDocumentType                   as AccountingDocumentType
      // JournalItem.


}
where
  //   JournalItem.PurchasingDocument     <> ''
  //   or JournalItem.PurchasingDocument     = '' )
  //     JournalItem.DebitCreditCode                    =  'S'
  //       JournalItem.DebitCreditCode              =  'H'
       JournalItem.Ledger                       =  '0L'
  and  JournalItem.OffsettingAccount            <> ''
  and(
       JournalItem.AccountingDocumentType       =  'KR'
    or JournalItem.AccountingDocumentType       =  'KG'
    or JournalItem.AccountingDocumentType       =  'RE'
    or JournalItem.AccountingDocumentType       =  'KD'
  )
  and  JournalItem.AmountInCompanyCodeCurrency  <> 0
  and  JournalItem.TransactionTypeDetermination <> 'JII'
  and  JournalItem.TransactionTypeDetermination <> 'JIC'
  and  JournalItem.TransactionTypeDetermination <> 'JIS'
  and  JournalItem.TransactionTypeDetermination <> 'JRC'
  and  JournalItem.TransactionTypeDetermination <> 'JRS'
  and  JournalItem.TransactionTypeDetermination <> 'JRI'
  and  JournalItem.TaxCode                      <> 'G0'
  and  HSN.ProfitCenter <> ' ' //or ( hsn.IN_HSNOrSACCode <> ' ' and JournalItem.Product <> ' ' ))
  //  and  JournalItem.TaxCode <> 'BC'
  //  and  JournalItem.AccountingDocument           <> '1900000021'
  //  and  JournalItem.ReferenceDocumentItem        <> '000000'
  //  and  JournalItem.GLAccount                    <> '0066000130'
  //  and  JournalItem.GLAccount                    <> '0066000120'
  //  and  JournalItem.GLAccount                    <> '0066000140'
  //  and  JournalItem.GLAccount                    <> '0012605901'
  //  and  JournalItem.GLAccount                    <> '0012605900'
  //  and  JournalItem.GLAccount                    <> '0012605902'
  //  and  JournalItem.GLAccount                    <> '0012605903'
  //  and  JournalItem.GLAccount                    <> '0012605905'
  //  and  JournalItem.GLAccount                    <> '0012605904'
  //  and  JournalItem.GLAccount                    <> '0012605906'
  //  and  JournalItem.GLAccount                    <> '0012605907'
  //  and  JournalItem.GLAccount                    <> '0012605908'
  //  //     and JournalItem.GLAccount <> '0012605908'
  //  and  JournalItem.GLAccount                    <> '0012605909'
  //  and  JournalItem.GLAccount                    <> '0012605910'
  //  and  JournalItem.GLAccount                    <> '0012605911'
  //  and  JournalItem.GLAccount                    <> '0012605912'
  //  and  JournalItem.GLAccount                    <> '0012605913'
  //  and  JournalItem.GLAccount                    <> '0012605914'
  //  and  JournalItem.GLAccount                    <> '0012605915'
  //  and  JournalItem.GLAccount                    <> '0012605916'
  //  and  JournalItem.GLAccount                    <> '0012605917'
  //  and  JournalItem.GLAccount                    <> '0012605918'
  //  and  JournalItem.GLAccount                    <> '0012605919'
  //  and  JournalItem.GLAccount                    <> '0012605920'
  //  and  JournalItem.GLAccount                    <> '0012605921'
  //  and  JournalItem.GLAccount                    <> '0012605922'
  //  and  JournalItem.GLAccount                    <> '0012605923'
  //  and  JournalItem.GLAccount                    <> '0012605924'
  //  and  JournalItem.GLAccount                    <> '0012605925'
  //  and  JournalItem.GLAccount                    <> '0022005150'
  //  and  JournalItem.GLAccount                    <> '0022090100' //newly Added
  //  and  JournalItem.GLAccount                    <> '0022005104' //newly Added
  //  and  JournalItem.GLAccount                    <> '0022005103' //newly Added
  //  and  JournalItem.GLAccount                    <> '0022005112' //newly Added
  //  and  JournalItem.GLAccount                    <> '0022005113' //newly Added
  //  and  JournalItem.GLAccount                    <> '0022090600' //newly Added
  //  and  JournalItem.GLAccount                    <> '0022090200' //newly Added
  //  and  JournalItem.GLAccount                    <> '0012540000' //newly Added
  //  and  JournalItem.GLAccount                    <> '0065008320' //newly Added
  and  JournalItem.GLAccount                    <> '0051100900' //newly Added 0066000131
  //  and  JournalItem.GLAccount                    <> '0051900000'   "cmntd b Krishna 10/10/24
  //  and  JournalItem.GLAccount                    <> '0066000131'
  //  and  JournalItem.GLAccount                    <> '0066000121'

  and  JournalItem.FinancialAccountType         =  'S' //newly Added
  and  JournalItem.TransactionTypeDetermination <> 'WIT'
//  and  JournalItem.GLAccountType                <> 'P'
// and JournalItem.GLAccountType = 'P'
// and(
//       JournalItem.AccountingDocumentType =  'RE'
//    or JournalItem.AccountingDocumentType =  'KR'
//  )

//       JournalItem.IsReversal             <> 'X'
//  and  JournalItem.IsReversed             <> 'X'
//  and  JournalItem.OffsettingAccount      <> ''
//  and(
//       JournalItem.AccountingDocumentType =  'DR'
//    or JournalItem.AccountingDocumentType =  'DG'
//
group by
  JournalItem.AccountingDocument,
  JournalItem.PurchasingDocument,
  JournalItem.FiscalYear,
  JournalItem.PostingDate,
  JournalItem.DocumentDate,
  JournalItem.OffsettingAccount,
  JournalItem.PurchasingDocumentItem,
  JournalItem.DebitCreditCode,
  JournalItem.ReferenceDocument,
  JournalItem.ReferenceDocumentItem,
  JournalItem.TaxCode,
  JournalItem.TransactionTypeDetermination,
  JournalItem.AmountInCompanyCodeCurrency,
  JOURNAL_Spec.amcomp,
  JournalItem.AccountingDocumentItem,
  JournalItem.FinancialAccountType,
  //  JournalItem.GLAccountType,
  JournalItem.GLAccount,
  //   JournalItem.ReferenceDocument,
  JournalItem.PostingDate,
  JournalItem.CreditAmountInCoCodeCrcy,
  JournalItem.DebitAmountInCoCodeCrcy,
  JournalItem.CompanyCodeCurrency,
  //     gstin.gstin,
  GetSupplier.Supplier,
  HSNcode.ConsumptionTaxCtrlCode,
  HSN.IN_HSNOrSACCode,
  JournalItem.Product,
  JournalItem.BaseUnit,
  JournalItem.AccountingDocumentType
