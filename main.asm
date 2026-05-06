.org 0

ldi r16, (1<<REFS0)       ; AVCC reference
out ADMUX, r16

ldi r16, (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1) ; ADC enable + prescaler 64
out ADCSRA, r16

ldi r16, 0xFF
out DDRC, r16            ; PORTC output (LED)


; MAIN LOOP

MAIN:
    sbi ADCSRA, ADSC     ; start conversion

WAIT:
    sbis ADCSRA, ADIF    ; wait until done
    rjmp WAIT

    in r18, ADCL         ; read low byte
    in r19, ADCH         ; read high byte

    sbi ADCSRA, ADIF     ; clear flag

    ; Compare threshold (example: 300)
    ldi r20, low(300)
    ldi r21, high(300)

    cp r18, r20
    cpc r19, r21

    brlo DARK            ; if less ? dark

LIGHT:
    cbi PORTC, 0         ; LED OFF
    rjmp MAIN

DARK:
    sbi PORTC, 0         ; LED ON
    rjmp MAIN