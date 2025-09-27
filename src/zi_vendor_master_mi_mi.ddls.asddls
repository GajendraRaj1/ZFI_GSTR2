@EndUserText.label: 'Basic View for Vendor Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_VENDOR_MASTER_MI_MI
  as select from I_Supplier   as Supplier
  //  association [0..1] to I_RegionText as RegionText on Supplier.Region = RegionText.Region
    inner join   I_RegionText as RegionText on Supplier.Region = RegionText.Region and Supplier.Country = RegionText.Country
{
  key Supplier.Supplier                 as Supplier,
      Supplier.Region                   as Region,
      RegionText.Country                as Country,
      RegionText.Language               as Langauage,
      Supplier.SupplierName             as SupplierName,
      Supplier.TaxNumber2               as TaxNumber2,
      Supplier.TaxNumber3               as TaxNumber3,
      Supplier.BusinessPartnerPanNumber as Panno,
      // Supplier.
      RegionText.RegionName             as RegionName
}
