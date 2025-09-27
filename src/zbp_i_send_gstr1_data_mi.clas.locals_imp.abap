CLASS lhc_zi_send_gstr1_data_mi DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
    TYPES : BEGIN OF lty_auth,
              uname    TYPE string,
              password TYPE string,
            END OF lty_auth.

    DATA : ls_config TYPE lty_auth.
    DATA : lv_post        TYPE string,
           lo_http_client TYPE REF TO if_web_http_client,
           url1           TYPE string.
    TYPES : BEGIN OF ty_final,

              referencedocumentmiro TYPE string,
              referencedocumentitem TYPE string,
              accountingdocument    TYPE string,
              purchasingdocument    TYPE string,
              fiscalyear            TYPE string,
              status                TYPE string,
            END OF ty_final.
    DATA : wa_create TYPE zgstr2_st.


    METHODS
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check.

    METHODS get_auth_token
      RETURNING VALUE(lv_authtoken) TYPE string.

*    METHODS get_auth_token1
*      RETURNING VALUE(lv_authtoken) TYPE string.
*  protected section.
*    methods new_message redefinition.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_send_gstr1_data_mi RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_send_gstr1_data_mi.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_send_gstr1_data_mi.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_send_gstr1_data_mi.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_send_gstr1_data_mi RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_send_gstr1_data_mi.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_send_gstr1_data_mi RESULT result.

    METHODS status_update FOR MODIFY
      IMPORTING keys FOR ACTION zi_send_gstr1_data_mi~status_update RESULT result.

*    METHODS response FOR MODIFY
*      IMPORTING keys FOR ACTION zi_send_gstr1_data_mi~response RESULT result. "Cmntd by Krishna 23/09/24

    TYPES : BEGIN OF ty_res,
              result TYPE string,
              error  TYPE string,
            END OF ty_res.
    " DATA wres TYPE REF TO data.
    DATA ls_res TYPE ty_res.
    TYPES: BEGIN OF ret,
*             result_id          TYPE char1,
*             result_description TYPE char20,
*             result_extra_key   TYPE char40,

             result_id          TYPE string,
             result_description TYPE string,
             result_extra_key   TYPE string,
           END OF ret.
    TYPES: BEGIN OF tres,
             status(23),
             message(120),
             response     TYPE ret,
           END OF tres.
    DATA : lv_json      TYPE string,
           lv_token     TYPE string,
           lv_res_token TYPE string,
           string1      TYPE string,
           string2      TYPE string,
*           status       TYPE char40.
           status       TYPE string.
    CONSTANTS:
      "url     TYPE string VALUE 'https://api-platform.mastersindia.co/api/v1/saas-apis/sales/',
      content_type TYPE string VALUE 'Content-Type',
      json_content TYPE string VALUE 'application/json',
      base_url     TYPE string VALUE 'https://api-platform.mastersindia.co/api/v1/',
      gstr2_url    TYPE string VALUE 'https://api-platform.mastersindia.co/api/v1/saas-apis/purchase/'.
*    METHODS create_client
*      IMPORTING url           TYPE string
*        RETURNING VALUE(result) TYPE REF TO if_web_http_client
*        RAISING   cx_static_check.

ENDCLASS.

CLASS lhc_zi_send_gstr1_data_mi IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.

*  METHOD if_apj_rt_exec_object~execute.
*  ENDMETHOD.
*
*  METHOD if_apj_dt_exec_object~get_parameters.
*  ENDMETHOD.
*
*  METHOD new_message.
*  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD status_update.
 if  1 = 2.
    DATA: netinvoiceamount TYPE string,
          tot_tax_val      TYPE string,
          txpd_tax_val     TYPE string,
          gstr2_ret        TYPE string,
          period           TYPE string,
          igst             TYPE string,
          cgst             TYPE string,
          sgst             TYPE string,
          qty              TYPE string,
          gst_rate         TYPE i,
          gst_rate1        TYPE string,    "gst rate round-off
          uom              TYPE string,
          cus_gstin        TYPE string,
          rev_chr          TYPE string,
          date             TYPE string,
          inv_date         TYPE string,
          sup_type         TYPE string,
          place_supp       TYPE string,
          inv_cat          TYPE string,
          inv_sts          TYPE string,
          inv_type         TYPE string,
          lv_port          TYPE string,
          lv_space         TYPE string,
          str1             TYPE string,
          str2             TYPE string,
          str3             TYPE string,
          str4             TYPE string,
          str5             TYPE string,
          str6             TYPE string,
          str7             TYPE string,
          str8             TYPE string,
          str9             TYPE string,
          str10            TYPE string,
          str11            TYPE string, str12 TYPE string,
          tot_inv          TYPE string,
          tot_taxable      TYPE string,
          tot_txpd         TYPE string,
          cess             TYPE string,
          itc_elgibity     TYPE string.


    "response store dd
    TYPES : BEGIN OF ty_itmlst,
              bukrs         TYPE bukrs,
              belnr         TYPE belnr_d,
              gjahr         TYPE gjahr,
              posnr         TYPE string,
              igst_amount   TYPE string,
              cgst_amount   TYPE string,
              sgst_amount   TYPE string,
              taxable_value TYPE string,
              hsn_sac       TYPE string,
              product_name  TYPE string,
              item_desc     TYPE string,
              quantity      TYPE string,
              cess_amount   TYPE string,
              gst_rate      TYPE string,
              unit          TYPE string,
              error         TYPE zst_gst_auto_reco_error,
            END OF ty_itmlst.

    DATA : tt_itmlst TYPE TABLE OF ty_itmlst.

    TYPES : BEGIN OF ty_saledt,
              document_date(30),
              supply_type(30),
              invoice_status(30),
              invoice_category(30),
              invoice_type(30),
              total_invoice_value(30),
              total_taxable_value(30),
              txpd_taxtable_value(30),
              gstr1_return_period(30),
              gstr3b_return_period(30),
              reverse_charge(30),
              isamended(30),
              place_of_supply(30),
              supplier_gstin(30),
              buyer_gstin(30),
              customer_name(60),
              itemlist                 LIKE tt_itmlst,
              error                    TYPE zst_gst_auto_reco_error,
            END OF ty_saledt.


*    DATA : lt_saledt TYPE STANDARD TABLE OF ty_saledt,
*           lt_head   TYPE STANDARD TABLE OF ty_saledt.

    TYPES : BEGIN OF ty_purchasedt,
              document_number(30),
              document_date(30),
              original_document_number(30),
              original_document_date(12),
              ref_document_number(30),
              ref_document_date(12),
              supply_type(30),
              erp_document_number(30),
              erp_document_date(12),
              transaction_number(30),
              gl_code(20),
              invoice_status(30),
              invoice_category(30),
              invoice_type(30),
              total_invoice_value(30),
              total_taxable_value(30),
              txpd_taxtable_value(30),
              gstr1_return_period(30),
              gstr3b_return_period(30),
              reverse_charge(30),
              isamended(30),
              inv_itc_eleg(30),
              place_of_supply(30),
              supplier_gstin(30),
              buyer_gstin(30),
              customer_name(60),
              ftp_status                   TYPE string,
              itemlist                     LIKE tt_itmlst,
              error                        TYPE  zst_gst_auto_reco_error,
            END OF ty_purchasedt.


    DATA : itemdesc TYPE string.
    DATA : lt_purchasedt TYPE TABLE OF ty_purchasedt,
           lt_head       TYPE STANDARD TABLE OF ty_purchasedt.

    TYPES : BEGIN OF ty_cntdata,
              success_count       TYPE i,
              failure_count       TYPE i,
              purchase_error_data LIKE lt_purchasedt,
            END OF ty_cntdata.

    TYPES : BEGIN OF ty_output,
              result TYPE ty_cntdata,
              status TYPE string,
            END OF ty_output.

    DATA : ls_output TYPE ty_output.


    DATA:
      lv_lines       TYPE i,
      lv_count       TYPE i,
      lv_syindex     TYPE i,
      lv_syindex2    TYPE i,
      lv_indx        TYPE i,
      lv_divid       TYPE i,
      lv_times       TYPE i,
      lv_times1      TYPE i,
      lv_times2      TYPE i,
      lv_stop        TYPE i,
      lv_gstrate     TYPE i,
      lv_igst        TYPE string,
      lv_cgst        TYPE string,
      lv_sgst        TYPE string,
      lv_qnty        TYPE string,
      lv_taxable_amt TYPE string,
      lv_cess_amt    TYPE string,
      lv_qa          TYPE string,

      dps            TYPE string,
      validhsn       TYPE string,
      hsndesc        TYPE string,
      allexists      TYPE string.

    dps = 'Data Posted Successfully'.
*   validhsn = 'hsn_code should be of valid type!'.
*   hsndesc = |Both hsn code and item description Shouldn't be blank at same time|.
*   allexists = 'This invoice already exists in our system'.

    "response store dd



******* Converting data from JSON format to table
    FIELD-SYMBOLS:
      <data>                         TYPE data,
      <data_u>                       TYPE data,
      <text>                         TYPE data,
      <text1>                        TYPE data,
      <templates>                    TYPE data,
      <templates_uti>                TYPE data,
      <templates_result>             TYPE any,
      <result_uuid>                  TYPE STANDARD TABLE,
      <result_status>                TYPE STANDARD TABLE,
      <result_status_type>           TYPE STANDARD TABLE,
      <metafield_result>             TYPE data,
      <metafield_result_uuid>        TYPE data,
      <metafield_result_status>      TYPE data,
      <metafield_result_utilization> TYPE data,
      <metadata_result>              TYPE data,
      <metafield_result_sts_type>    TYPE data,
      <metadata_result_sts_type>     TYPE data,
      <metadata>                     TYPE STANDARD TABLE,
      <textdata>                     TYPE data.


    DATA lr_data TYPE REF TO data.
    DATA templates TYPE REF TO data.

*    READ ENTITIES OF zi_send_gstr1_data_mi  IN LOCAL MODE
*    ENTITY zi_send_gstr1_data_mi  "ZI_SALES_DATA_TO_MI
*    ALL FIELDS WITH
*    CORRESPONDING #( keys )
*    RESULT DATA(lt_gstr2)
*    FAILED DATA(failed_data)
*    REPORTED DATA(reported_data).
*    READ TABLE keys INTO DATA(wa_keys) INDEX 1.
*    IF sy-subrc = 0.
*      SELECT SINGLE * FROM zi_send_gstr1_data_mi WHERE referencedocumentmiro  = @wa_keys-referencedocumentmiro
*      INTO @DATA(wa_purchase).
*    ENDIF.

    "sending multiple data to portal
    READ ENTITIES OF zi_send_gstr1_data_mi  IN LOCAL MODE
    ENTITY zi_send_gstr1_data_mi  "ZI_SALES_DATA_TO_MI
    ALL FIELDS WITH
    CORRESPONDING #( keys )
    RESULT DATA(lt_gstr2_ml)
    FAILED DATA(failed_data_ml)
    REPORTED DATA(reported_data_ml).
*    READ TABLE keys INTO DATA(wa_keys_ml) INDEX 1.
    LOOP AT keys INTO DATA(wa_keys_ml).
      SELECT * FROM zi_send_gstr1_data_mi WHERE refdocno = @wa_keys_ml-documentreferenceid
      AND referencedocumentmiro = @wa_keys_ml-referencedocumentmiro
      INTO TABLE @DATA(it_purchase_ml).

* (-)by Anurag on 13.07.2024
*      SELECT * FROM zgstr2_st WHERE referencedocumentmiro = @wa_keys_ml-ReferenceDocumentMIRO
*      INTO @DATA(wa_check).
*      ENDSELECT.
*      IF wa_check-status = dps.
*        EXIT.
*      ENDIF.
* (-)by Anurag on 13.07.2024


*   ENDLOOP.



*    IF sy-subrc = 0.
*      SELECT * FROM zi_send_gstr1_data_mi WHERE referencedocumentmiro  = @wa_keys-referencedocumentmiro
*      INTO @DATA(it_purchase_ml).
*    ENDIF.
* data lv_docnum  TYPE string.
*lv_docnum = wa_keys_ml-DocumentReferenceID.
*    lv_lines = lines( it_purchase_ml ).
*    if  lv_lines < sy-index.
*    if lv_docnum = wa_keys_ml-DocumentReferenceID.
*    clear lv_docnum.
*    continue.
*    endif.
*    ENDIF.

      LOOP AT it_purchase_ml INTO DATA(wa_purchase).

*    lv_lines = lines( it_purchase_ml ).
*    if  lv_lines < sy-tabix.
*    if lv_docnum = wa_purchase-RefDocNo.
*    clear lv_docnum.
*    continue.
*    endif.
*    ENDIF.
        IF wa_purchase-taxcode = 'V0' OR wa_purchase-taxcode = 'G0'
         OR wa_purchase-taxcode = '' OR wa_purchase-reverse IS NOT INITIAL.
*          CLEAR : wa_purchase.
          CONTINUE.
        ENDIF.

        tot_taxable  = tot_taxable + wa_purchase-netinvoiceamount.
        tot_inv      = tot_inv + wa_purchase-tot_inv.
        txpd_tax_val = wa_purchase-netinvoiceamount.
        gstr2_ret    = wa_purchase-postingdate.


        IF wa_purchase-plant IS INITIAL.
          wa_purchase-plant = wa_purchase-proftcenter+6(4).
        ENDIF.

        IF wa_purchase-business_place IS NOT INITIAL.
          SELECT SINGLE gstin FROM zdb_org_gstin WHERE business_place = @wa_purchase-business_place
                                                 AND   palnt          = @wa_purchase-plant INTO @cus_gstin.
        ELSE.
          cus_gstin = ''.
        ENDIF.
        " cus_gstin = '27AABCR0897A1ZJ'."'27AACCV4229P1ZT'."'27ADDPA4822E1Z4'."'27ADDPA4822E1Z4'."'27AIAPV4653Q1ZH'.
        IF  wa_purchase-rcgst IS NOT INITIAL OR wa_purchase-rsgst IS NOT INITIAL.
          rev_chr = 'Y'.
        ELSE.
          rev_chr = 'N'.
        ENDIF.
        sup_type = 'Normal'.
        " place_supp = '27'.

        "Start of changes Krishna 23/10
        place_supp = cus_gstin+0(2).
        IF wa_purchase-doctype = 'KD'.
          inv_cat = 'DDN'.
        ELSEIF wa_purchase-doctype = 'KG'.
          inv_cat = 'CDN'.
        ELSE.
          inv_cat = 'TXN'.
        ENDIF.
*         inv_cat  = 'TXN'.
        "End of changes Krishna 23/10
        inv_sts  = 'ADD'.
        inv_type = 'R'.
        lv_port  = ''.
        lv_space = ''.

        date = wa_purchase-invoicedate.
        CONCATENATE date+6(2) '-' date+4(2) '-' date+0(4) INTO inv_date.
        CONDENSE inv_date NO-GAPS.
        CONCATENATE gstr2_ret+4(2) '-' gstr2_ret+0(4) INTO period.

        CONCATENATE wa_purchase-PostingDate+6(2) '-' wa_purchase-PostingDate+4(2) '-'
        wa_purchase-PostingDate+0(4) INTO DATA(lv_postingdate).

      ENDLOOP.

      CONCATENATE : lv_post '{'
                                 INTO lv_post SEPARATED BY ' '.


      CONCATENATE : lv_post  '"purchaseData":' '['
                              INTO lv_post SEPARATED BY ' '.

      CONCATENATE : lv_post    '{'
                                " '"document_number":' '"' wa_purchase-referencedocumentmiro '"' ','
                                  '"document_number":' '"' wa_purchase-refdocno '"' ','
                                  '"document_date":' '"' inv_date '"' ','
                                  '"original_document_number":' '"' lv_space '"' ','
                                  '"original_document_date":' '"' lv_space '"' ','
                                  '"ref_document_number":' '"' lv_space '"' ','
                                  '"ref_document_date":' '"' lv_port '"' ','
                                  '"supply_type":' '"' sup_type '"' ','
                                  '"erp_document_number":' '"' wa_purchase-accountingdocument '"' ','
                                  '"erp_document_date":' '"' lv_postingdate '"' ','
                                  '"transaction_number":' '"' wa_purchase-accountingdocument '"' ','
                                  '"gl_code":' '"' lv_space '"' ','
                                  '"invoice_status":' '"' inv_sts '"' ','
                                  '"invoice_category":' '"' inv_cat '"' ','
                                  '"invoice_type":' '"' inv_type '"' ','
*                                '"total_invoice_value":' netinvoiceamount ','
*                                '"total_taxable_value":' netinvoiceamount ','
*                                '"txpd_taxable_value":' netinvoiceamount ','
                                   '"total_invoice_value":' tot_inv ','
                                  '"total_taxable_value":' tot_taxable ','
*                                '"txpd_taxable_value":' tot_txpd ','
                                  '"txpd_taxable_value":' '"' lv_space '"' ','
*                                '"total_taxable_value":' tot_tax_val ','
*                                '"txpd_taxable_value":' txpd_tax_val ','
                                  '"shipping_bill_number":' '"' lv_space '"' ','
                                  '"shipping_bill_date":' '"' lv_port '"' ','
                                  '"reason":' '"' lv_space '"' ','
                                  '"port_code":' '"' lv_port '"' ','
                                  '"inv_itc_elgibity":' '"' lv_port '"' ','
                                  '"location":' '"' wa_purchase-ProftCenter '"' ','
                                  '"gstr2_return_period":' '"' period '"' ','
                                  '"gstr3b_return_period":' '"' period '"' ','
                                  '"reverse_charge":' '"' rev_chr '"' ','
                                  '"isamended":' '"' lv_port '"' ','
                                  '"amended_pos":' '"' lv_space '"' ','
                                  '"amended_period":' '"' lv_port '"' ','
                                  '"place_of_supply":' '"' place_supp '"' ','
                                  '"supplier_gstin":' '"' wa_purchase-gstin '"' ','
                                  '"buyer_gstin":' '"' cus_gstin '"' ','
                                  '"supplier_name":' '"' wa_purchase-vendorname '"' ','
                                  '"customer_name":' '"' lv_space '"' ','
                                      INTO lv_post. " SEPARATED BY ' '.

      CONCATENATE : lv_post '"itemList":' '['
                               INTO lv_post SEPARATED BY ' '.


      DATA: lv_tabix TYPE sy-tabix.
      CLEAR : lv_tabix, gstr2_ret, period.

      LOOP AT it_purchase_ml INTO DATA(wa_purchase_item) WHERE refdocno = wa_purchase-refdocno
                                                         AND referencedocumentmiro = wa_purchase-referencedocumentmiro.
*                                                         AND ReferenceDocumentItem = wa_purchase-ReferenceDocumentItem.
*   lv_lines = lines( it_purchase_ml ).

        IF wa_purchase_item-taxcode = 'V0' OR wa_purchase_item-taxcode = 'G0'
         OR wa_purchase_item-taxcode = '' OR wa_purchase_item-reverse IS NOT INITIAL.
          CLEAR : wa_purchase_item.
          CONTINUE.
        ENDIF.



        lv_tabix = lv_tabix + 1.
        IF lv_tabix NE 1.
          CONCATENATE lv_post ',' INTO lv_post.
        ENDIF.

        CASE wa_purchase_item-uom.
          WHEN 'KG'.
            uom = 'KGS'.
          WHEN 'NO'.
            uom = 'NOS'.
          WHEN 'MT'.
            uom = 'MTS'.
          WHEN 'L'.
            uom = 'LTR'.
          WHEN 'TO'.
            uom = 'TON'.
          WHEN 'EA'.
            uom = 'NOS'.
          WHEN 'KM'.
            uom = 'KME'.
          WHEN 'DR'.
            uom = 'DRM'.
          WHEN 'ML'.
            uom = 'MLT'.
          WHEN 'M3'.
            uom = 'CBM'.
          WHEN 'M2'.
            uom = 'SQM'.
          WHEN 'G'.
            uom = 'GMS'.
          WHEN 'FT2'.
            uom = 'SQF'.
          WHEN 'DZ'.
            uom = 'DOZ'.
          WHEN 'BOX'.
            uom = 'BOX'.
          WHEN 'BT'.
            uom = 'BTL'.
          WHEN 'BAG'.
            uom = 'BAG'.
          WHEN 'PAA'.
            uom = 'PRS'.
          WHEN 'PAC'.
            uom = 'PAC'.
          WHEN 'ROL'.
            uom = 'ROL'.
          WHEN 'SET'.
            uom = 'SET'.
          WHEN OTHERS.
            uom = 'OTH'.
        ENDCASE.
        tot_tax_val = wa_purchase_item-netinvoiceamount.
*       gstr2_ret   = wa_purchase_item-invoicedate.
        igst        = wa_purchase_item-igst.
        cgst        = wa_purchase_item-cgst.
        sgst        = wa_purchase_item-sgst.

        IF rev_chr = 'Y'.
          igst        = wa_purchase_item-rigst.
          cgst        = wa_purchase_item-rcgst.
          sgst        = wa_purchase_item-rsgst.
        ENDIF.

        IF wa_purchase-taxcode = 'AN'.

          igst        = wa_purchase_item-igst * 0.
          cgst        = wa_purchase_item-cgst * 0.
          sgst        = wa_purchase_item-sgst * 0.

        ENDIF.


        qty         = wa_purchase_item-porderquantity.

        IF wa_purchase_item-hsncode IS NOT INITIAL.
          itemdesc = wa_purchase_item-materialdescription.
        ELSE.
          itemdesc = wa_purchase_item-narration.
        ENDIF.

**Start by Krishna 23/09/24
        IF wa_purchase_item-hsncode IS NOT INITIAL.

          DATA(lv_length) = strlen( wa_purchase_item-hsncode ).

          IF wa_purchase_item-hsncode CA 'T'.
            DATA(lv_position) = sy-fdpos + 1.
            IF lv_length = lv_position.
              lv_length = lv_length - 1.
              wa_purchase_item-hsncode =  wa_purchase_item-hsncode+0(lv_length).
            ENDIF.
          ENDIF.
        ENDIF.
**End by Krishna 23/09/24

        IF wa_purchase_item-cgst_per IS NOT INITIAL AND wa_purchase_item-sgst_per IS NOT INITIAL.
          gst_rate  = wa_purchase_item-cgst_per + wa_purchase_item-sgst_per.
          gst_rate1 = gst_rate.
        ELSEIF wa_purchase_item-igst_per IS NOT INITIAL.
          gst_rate  = wa_purchase_item-igst_per.
          gst_rate1 = gst_rate.
        ELSEIF wa_purchase_item-rcgst_per IS NOT INITIAL AND wa_purchase_item-rsgst_per IS NOT INITIAL.
          CLEAR : GST_RATE, GST_RATE1.
          gst_rate  = wa_purchase_item-rcgst_per + wa_purchase_item-rsgst_per.
          gst_rate1 = gst_rate.
        ELSEIF wa_purchase_item-Rigst_per IS NOT INITIAL.
          CLEAR : GST_RATE, GST_RATE1.
          gst_rate  = wa_purchase_item-Rigst_per.
          gst_rate1 = gst_rate.
        ENDIF.
       DATA  RATE TYPE N LENGTH 2 .
       if  wa_purchase_item-taxcode = 'IS' .

       RATE =  ( wa_purchase_item-TotaltaxAmount /  wa_purchase_item-BaseAmount  ) * 100 .

       gst_rate1 =  RATE .

       shift gst_rate1 LEFT DELETING LEADING '0' .

       ELSE .


       ENDIF .



        cess = '0.00'.
        itc_elgibity = 'Y'.
    IF wa_purchase_item-hsncode+0(2) = '99' .
    itc_elgibity = 'IS'.
    ELSEIF wa_purchase_item-GL_Code = '61005000'  .
    itc_elgibity = 'CP'.
    ELSE  .
     itc_elgibity = 'IP'.
    ENDIF .









        CONCATENATE : lv_post '{'
                                        ' "igst_amount":' igst  ','
                                        ' "cgst_amount":' cgst  ','
                                        ' "sgst_amount":' sgst  ','
                                        ' "taxable_value":' tot_tax_val ','
                                        ' "hsn_code":' '"' wa_purchase_item-hsncode '"' ','
                                        ' "product_name":' '"' lv_space '"' ','
*                                    ' "item_description":' '"' wa_purchase-materialdescription '"' ','
                                        ' "item_description":' '"' itemdesc '"' ','
                                        ' "quantity":' qty ','
                                        ' "cess_amount":' cess ','
                                        ' "gst_rate":' gst_rate1 ','
                                        ' "unit_of_product":' '"' uom '"' ','
                                        ' "itc_elgibity":' '"' itc_elgibity '"'
                                         '}' INTO lv_post. " SEPARATED BY ' '.

        CLEAR : wa_purchase_item,igst,cgst,sgst,qty,gst_rate1, cess, itc_elgibity,RATE.
*if lv_lines < sy-index.
*EXIT.
*ENDIF.
      ENDLOOP.

      CLEAR : gstr2_ret, period.
      CONCATENATE : lv_post   ']' INTO lv_post SEPARATED BY ' '.
      CONCATENATE : lv_post   '}' INTO lv_post SEPARATED BY ' '.

      CONCATENATE : lv_post   ']' INTO lv_post SEPARATED BY ' '.
      CONCATENATE : lv_post   '}' INTO lv_post SEPARATED BY ' '.
*    clear : wa_purchase_item,igst,cgst,sgst,qty,gst_rate1.
*    endloop.
*    CONDENSE lv_post NO-GAPS.
*    DELETE ADJACENT DUPLICATES FROM it_purchase_ml COMPARING DocumentReferenceID ReferenceDocumentMIRO.
      lv_json = lv_post.

      wa_create-referencedocumentmiro = wa_purchase-referencedocumentmiro.
      wa_create-referencedocumentitem = wa_purchase-accountingdocument.
      wa_create-fiscalyear            = wa_purchase-fiscalyear.
      wa_create-purchasingdocument    = wa_purchase-purchasingdocument."''.
      wa_create-accountingdocument    = wa_purchase-accountingdocument."''.
      wa_create-ref_doc               = wa_purchase-refdocno.
*     wa_create-vendor                = wa_purchase-Vendor.
      MODIFY zgstr2_st FROM @wa_create.

      IF wa_purchase IS NOT INITIAL.
        TRY.
            DATA lv_url TYPE string.
            " CONCATENATE base_url 'saas-apis/sales/' INTO lv_url.
            " CONCATENATE base_url 'saas-apis/purchase/' INTO lv_url.
            lv_url = 'https://api-platform.mastersindia.co/api/v1/saas-apis/purchase/'.
            lv_res_token = get_auth_token( ).
            SPLIT lv_res_token AT ':' INTO string1 string2.
            CLEAR lv_res_token.
            lv_res_token = string2.
            REPLACE ALL OCCURRENCES OF '"' IN lv_res_token WITH ' '.
            REPLACE ALL OCCURRENCES OF '}' IN lv_res_token WITH ' '.
            CONDENSE lv_res_token NO-GAPS.
            "CONCATENATE 'JWT' '' lv_res_token INTO lv_res_token.
            TRY.
                DATA(client) = create_client( lv_url ).
              CATCH cx_static_check.
            ENDTRY.
            DATA(req) = client->get_http_request(  ).
            " req->set_header_field( i_name = content_type i_value = json_content ).
            req->set_header_fields(  VALUE #(
            ( name = 'Content-Type' value  = 'application/json' )
            ( name = 'productid' value     = 'enterprises' )
            ( name = 'Authorization' value = |JWT { lv_res_token }| ) ) ).
            " req->set_text( lv_json ).
            req->append_text(
            EXPORTING
            data = lv_json ).
            " req->set_header_field( i_name = 'Authorization' i_value = |JWT { lv_res_token }| ).
            TRY.
                " DATA(lv_response) = client->execute( if_web_http_client=>post )."->get_text(  ).
                DATA(lv_response) = client->execute(
                                i_method  = if_web_http_client=>post ).
                DATA(json_response) = lv_response->get_text( ).
                DATA(stat) = lv_response->get_status(  ).
                client->close( ). "(+)by Anurag on 14.07.2024
              CATCH: cx_web_http_client_error.
            ENDTRY.
          CATCH cx_static_check. "(+)by Anurag on 14.07.2024
        ENDTRY.
      ENDIF.

*    "response store dd

      IF stat-code = '200'.

        /ui2/cl_json=>deserialize(
     EXPORTING
     json = json_response
     CHANGING
     data = ls_output ).
        lt_head = ls_output-result-purchase_error_data.

        IF ls_output-result-failure_count = '1'.
          SPLIT json_response AT 'error' INTO str1 str2.
          SPLIT str2 AT 'error' INTO str3 str4.
          REPLACE ALL OCCURRENCES OF '"' IN str4 WITH ''.
          REPLACE ALL OCCURRENCES OF '{' IN str4 WITH ''.
          REPLACE ALL OCCURRENCES OF '}' IN str4 WITH ''.
          REPLACE ALL OCCURRENCES OF '[' IN str4 WITH ''.
          REPLACE ALL OCCURRENCES OF ']' IN str4 WITH ''.
          SPLIT str4 AT ':' INTO str5 str6.
          SPLIT str6 AT ':' INTO str7 str8.
          SPLIT str8 AT 'values' INTO str9 str10.
          SPLIT str9 AT ',' INTO str11 str12.


          SELECT SINGLE * FROM zgstr2_st WHERE referencedocumentmiro = @wa_create-referencedocumentmiro
          AND ref_doc = @wa_create-ref_doc
          INTO @DATA(wa_zgstr2_st).
          IF wa_zgstr2_st IS NOT INITIAL.
            wa_zgstr2_st-status = str11.
            MODIFY zgstr2_st FROM @wa_zgstr2_st.
          ENDIF.
        ENDIF.
*    "response store dd

        " out->write( lv_response ).
        " CATCH cx_root INTO DATA(exc).
        "  out->write( exc->get_text(  ) ).
        " ENDTRY.
        "  endif.

        IF ls_output-result-success_count = '1'.
          SELECT SINGLE * FROM zgstr2_st WHERE referencedocumentmiro = @wa_create-referencedocumentmiro
          AND ref_doc = @wa_create-ref_doc
          INTO @DATA(wa_zgstr2_status).
          IF wa_zgstr2_status IS NOT INITIAL.
            wa_zgstr2_status-status = 'Data Posted Successfully'.
            MODIFY zgstr2_st FROM @wa_zgstr2_status.
          ENDIF.
        ENDIF.


        DATA(lv_message) = me->new_message(
                         id = 'ZGSTR1_MESSAGE'
                         number = '001'
                         severity = ms-success
                         v1       = str11 ).
        DATA ls_record LIKE LINE OF reported-zi_send_gstr1_data_mi.
        ls_record-%msg = lv_message.
        ls_record-%element-referencedocumentmiro = if_abap_behv=>mk-on.
        "  ls_record-%element- = if_abap_behv=>mk-on.
        APPEND ls_record TO reported-zi_send_gstr1_data_mi.

      ENDIF..
      "ENDLOOP.
      "ENDLOOP.
      CLEAR : wa_purchase, wa_keys_ml, wa_keys_ml, wa_zgstr2_st, wa_zgstr2_status, lv_post, lv_json, wa_create,
              lv_res_token, lv_response, json_response, stat, ls_output, lt_head, str1, str2, str3, str4, str5,
              str6, str7, str8, str9, str10, str11, str12, ls_record, lv_message.

    ENDLOOP.
    endif .
  ENDMETHOD.


  "MICHAEL

  METHOD create_client.

    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD.

  METHOD get_auth_token.

    ls_config-uname = 'rahul.bagul@reliableautotech.com'.
*    ls_config-password = 'Reli@123456789'.
    "data(dest) = cl_http_destination_provider=>create_by_url( url ).
    "DATA(result) = cl_web_http_client_manager=>create_by_http_destination( dest ).
    DATA url TYPE string.
    CONCATENATE base_url 'token-auth/' INTO url.
    CONDENSE url NO-GAPS.


    lv_token = '{"password":"Reli@123456789","username":"rahul.bagul@reliableautotech.com"}'.

    " DATA(req) = result->get_http_request( ).
    TRY.
        DATA(client) = create_client( url ).
      CATCH cx_static_check.
    ENDTRY.
    DATA(req) = client->get_http_request(  ).
    req->set_text( lv_token ).
    req->set_header_field( i_name = content_type i_value = json_content ).
    TRY.
        lv_authtoken = client->execute( if_web_http_client=>post )->get_text(  ).
        client->close(  ). "(+)by Anurag on 14.07.2024
      CATCH cx_static_check.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_send_gstr1_data_mi DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_send_gstr1_data_mi IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
