
  {$DEFINE SP_DATASET}
  {$DEFINE SP_STREAM}
  
 {$UNDEF XE2UP}
 {$IFDEF DCC}
   {$IF CompilerVersion >= 24}
     {$DEFINE XE2UP}
   {$ENDIF}
 {$ENDIF}
