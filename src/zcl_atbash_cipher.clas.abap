CLASS zcl_atbash_cipher DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      constructor,
      decode
        IMPORTING
          cipher_text       TYPE string
        RETURNING
          VALUE(plain_text) TYPE string,
      encode
        IMPORTING
          plain_text         TYPE string
        RETURNING
          VALUE(cipher_text) TYPE string.

  PRIVATE SECTION.
    DATA:
      abcde_table TYPE SORTED TABLE OF c WITH UNIQUE KEY table_line,
      numbers     TYPE string.

ENDCLASS.

CLASS zcl_atbash_cipher IMPLEMENTATION.

  METHOD constructor.
    DATA offset TYPE i.
    DATA(l_abcde) = to_lower( sy-abcde ).
    DO strlen( sy-abcde ) TIMES.
      offset = sy-index - 1.
      INSERT l_abcde+offset(1) INTO TABLE abcde_table.
    ENDDO.
    numbers = `0123456789`.
    BREAK-POINT.
  ENDMETHOD.

  METHOD decode.
    DATA:
      lines  TYPE i,
      offset TYPE i,
      ch     TYPE c,
      index  TYPE i.

    lines = lines( abcde_table ).

    DO strlen( cipher_text ) TIMES.
      offset = sy-index - 1.
      ch = cipher_text+offset(1).

      index = line_index( abcde_table[ table_line = ch ] ).
      IF index <> 0.
        plain_text = plain_text && abcde_table[ lines - index + 1 ].
        CONTINUE.
      ENDIF.

      IF numbers CA ch.
        plain_text = plain_text && ch.
      ENDIF.
    ENDDO.

  ENDMETHOD.

  METHOD encode.
    DATA:
      lines   TYPE i,
      counter TYPE i,
      offset  TYPE i,
      ch      TYPE c,
      index   TYPE i.

    lines = lines( abcde_table ).

    DO strlen( plain_text ) TIMES.
      offset = sy-index - 1.
      ch = to_lower( plain_text+offset(1) ).

      index = line_index( abcde_table[ table_line = ch ] ).
      IF index <> 0.
        IF counter = 5.
          cipher_text = cipher_text && ` `.
          counter = 0.
        ENDIF.
        cipher_text = cipher_text && abcde_table[ lines - index + 1 ].
        counter += 1.
      ENDIF.

      IF numbers CA ch.
        IF counter = 5.
          cipher_text = cipher_text && ` `.
          counter = 0.
        ENDIF.
        cipher_text = cipher_text && ch.
        counter += 1.
      ENDIF.

    ENDDO.

  ENDMETHOD.

ENDCLASS.