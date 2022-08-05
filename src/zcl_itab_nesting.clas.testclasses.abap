CLASS ltcl_itab_nesting DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_itab_nesting.

    TYPES: BEGIN OF song_nested_type,
             song_id   TYPE string,
             song_name TYPE string,
           END OF song_nested_type.
    TYPES: BEGIN OF album_song_nested_type,
             album_id   TYPE string,
             album_name TYPE string,
             songs      TYPE STANDARD TABLE OF song_nested_type WITH KEY song_id,
           END OF album_song_nested_type.
    TYPES: BEGIN OF artist_album_nested_type,
             artist_id   TYPE string,
             artist_name TYPE string,
             albums      TYPE STANDARD TABLE OF album_song_nested_type WITH KEY album_id,
           END OF artist_album_nested_type.
    TYPES nested_data TYPE STANDARD TABLE OF artist_album_nested_type WITH KEY artist_id.

    METHODS setup.
    METHODS test_nesting FOR TESTING RAISING cx_static_check.
ENDCLASS.
CLASS ltcl_itab_nesting IMPLEMENTATION.

  METHOD setup.
    cut = NEW zcl_itab_nesting( ).
  ENDMETHOD.

  METHOD test_nesting.

    cut->perform_nesting( ).

  ENDMETHOD.

ENDCLASS.