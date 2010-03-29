      SUBROUTINE  STPLOT (ITIT,STATS,MAXAXIS,MAXST,NS,ISYMB,
     X                    AXLIM,LAB,IHOR)
C
C  AXLIM  MIN,MAX,DEL OF EACH AXIS.  1-STATS AND 2-FIXED AXIS
C  IHOR   HORIZONTAL AXIS.  1-STATS AND 2-FIXED AXIS
C  ISYMB  (0-NO,1-YES), (CHAR SYMBOL), (S,D,L, ), (CRT SIZE OF CHAR SYMBOL)
C  ITIT   TITLING
C  LAB     1-STATS AND 2-FIXED AXIS
C  NS     # VALUES
C  STATS  STATISTICS.
C           1.  MIN
C           2.  MEAN-STD DEV*SFACTOR
C           3.  MEAN
C           4.  MEAN+STD DEV*SFACTOR
C           5.  MAX
C           6.  # POINTS
C           7.  FIXED AXIS VALUE
C
      DIMENSION  AXLIM(2,2)
      DIMENSION  IDASH(3)
      DIMENSION  ISYMB(4,MAXST)
      CHARACTER*16 CFMTX, CFMTY
      CHARACTER*80 ITIT(3)
      CHARACTER*8 LAB(2),IFMTX(2),IFMTY(2)
      CHARACTER*8 LABEL(5)
      CHARACTER*1 CTEMP
      DIMENSION  STATS(MAXAXIS,MAXST)
C
      DATA  IDASH / 65535, 40167, 21845/
      DATA  LABEL(1) / 'MIN     '/
      DATA  LABEL(2) / 'SD-     '/
      DATA  LABEL(3) / 'AVE     '/
      DATA  LABEL(4) / 'SD+     '/
      DATA  LABEL(5) / 'MAX     '/
      DATA IBL / ' ' /
      DATA  XBEG /0.07/
      DATA  XEND /0.92/
      DATA  YBEG /0.07/
      DATA  YEND /0.92/
C
      FY(X1,Y1,X2,Y2,X)=(Y1*(X-X2)-Y2*(X-X1))/(X1-X2)

C
C     TURN OFF CLIPPING SO LABELS WILL BE PLOTTED
C
      CALL GSCLIP(0)

C
C  DETERMINE INDICES OF HORIZONTAL (X) AND VERTICAL (Y) AXES.
C
      IX=7
      IY=7
      IVER=3-IHOR

C
C  DRAW GRID.
C
      XMIN = AXLIM(1,IHOR)
      XMAX = AXLIM(2,IHOR)
      IF(XMAX .LT. XMIN) THEN
         T = XMAX
         XMAX = XMIN
         XMIN = T
      ENDIF
C
c      YMIN = AXLIM(1,IVER)
c      YMAX = AXLIM(2,IVER)
      YMIN = INT(AXLIM(1,IVER))
      YMAX = INT(AXLIM(2,IVER)+0.6)
      IF(YMAX .LT. YMIN) THEN
         T = YMAX
         YMAX = YMIN
         YMIN = T
      ENDIF
C
      CALL  MAJMIN (XMIN,XMAX-XMIN,IFMTX,MAJORX,MINORX,NDIG1,ISZ1,
     X              YMIN,YMAX-YMIN,IFMTY,MAJORY,MINORY,NDIG2,ISZ2)
C      CALL  MAJMIN (YMAX-YMIN,IFMTY,MAJORY,MINORY)
C
      CALL  SET (XBEG, XEND, YBEG, YEND,
     X           XMIN, XMAX, YMIN, YMAX, 1)
      WRITE (CFMTX,520)IFMTX
 520  FORMAT(2A8)
      WRITE (CFMTY,520)IFMTY

      CALL  LABMOD(CFMTX,CFMTY,NDIG1,NDIG2, ISZ1,ISZ2,  4,4, 0)
      CALL  PERIML (MAJORX, MINORX, MAJORY, MINORY)
      CALL  PLCHMQ(CPUX(500),CPUY(20),LAB(IHOR),16.,0.,0.)
      CALL  PLCHMQ(CPUX(20),CPUY(500),LAB(IVER),16.,90.,0.)
      CALL  PLCHMQ(CPUX(20),CPUY(1010),ITIT(1),12.,0.,-1.)
      CALL  PLCHMQ(CPUX(20),CPUY(985), ITIT(2),12.,0.,-1.)
      CALL  PLCHMQ(CPUX(20),CPUY(960), ITIT(3),12.,0.,-1.)
C
      LINE = 0
      DO 700 LOC=1,5
      IF(ISYMB(1,LOC) .EQ. 0) GO TO 700
C
      LINE = LINE+1
      LINE50 = 50*LINE
      CALL PLCHMQ(CPUX(950),CPUY(800-LINE50),LABEL(LOC)(1:3),
     X     12.,0.,-1.)
C
      IF(IHOR .EQ. 1) IX=LOC
      IF(IHOR .EQ. 2) IY=LOC
C
C  MARK POINTS WITH REQUESTED SYMBOL (ONE CHARACTER).
C
      IF(ISYMB(3,LOC) .EQ. IBL) GO TO 350
      WRITE (CTEMP,510)ISYMB(3,LOC)
 510  FORMAT(A1)
      CALL PLCHMQ(CPUX(1000),CPUY(800-LINE50),CTEMP,
     X     12.0,0.,-1.)
      DO 300 I=1,NS
      IF(STATS(I,6) .LE. 0.0) GO TO 300
      XPT = STATS(I,IX)
      YPT = STATS(I,IY)
      IF(XPT .LT. XMIN  .OR.  XPT .GT. XMAX) GO TO 300
      IF(YPT .LT. YMIN  .OR.  YPT .GT. YMAX) GO TO 300
      WRITE (CTEMP,510)ISYMB(3,LOC)      
      CALL PLCHMQ (XPT,YPT,CTEMP,FLOAT(ISYMB(4,LOC)),
     X     0.,0.)
300   CONTINUE
350   CONTINUE
C
C  CONNECT LINE WITH REQUESTED LINE PATTERN.
C
      IPAT=ISYMB(2,LOC)
      IF(IPAT.EQ.0) GO TO 700
      CALL DASHDB(IDASH(IPAT))
      CALL  LINED (CPUX(950), CPUY(785-LINE50), 
     X     CPUX(10000), CPUY(785-LINE50))
C
C  PLOT LINE.
C
      I1=0
      I2=0
      DO 400 I=1,NS
         J=NS-I+1
         IF(I1.EQ.0.AND.STATS(I,6).GT.0.0) I1=I
         IF(I2.EQ.0.AND.STATS(J,6).GT.0.0) I2=J
  400 CONTINUE
      IF(I2.LE.I1) GO TO 700
      XPRE = STATS(I1,IX)
      YPRE = STATS(I1,IY)
      I1 = I1+1
      DO 600 I=I1,I2
      IF(STATS(I,6) .LE. 0.0) GO TO 600
      XPT = STATS(I,IX)
      YPT = STATS(I,IY)
      IPASS=0
      X1 = XPRE
      Y1 = YPRE
      X2 = XPT
      Y2 = YPT
C
500   CONTINUE
C
      IPLEFT=0
      IPRGT =0
      IPBOT =0
      IPTOP =0
      IF(X1 .LT. XMIN) IPLEFT = 1
      IF(X1 .GT. XMAX) IPRGT  = 2
      IF(Y1 .LT. YMIN) IPBOT  = 4
      IF(Y1 .GT. YMAX) IPTOP  = 8
      IPCODE = IPLEFT + IPRGT + IPBOT + IPTOP
C
      ILEFT=0
      IRGT =0
      IBOT =0
      ITOP =0
      IF(X2 .LT. XMIN) ILEFT = 1
      IF(X2 .GT. XMAX) IRGT  = 2
      IF(Y2 .LT. YMIN) IBOT  = 4
      IF(Y2 .GT. YMAX) ITOP  = 8
      ICODE = ILEFT + IRGT + IBOT + ITOP
      IF(ICODE .EQ. 0  .AND.  IPCODE .EQ. 0) GO TO 560
      IF(ICODE .EQ. IPCODE) GO TO 575
      ILEFT = ILEFT+IPLEFT
      IF(ILEFT .EQ. 2) GO TO 575
      IRGT  = IRGT +IPRGT
      IF(IRGT  .EQ. 4) GO TO 575
      IBOT  = IBOT +IPBOT
      IF(IBOT  .EQ. 8) GO TO 575
      ITOP  = ITOP+IPTOP
      IF(ITOP .EQ. 16) GO TO 575
C
      IC = IPCODE
      X = X1
      Y = Y1
      IF(IC .EQ. 0) THEN
        IC = ICODE
        X = X2
        Y = Y2
      ENDIF
      IF(X .LT. XMIN) THEN
        X = XMIN
        Y = FY(X1,Y1,X2,Y2,XMIN)
        ELSE IF(X .GT. XMAX) THEN
               X = XMAX
               Y = FY(X1,Y1,X2,Y2,XMAX)
      ENDIF
C
      IF(Y .LT. YMIN) THEN
        X = FY(Y1,X1,Y2,X2,YMIN)
        Y = YMIN
        ELSE IF(Y .GT. YMAX) THEN
               X = FY(Y1,X1,Y2,X2,YMAX)
               Y = YMAX
      ENDIF
      IF(IC .EQ. IPCODE) THEN
        X1 = X
        Y1 = Y
      ENDIF
      IF(IC .EQ. ICODE) THEN
        X2 = X
        Y2 = Y
      ENDIF
      IPASS = IPASS+1
      IF(IPASS .GT. 2) GO TO 575
      GO TO 500
560   CONTINUE
      CALL  LINED (X1, Y1, X2, Y2)
575   CONTINUE
      XPRE = XPT
      YPRE = YPT
600   CONTINUE
700   CONTINUE
      CALL  MYFRAME
C
      RETURN
C
      END