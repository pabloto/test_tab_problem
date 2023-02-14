**FREE

///
// APPERRC template
// Used for error capturing
///

Exec Sql
  Set Option Datfmt = *Iso, Timfmt = *Iso, Closqlcsr = *EndMod, Commit = *none;

Exec Sql 
  update testupdate
  set ostpc = 'TEST'
  where ococl = '20470' and otito  = 'FCT';

Exec Sql 
  update testupdate
  set ostpc = 'POSTTEST'
  where ococl = '20470' and otito  = 'FCT';

snd-msg 'test';



Return;