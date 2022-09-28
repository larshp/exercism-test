CLASS zcl_atbash_cipher DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS decode
      IMPORTING
        cipher_text TYPE string
      RETURNING
        VALUE(plain_text)  TYPE string .

    METHODS encode
      IMPORTING
        plain_text        TYPE string
      RETURNING
        VALUE(cipher_text) TYPE string .

    METHODS constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA plain TYPE string VALUE 'abc'.
    DATA cipher TYPE string.
    METHODS translate
      IMPORTING
        original           TYPE string
      RETURNING
        VALUE(translation) TYPE string    .
ENDCLASS.



CLASS zcl_atbash_cipher IMPLEMENTATION.
  METHOD constructor.
    plain  = 'abcdefghijklmnopqrstuvwxyz0123456789'.
    cipher = 'zyxwvutsrqponmlkjihgfedcba0123456789'.
  ENDMETHOD.

  METHOD decode.
    DATA: lv_plain_idx  TYPE i VALUE -1,
          lv_cipher_idx TYPE i,
          lv_char(255),
          lv_blank(1) VALUE space.

    DO strlen( cipher_text ) TIMES.
      DATA(lv_idx) = sy-index - 1.
      lv_blank = cipher_text+lv_idx(1).
      IF lv_blank = space.
        CONTINUE.
      ELSE.
        FIND cipher_text+lv_idx(1) IN cipher MATCH OFFSET lv_cipher_idx.
        ADD 1 TO lv_plain_idx.
        IF sy-subrc = 0.
          lv_char+lv_plain_idx(1) = plain+lv_cipher_idx(1).
        ELSE.
          lv_char+lv_plain_idx(1) = cipher_text+lv_idx(1).
        ENDIF.
      ENDIF.
    ENDDO.
    plain_text = lv_char.
  ENDMETHOD.

  METHOD encode.
    DATA(plain_t) = replace( val = plain_text regex = '([[:punct:]])' with = ' ' occ = 0 ).
    CONDENSE plain_t NO-GAPS.
    plain_t = to_lower( plain_t ).
    DATA(cipher_string) = translate( plain_t ).
    cipher_text = condense( replace( val = cipher_string regex = '(.....)' with = `$1 ` occ = 0 ) ).
  ENDMETHOD.

  METHOD translate.
    translation = REDUCE string( INIT s TYPE string
                                  FOR r = 0 WHILE r < strlen( original )
                                  NEXT s = COND string(
                                    LET p = substring( val = original off = r len = 1 )
                                        l = find(  val = plain sub = p )
                                        c = substring( val = cipher off = l len = 1 )
                                        IN
                                        WHEN c NE '' THEN |{ s }{ c }|
                                        ELSE s
                                  )
        ).
  ENDMETHOD.
ENDCLASS.