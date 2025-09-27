@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Wbs Data against Journal Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZWBS_DATA as select  distinct from 
I_OperationalAcctgDocItem as a inner join 
I_EnterpriseProject as b on ( a.WBSElementInternalID = b.WBSElementInternalID )
{
 a.AccountingDocument,
 a.FiscalYear,
 a.CompanyCode,
 b.Project,
 a.WBSElementInternalID,
 b.InvestmentProfile   
}
where 
a.AccountingDocumentItemType = 'W'
