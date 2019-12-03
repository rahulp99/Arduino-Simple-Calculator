.include "./m328Pdef.inc"
start: ldi r16, 0b11100011
       out DDRD, r16 
       ldi r16, 0b11111111
       out DDRB, r16
       ldi r16, 0b11111111
       out DDRC, r16
       ldi r18, 0b00000100
       ldi r19, 0b00001000
       ldi r20, 0b00010000
       ldi r26, 0x00
       mov r4, r26

input:  in r17, PIND
        call delay_ms
        and r17, r18
        breq input
        call glow
        ldi r22, 0x00
        ldi r23, 0x00
        ldi r24, 0x00

input1: call delay
        in r21, PIND
        call delay_ms
        and r21, r18
        brne input2
num1:   in r17, PIND
        call delay_ms
        and r17, r19
        breq num1
        call glow
        inc r22
        rjmp input1

input2: call glow
input2a:call delay 
        in r21, PIND
        call delay_ms
        and r21, r18
        brne operator
num2:   in r17, PIND
        call delay_ms
        and r17, r19
        breq num2
        call glow
        inc r23
        rjmp input2a

operator: call glow
operatora:  call delay    
            in r21, PIND
                call delay_ms
          and r21, r18
          brne calculate
oper:     in r17, PIND
                call delay_ms
          and r17, r20
          breq oper
          call glow
          inc r24
          rjmp operatora

calculate: call glow
           subi r24, 0x01
           breq addition
           rjmp multiply

addition: add r22, r23
          rjmp check
multiply: mul r22, r23
          mov r22, r0
          rjmp check

check:  cpi r22, 0x0A
        brlt display
        subi r22, 0x0A
        inc r26
        rjmp check

delay:  ldi r27,0xFF
        ldi r28,0x3F
        ldi r29,0x30
in:     subi r27,0x01
        sbci r28,0x00
        sbci r29,0x00
        brne in
        ret

delay_ms:
	ldi r27, 255
	ldi r28, 211
	ldi r29, 5

	inner1:
		subi r27,1
		sbci r28,0
		sbci r29,0
		brne inner1
	ret

glow:
        out PORTD, r16
        call delay_ms
        out PORTD, r26
        ret

display:
	add r22, r4
	breq glow1
	again:
		ldi r16, 0b00100000
		out PORTD, r16
		call delay
		out PORTD, r4
		call delay
		dec r22
		brne again
	glow1:
		add r26, r4
		breq exit_loop
		again1:
			ldi r16, 0b01000000
			out PORTD, r16
			call delay
			out PORTD, r4
			call delay
			dec r26
			brne again1

	exit_loop:
		rjmp start