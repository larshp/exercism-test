CLASS zcl_itab_combination DEFINITION
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



CLASS zcl_itab_combination IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ITAB_COMBINATION->PERFORM_COMBINATION
* +-------------------------------------------------------------------------------------------------+
* | [--->] ALPHAS                         TYPE        ALPHAS
* | [--->] NUMS                           TYPE        NUMS
* | [<-()] COMBINED_DATA                  TYPE        COMBINED_DATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD perform_combination.
    combined_data[] = alphas[].
    LOOP AT combined_data ASSIGNING FIELD-SYMBOL(<fs_comb>).
      DATA(lv_index) = sy-tabix.
      <fs_comb>-colx = |{ <fs_comb>-colx }{ nums[ lv_index ]-col1 }|.
      <fs_comb>-coly = |{ <fs_comb>-coly }{ nums[ lv_index ]-col2 }|.
      <fs_comb>-colz = |{ <fs_comb>-colz }{ nums[ lv_index ]-col3 }|.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.