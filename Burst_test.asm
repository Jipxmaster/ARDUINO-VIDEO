#define __SFR_OFFSET 0x00
#include "avr/io.h"

.global start
.global burst

start:
  NOP;
  SBI DDRB, 0;              // 125
  SBI DDRB, 1;

burst:
  CLI;                        // 62.5
  LDI R20, 250;               // 62.5   A = 5
  CALL short_sync;            // 250
  LDI R20, 251;               // 62.5   A = 5
  CALL long_sync;             // 250
  LDI R20, 251;               // 62.5   A = 5
  CALL short_sync;            // 250
  LDI R20, 0;                 // 62.5
  CALL fotograma;             // 250
  LDI R20, 208;               // 62.5
  CALL fotograma;             // 250
  JMP burst;                  // 125

//-------------------------- SINCRONISMO CORTO, DEJA 5 CICLOS DE RELOJ
short_sync:                 // time = 437.5
  CBI PORTB, 0;             // 125
  CBI PORTB, 1;             // 125
  LDI R21, 250;             // 62.5 B = 250
  LDI R22, 1;               // C = 1
  NOP;
  
short_sync_1:               // (6-1)*250 + 312.5 = 1562.5
  ADD R21, R22;             // 62.5
  NOP
  BRCC short_sync_1;        // 125 if branch, else: 62.5
  NOP;                      // 62.5
  NOP;
//--------------------------
short_sync_2:               // time = 187.5
  SBI PORTB, 0;             // 125
  LDI R21, 140;              // B = 140

short_sync_3:               // time = (116-1)*250 + 312.5 = 28875
  ADD R21, R22;             // 62.5
  NOP;
  BRCC short_sync_3;        // 125 if branch, else: 62.5
  NOP;                      // 62.5
  NOP;

short_sync_4:               // time = 937.5 if branch: 187.5
  ADD R20, R22;             // 62.5
  BRCS short_sync_5;        // 125 if branch, else: 62.5
  NOP;
  NOP;
  NOP;
  NOP;
  NOP;
  NOP;
  NOP;
  NOP;
  RJMP short_sync;          // 125
// Retorno
short_sync_5:
  RET;                      // 250

// 750 if not branch, else: 437.5

//-------------------------- SINCRONISMO LARGO, DEJA 5 CICLOS DE RELOJ
long_sync:               // time = 375
  CBI PORTB, 0;             // 125
  CBI PORTB, 1;             // 125
  LDI R22, 1;               // 62.5 C = 1
  LDI R21, 138;              // 62.5 B = 100

long_sync_1:               // time = (118-1)*250 + 375 = 29625
  ADD R21, R22;             // 62.5
  NOP;
  BRCC long_sync_1;        // 125 if branch, else: 62.5
  NOP;
  NOP;
  NOP;
  
//--------------------------
long_sync_2:                 // time = 250
  SBI PORTB, 0;             // 125
  LDI R21, 252;             // B = 252
  NOP;
  
long_sync_3:               // (4 - 1) * 250 + 250
  ADD R21, R22;             // 62.5
  NOP;
  BRCC long_sync_3;        // 125 if branch, else: 62.5
  NOP;
  
// ------------------------- 1250
long_sync_4:               //
  ADD R20, R22;             // 62.5
  BRCS long_sync_5;         // 125 if branch, else: 62.5
  NOP;
  NOP;
  NOP;
  NOP;
  NOP;
  NOP;
  NOP;
  NOP;
  RJMP long_sync;           // 125
// Retorno
long_sync_5:
  RET;                      // 250

// 750 if not branch, else: 437.5


//----------------------------- FOTOGRAMA, DEJA 5 CICLOS DE RELOJ
fotograma:
  CBI PORTB, 0;           // 125
  CBI PORTB, 1;           // 125
  LDI R22, 1;             // 62.5
  LDI R21, 242;           // 62.5

fotograma_1:        // (14 - 1) * 250 + 375 = 3625
  ADD R21, R22;
  NOP;
  BRCC fotograma_1;
  NOP;
  NOP;
  NOP;

fotograma_2:
  SBI PORTB, 0;           // 125
  LDI R21, 225;           // 62.5

fotograma_3:        // (31 - 1) * 250 + 312.5 = 7812.5
  ADD R21, R22;
  NOP;
  BRCC fotograma_3;
  NOP;
  NOP;

fotograma_4:
  SBI PORTB, 1;           // 125
  CBI PORTB, 0;           // 125
  LDI R21, 52;            // 62.5

fotograma_5:      // (204-1) * 250 + 187.5 = 50937.5
  ADD R21, R22;
  NOP;
  BRCC fotograma_5;

fotograma_6:
  ADD R20, R22;             // 62.5
  BRCS fotograma_7;         // 125 if branch, else: 62.5
  NOP;
  NOP;
  NOP;
  NOP;
  NOP;
  NOP;
  NOP;
  NOP;
  RJMP fotograma;           // 125

fotograma_7:
  RET;                    // 250

// 750 if not branch, else: 437.5
