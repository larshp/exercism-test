CLASS zcl_secret_handshake DEFINITION PUBLIC FINAL.
  PUBLIC SECTION.
    TYPES: number TYPE c LENGTH 5.

    TYPES: BEGIN OF tty_actions,
         number     TYPE number,
         action     TYPE string,
       END OF tty_actions.

    DATA actions TYPE STANDARD TABLE OF tty_actions.
    DATA secrets TYPE string_table.

    METHODS get_commands
      IMPORTING
        code            TYPE i
      RETURNING
        VALUE(commands) TYPE string_table.
  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS convert_to_base_2
      IMPORTING
        number TYPE i
      RETURNING
        VALUE(result) TYPE number.
ENDCLASS.

CLASS zcl_secret_handshake IMPLEMENTATION.
  METHOD get_commands.
      DATA action_number TYPE number.
    IF code BETWEEN 1 AND 31.
************************************************************
* Create list of actions
************************************************************
      actions = VALUE #(
        ( number = '00001' action = `wink` )
        ( number = '00010' action = `double blink` )
        ( number = '00100' action = `close your eyes` )
        ( number = '01000' action = `jump` )
        ( number = '10000' action = `reverse` )  ).

      DATA(final_number)  = convert_to_base_2( code ).

************************************************************
* List actions from left to right based on final number
************************************************************
      
      DATA(position)     = 4.

      LOOP AT actions ASSIGNING FIELD-SYMBOL(<action>).
        action_number = <action>-number.
        IF action_number+position(1) = final_number+position(1)
            AND final_number+position(1) = 1.
          APPEND <action>-action TO secrets.
        ENDIF.
        position = position - 1.
      ENDLOOP.

************************************************************
* Check for reversal
************************************************************
      DATA(table_lines) = lines( secrets ).

      FIND FIRST OCCURRENCE OF `reverse` IN TABLE secrets.
      IF sy-subrc = 0.
        WHILE table_lines > 0.
          READ TABLE secrets ASSIGNING FIELD-SYMBOL(<secret>) INDEX table_lines.
          APPEND <secret> TO commands.
          table_lines = table_lines - 1.
        ENDWHILE.
        DELETE commands INDEX 1.  "First index will be the reverse line that shouldn't be used
      ELSE.
        commands = secrets.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD convert_to_base_2.
    DATA(remainder) = number.
    DATA(mod)       = 0.

************************************************************
* Divide the given number (in base 10) with 2 until the
* result finally left is less than 2.
************************************************************
    WHILE remainder > 1.
      mod = remainder MOD 2.
      remainder = floor( EXACT #( remainder / 2 ) ).
      result = mod && result.
    ENDWHILE.
    result = remainder && result.

************************************************************
* Complete 5 positions in the result - add leading zeros
************************************************************
    DATA(total_position) = 5 - strlen( result ).
    DO total_position TIMES.
      result = '0' && result.
    ENDDO.
  ENDMETHOD.
ENDCLASS.