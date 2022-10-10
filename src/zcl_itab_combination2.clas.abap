CLASS zcl_itab_combination2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF alphatab_type,
             cola TYPE string,
             colb TYPE string,
             colc TYPE string,
           END OF alphatab_type.
    TYPES alphas TYPE STANDARD TABLE OF alphatab_type.

    TYPES: BEGIN OF numtab_type,
             col1 TYPE string,
             col2 TYPE string,
             col3 TYPE string,
           END OF numtab_type.
    TYPES nums TYPE STANDARD TABLE OF numtab_type.

    TYPES: BEGIN OF combined_data_type,
             colx TYPE string,
             coly TYPE string,
             colz TYPE string,
           END OF combined_data_type.
    TYPES combined_data TYPE STANDARD TABLE OF combined_data_type WITH EMPTY KEY.

    METHODS perform_combination
      IMPORTING
        alphas               TYPE alphas
        nums                 TYPE nums
      RETURNING
        VALUE(combined_data) TYPE combined_data.

  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS zcl_itab_combination2 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ITAB_COMBINATION->PERFORM_COMBINATION
* +-------------------------------------------------------------------------------------------------+
* | [--->] ALPHAS                         TYPE        ALPHAS
* | [--->] NUMS                           TYPE        NUMS
* | [<-()] COMBINED_DATA                  TYPE        COMBINED_DATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD perform_combination.

    DATA(ls_cola) = VALUE #( alphas[ 1 ] OPTIONAL ).
    DATA(ls_col1) = VALUE #( nums[ 1 ] OPTIONAL ).
    IF ls_cola IS NOT INITIAL AND ls_col1 IS NOT INITIAL.
      APPEND VALUE #( colx = ls_cola-cola && ls_col1-col1
                      coly = ls_cola-colb && ls_col1-col2
                      colz = ls_cola-colc && ls_col1-col3 ) TO combined_data.
    ENDIF.

    ls_cola = VALUE #( alphas[ 2 ] OPTIONAL ).
    ls_col1 = VALUE #( nums[ 2 ] OPTIONAL ).
    IF ls_cola IS NOT INITIAL AND ls_col1 IS NOT INITIAL.
      APPEND VALUE #( colx = ls_cola-cola && ls_col1-col1
                      coly = ls_cola-colb && ls_col1-col2
                      colz = ls_cola-colc && ls_col1-col3 ) TO combined_data.
    ENDIF.

    ls_cola = VALUE #( alphas[ 3 ] OPTIONAL ).
    ls_col1 = VALUE #( nums[ 3 ] OPTIONAL ).
    IF ls_cola IS NOT INITIAL AND ls_col1 IS NOT INITIAL.
      APPEND VALUE #( colx = ls_cola-cola && ls_col1-col1
                      coly = ls_cola-colb && ls_col1-col2
                      colz = ls_cola-colc && ls_col1-col3 ) TO combined_data.
    ENDIF.

  ENDMETHOD.
ENDCLASS.