CLASS zcl_clock DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        !hours   TYPE i
        !minutes TYPE i DEFAULT 0.
    METHODS get
      RETURNING
        VALUE(result) TYPE string.
    METHODS add
      IMPORTING
        !minutes TYPE i.
    METHODS sub
      IMPORTING
        !minutes TYPE i.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF type_s_time,
        hours   TYPE i,
        minutes TYPE i,
      END OF type_s_time.

    DATA _time TYPE i.

    METHODS:
      _convert_in
        IMPORTING
          is_time        TYPE type_s_time
        RETURNING
          VALUE(rv_time) TYPE i,
      _convert_out
        IMPORTING
          iv_time        TYPE i
        RETURNING
          VALUE(rs_time) TYPE type_s_time.

ENDCLASS.

CLASS zcl_clock IMPLEMENTATION.
  METHOD add.
    _time = _convert_in( VALUE #( minutes = _time + minutes ) ).
  ENDMETHOD.

  METHOD constructor.
    _time = _convert_in( VALUE #( hours   = hours
                                  minutes = minutes ) ).
  ENDMETHOD.

  METHOD get.
    DATA(ls_time) = _convert_out( _time ).
    result = |{ ls_time-hours PAD = '0' WIDTH = 2 ALIGN = RIGHT }:{ ls_time-minutes PAD = '0' WIDTH = 2 ALIGN = RIGHT }|.
  ENDMETHOD.

  METHOD sub.
    _time = _convert_in( VALUE #( minutes = _time - minutes ) ).
  ENDMETHOD.

  METHOD _convert_in.
    DATA(ls_time) = is_time.

    IF ls_time-hours < 0.
      ls_time-hours = 24 + frac( CONV decfloat34( ls_time-hours / 24 ) ) * 24.
    ENDIF.

    IF ls_time-minutes < 0.
      ls_time-minutes = 1440 + frac( CONV decfloat34( ls_time-minutes / 1440 ) ) * 1440.
    ENDIF.

    rv_time = CONV decfloat34( frac( ( ls_time-hours * 60 + ls_time-minutes ) / 1440 ) ) * 1440.
  ENDMETHOD.

  METHOD _convert_out.
    rs_time-hours   = trunc( CONV decfloat34( iv_time / 60 ) ).
    rs_time-minutes = CONV decfloat34( frac( iv_time / 60 ) ) * 60.
  ENDMETHOD.
ENDCLASS.