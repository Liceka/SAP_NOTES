*&---------------------------------------------------------------------*
*                               .,,,,,,,,,,,,
*                        ,;%%%%uuuuuuuuuuuuu%%%\
*                     /%%%%%uuuu====####uuuuuu%%%%
*                   /%%%%%uuuu.....===###uuuuu%%%%%%
*            , `````\%%%%%uuu....##.===##uuuu%%%%%%%%
*           ,````````)####\%u....../==#/uuu%%%%%%%%%%%
*           ,`````/#########\%mmmmmmmmmmmmm%%%%%%%%%%%;
*           #\``/##########(mmmmmmmmmmmmmmmmnu%%`%%%%%%%
*           ###############(mmmmmmmmmmmmmmmmmnuu%%`%%%%%%;
*           u\###########/ (mmmmmmmmmmmmmmmmmmnuu%%`%%%%%%%%
*          uuuuuEEE         \mmmmmmmmmmmmmmmmmnuuu%%`%%%%%%%%%
*          uuuuuEEE    .:::,#u,mmmmnnmmmmmmmmmnuuu%%;; %%%%%%%%%
*           uuuuuu\##\:::::##uuummmmmmmmmmmmmmnuu%%;;;; :...%%%%%%
*              uuuuu\#######/uuuuuuuuuu,mmmmmmnu%%...;;;  ::...%%%%
*                 \uuuuuuuuuuuuuuuuuuuuuuuu,mmnu/ \...;;;   ::...%%%
*                   >####&&################<%%%%    \;;;/    ::...%%%
*               (#####&&&################%%%%%%%              ::..%%%
*           (######&&&&##############(%%%%%%%%%%                ::%/
*          (####&&&&&&#############(%%%%%%%%%%%%%
*        (#######&&&&&############(%%%%%%%%%%%%%%%%
*       (#########################(%%%%%%%%%%%%%%%%%%
*       (# (######################(%%%%%%%%%%%%%%%%%%%%
*          (#######################(%%%%%%%%%%%%%%%%%%%%%
*         %%%(#####################(%%%%%%%%%%%%%%%%%%%%%%%
*        %%%%%%(####################(%%%%%%%%%%%%%%%%%%%%%%%
*       ;%%%%%%; (#################n`%%%%%%%%`%%%%%%%%%%%%%%%
*      (%%%%%%%(  ;%nn############nn`%%%%%%%%`%%%%%%%%%%%%%%%%
*       ;%%%%%%%  %%%nnnnnnnnnnnnn`%%%%%%%%%`%%%%%%%%%%%%%%%%%%(@@@)
*        \%%%%%;  %%%%nnnnnnnn`%%%%%%%%%`%%`n%%%%%%%%%%%%%%%%%(@@@@@)
*         (%(%/   %%%%%nnnnnn`%%%%%%%%%%%`nnnn%%%%%%%%%%%%%%%%(@@@@@@
*                %%%%%%nnnnnn`%%%%%%%%`nnnnnnnn%%%%%%%%%%%%%%(@@@@@@@
*               %%%%%%%nnnnnnn(%(%)nnnnnnnnnnnn%%%%%%%%%%%%%(@@@@@@@)
*           .,;%%%%%%%%nnnnnnnnnnnnnnnnnnnnnnn%%%%%%%%%%%%%(@@@@@@@@
*    ,nnnnnnn%%%%%%%%%nnnnnn)nnnnnnnnnnnnnnn%%%%%%%%%%%%%%(@@@@@@@)
* /nnnnnnnnnnn%%%%%%nnnnnnnnnnn)nnnnnnnnn%%%%%%%%%%%%%%%/  (@@@@)
*(uu(uuuuuuuuuuuuuuuuuuuuuuuuuuu/   (uu;;;;;;;;;;;uu)
*                                    (uu;;;;;;;;;;uu)
*                                     (uuuuuuuuuuuuu)
*                                       (uu)(uu)(uu)
*
*&---------------------------------------------------------------------*
*& REPORT                : Z_SMART_LBA
*& VERSION               : 1.00
*& AUTHOR                : EH7MM61  -  EH7MM61
*& FUNCTION / DEPARTMENT :  /
*&---------------------------------------------------------------------*
*& CREATION DATE         : 2023.06.22
*& PURPOSE               :
*&---------------------------------------------------------------------*
*& CORRECTION ON VERSION : 1.00
*& NEW VERSION           : 1.01
*& AUTHOR                :
*& DATE                  :
*& REASON                :
*& CHANGE                :
*&---------------------------------------------------------------------*
*& HISTORY
*&---------------------------------------------------------------------*

REPORT z_smartmail_lba.

INCLUDE Z_SMARTMAIL_LBA_TOP.
*INCLUDE z_smart_lba_top.
INCLUDE Z_SMARTMAIL_LBA_SCR.
*INCLUDE z_smart_lba_scr.
INCLUDE Z_SMARTMAIL_LBA_F01.
*INCLUDE z_smart_lba_f01.

INITIALIZATION.

PERFORM data_initialization.

START-OF-SELECTION.



END-OF-SELECTION.