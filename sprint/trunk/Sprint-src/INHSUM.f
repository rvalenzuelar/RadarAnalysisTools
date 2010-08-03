      SUBROUTINE INHSUM(IDEV,ICC,IYES,AZCOR,DASANG)
C
C        PRINT OUT SUMMARY OF DATA TAKEN FROM UNIVERSAL FORMAT TAPE
C
      INCLUDE 'SPRINT.INC'
c      PARAMETER (MAXEL=150,NID=129+3*MAXEL)

      CHARACTER*8 IDENTF(11),ISCTYP(2)
      CHARACTER*1 IYES,ICC
      COMMON /IDBLK/ ID(NID)
      COMMON /SCAN/ ICOPLANE,IFLGBAS,IPPI,ILLE,ILLZ
      COMMON /TRANS/ X1,X2,XD,Y1,Y2,YD,Z1,Z2,ZD,NX,NY,NZ,XORG,YORG,
     X   ANGXAX,ZRAD,AZLOW,BAD,ASNF,ACSF,IAXORD(3),NPLANE,EDIAM
      DATA IDENTF/' ','POWER','REFLECT','VELOCITY','VARIANCE',
     X                'CORREL','TIME','GEOMETRY',' ',' ',' '/
      DATA ISCTYP/'PPI','COPLANE'/
      DATA IDCPLN/'CO'/
C
      IF(IYES.NE.'Y') RETURN
      IF(ID(35).NE.0) GO TO 10
      WRITE(IDEV,200)
  200 FORMAT(/5X,'NO INPUT FILE EXISTS AT PRESENT'/)
      RETURN
   10 CONTINUE
      SF=1./ID(44)
c      WRITE(IDEV,100)ICC
c 100  FORMAT(A1)

c-----CALL DMPCHAR(ID,30)

      WRITE(IDEV,105) (ID(I),I=25,30),(ID(J),J=1,24)
 105  FORMAT(/,' RADAR (.RAD)  VOLUME HEADER',5X,6A2
     +/3X,'DATE= ',I2.2,'/',I2.2,'/',I2.2,6X,
     +'TIME= ',I2.2,':',I2.2,':',I2.2,'--',I2.2,':',I2.2,':',I2.2,6X,
     +'PTS/RECORD= ',I4/3X,
     +'TAPE= ',3A2,4X,'RADAR= ',3A2,4X,'PROGRAM= ',4A2,4X,
     +'PROJECT= ',4A2)
      NFLD=ID(75)
      WRITE(IDEV,110) NFLD
 110  FORMAT(3X,'NO. OF FIELDS= ',I2//3X,'FIELD NAME',9X,'SCALE FACTOR'
     X       ,5X,'FIELD TYPE')
      K5=75
      RNY=0.0
      DO 15 N=1,NFLD
      K1=K5+1
      K2=K1+1
      K5=K1+4
      K=ITPFLD(ID(K1))
      IF(K.EQ.3.AND.RNY.EQ.0.0) RNY = IABS(ID(K1+2)) * 0.01
      K=K+1
      WRITE(IDEV,115) ID(K1),ID(K2),ID(K5),IDENTF(K)
 115  FORMAT(6X,2A4,12X,I4,10X,A8)
 15   CONTINUE
      R1=ID(46)*0.001
      R2=ID(31)+(ID(32)*0.001)
      R3=ID(33)*0.001
      R4=ID(47)*0.01
      R5=ID(48)*0.01
      R6=AZCOR
      WRITE(IDEV,120) R4,R5,R1,R6,ID(34),R2,R3,RNY
  120 FORMAT(/3X,'RADAR  (X,Y,HGT)  (KM,KM,KMSL)=  (',
     +        F8.3,',',F8.3,',',F7.3,' )'
     +       /3X,'AZIMUTH CORRECTION (DEG)= ',F8.3
     +       /3X,'GATES/BEAM= ',I4,3X,
     +'FIRST GATE (KM)= ',F7.3,5X,'GATE SPACING (KM)= ',F7.3,
     +/3X,'NYQUIST VELOCITY (M/S)= ',F5.2)
      ICP=0
      IF(ID(50).EQ.IDCPLN) ICP=1
      WRITE(IDEV,121) ISCTYP(ICP+1)
  121 FORMAT(3X,'SCANNING MODE= ',A8)
      IF(ICP.EQ.1) THEN
C
C        COPLANE SCAN
C
         BASANG=DASANG
         IF (BASANG.LT.0.0) BASANG=BASANG+360.0
         ID(51)=BASANG*64.0
         WRITE(IDEV,122) BASANG
  122    FORMAT(3X,'COPLANE BASE ANGLE (DEG)= ',F6.2)
      END IF
      RETURN
      END
