== Project Aeolus == 


      ,-`{-`/
      ,-~ , \ {-~~-,
    ,~  ,   ,`,-~~-,`,
  ,`   ,   { {      } }                                             }/
 ;     ,--/`\ \    / /                                     }/      /,/
;  ,-./      \ \  { {  (                                  /,;    ,/ ,/
; /   `       } } `, `-`-.___                            / `,  ,/  `,/
 \|         ,`,`    `~.___,---}                         / ,`,,/  ,`,;
  `        { {                                     __  /  ,`/   ,`,;
        /   \ \                                 _,`, `{  `,{   `,`;`
       {     } }       /~\         .-:::-.     (--,   ;\ `,}  `,`;
       \\._./ /      /` , \      ,:::::::::,     `~;   \},/  `,`;     ,-=-
        `-..-`      /. `  .\_   ;:::::::::::;  __,{     `/  `,`;     {
                   / , ~ . ^ `~`\:::::::::::<<~>-,,`,    `-,  ``,_    }
                /~~ . `  . ~  , .`~~\:::::::;    _-~  ;__,        `,-`
       /`\    /~,  . ~ , '  `  ,  .` \::::;`   <<<~```   ``-,,__   ;
      /` .`\ /` .  ^  ,  ~  ,  . ` . ~\~                       \\, `,__
     / ` , ,`\.  ` ~  ,  ^ ,  `  ~ . . ``~~~`,                   `-`--, \
    / , ~ . ~ \ , ` .  ^  `  , . ^   .   , ` .`-,___,---,__            ``
  /` ` . ~ . ` `\ `  ~  ,  .  ,  `  ,  . ~  ^  ,  .  ~  , .`~---,___
/` . `  ,  . ~ , \  `  ~  ,  .  ^  ,  ~  .  `  ,  ~  .  ^  ,  ~  .  `-,

                                               - ASCCI Art by Daniel Hunt-
== 


Olypius micro is the 16-instruction Instruction Set Architecture used for our project.

Instruction Set List
+----------------+----------------+------------+
| Instruction ID |     Opcode     |  Pneumonic |
+----------------+----------------+------------+
|       0        |      0000      |    LDA     |
|       1        |      0001      |    LDB     |
|       2        |      0010      |    LDO     |
|       3        |      0011      |    LDS A   |
|       4        |      0100      |    LDS B   |
|       5        |      0101      |    LSH     |
|       6        |      0110      |    RSH     |
|       7        |      0111      |    CLR     |
|       8        |      1000      |    SNZ A   |
|       9        |      1001      |    SNZ B   |
|       10       |      1010      |    ADD     |
|       11       |      1101      |    SUB     |
|       12       |      1101      |    AND     |
|       13       |      1101      |    OR      |
|       14       |      1110      |    XOR     |
|       15       |      1111      |    INV     |
+----------------+----------------+------------+


Architectural State Elements

  A register =
  4-bit general purpose register, can be used as an ALU input.

  B register
  4-bit general purpose register, can be used as an ALU input.


  ACC(umulator) register
  O(utput) register
  Shift flag
  Overflow flag