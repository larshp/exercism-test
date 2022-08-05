CLASS ltcl_itab_nesting DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_itab_nesting.
    METHODS setup.
    METHODS test_nesting FOR TESTING RAISING cx_static_check.
ENDCLASS.
CLASS ltcl_itab_nesting IMPLEMENTATION.

  METHOD setup.
    cut = NEW zcl_itab_nesting( ).
  ENDMETHOD.

  METHOD test_nesting.

    DATA(sdf) = VALUE zcl_itab_nesting=>nested_data(
                 ( artist_id   = '1'
                   artist_name = 'Godsmack'
                   albums      = VALUE #( (
                      album_id   = '1'
                      album_name = 'Faceless'
                      songs      = VALUE #( (
                        song_id   = '1'
                        song_name = 'Straight Out Of Line' ) ) ) ) ) ).

  ENDMETHOD.

ENDCLASS.