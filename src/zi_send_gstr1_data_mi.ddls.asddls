@AbapCatalog.sqlViewName: 'ZI_SEND_GSTR1_MI'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true

define root view ZI_SEND_GSTR1_DATA_MI
  as select from zi_gstr1_send_mi as JournalItem
  //  left outer join ZI_JOURNALENTRYITEM1 as JournalEntry   on  JournalItem.accountingdocument = JournalEntry.AccountingDocument
  //define root view ZI_SEND_GSTR1_DATA_MI
  // as select from I_JournalEntryItem as JournalItem


  //  association [0..1] to ZI_JOURNALENTRYITEM1           as JournalEntry    on  JournalItem.referencedocumentmiro = JournalEntry.ReferenceDocumentMIRO
  //                                                                          and JournalItem.referencedocumentitem = JournalEntry.ReferenceDocumentItem
  association [0..1] to ZI_JOURNALENTRYITEM1           as JournalEntry    on  JournalItem.accountingdocument    = JournalEntry.AccountingDocument
                                                                          and JournalEntry.Acctype              = 'S'
                                                                          and JournalItem.referencedocumentitem = JournalEntry.ReferenceDocumentItem
  //   and JournalEntry.GLAcctype = 'P'

  // association [0..1] to zdb_org_gstin as organi_gstin on $projection.business_place = Acctgdoc.BusinessPlace

  association [1]    to I_OperationalAcctgDocItem      as Acctgdoc        on  JournalItem.accountingdocument = Acctgdoc.AccountingDocument
  //  and Acctgdoc.BusinessPlace <> ''
                                                                          and Acctgdoc.FinancialAccountType  = 'K'
  //Profit Center
  association [1]    to I_OperationalAcctgDocItem      as ProfitCenter    on  JournalItem.accountingdocument =  ProfitCenter.AccountingDocument
                                                                          and JournalItem.accitem            =  ProfitCenter.AccountingDocumentItem
                                                                          and ProfitCenter.ProfitCenter      <> ''
  //   and Acctgdoc.FinancialAccountType = 'K'

  association [1]    to I_OperationalAcctgDocItem      as Cgst_gl         on  JournalItem.accountingdocument       = Cgst_gl.AccountingDocument
                                                                          and JournalItem.amcomp                   = Cgst_gl.TaxBaseAmountInCoCodeCrcy
                                                                          and Cgst_gl.AccountingDocumentItemType   = 'T'
                                                                          and Cgst_gl.TransactionTypeDetermination = 'JIC'
  //Added for KG Type
  // association [0..1] to I_JournalEntryItem  as KGJournal on JournalItem.accountingdocument = KGJournal.AccountingDocument
  //                                                       and KGJournal.DebitCreditCode = 'H'
  //                                                       and KGJournal.GLAccountType = 'P'
  //                                                       and KGJournal.ReferenceDocumentType = 'KG'
  // association [1] to  I_OperationalAcctgDocItem as KGCgst_gl on JournalItem.accountingdocument = KGCgst_gl.AccountingDocument
  //                                                              and  JournalItem.amcomp = KGCgst_gl.TaxBaseAmountInCoCodeCrcy
  //                                                              and KGCgst_gl.AccountingDocumentItemType = 'T'
  //                                                              and KGCgst_gl.TransactionTypeDetermination = 'JIC'
  //Ended
  association [1]    to I_OperationalAcctgDocItem      as sgst_gl         on  JournalItem.accountingdocument       = sgst_gl.AccountingDocument
                                                                          and JournalItem.amcomp                   = sgst_gl.TaxBaseAmountInCoCodeCrcy
                                                                          and sgst_gl.AccountingDocumentItemType   = 'T'
                                                                          and sgst_gl.TransactionTypeDetermination = 'JIS'

  association [1]    to I_OperationalAcctgDocItem      as igst_gl         on  JournalItem.accountingdocument       = igst_gl.AccountingDocument
                                                                          and JournalItem.amcomp                   = igst_gl.TaxBaseAmountInCoCodeCrcy
                                                                          and igst_gl.AccountingDocumentItemType   = 'T'
                                                                          and igst_gl.TransactionTypeDetermination = 'JII'

  //IS Tax Code
  association [1]    to I_OperationalAcctgDocItem      as igst_glis       on  JournalItem.accountingdocument         = igst_glis.AccountingDocument
                                                                          and JournalItem.amcomp                     = igst_glis.TaxBaseAmountInCoCodeCrcy
                                                                          and igst_glis.AccountingDocumentItemType   = 'T'
                                                                          and (
                                                                             igst_glis.AccountingDocumentItem        = '003'
                                                                             //                                                              or igst_glis.AccountingDocumentItem = '004'
                                                                             or igst_glis.AccountingDocumentItem     = '005'
                                                                             //                                                              or igst_glis.AccountingDocumentItem = '006'
                                                                             or igst_glis.AccountingDocumentItem     = '007'
                                                                             //                                                              or igst_glis.AccountingDocumentItem = '008'
                                                                             or igst_glis.AccountingDocumentItem     = '009'
                                                                             or igst_glis.AccountingDocumentItem     = '011'
                                                                             or igst_glis.AccountingDocumentItem     = '013'
                                                                             or igst_glis.AccountingDocumentItem     = '015'
                                                                             or igst_glis.AccountingDocumentItem     = '017'
                                                                             or igst_glis.AccountingDocumentItem     = '019'
                                                                             or igst_glis.AccountingDocumentItem     = '021'
                                                                             or igst_glis.AccountingDocumentItem     = '023'
                                                                             or igst_glis.AccountingDocumentItem     = '025'
                                                                             or igst_glis.AccountingDocumentItem     = '027'
                                                                             or igst_glis.AccountingDocumentItem     = '029'
                                                                             or igst_glis.AccountingDocumentItem     = '031'
                                                                             or igst_glis.AccountingDocumentItem     = '033'
                                                                             or igst_glis.AccountingDocumentItem     = '035'
                                                                             or igst_glis.AccountingDocumentItem     = '037'
                                                                             or igst_glis.AccountingDocumentItem     = '039'
                                                                             or igst_glis.AccountingDocumentItem     = '041'
                                                                             or igst_glis.AccountingDocumentItem     = '043'
                                                                             or igst_glis.AccountingDocumentItem     = '045'
                                                                             or igst_glis.AccountingDocumentItem     = '047'
                                                                             or igst_glis.AccountingDocumentItem     = '049'
                                                                             or igst_glis.AccountingDocumentItem     = '051'
                                                                             or igst_glis.AccountingDocumentItem     = '053'
                                                                             or igst_glis.AccountingDocumentItem     = '055'
                                                                             or igst_glis.AccountingDocumentItem     = '057'
                                                                             or igst_glis.AccountingDocumentItem     = '059'
                                                                             or igst_glis.AccountingDocumentItem     = '061'
                                                                             or igst_glis.AccountingDocumentItem     = '063'
                                                                             or igst_glis.AccountingDocumentItem     = '065'
                                                                             or igst_glis.AccountingDocumentItem     = '067'
                                                                             or igst_glis.AccountingDocumentItem     = '069'
                                                                             or igst_glis.AccountingDocumentItem     = '071'
                                                                             or igst_glis.AccountingDocumentItem     = '073'
                                                                             or igst_glis.AccountingDocumentItem     = '075'
                                                                             or igst_glis.AccountingDocumentItem     = '077'
                                                                             or igst_glis.AccountingDocumentItem     = '079'
                                                                             or igst_glis.AccountingDocumentItem     = '081'
                                                                             or igst_glis.AccountingDocumentItem     = '083'
                                                                             or igst_glis.AccountingDocumentItem     = '085'
                                                                             or igst_glis.AccountingDocumentItem     = '087'
                                                                             or igst_glis.AccountingDocumentItem     = '089'
                                                                             or igst_glis.AccountingDocumentItem     = '091'
                                                                             or igst_glis.AccountingDocumentItem     = '093'
                                                                             or igst_glis.AccountingDocumentItem     = '095'
                                                                             or igst_glis.AccountingDocumentItem     = '097'
                                                                             or igst_glis.AccountingDocumentItem     = '099'
                                                                             or igst_glis.AccountingDocumentItem     = '101'
                                                                             or igst_glis.AccountingDocumentItem     = '103'
                                                                           )
                                                                          and igst_glis.TransactionTypeDetermination = ''

  association [1]    to ZI_RCM_DETAILS                 as RCM_Cgst_gl     on  JournalItem.accountingdocument           = RCM_Cgst_gl.AccountingDocument
  //                                                                          and JournalItem.accountingdocumentitem           = RCM_Cgst_gl.AccountingDocumentItem
  //                                                                          and JournalItem.amcomp                       = RCM_Cgst_gl.TaxBaseAmountInCoCodeCrcy
  //                                                                        and RCM_Cgst_gl.AccountingDocumentItemType   = 'T'
                                                                          and RCM_Cgst_gl.TaxItem                      = JournalItem.referencedocumentitem
                                                                          and RCM_Cgst_gl.TransactionTypeDetermination = 'JRC'
  association [1]    to ZI_RCM_DETAILS                 as RCM_sgst_gl     on  JournalItem.accountingdocument           = RCM_sgst_gl.AccountingDocument
  //                                                                          and JournalItem.accountingdocumentitem           = RCM_sgst_gl.AccountingDocumentItem
  //                                                                          and JournalItem.amcomp                       = RCM_sgst_gl.TaxBaseAmountInCoCodeCrcy
  //                                                                        and RCM_sgst_gl.AccountingDocumentItemType   = 'T'
                                                                          and RCM_sgst_gl.TaxItem                      = JournalItem.referencedocumentitem
                                                                          and RCM_sgst_gl.TransactionTypeDetermination = 'JRS'
  association [1]    to ZI_RCM_DETAILS                 as RCM_igst_gl     on  JournalItem.accountingdocument           = RCM_igst_gl.AccountingDocument
  //                                                                          and JournalItem.accountingdocumentitem           = RCM_igst_gl.AccountingDocumentItem
  //                                                                          and JournalItem.amcomp                       = RCM_igst_gl.TaxBaseAmountInCoCodeCrcy
  //                                                                          and RCM_igst_gl.AccountingDocumentItemType   = 'T'
                                                                          and RCM_igst_gl.TaxItem                      = JournalItem.referencedocumentitem
                                                                          and RCM_igst_gl.TransactionTypeDetermination = 'JRI'



  //  and Acctgdoc.BusinessPlace <> ''
  // and Acctgdoc.FinancialAccountType = 'K'
  //   and Acctgdoc.AccountingDocumentItemType = 'T'

  //                                                             and Acctgdoc.DocumentItemText <> ''
  //                                                             and Acctgdoc.BusinessPlace <> ''
  //   and Acctgdoc.
  //    and JournalEntry.ReferenceDocumentItem = Acctgdoc.AccountingDocumentItem
  association [0..1] to I_JournalEntry                 as Jeheader        on  JournalItem.accountingdocument = Jeheader.AccountingDocument
  association [1]    to I_JournalEntryItem             as Jeplant         on  JournalItem.accountingdocument =  Jeplant.AccountingDocument
                                                                          and Jeplant.Plant                  <> ''

  association [1]    to I_JournalEntryItem             as HSN             on  JournalItem.accountingdocument = HSN.AccountingDocument
                                                                          and HSN.FinancialAccountType       = 'K'

  //association [0..1] to I_JournalEntryItem as GetSupplier on  JournalItem.CompanyCode          =  GetSupplier.CompanyCode
  association [0..1] to ZI_VENDOR_MASTER               as VendorDetails   on  JournalItem.supplier    = VendorDetails.Supplier
                                                                          and VendorDetails.Langauage = 'E'
  //                                                                          and VendorDetails.Country   = 'IN'

  association [0..1] to ZI_PO_MASTER                   as PO_Master       on  JournalItem.referencedocumentmiro = PO_Master.SupplierInvoice
                                                                          and JournalItem.referencedocumentitem = PO_Master.SupplierInvoiceItem
                                                                          and JournalItem.fiscalyear            = PO_Master.FiscalYear

  //  association [1..1] to ZGST_ITC_RECO                  as itc_reco        on  itc_reco.Accountingdocument = JournalItem.accountingdocument  +cmntd by krishna 10/09/24
//  association [1..1] to ZI_GST_ITC_RECO                as itc_reco        on  itc_reco.Accountingdocument = JournalItem.accountingdocument //Add by Krishna 10/09/24 "hp
  //  association [1] to ZORG_GSTIN as GSTIN on  Acctgdoc.BusinessPlace = GSTIN.BusinessPlace

  //  and JournalItem.accountingdocument = PO_Master.
  // association [0..1] to ZI_JOURNALENTRYITEM1           as JournalEntry   on  JournalItem.accountingdocument = JournalEntry.AccountingDocument
  //  and JournalItem. = SupplierInvoicePORef.SupplierInvoiceItem


  //      on  JournalItem.referencedocumentmiro = PO_Master.SupplierInvoice
  //                                                                          and JournalItem.referencedocumentitem = PO_Master.SupplierInvoiceItem
  // and JournalItem.acc


  association [0..1] to I_SupplierInvoiceAPI01         as SupplierInvoice on  SupplierInvoice.SupplierInvoice = JournalItem.referencedocumentmiro
                                                                          and SupplierInvoice.FiscalYear      = JournalItem.fiscalyear
  association [0..1] to I_PurOrdItmPricingElementAPI01 as POItemPricing   on  JournalItem.purchasingdocument        = POItemPricing.PurchaseOrder
                                                                          and JournalItem.purchasingdocumentitem    = POItemPricing.PurchaseOrderItem
                                                                          and (
                                                                             POItemPricing.ConditionType            = 'PMP0'
                                                                             or POItemPricing.ConditionType         = 'PPR0'
                                                                           )
                                                                          and POItemPricing.ConditionInactiveReason = ''
  association [0..1] to Z_Discount                     as Discount        on  JournalItem.referencedocumentmiro = Discount.ReferenceDocumentMIRO
                                                                          and JournalItem.referencedocumentitem = Discount.ReferenceDocumentItem
                                                                          and JournalItem.fiscalyear            = Discount.FiscalYear
  //  association [0..1] to ZI_JOURNALENTRYITEM1          as Fi_Postings   on JournalItem.fiscalyear                = Fi_Postings.FiscalYear
  //                                                                       and JournalItem.supplier                 = Fi_Postings.Supplier
  //                                                                       and JournalItem.purchasingdocument       = ''
  association [0..1] to zgstr2_st                      as status          on  JournalItem.referencedocumentmiro = status.referencedocumentmiro
  //  association [1] to zdb_org_gstin                  as gstin_org       on Acctgdoc.BusinessPlace = gstin_org.business_place


  association [0..1] to ZRECO_ACTION_HELP              as _rrfilter       on  $projection.reco_action = _rrfilter.ReverseResponsefilter

  association [1]    to ZGSTR2_TAXRATE_DETAILS         as taxrate         on  JournalItem.accountingdocument = taxrate.AccountingDocument


  // association [0..1] to YY1_ForMastersIndiaAPI as forMastersIndia on JournalItem.accountingdocument = forMastersIndia.BillingDocumentItem

  //    association [0..1] to YY1_GLDescription as GLDescription on PO_Master.GL_Code = GLDescription.GLAccount

  //association [0..1] to YY1_TaxCode as primustaxcode on JournalItem.taxcode = primustaxcode.TaxCode

  //association [0..1] to ZI_FIXED_VALUES as fixed_values on sy

  association [0..1] to I_ProductText                  as _MaterialDesc   on  $projection.MaterialCode = _MaterialDesc.Product
                                                                          and _MaterialDesc.Language   = 'E'

  association [0..1] to ZWBS_DATA as B    on JournalItem.accountingdocument = B.AccountingDocument
                                         and JournalItem.fiscalyear  = B.FiscalYear
{
  key JournalItem.referencedocumentmiro                                                                                               as ReferenceDocumentMIRO,
  key JournalItem.referencedocumentitem                                                                                               as ReferenceDocumentItem,
      //  key JournalItem.ref
  key Jeheader.DocumentReferenceID,
      JournalItem.accountingdocument                                                                                                  as AccountingDocument,
      JournalItem.purchasingdocument                                                                                                  as PurchasingDocument,
      JournalItem.fiscalyear                                                                                                          as FiscalYear,
      JournalItem.purchasingdocumentitem                                                                                              as PurchasingDocumentItem,
      //      JournalItem.debitcreditcode                                                                                                           as DebitCreditCode,
      JournalItem.supplier                                                                                                            as Vendor,
      // gstin_org.gstin as orggstin,
      ProfitCenter.ProfitCenter                                                                                                       as ProftCenter,
      // organi_gstin.gstin as org_gstin,
      // gstin.gstin as org_gstin,
      //gstin_org.palnt as organisationgstin,
      //      organi_gstin.gstin as orga_gstin,
      //      organi_gstin.gstin as organization_gstin,
      // VendorDetails.
      //   Fi_Postings.AccountingDocument                                              as Fi_Posting,
      //      PO_Master.PurchaseOrderItemMaterial                                                                         as MaterialCode,
      JournalItem.product                                                                                                             as MaterialCode,
      //      case when JournalItem.purchasingdocument is not initial then
      //      SupplierInvoice.DocumentDate
      //      else
      //           JournalItem.postingdate                                                                                           end       as InvoiceDate,
      JournalItem.doc_date                                                                                                            as InvoiceDate,
      JournalItem.postingdate                                                                                                         as PostingDate,
      // JournalItem.
      case when JournalItem.purchasingdocument is not initial then
      SupplierInvoice.SupplierInvoiceIDByInvcgParty
      else
      Jeheader.DocumentReferenceID      end                                                                                           as RefDocNo,
      VendorDetails.SupplierName                                                                                                      as VendorName,
      Jeheader.IsReversal                                                                                                             as IsReversal,
      //  case when Jeheader.IsReversal is not initial then
      Jeheader.ReversalReferenceDocument                                                                                              as Reverse,

      VendorDetails.Region                                                                                                            as VendorRegion,
      VendorDetails.RegionName                                                                                                        as RegionName,
      VendorDetails.TaxNumber3                                                                                                        as GSTIN,
      VendorDetails.TaxNumber2                                                                                                        as TIN,
      VendorDetails.Panno                                                                                                             as PANNO,
      //  VendorDetails.
      PO_Master.PurchasingGroup                                                                                                       as Department,
      //Additional fields
      case when JournalItem.purchasingdocument is initial then
      Jeplant.Plant
      else
      PO_Master.plant                                                                                                       end       as BusinessArea,
      // PO_Master.Doctype
      //  Jeheader.bu
      //  JournalItem.p
      JournalItem.amcomp                                                                                                              as Amount,

      Jeheader.AccountingDocumentType                                                                                                 as Doctype,
      case when JournalItem.purchasingdocument is initial then
      Jeplant.Plant
      else
      PO_Master.plant                                                                                                             end as Plant,
      JournalItem.glcode                                                                                                              as GL_Code,
      PO_Master.Trans_Key                                                                                                             as Trans_Key,
      case when JournalItem.purchasingdocument  is initial and JournalItem.taxcode = 'IS'  then
       igst_glis.GLAccount else
       case when JournalItem.purchasingdocument  is initial and JournalItem.taxcode <> 'V0' then
      igst_gl.GLAccount else
      case when JournalItem.purchasingdocument  is not initial and JournalItem.taxcode <> 'V0' then
      igst_gl.GLAccount else
      case when JournalItem.taxcode <> 'V0' then
      igst_gl.GLAccount else
      case when JournalItem.accountingdocumenttype = 'KD' and JournalItem.taxcode = 'AD' then igst_gl.GLAccount  //Add By Krishna 24/10/24
      end end end end end                                                                                                             as igst_gl,
      case when JournalItem.purchasingdocument is initial and JournalItem.taxcode <> 'V0' then
      Cgst_gl.GLAccount else
      case when JournalItem.purchasingdocument is not initial and JournalItem.taxcode <> 'V0' then
      Cgst_gl.GLAccount else
      case when JournalItem.taxcode <> 'V0' then
      Cgst_gl.GLAccount else
      case when JournalItem.accountingdocumenttype = 'KD' and JournalItem.taxcode = 'AD' then Cgst_gl.GLAccount  //Add By Krishna 24/10/24
      end end end end                                                                                                                 as cgst_gl,
      case when JournalItem.purchasingdocument is initial and JournalItem.taxcode <> 'V0' then
      sgst_gl.GLAccount else
      case when JournalItem.purchasingdocument is not initial and JournalItem.taxcode <> 'V0' then
      sgst_gl.GLAccount else
      case when JournalItem.taxcode <> 'V0' then
      sgst_gl.GLAccount else
      case when JournalItem.accountingdocumenttype = 'KD' and JournalItem.taxcode = 'AD' then sgst_gl.GLAccount  //Add By Krishna 24/10/24
      end end end end                                                                                                                 as sgst_gl,
      //       case when JournalItem.purchasingdocument  is initial and RCM_igst_gl.GLAccount is initial then
      //      igst_gl.GLAccount else
      //      case when RCM_igst_gl.GLAccount is not initial then
      //      RCM_igst_gl.GLAccount else
      //      igst_gl.GLAccount  end   end     end                                                                                                            as igst_gl,
      //      case when JournalItem.purchasingdocument is initial and RCM_Cgst_gl.GLAccount is initial then
      //      Cgst_gl.GLAccount else
      //      case when RCM_Cgst_gl.GLAccount is not initial then
      //      RCM_Cgst_gl.GLAccount  else
      //      Cgst_gl.GLAccount end  end                                                                                                                as cgst_gl,
      //      case when JournalItem.purchasingdocument is initial and RCM_sgst_gl.GLAccount is initial then
      //      sgst_gl.GLAccount else
      //      case when RCM_sgst_gl.GLAccount is not initial then
      //      RCM_sgst_gl.GLAccount else
      //      sgst_gl.GLAccount   end     end                                                                                                             as sgst_gl,
      //      case when  RCM_igst_gl.GLAccount is initial and igst_gl.GLAccount is not initial then
      //      igst_gl.GLAccount else
      //      //case when  RCM_igst_gl.GLAccount is not initial and igst_gl.GLAccount is initial then
      //      RCM_igst_gl.GLAccount  end  end                                                                                                                 as igst_gl,
      //      case when RCM_Cgst_gl.GLAccount is initial and Cgst_gl.GLAccount is not initial then
      //      Cgst_gl.GLAccount else
      //    //  case when RCM_Cgst_gl.GLAccount is not initial and Cgst_gl.GLAccount is initial then
      //      RCM_Cgst_gl.GLAccount   end                                                                                                                 as cgst_gl,
      //      case when RCM_sgst_gl.GLAccount is initial and sgst_gl.GLAccount is not initial then
      //      sgst_gl.GLAccount else
      //    //  case when RCM_sgst_gl.GLAccount is not initial and sgst_gl.GLAccount is initial then
      //      RCM_sgst_gl.GLAccount   end                                                                                                              as sgst_gl,

      //IGST GL Code for IS tax codes
      //      case when JournalItem.purchasingdocument is initial and JournalItem.taxcode = 'IS' then
      //      igst_glis.GLAccount end as igst_gl,
      case when JournalItem.purchasingdocument is not initial then
            PO_Master.DocumentCurrency
            else
            JournalItem.compcurr end                                                                                                  as companycodecurrecy,

      //  PO_Master.
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      PO_Master.Tot_Inv                                                          as Tot_Inv,
      //Additional fields ended
      status.status                                                                                                                   as Status,
//      itc_reco.Status                                                                                                                 as reco_status,
//      itc_reco.RecoAction                                                                                                             as reco_action,
//      itc_reco.Reason                                                                                                                 as reason,
//      itc_reco.RetenPostDoc                                                                                                           as retensionpostingdocno,
//      itc_reco.ReverseRet                                                                                                             as revrseretensionpostingdocno,
      //      _rrfilter.ReverseResponsefilter as reco_action,
      //      _rrfilter.ReverseResponsefilter as    ReverseResponsefilter,

      JournalItem.amcomp,



      case
        when PO_Master.PurchasingGroup = '001' then 'Group 001'
        when PO_Master.PurchasingGroup = '002' then 'Group 002'
        when PO_Master.PurchasingGroup = '003' then 'Group 003'
        when PO_Master.PurchasingGroup = '005' then 'Transportation Srv'
        when PO_Master.PurchasingGroup = '006' then 'TM – Ext. Planning'
        when PO_Master.PurchasingGroup = '007' then 'TM – Int. Planning'
        when PO_Master.PurchasingGroup = 'Z01' then 'Sales & Marketing'
        when PO_Master.PurchasingGroup = 'Z02' then 'Canteen Dept.'
        when PO_Master.PurchasingGroup = 'Z03' then 'Safety Dept.'
        when PO_Master.PurchasingGroup = 'Z04' then 'General Admin'
        when PO_Master.PurchasingGroup = 'Z05' then 'Accounts & Finance'
        when PO_Master.PurchasingGroup = 'Z06' then 'EDP/IT Dept.'
        when PO_Master.PurchasingGroup = 'Z07' then 'Store Dept.'
        when PO_Master.PurchasingGroup = 'Z08' then 'Purchase Dept.'
        when PO_Master.PurchasingGroup = 'Z09' then 'Civil Dept.'
        when PO_Master.PurchasingGroup = 'Z10' then 'Engineering Dept.'
        when PO_Master.PurchasingGroup = 'Z11' then 'Electrical Dept.'
        when PO_Master.PurchasingGroup = 'Z12' then 'Instrument Dept.'
        when PO_Master.PurchasingGroup = 'Z13' then 'Manufacturing Dept'
        when PO_Master.PurchasingGroup = 'Z14' then 'Sugar Godown'
        when PO_Master.PurchasingGroup = 'Z15' then 'Agriculture Dept.'
        when PO_Master.PurchasingGroup = 'Z16' then 'Cane - Yard'
        when PO_Master.PurchasingGroup = 'Z17' then 'Time Office Dept'
        when PO_Master.PurchasingGroup = 'Z18' then 'Security Dept.'
        when PO_Master.PurchasingGroup = 'Z19' then 'Vehicle Dept'
        when PO_Master.PurchasingGroup = 'Z20' then 'Distillery Dept.'
        when PO_Master.PurchasingGroup = 'Z21' then 'Co-gen Department'
        when PO_Master.PurchasingGroup = 'Z22' then 'WTP Department'
        when PO_Master.PurchasingGroup = 'Z23' then 'Petrol Pump'
        when PO_Master.PurchasingGroup = 'Z24' then 'ETP Department'
        when PO_Master.PurchasingGroup = 'Z25' then 'OHC / Medical Dept'
        when PO_Master.PurchasingGroup = 'Z26' then 'Sanitation Dept'
        when PO_Master.PurchasingGroup = 'Z27' then 'HR Dept.'
        end                                                                                                                           as DepartmentDescreption,
      //      PO_Master.PurchaseOrderItemText                                                                                                 as MaterialDescription,
      _MaterialDesc.ProductName                                                                                                       as MaterialDescription,
      //      PO_Master.BaseUnit                                                                                                              as UOM,

      JournalItem.baseunit                                                                                                            as UOM,
      //      case when JournalItem.purchasingdocument is not initial then
      //      PO_Master.ConsumptionTaxCtrlCode  else
      //               HSN.AssignmentReference          end                                     as HSNCode,

      case when JournalItem.hsn_code is not initial then
      JournalItem.hsn_code else
      JournalItem.hsncode end                                                                                                         as HSNCode,

      PO_Master.PurchaseOrderDate                                                                                                     as PurchaseOrderDate,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      PO_Master.OrderQuantity                                                                                                         as POrderQuantity,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      PO_Master.QuantityInPurchaseOrderUnit                                                                                           as QuantityInPurchaseOrderUnit,

      PO_Master.DocumentCurrency                                                                                                      as DocumentCurrency,

      @Semantics.amount.currencyCode: 'companycodecurrecy'
      case when JournalItem.purchasingdocument is not initial and  PO_Master.DocumentCurrency <> 'INR' and JournalItem.amcomp < 0 then
      JournalItem.amcomp * -1 else

      case when JournalItem.purchasingdocument is  not initial and JournalItem.amcomp < 0 then
      JournalItem.amcomp * -1 else

      case when JournalItem.purchasingdocument is  initial and JournalItem.amcomp < 0 then
      JournalItem.amcomp * -1 else

      case when JournalItem.purchasingdocument is not initial and  PO_Master.DocumentCurrency <> 'INR' then
      JournalItem.amcomp else

      case when JournalItem.purchasingdocument is not initial   then
      JournalItem.amcomp else
      
      case when JournalItem.purchasingdocument is  initial   then
      JournalItem.amcomp
      end end end end end end                                                                                             as NetInvoiceAmount,
      //      case when JournalItem.purchasingdocument is not initial  then
      //       PO_Master.SupplierInvoiceItemAmount else
      //       PO_Master.SupplierInvoiceItemAmount end end                                                                                          as NetInvoiceAmount,

      //  else
      //  JournalEntry.amcomp   end as NetInvoiceAmount,
      //  PO_Master.ConditionRateValueC
      //  @Semantics.amount.currencyCode: 'DocumentCurrency'
      PO_Master.NetPriceAmount                                                                                                        as Rate,
      //  PO_Master.
      // PO_Master.BaseUnit                                  as Rate,


      @Semantics.amount.currencyCode: 'companycodecurrecy'
      case when JournalItem.docnum = '13' then
      JournalItem.amcomp * -1  else

      case when JournalItem.purchasingdocument is not initial and  PO_Master.DocumentCurrency <> 'INR'
      and JournalItem.amcomp < 0 then
      JournalItem.amcomp * -1 else

      case when JournalItem.purchasingdocument is  initial
      and JournalItem.amcomp < 0 then
      JournalItem.amcomp * -1 else

      case when JournalItem.purchasingdocument is  not initial
      and JournalItem.amcomp < 0 then
      JournalItem.amcomp * -1 else

      case when JournalItem.purchasingdocument is not initial and  PO_Master.DocumentCurrency <> 'INR' then
      JournalItem.amcomp else

      case when JournalItem.purchasingdocument is  not initial then
      JournalItem.amcomp else

      case when JournalItem.purchasingdocument is  initial then
      JournalItem.amcomp
      end end end end end end end                                                                                                     as BaseAmount,


      //      POItemPricing.ConditionAmount                     as GrossAmount,
      POItemPricing.ConditionRateValue                                                                                                as ConditionRateValue,
      //      PO_Master.TaxCode
      //                                                                                                                      as TaxCode,
      //      case JOU
      case when JournalItem.purchasingdocument is not initial then
      PO_Master.TaxCode
      else
      // JournalEntry.TaxCode
           JournalItem.taxcode                                                                                                   end  as TAXCODE,
      @Semantics.amount.currencyCode: 'companycodecurrecy'
      PO_Master.NetPriceAmount                                                                                                        as amnt_com_curr,

      @Semantics.amount.currencyCode: 'companycodecurrecy'
      case when JournalItem.taxcode = 'AN'
      then
      Cgst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.docnum = '13' and Cgst_gl.AmountInCompanyCodeCurrency < 0
      and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.purchasingdocument is initial
      and JournalItem.taxcode <> 'V0' and JournalItem.taxcode is not initial
      and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.purchasingdocument is not initial
      and JournalItem.taxcode <> 'V0' and JournalItem.taxcode is not initial
      and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.docnum = '13' and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
      Cgst_gl.AmountInCompanyCodeCurrency * -1 else

      case when JournalItem.purchasingdocument is initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.taxcode <> 'V0' and JournalItem.taxcode is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency else

      case when JournalItem.purchasingdocument is not initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.taxcode <> 'V0' and JournalItem.taxcode is not initial then 
      Cgst_gl.AmountInCompanyCodeCurrency
      else
      Cgst_gl.AmountInCompanyCodeCurrency
      end end end end end end end                                                                                                     as CGST,

      @Semantics.amount.currencyCode: 'companycodecurrecy'

      case when JournalItem.taxcode = 'AN'
      then
      sgst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.docnum = '13' and sgst_gl.AmountInCompanyCodeCurrency < 0
      and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      sgst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.purchasingdocument is initial
      and JournalItem.taxcode <> 'V0' and JournalItem.taxcode is not initial
      and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      sgst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.purchasingdocument is not initial
      and JournalItem.taxcode <> 'V0' and JournalItem.taxcode is not initial
      and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      sgst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.docnum = '13' and sgst_gl.AmountInCompanyCodeCurrency < 0 then
      sgst_gl.AmountInCompanyCodeCurrency * -1 else

      case when JournalItem.purchasingdocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.taxcode <> 'V0' and JournalItem.taxcode is not initial then
            sgst_gl.AmountInCompanyCodeCurrency else

           case when JournalItem.purchasingdocument is not initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
           and JournalItem.taxcode <> 'V0' and JournalItem.taxcode is not initial then 
                sgst_gl.AmountInCompanyCodeCurrency
          else
          sgst_gl.AmountInCompanyCodeCurrency
          end end end end end end end                                                                                                 as SGST,

      @Semantics.amount.currencyCode: 'companycodecurrecy'
      case when JournalItem.taxcode = 'AN'
      then
      igst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.docnum = '13' and igst_gl.AmountInCompanyCodeCurrency < 0
      and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      igst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.purchasingdocument is initial and igst_glis.AmountInCompanyCodeCurrency is not initial
      and JournalItem.taxcode = 'IS'
      and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial  then
      igst_glis.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.purchasingdocument is initial
      and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      igst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.purchasingdocument is not initial
      and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      igst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.docnum = '13' and igst_gl.AmountInCompanyCodeCurrency < 0 then
      igst_gl.AmountInCompanyCodeCurrency * -1 else

      case when JournalItem.purchasingdocument is initial and igst_glis.AmountInCompanyCodeCurrency is not initial
      and JournalItem.taxcode = 'IS' then
      igst_glis.AmountInCompanyCodeCurrency else

      case when JournalItem.purchasingdocument is initial and igst_gl.AmountInCompanyCodeCurrency is not initial then
       igst_gl.AmountInCompanyCodeCurrency else

      case when JournalItem.purchasingdocument is not initial 
      and igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
      igst_gl.AmountInCompanyCodeCurrency * -1 else

      case when JournalItem.purchasingdocument is not initial and igst_gl.AmountInCompanyCodeCurrency is not initial then  //and PO_Master.IGST is not initial then
      igst_gl.AmountInCompanyCodeCurrency 
      
      end end end end end end end end end end                                                                                           as IGST,

     
      //******************************************************* sgst******************************************

//      case when 
////      JournalItem.purchasingdocument is initial and 
//      sgst_gl.AmountInCompanyCodeCurrency is not initial
//      and JournalItem.taxcode = 'AA' and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
////      cast(1.5 as abap.fltp) else
//            cast(0.015 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when 
//      JournalItem.purchasingdocument is initial and 
      sgst_gl.AmountInCompanyCodeCurrency is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '6C' or JournalItem.taxcode = '2M' or JournalItem.taxcode = '3M' or 
      JournalItem.taxcode = '6K' or JournalItem.taxcode = '2O' or JournalItem.taxcode = '3I' or 
      JournalItem.taxcode = '3K' or JournalItem.taxcode = '3G' ) then
//      cast(2.5 as abap.fltp) else
            cast(0.025 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when 
//      JournalItem.purchasingdocument is initial and
       sgst_gl.AmountInCompanyCodeCurrency is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '6A' or JournalItem.taxcode = '2I' or JournalItem.taxcode = '6I'  or 
      JournalItem.taxcode = '2K' or JournalItem.taxcode = '3E' or JournalItem.taxcode = '3C' )
      then
//      round(6,0) else
            cast(0.06 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when 
//      JournalItem.purchasingdocument is initial and 
      RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then //or JournalItem.taxcode = 'G4' or JournalItem.taxcode = 'AJ' or JournalItem.taxcode = 'AM' then
//      round(9,0) else
            cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when
//       JournalItem.purchasingdocument is initial and
        RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  )  then
//      round(9,0) else
            cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when
//       JournalItem.purchasingdocument is initial  and
       RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then
//      round(9,0) else
            cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when
//       JournalItem.purchasingdocument is initial and 
       RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then
//      round(9,0) else
            cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when
//       JournalItem.purchasingdocument is initial and 
       sgst_gl.AmountInCompanyCodeCurrency is not initial
      and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial and ( 
      JournalItem.taxcode = '22' or JournalItem.taxcode = '6B' or JournalItem.taxcode = '2E' or JournalItem.taxcode = '6N' 
       or JournalItem.taxcode = '6J'  or JournalItem.taxcode = '2G'  or JournalItem.taxcode = '6M' ) then
//      round(14,0) else
            floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp)) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and JournalItem.taxcode = 'AA' and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
//      cast(1.5 as abap.fltp) else
            cast(0.015 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and  ( JournalItem.taxcode = '6C' or JournalItem.taxcode = '2M' or JournalItem.taxcode = '3M' or 
      JournalItem.taxcode = '6K' or JournalItem.taxcode = '2O' or JournalItem.taxcode = '3I' or 
      JournalItem.taxcode = '3K' or JournalItem.taxcode = '3G' )  and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
//      cast(2.5 as abap.fltp) else
            cast(0.025 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and  ( JournalItem.taxcode = '6A' or JournalItem.taxcode = '2I' or JournalItem.taxcode = '6I'  or 
      JournalItem.taxcode = '2K' or JournalItem.taxcode = '3E' or JournalItem.taxcode = '3C' ) and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
//      round(6,0) else
            cast(0.06 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
//      round(9,0) else
            cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and ( JournalItem.taxcode = '22' or JournalItem.taxcode = '6B' or JournalItem.taxcode = '2E' or JournalItem.taxcode = '6N' 
       or JournalItem.taxcode = '6J'  or JournalItem.taxcode = '2G'  or JournalItem.taxcode = '6M' ) and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
//      round(14,0) else
            floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp)) else

//      case when JournalItem.purchasingdocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
//      and JournalItem.taxcode = 'AA' then
//      cast(1.5 as abap.fltp) else
      case when JournalItem.purchasingdocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '6C' or JournalItem.taxcode = '2M' or JournalItem.taxcode = '3M' or 
      JournalItem.taxcode = '6K' or JournalItem.taxcode = '2O' or JournalItem.taxcode = '3I' or 
      JournalItem.taxcode = '3K' or JournalItem.taxcode = '3G' )  then
      cast(2.5 as abap.fltp) else
      case when JournalItem.purchasingdocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '6A' or JournalItem.taxcode = '2I' or JournalItem.taxcode = '6I'  or 
      JournalItem.taxcode = '2K' or JournalItem.taxcode = '3E' or JournalItem.taxcode = '3C' ) then
      round(6,0) else
      case when JournalItem.purchasingdocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then
      round(9,0) else
      case when JournalItem.purchasingdocument is initial
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then
      (cast(0.09 as abap.fltp) * cast(100 as abap.fltp)) else
      case when JournalItem.purchasingdocument is not initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  )
       then  round(9,0) 
       else
      case when JournalItem.purchasingdocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '22' or JournalItem.taxcode = '6B' or JournalItem.taxcode = '2E' or JournalItem.taxcode = '6N' 
       or JournalItem.taxcode = '6J'  or JournalItem.taxcode = '2G'  or JournalItem.taxcode = '6M' ) then
      round(14,0) else
//      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
//      and JournalItem.taxcode = 'AA' then
//      cast(1.5 as abap.fltp) else
      //      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and  ( JournalItem.taxcode = '6C' or JournalItem.taxcode = '2M' or JournalItem.taxcode = '3M' or 
      JournalItem.taxcode = '6K' or JournalItem.taxcode = '2O' or JournalItem.taxcode = '3I' or 
      JournalItem.taxcode = '3K' or JournalItem.taxcode = '3G' )  then  //or JournalItem.taxcode = 'AK' or JournalItem.taxcode = 'AH' then
      cast(2.5 as abap.fltp) else
      //      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and  ( JournalItem.taxcode = '6A' or JournalItem.taxcode = '2I' or JournalItem.taxcode = '6I'  or 
      JournalItem.taxcode = '2K' or JournalItem.taxcode = '3E' or JournalItem.taxcode = '3C' ) then
      round(6,0) else
      //      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then //or JournalItem.taxcode = 'AJ' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else
      round(9,0) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and (  JournalItem.taxcode = '22' or JournalItem.taxcode = '6B' or JournalItem.taxcode = '2E' or JournalItem.taxcode = '6N' 
       or JournalItem.taxcode = '6J'  or JournalItem.taxcode = '2G'  or JournalItem.taxcode = '6M' ) then
      round(14,0)
      //      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp))

        end end end end end end end end end end end end end end end end end end end end end end 
//        end 
//        end end                      
             as SGST_per,
      //******************************************************* cgst******************************************

//      case when
////       JournalItem.purchasingdocument is initial and
//        JournalItem.taxcode = 'AA'
//      and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
//      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      case when 
//      JournalItem.purchasingdocument is initial and 
      RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '6C' or JournalItem.taxcode = '2M' or JournalItem.taxcode = '3M' or 
      JournalItem.taxcode = '6K' or JournalItem.taxcode = '2O' or JournalItem.taxcode = '3I' or 
      JournalItem.taxcode = '3K' or JournalItem.taxcode = '3G' ) then
      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      case when 
//      JournalItem.purchasingdocument is initial and 
      RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '6A' or JournalItem.taxcode = '2I' or JournalItem.taxcode = '6I'  or 
      JournalItem.taxcode = '2K' or JournalItem.taxcode = '3E' or JournalItem.taxcode = '3C' ) then
      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when
//       JournalItem.purchasingdocument is initial and 
       RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then //or JournalItem.taxcode = 'G4' or JournalItem.taxcode = 'AJ' or JournalItem.taxcode = 'AM' then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when 
//      JournalItem.purchasingdocument is initial and 
      RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when 
//      JournalItem.purchasingdocument is initial and
       RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when
//       JournalItem.purchasingdocument is initial and
        RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when 
//      JournalItem.purchasingdocument is initial and
       RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( 
      JournalItem.taxcode = '22' or JournalItem.taxcode = '6B' or JournalItem.taxcode = '2E' or JournalItem.taxcode = '6N' 
       or JournalItem.taxcode = '6J'  or JournalItem.taxcode = '2G'  or JournalItem.taxcode = '6M' ) then
      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp)) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and JournalItem.taxcode = 'AA' and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and  ( JournalItem.taxcode = '6C' or JournalItem.taxcode = '2M' or JournalItem.taxcode = '3M' or 
      JournalItem.taxcode = '6K' or JournalItem.taxcode = '2O' or JournalItem.taxcode = '3I' or 
      JournalItem.taxcode = '3K' or JournalItem.taxcode = '3G' )  and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and  ( JournalItem.taxcode = '6A' or JournalItem.taxcode = '2I' or JournalItem.taxcode = '6I'  or 
      JournalItem.taxcode = '2K' or JournalItem.taxcode = '3E' or JournalItem.taxcode = '3C' ) and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and ( JournalItem.taxcode = '22' or JournalItem.taxcode = '6B' or JournalItem.taxcode = '2E' or JournalItem.taxcode = '6N' 
       or JournalItem.taxcode = '6J'  or JournalItem.taxcode = '2G'  or JournalItem.taxcode = '6M' ) and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp)) * cast(0 as abap.fltp) else

      case when 
//      JournalItem.purchasingdocument is initial
//      //      and JournalEntry.DebitCreditCode = 'S'
//      //      and JournalEntry.Trans_type = 'KBS'
//      and JournalItem.taxcode = 'AA' then
//      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) else
//      case when
       JournalItem.purchasingdocument is initial
      and  ( JournalItem.taxcode = '6C' or JournalItem.taxcode = '2M' or JournalItem.taxcode = '3M' or 
      JournalItem.taxcode = '6K' or JournalItem.taxcode = '2O' or JournalItem.taxcode = '3I' or 
      JournalItem.taxcode = '3K' or JournalItem.taxcode = '3G' )  then
      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else
      //      (cast(JournalEntry.amcomp as abap.fltp) * 0.025) else
      case when JournalItem.purchasingdocument is initial
      //      and JournalEntry.DebitCreditCode = 'S'
      //      and JournalEntry.Trans_type = 'KBS'
      and  ( JournalItem.taxcode = '6A' or JournalItem.taxcode = '2I' or JournalItem.taxcode = '6I'  or 
      JournalItem.taxcode = '2K' or JournalItem.taxcode = '3E' or JournalItem.taxcode = '3C' ) then
      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else
      //      (cast(JournalEntry.amcomp as abap.fltp) * 0.06) else
      case when JournalItem.purchasingdocument is initial
      //      and JournalEntry.DebitCreditCode = 'S'
      //      and JournalEntry.Trans_type = 'KBS'
      and ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then
      (cast(0.09 as abap.fltp) * cast(100 as abap.fltp)) else

      case when JournalItem.purchasingdocument is not initial
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

      //      (cast(JournalEntry.amcomp as abap.fltp) * 0.09) else
      case when JournalItem.purchasingdocument is initial
      //      and JournalEntry.DebitCreditCode = 'S'
      //      and JournalEntry.Trans_type = 'KBS'
      and (  JournalItem.taxcode = '22' or JournalItem.taxcode = '6B' or JournalItem.taxcode = '2E' or JournalItem.taxcode = '6N' 
       or JournalItem.taxcode = '6J'  or JournalItem.taxcode = '2G'  or JournalItem.taxcode = '6M' ) then
      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp)) else
      //      (cast(JournalEntry.amcomp as abap.fltp) * 0.14) else


//      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
//      and JournalItem.taxcode = 'AA' then
//      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) else
      
      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and  ( JournalItem.taxcode = '6C' or JournalItem.taxcode = '2M' or JournalItem.taxcode = '3M' or 
      JournalItem.taxcode = '6K' or JournalItem.taxcode = '2O' or JournalItem.taxcode = '3I' or 
      JournalItem.taxcode = '3K' or JournalItem.taxcode = '3G' )   then 
      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else
      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and  ( JournalItem.taxcode = '6A' or JournalItem.taxcode = '2I' or JournalItem.taxcode = '6I'  or 
      JournalItem.taxcode = '2K' or JournalItem.taxcode = '3E' or JournalItem.taxcode = '3C' ) then
      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else
      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and  ( JournalItem.taxcode = '2Q' or JournalItem.taxcode = 'G4' or JournalItem.taxcode = '3A' or JournalItem.taxcode = '2S' or JournalItem.taxcode = 'H2' or 
      JournalItem.taxcode = '2W' or JournalItem.taxcode = '2Y' or JournalItem.taxcode = '2U' or JournalItem.taxcode = '6S' or JournalItem.taxcode = 'H3' 
      or JournalItem.taxcode = 'H5' or JournalItem.taxcode = 'H6' or JournalItem.taxcode = 'J2'  ) then
      (cast(0.09 as abap.fltp) * cast(100 as abap.fltp)) else
      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      and ( JournalItem.taxcode = '22' or JournalItem.taxcode = '6B' or JournalItem.taxcode = '2E' or JournalItem.taxcode = '6N' 
       or JournalItem.taxcode = '6J'  or JournalItem.taxcode = '2G'  or JournalItem.taxcode = '6M' ) then //or JournalItem.taxcode = 'AJ' then
      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp))
      end end end end end end end end end end end end end end end end end end end end end 
//      end 
//      end   
//      end     
                                  as CGST_per,

      //******************************************************* cgst******************************************

      //******************************************************* igst******************************************

      case when JournalItem.purchasingdocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial
      and RCM_igst_gl.AmountInCompanyCodeCurrency is not null
      and ( JournalItem.taxcode = '30' or JournalItem.taxcode = '2L'  or JournalItem.taxcode = '2A'  or JournalItem.taxcode = '3L'  or 
      JournalItem.taxcode = '34' or JournalItem.taxcode = '2N'  or JournalItem.taxcode = '3H'  or JournalItem.taxcode = '3J' or JournalItem.taxcode = '3F' ) then
      cast(0.05 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when JournalItem.purchasingdocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial
      and RCM_igst_gl.AmountInCompanyCodeCurrency is not null
      and ( JournalItem.taxcode = '23'or JournalItem.taxcode = '29' or JournalItem.taxcode = '2H' or JournalItem.taxcode = '2B' or JournalItem.taxcode = '35' 
      or JournalItem.taxcode = '2J' or JournalItem.taxcode = '3D' or JournalItem.taxcode = '3B' ) and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      cast(0.12 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when JournalItem.purchasingdocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial
      and RCM_igst_gl.AmountInCompanyCodeCurrency is not null
      and (  JournalItem.taxcode = '24' or JournalItem.taxcode = '2P' or JournalItem.taxcode = 'G3'
         or JournalItem.taxcode = 'K1' or JournalItem.taxcode = 'K9' or JournalItem.taxcode = '2Z' 
         or JournalItem.taxcode = 'RN' or JournalItem.taxcode = '2R' or JournalItem.taxcode = 'H1'
         or JournalItem.taxcode = 'K3' or JournalItem.taxcode = 'L1' or JournalItem.taxcode = '2V' 
          or JournalItem.taxcode = '2X' or JournalItem.taxcode = 'RS' or JournalItem.taxcode = '2T' 
           or JournalItem.taxcode = '6R' or JournalItem.taxcode = 'H4' or JournalItem.taxcode = 'J1' or JournalItem.taxcode = 'K4'  ) then
      cast(0.18 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when JournalItem.purchasingdocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not null
      and ( JournalItem.taxcode = '25' or JournalItem.taxcode = '26' or JournalItem.taxcode = '2D' or JournalItem.taxcode = '2C' 
      or JournalItem.taxcode = '36' or JournalItem.taxcode = '2F' or JournalItem.taxcode = '6L' or JournalItem.taxcode = '6O' ) and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      cast(0.28 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else

      case when PO_Master.IGST is not null and POItemPricing.ConditionAmount is not null
      and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not null then
      cast( PO_Master.IGST as abap.fltp ) / cast( PO_Master.SupplierInvoiceItemAmount as abap.fltp ) * cast( 100 as abap.fltp ) * cast(0 as abap.fltp) else

      case when
      JournalItem.taxcode = '30' or JournalItem.taxcode = '2L'  or JournalItem.taxcode = '2A'  or JournalItem.taxcode = '3L'  or 
      JournalItem.taxcode = '34' or JournalItem.taxcode = '2N'  or JournalItem.taxcode = '3H'  or JournalItem.taxcode = '3J' or JournalItem.taxcode = '3F' then 
      cast(0.05 as abap.fltp) * cast(100 as abap.fltp) else

      case when ( JournalItem.taxcode = '23'or JournalItem.taxcode = '29' or JournalItem.taxcode = '2H' or JournalItem.taxcode = '2B' or JournalItem.taxcode = '35' 
      or JournalItem.taxcode = '2J' or JournalItem.taxcode = '3D' or JournalItem.taxcode = '3B' ) then
      cast(0.12 as abap.fltp) * cast(100 as abap.fltp) else

      case when
      JournalItem.taxcode = '24' or JournalItem.taxcode = '2P' or JournalItem.taxcode = 'G3'
         or JournalItem.taxcode = 'K1' or JournalItem.taxcode = 'K9' or JournalItem.taxcode = '2Z' 
         or JournalItem.taxcode = 'RN' or JournalItem.taxcode = '2R' or JournalItem.taxcode = 'H1'
         or JournalItem.taxcode = 'K3' or JournalItem.taxcode = 'L1' or JournalItem.taxcode = '2V' 
          or JournalItem.taxcode = '2X' or JournalItem.taxcode = 'RS' or JournalItem.taxcode = '2T' 
           or JournalItem.taxcode = '6R' or JournalItem.taxcode = 'H4' or JournalItem.taxcode = 'J1' or JournalItem.taxcode = 'K4' then
      floor( cast(0.18 as abap.fltp) * cast(100 as abap.fltp) ) else

      case when JournalItem.taxcode = 'IS' and taxrate.ConditionRateAmount is not initial then
      floor(taxrate.ConditionRateAmount) else

      case when
      JournalItem.taxcode = '25' or JournalItem.taxcode = '26' or JournalItem.taxcode = '2D' or JournalItem.taxcode = '2C' 
      or JournalItem.taxcode = '36' or JournalItem.taxcode = '2F' or JournalItem.taxcode = '6L' or JournalItem.taxcode = '6O' then
      floor( cast(0.28 as abap.fltp) * cast(100 as abap.fltp) )

      end end end end end end end end end end                                                                                         as IGST_per,

      case when JournalItem.purchasingdocument is initial and JournalItem.taxcode = 'IS' then
      cast(0.18 as abap.fltp) * cast(100 as abap.fltp)  end                                                                           as igst_perc,


      //******************************************************* igst******************************************


      //*******************************************************RSGST******************************************
      case when PO_Master.RSGST is not initial and PO_Master.SupplierInvoiceItemAmount is not initial then
       ceil (cast( PO_Master.RSGST as abap.fltp ) / cast( PO_Master.SupplierInvoiceItemAmount as abap.fltp ) * cast( 100 as abap.fltp )) else

      //RCM Percentage

      case when JournalItem.purchasingdocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3M'or JournalItem.taxcode = '3K' ) then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

//       case when JournalItem.purchasingdocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
//      and JournalItem.taxcode = 'AI' then
//        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3A' or  JournalItem.taxcode = '2Y'  or  JournalItem.taxcode = 'J2'  ) then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3M'or JournalItem.taxcode = '3K' ) then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

//       case when JournalItem.purchasingdocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
//      and JournalItem.taxcode = 'AL' then
//        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3A' or  JournalItem.taxcode = '2Y'  or  JournalItem.taxcode = 'J2'  ) then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.purchasingdocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3M'or JournalItem.taxcode = '3K' ) then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

//       case when JournalItem.purchasingdocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
//      and JournalItem.taxcode = 'AI' then
//        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3A' or  JournalItem.taxcode = '2Y'  or  JournalItem.taxcode = 'J2'  ) then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3M'or JournalItem.taxcode = '3K' ) then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

//       case when JournalItem.purchasingdocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
//      and JournalItem.taxcode = 'AL' then
//        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3A' or  JournalItem.taxcode = '2Y'  or  JournalItem.taxcode = 'J2'  ) then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp)

          end end end end end end end 
//          end end end end 
end 
end         as RSGST_per,

      case when JournalItem.purchasingdocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      ceil(cast(RCM_sgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
      sgst_gl.AmountInCompanyCodeCurrency
      //      RCM_sgst_gl.AmountInCompanyCodeCurrency
      else
      case when JournalItem.purchasingdocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      ceil(cast(RCM_sgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
      sgst_gl.AmountInCompanyCodeCurrency
      //      RCM_sgst_gl.AmountInCompanyCodeCurrency
      else
      fltp_to_dec (  PO_Master.RSGST as abap.dec(16,2))
      //      PO_Master.RSGST
        end end                                                                                                                       as RSGST,

      //*******************************************************RSGST******************************************

      //*******************************************************RCGST******************************************
      case when PO_Master.RCGST is not null and PO_Master.SupplierInvoiceItemAmount is not null then
           ceil (cast( PO_Master.RCGST as abap.fltp ) / cast( PO_Master.SupplierInvoiceItemAmount as abap.fltp ) * cast( 100 as abap.fltp )) else

      case when JournalItem.purchasingdocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3M'or JournalItem.taxcode = '3K' ) then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

//       case when JournalItem.purchasingdocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
//      and JournalItem.taxcode = 'AI' then
//        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3A' or  JournalItem.taxcode = '2Y'  or  JournalItem.taxcode = 'J2'  ) then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3M'or JournalItem.taxcode = '3K' ) then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

//       case when JournalItem.purchasingdocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
//      and JournalItem.taxcode = 'AL' then
//        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3A' or  JournalItem.taxcode = '2Y'  or  JournalItem.taxcode = 'J2'  ) then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

      //RCM Percentage
      case when JournalItem.purchasingdocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3M'or JournalItem.taxcode = '3K' ) then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

//       case when JournalItem.purchasingdocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
//      and JournalItem.taxcode = 'AI' then
//        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3A' or  JournalItem.taxcode = '2Y'  or  JournalItem.taxcode = 'J2'  ) then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3M'or JournalItem.taxcode = '3K' ) then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

//       case when JournalItem.purchasingdocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
//      and JournalItem.taxcode = 'AL' then
//        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and ( JournalItem.taxcode = '3A' or  JournalItem.taxcode = '2Y'  or  JournalItem.taxcode = 'J2'  ) then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp)

          end end end end end end 
          end 
//          end end end end 
end 
end                                  as RCGST_per,


      case when JournalItem.purchasingdocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      ceil(cast(RCM_Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
        Cgst_gl.AmountInCompanyCodeCurrency
      //      RCM_Cgst_gl.AmountInCompanyCodeCurrency
      else
      case when JournalItem.purchasingdocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      ceil(cast(RCM_Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
        Cgst_gl.AmountInCompanyCodeCurrency
      //      RCM_Cgst_gl.AmountInCompanyCodeCurrency
      else
      fltp_to_dec (  PO_Master.RCGST as abap.dec(16,2))
      //      PO_Master.RCGST
       end end                                                                                                                        as RCGST,

      //*******************************************************RCGST******************************************

      case when JournalItem.purchasingdocument is not initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.taxcode = 'J1' then
      cast(0.18 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is not initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
       cast(0.5 as abap.fltp) * cast(100 as abap.fltp) else

      case when PO_Master.RIGST is not null and PO_Master.SupplierInvoiceItemAmount is not null then
           ceil (cast( PO_Master.RIGST as abap.fltp ) / cast( PO_Master.SupplierInvoiceItemAmount as abap.fltp ) * cast( 100 as abap.fltp )) else
           

       case when JournalItem.purchasingdocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial
       and ( JournalItem.taxcode = '2Z' or JournalItem.taxcode = 'RN' or JournalItem.taxcode = '2X' or JournalItem.taxcode = 'RS' or JournalItem.taxcode = 'J1' ) then
        cast(0.18 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.purchasingdocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
       cast(0.5 as abap.fltp) * cast(100 as abap.fltp)
          end end end end end                                                                                                         as RIGST_per,

      case when JournalItem.purchasingdocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      //      ceil(cast(RCM_igst_gl.AmountInCompanyCodeCurrency as abap.fltp))
      igst_gl.AmountInCompanyCodeCurrency
      else
      case when JournalItem.purchasingdocument is not initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      //      ceil(cast(RCM_igst_gl.AmountInCompanyCodeCurrency as abap.fltp))
      igst_gl.AmountInCompanyCodeCurrency
      else
      fltp_to_dec (  PO_Master.RIGST as abap.dec(16,2)) end end                                                                       as RIGST,


      // case when JournalItem.purchasingdocument is initial


      //******************************************************TOTAL TAX AMOUNT*****************************************************
      //       @Semantics.amount.currencyCode: 'DocumentCurrency'

      case when JournalItem.docnum = '13' and JournalItem.purchasingdocument is initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))
         +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp)) else

      case when JournalItem.docnum = '13' and JournalItem.purchasingdocument is not initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))
         +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp) ) else

      case when JournalItem.docnum = '13' and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))
         +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp)) else

      case when JournalItem.docnum = '13' and JournalItem.purchasingdocument is initial and igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))  else

      case when JournalItem.docnum = '13' and JournalItem.purchasingdocument is not initial and igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))  else

      case when JournalItem.docnum = '13' and igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp)) else

      case when JournalItem.purchasingdocument is initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial then
        Cgst_gl.AmountInCompanyCodeCurrency
         +
        sgst_gl.AmountInCompanyCodeCurrency else

          case when JournalItem.purchasingdocument is initial and igst_gl.AmountInCompanyCodeCurrency is not initial then
          igst_gl.AmountInCompanyCodeCurrency else

          case when JournalItem.purchasingdocument is initial and JournalItem.taxcode = 'IS' then
          igst_glis.AmountInCompanyCodeCurrency else

         case when Cgst_gl.AmountInCompanyCodeCurrency is not initial then
          Cgst_gl.AmountInCompanyCodeCurrency +
          sgst_gl.AmountInCompanyCodeCurrency  else

         case when igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
          igst_gl.AmountInCompanyCodeCurrency * -1 else
          
         case when igst_gl.AmountInCompanyCodeCurrency is not initial then
          igst_gl.AmountInCompanyCodeCurrency

         end end end end end end end end end end end end                                                                                 as TotaltaxAmount,

      //******************************************************TOTAL TAX AMOUNT*****************************************************


      //******************************************************TOTAL INVOICE*****************************************************
      @Semantics.amount.currencyCode: 'companycodecurrecy' //DocumentCurrency

      case when JournalItem.docnum = '13' and JournalItem.purchasingdocument is initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp ))
        +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp ))
        +
        ceil(cast(JournalItem.amcomp as abap.fltp) * cast(-1 as abap.fltp )) else

      case when JournalItem.docnum = '13' and JournalItem.purchasingdocument is not initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp ))
        +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp ))
        +
        ceil(cast(JournalItem.amcomp as abap.fltp) * cast(-1 as abap.fltp )) else

      case when JournalItem.docnum = '13' and JournalItem.purchasingdocument is initial and igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp ))
        +
        ceil(cast(JournalItem.amcomp as abap.fltp) * cast(-1 as abap.fltp ))  else

      case when JournalItem.docnum = '13' and JournalItem.purchasingdocument is not initial and igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp ) )
        +
        ceil(cast(JournalItem.amcomp as abap.fltp)  * cast(-1 as abap.fltp ) ) else

      case when JournalItem.purchasingdocument is initial and JournalItem.docnum = '13' then
        ceil(cast(JournalItem.amcomp as abap.fltp) * cast(-1 as abap.fltp )) else

      case when JournalItem.purchasingdocument is not initial and  PO_Master.DocumentCurrency <> 'INR' then
      JournalItem.amcomp else

      case when JournalItem.purchasingdocument is initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial then
          ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
         +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
         +
         ceil(cast(JournalItem.amcomp as abap.fltp)) else

         case when JournalItem.purchasingdocument is initial and igst_gl.AmountInCompanyCodeCurrency is not initial
         then
          ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp))
          +
          ceil(cast(JournalItem.amcomp as abap.fltp))  else

          case when JournalItem.purchasingdocument is initial and JournalItem.taxcode = 'IS' then
          ceil(cast(igst_glis.AmountInCompanyCodeCurrency as abap.fltp))
          +
          ceil(cast(JournalItem.amcomp as abap.fltp))  else

          case when JournalItem.purchasingdocument is not initial and JournalItem.taxcode = 'G0' then
          ceil(cast(JournalItem.amcomp as abap.fltp))  else

          case when JournalItem.purchasingdocument is initial then
          ceil(cast(JournalItem.amcomp as abap.fltp)) else

         case when Cgst_gl.AmountInCompanyCodeCurrency is not initial then
          ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
         +
         ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
         +
         ceil(cast(JournalItem.amcomp as abap.fltp)) else

          case when igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 
          and JournalItem.amcomp < 0 then
          igst_gl.AmountInCompanyCodeCurrency * -1
          +
          JournalItem.amcomp  * -1 else

          case when igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
          igst_gl.AmountInCompanyCodeCurrency * -1
          +
          JournalItem.amcomp  else
          
          case when igst_gl.AmountInCompanyCodeCurrency is not initial then
          igst_gl.AmountInCompanyCodeCurrency 
          +
          JournalItem.amcomp  else

         case when Cgst_gl.AmountInCompanyCodeCurrency is initial and sgst_gl.AmountInCompanyCodeCurrency is initial then
         cast(JournalItem.amcomp as abap.dec(16,2)) else
         
         case when igst_gl.AmountInCompanyCodeCurrency is initial then
         JournalItem.amcomp 

         end end end end end end end end end end end end end  end end end end                                                                as Tot_Inv,


      //******************************************************TOTAL INVOICE*****************************************************

      PO_Master.ReferenceDocument                                                                                                     as ReferenceDocumentMIGO,

      Acctgdoc.BusinessPlace                                                                                                          as business_place,
    // Acctgdoc.DocumentItemText                                                                                                       as Narration,
      JournalEntry.naration as Narration,
      Acctgdoc.WithholdingTaxCode                                                                                                     as tds_tax_code,

      // Add by Krishna 29/10/24
      case when JournalItem.accountingdocumenttype = 'KD' and JournalItem.purchasingdocument is initial and JournalItem.referencedocumentitem = '000001'
      then Acctgdoc.WithholdingTaxAmount
      else
      // Add by Krishna 29/10/24
      case when JournalItem.purchasingdocument is initial and JournalItem.referencedocumentitem = '000002' then
      Acctgdoc.WithholdingTaxAmount else
      case when JournalItem.purchasingdocument is not initial and JournalItem.referencedocumentitem = '000001' then
      Acctgdoc.WithholdingTaxAmount
      end end end                                                                                                                   as less_TDS

      
          , B.InvestmentProfile,
      
           B.Project,
           B.WBSElementInternalID



}
where
  // JournalItem.referencedocumentitem = '000002'
        JournalItem.acctype                =  'S'
  and   JournalItem.debitcreditcode        =  'S'
  or(
        JournalItem.debitcreditcode        =  'H'
    and JournalItem.accountingdocumenttype =  'KG'
  )
  or(
        ProfitCenter.ProfitCenter          <> ' '
    and taxrate.BillingDocumentType        =  'JSTO'
  )

//  and ( JournalItem.accountingdocumenttype = 'KR' or JournalItem.accountingdocumenttype = 'RE' )
//  and ( JournalItem.debitcreditcode   = 'H' and JournalItem.accountingdocumenttype = 'KG' )
//  and  JournalItem.transactiontypedetermination <> 'JRC'
//  and  JournalItem.transactiontypedetermination <> 'JRS'
//  and  JournalItem.transactiontypedetermination <> 'JRI'

//  and JournalItem.transactiontypedetermination <> 'KBS' or JournalItem.transactiontypedetermination <> 'WRX'
//  and JournalItem.glcode <> '0066000130'
//  and JournalItem.glcode <> '0066000120'
//  and JournalItem.debitcreditcode = 'H'
//and  JournalItem.accitem = '002'
// and (JournalItem.glacctype = 'P'
// or JournalItem.glacctype = 'X' )

//  where
//   JournalItem.purchasingdocument = ''
// )//where ( JournalItem.purchasingdocument <> ''

group by
  JournalItem.referencedocumentmiro,
  JournalItem.referencedocumentitem,
  JournalItem.accountingdocument,
  JournalItem.purchasingdocument,
  JournalItem.fiscalyear,
  JournalItem.purchasingdocumentitem,
  //  JournalItem.debitcreditcode,
  JournalItem.supplier,
  // Fi_Postings.AccountingDocument,
  PO_Master.PurchaseOrderItemMaterial,
  SupplierInvoice.DocumentDate,
  JournalItem.postingdate,
  JournalItem.doc_date,
  // JournalItem.refdoc,
  SupplierInvoice.SupplierInvoiceIDByInvcgParty,
  VendorDetails.SupplierName,
  VendorDetails.Region,
  VendorDetails.RegionName,
  VendorDetails.TaxNumber3,
  VendorDetails.TaxNumber2,
  VendorDetails.Panno,
  PO_Master.PurchasingGroup,
  status.status,
//  itc_reco.Status,
//  itc_reco.RecoAction,
//  itc_reco.Reason,
//  itc_reco.RetenPostDoc,
//  itc_reco.ReverseRet,
  //  PO_Master.PurchaseOrderItemText,
  _MaterialDesc.ProductName,
  //  PO_Master.BaseUnit,
  JournalItem.baseunit,
  PO_Master.ConsumptionTaxCtrlCode,
  PO_Master.PurchaseOrderDate,
  PO_Master.OrderQuantity,
  PO_Master.QuantityInPurchaseOrderUnit,
  PO_Master.DocumentCurrency,
  PO_Master.SupplierInvoiceItemAmount,
  PO_Master.NetPriceAmount,
  POItemPricing.ConditionAmount,
  POItemPricing.ConditionRateValue,
  PO_Master.TaxCode,
  //  HSN.AssignmentReference,

  JournalItem.hsn_code,
  JournalItem.hsncode,
  JournalItem.product,
  //Discount.divis,
  PO_Master.SGST,
  PO_Master.CGST,
  PO_Master.IGST,
  PO_Master.RSGST,
  PO_Master.RCGST,
  PO_Master.RIGST,
  PO_Master.BusinessArea,
  // PO_Master.Doctype,
  Jeheader.AccountingDocumentType,
  Jeheader.DocumentReferenceID,
  PO_Master.plant,
  Jeplant.Plant,
  Jeplant.BusinessArea,
  PO_Master.Tot_Inv,
  PO_Master.ReferenceDocument,
  PO_Master.GL_Code,
  PO_Master.Trans_Key,
  PO_Master.IGST_GL,
  PO_Master.CGST_GL,
  PO_Master.SGST_GL,
  PO_Master.com_code_curr,
  JournalEntry.amcomp,
  //  JournalEntry.DebitCreditCode,
  JournalEntry.Trans_type,
  JournalEntry.TaxCode,
  Acctgdoc.BusinessPlace,
  Acctgdoc.DocumentItemText,
  Acctgdoc.WithholdingTaxCode,
  Acctgdoc.WithholdingTaxAmount,
  JournalEntry.Acctype,
  //  JournalEntry.GLAcctype,
  JournalItem.amcomp,
  JournalEntry.IGST_GL,
  JournalEntry.CGST_GL,
  JournalEntry.SGST_GL,
  JournalEntry.PurchasingDocument,
  JournalItem.acctype,
  igst_gl.GLAccount,
  Cgst_gl.GLAccount,
  sgst_gl.GLAccount,
  Cgst_gl.AmountInCompanyCodeCurrency,
  sgst_gl.AmountInCompanyCodeCurrency,
  igst_gl.AmountInCompanyCodeCurrency,
  RCM_sgst_gl.AmountInCompanyCodeCurrency,
  RCM_Cgst_gl.AmountInCompanyCodeCurrency,
  RCM_igst_gl.AmountInCompanyCodeCurrency,
  //  RCM_sgst_gl.GLAccount,
  //  RCM_Cgst_gl.GLAccount,
  //  RCM_igst_gl.GLAccount,
  igst_glis.AmountInCompanyCodeCurrency,
  igst_glis.GLAccount,
  JournalItem.taxcode,
  JournalItem.glcode,
  JournalEntry.doctype,
  JournalItem.compcurr,
  ProfitCenter.ProfitCenter,
  Jeheader.IsReversal,
  Jeheader.ReversalReferenceDocument,
  //  JournalEntry.Crdcomp,
  //  KGCgst_gl.AmountInCompanyCodeCurrency,
  //  JournalItem.crdcomp,
  //  JournalItem.glacctype,
  //  status.reverse_ret,
  //  status.reten_post_doc,
  JournalItem.accountingdocumenttype, //Add by Krishna 24/10/24
  JournalItem.docnum,
  taxrate.ConditionRateAmount,
  JournalEntry.naration,
       B.InvestmentProfile,
        B.Project,
         B.WBSElementInternalID
//  organi_gstin
