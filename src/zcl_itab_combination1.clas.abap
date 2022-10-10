CLASS zcl_itab_combination1 DEFINITION
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



CLASS zcl_itab_combination1 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ITAB_COMBINATION->PERFORM_COMBINATION
* +-------------------------------------------------------------------------------------------------+
* | [--->] ALPHAS                         TYPE        ALPHAS
* | [--->] NUMS                           TYPE        NUMS
* | [<-()] COMBINED_DATA                  TYPE        COMBINED_DATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD perform_combination.
    combined_data = VALUE combined_data(
      FOR ls_alpha IN alphas INDEX INTO lv_index
      FOR ls_num IN nums FROM lv_index TO lv_index
      LET ls_comb = VALUE combined_data_type(
      colx = |{ ls_alpha-cola }| & |{ ls_num-col1 }|
      coly = |{ ls_alpha-colb }| & |{ ls_num-col2 }|
      colz = |{ ls_alpha-colc }| & |{ ls_num-col3 }| )
      IN ( CORRESPONDING #( ls_comb ) ) ).
  ENDMETHOD.
ENDCLASS.