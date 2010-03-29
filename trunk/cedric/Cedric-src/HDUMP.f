      SUBROUTINE HDUMP(MAX,IUN)
C
C        DUMPS VITAL DATA AT END OF HISTOGRAM (OR END OF SCREEN)
C
      CHARACTER KINT*20,KPER*8,KCENT*8,KENCD*5,LINE*129,IBL*1,ILAB*5
      DATA KINT,KPER,KCENT/'     INTERVALS      ','     PER','   CENT '/
      DATA ILAB,IBL/'....+',' '/
      NAX=MAX
      INDEX=MAX0(1,(NAX-1)/5+1) * 5
C
C        GENERATE AND WRITE THE FIRST LINE  (TICK MARKS)
C
      LINE=IBL
      LINE(1:20)=KINT(1:20)
      DO 10 I=1,INDEX,5
         L=20+I
         LINE(L:L+4)=ILAB(1:5)
   10 CONTINUE
      LEND=20+INDEX
      LINE(LEND+1:LEND+8)=KPER(1:8)
      WRITE(IUN,101) LINE
  101 FORMAT(A)
C
C        GENERATE AND WRITE THE SECOND LINE  (LABELING)
C
      LINE=IBL
      DO 25 I=5,INDEX,5
         J=I
         L=17+I
         WRITE (KENCD,102)J
  102    FORMAT(I4,'%')
         LINE(L:L+4)=KENCD(1:5)
   25 CONTINUE
      LEND=21+INDEX
      LINE(LEND+1:LEND+7)=KCENT(1:7)
      WRITE(IUN,101) LINE
C
      RETURN
      END