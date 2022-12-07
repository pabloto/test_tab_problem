**free
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  BndDir('AL400MNUV2')
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(RECAPTCHAT)
  Text('Verifica validità Recaptcha');
// __________________________________________________________________
//   Verifica validità Recaptcha
Dcl-Pr RECAPTCHA1 Extpgm('RECAPTCHA1');
  Rc          Int(10);
  RcMessage   VarChar(100);
  Token       VarChar(1000);
End-Pr RECAPTCHA1;

Dcl-S Rc          Int(10);
Dcl-S RcMessage   VarChar(100);
Dcl-S Token       VarChar(1000) Inz('03AGdBq260TMr3O0nOYp-xaoPleXu6ZUCybj95OIOFVdbWjZxvRAR3TrdURVKmn+
                    m6hAL7raVS-8vzx79w10MQZ7P_vH-rNld1C309GI5rIIHhKylyKerkf6dW2bBkqV4CJGs1DysoVmi-KT+
                    vaTyVfDTkWdhutjXRjL09B7cMuG9lnOmBJxau6rS3JK2z74a9gzqEaX12mgfxNPH-F310-HLNWOu96CB+
                    wlxSeP2c_2JY5XNswQA5nK6Oc_56hlLAczsRPRNQ-NKGUKO5GbXiA3Xka7KJcUzI1dnfPwva4ZHiXOKw+
                    nwXizFnu9cAQJq0xE1Gl4kX-SIiFQn8p1_Tk7pOAC_UI-lqQgGIFgHvhgRL07XPt56xjWwG8t56Y1M8L+
                    PRoya5A0ZPuBB9JlpBp3AOq-E6q2A_ITULgEL7AAbbY_bWxmnhUOr9sOp47r1eEBo4fh9UiWbdZnHtI');


RECAPTCHA1(Rc:RcMessage:Token);

Return;