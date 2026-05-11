*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


"=======================================================
" 1. Fiyatlandırma ve Vergi Servisi
"=======================================================
CLASS zcl_pricing_service DEFINITION.
  PUBLIC SECTION.

    METHODS calculate_total
      IMPORTING
        iv_qty        TYPE i
        iv_price      TYPE any
        iv_tax_rate   TYPE any
      RETURNING
        VALUE(rv_net) TYPE dmbtr.
ENDCLASS.

CLASS zcl_pricing_service IMPLEMENTATION.
  METHOD calculate_total.
    DATA(lv_subtotal) = iv_qty * iv_price.
    rv_net = lv_subtotal + ( lv_subtotal * iv_tax_rate ).
  ENDMETHOD.
ENDCLASS.


"=======================================================
" 2. E-Posta Gönderim Servisi
"=======================================================
CLASS zcl_mail_service DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS send_confirmation
      IMPORTING
        iv_customer TYPE string
        iv_order_id TYPE string
        iv_amount   TYPE dmbtr.
  PRIVATE SECTION.
    DATA mo_out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.

CLASS zcl_mail_service IMPLEMENTATION.
  METHOD constructor.
    mo_out = io_out.
  ENDMETHOD.

  METHOD send_confirmation.
    mo_out->write( |[MAIL] Alıcı: { iv_customer } | &&
                   |-> { iv_order_id } nolu siparişiniz alınmıştır. | &&
                   |Tutar: { iv_amount } TL| ).
  ENDMETHOD.
ENDCLASS.


"=======================================================
" 3. Sistem Günlükleme (Logger) Servisi
"=======================================================
CLASS zcl_logger_service DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS write_log
      IMPORTING
        iv_message TYPE string.
  PRIVATE SECTION.
    DATA mo_out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.

CLASS zcl_logger_service IMPLEMENTATION.
  METHOD constructor.
    mo_out = io_out.
  ENDMETHOD.

  METHOD write_log.
    mo_out->write( |[LOG - { cl_abap_context_info=>get_system_time( )  }] { iv_message }| ).
  ENDMETHOD.
ENDCLASS.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

CLASS zcl_order_management DEFINITION.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_order,
        order_id   TYPE string,
        customer   TYPE string,
        product    TYPE string,
        quantity   TYPE i,
        unit_price TYPE p LENGTH 8 DECIMALS 2,
        tax_rate   TYPE p LENGTH 3 DECIMALS 2,
      END OF ty_order.

    METHODS constructor
      IMPORTING
        io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS create_order
      IMPORTING
        is_order TYPE ty_order.

  PRIVATE SECTION.
    " KOMPOZİSYON: Sınıfın sahip olduğu alt parçalar
    DATA mo_pricing TYPE REF TO zcl_pricing_service.
    DATA mo_mailer  TYPE REF TO zcl_mail_service.
    DATA mo_logger  TYPE REF TO zcl_logger_service.

ENDCLASS.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
CLASS zcl_order_management IMPLEMENTATION.

  METHOD constructor.
    " Bu nesnelerin ömrü, zcl_order_management nesnesinin ömrü kadardır.
    mo_pricing = NEW #( ).
    mo_mailer  = NEW #( io_out = io_out ).
    mo_logger  = NEW #( io_out = io_out ).
  ENDMETHOD.

  METHOD create_order.
    " 1. Loglama
    mo_logger->write_log( |Sipariş oluşturma süreci başladı. ID: { is_order-order_id }| ).

    " 2. Fiyat hesaplama (Doğrudan kompozisyon nesnesini kullanıyoruz)
    DATA(lv_total_amount) = mo_pricing->calculate_total(
      iv_qty      = is_order-quantity
      iv_price    = is_order-unit_price
      iv_tax_rate = is_order-tax_rate ).

    mo_logger->write_log( |Hesaplanan Toplam Tutar (KDV Dahil): { lv_total_amount } TL| ).

    " 3. Müşteriye Mail Gönderimi
    mo_mailer->send_confirmation(
      iv_customer = is_order-customer
      iv_order_id = is_order-order_id
      iv_amount   = lv_total_amount ).

    mo_logger->write_log( |Sipariş başarıyla tamamlandı.| ).
  ENDMETHOD.

ENDCLASS.
