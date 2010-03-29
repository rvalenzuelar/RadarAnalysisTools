      SUBROUTINE IMHSUM(IDEV,ID)
C
C        GENERATES A SUMMARY OF A MUDRAS 16-BIT VOLUME HEADER
C                                 IN CARTESIAN COORDINATES.
C
      PARAMETER (NMD=510)
      COMMON /AXUNTS/ IUNAXS,LABAXS(3,3),SCLAXS(3,3),AXNAM(3)
      CHARACTER*4 AXNAM
      DIMENSION ID(NMD),ITAX(3)
      DATA ITAX/ 'X', 'Y', 'Z' /
      WRITE(IDEV,100)
  100 FORMAT(' ')
      IF(ID(1).NE.0) GO TO 10
      WRITE(IDEV,200)
  200 FORMAT(/5X,'NO MUDRAS FILE EXISTS AT PRESENT'/)
      RETURN
   10 CONTINUE
      SF=1./ID(68)
      CF=1./ID(69)

      WRITE(IDEV,105) (ID(I),I=1,4),ID(117),ID(118),ID(116),
     X   (ID(I),I=71,74),(ID(I),I=10,12),(ID(I),I=119,121),
     X   (ID(I),I=13,15),(ID(I),I=48,50),(ID(I),I=125,127),
     X   (ID(I),I=5,7),  (ID(I),I=51,54),(ID(I),I=101,104),
     X    ID(8),ID(9),(ID(I),I=55,58),(ID(I),I=16,20),(ID(I),I=45,47)
  105 FORMAT(/' MUDRAS (.MUD)  VOLUME HEADER'15X,4A2
     X   /'  GENERAL INFORMATION...'
     X/'   DATE:      'I2,2('/'I2),5X'SOURCE:  '4A2,3X'SCIENTIST: '3A2
     X/'   BEG TIME:  'I2,2(':'I2),5X'RADAR:   '3A2,5X'SUBMITTER: '3A2
     X/'   END TIME:  'I2,2(':'I2),5X'PROGRAM: '3A2,5X'DATE RUN:  '4A2
     X/'   VOL. NAME: ', 4A2,      5X'PROJECT: '2A2,7X'TIME RUN:  '4A2
     X/'   COORD SYS: ', 2A2,      9X'TAPE:    '3A2,5X'SEQUENCE:  '3A2)
      WRITE(IDEV,106) ID(62),ID(96),ID(301),ID(63),ID(97),ID(106),
     X                ID(65),ID(99),ID(67),ID(451),ID(452),ID(453)
  106 FORMAT(/'  DATA CHARACTERISTICS...'
     X/'   COMPUTER:   ',3X,A2,5X'RECS/FIELD:  'I5,5X'PTS/FIELD:  'I6
     X/'   BITS/DATUM: ',I5,   5X'RECS/PLANE:  'I5,5X'NO. PLANES: 'I6
     X/'   BLOCK SIZE: ',I5,   5X'RECS/VOLUME: 'I5,5X'BAD DATA:   'I6
     X/'   WORDS/PLANE:',I5,   5X'WORDS/FIELD: 'I5,5X'MAX FIELDS: 'I6)
      N=ID(175)
      WRITE(IDEV,107) N
  107 FORMAT(/'  FIELDS PRESENT: ',I2,' ...'
     X       /4X,'NO.',3X,'NAME',7X,'SCALE FACTOR')
      K2=175
      DO 15 I=1,N
      K1=K2+1
      K2=K2+5
      WRITE(IDEV,108) I,ID(K1),ID(K1+1),ID(K1+2),ID(K1+3),ID(K1+4)
  108 FORMAT(4X,I3,3X,4A2,5X,I5)
   15 CONTINUE
      N=ID(302)
      WRITE(IDEV,109) N,ID(303)
  109 FORMAT(/'  LANDMARKS PRESENT: ',I2,5X,'(',I2,' RADAR) ...'
     X   /4X,'NO.',3X,'NAME',6X,'X (KM)',4X,'Y (KM)',4X,'Z (KM)')
      K=306
      DO 20 I=1,N
      R1=ID(K+3)*SF
      R2=ID(K+4)*SF
      R3=ID(K+5)*0.001
      WRITE(IDEV,110) I,ID(K),ID(K+1),ID(K+2), R1,R2,R3
  110 FORMAT(4X,I3,3X,3A2,2F10.2,F10.3)
      K=K+6
   20 CONTINUE
      IF(ID(303).NE.1) GO TO 21
C
C        WRITE OUT RADAR SPECS IF SINGLE RADAR
C
      R1=ID(304)*SF
      R2=ID(305)*SF
      WRITE(IDEV,116) R1,R2
  116 FORMAT('  NYQUIST VELOCITY:',F8.2,7X,'RADAR CONSTANT:',F8.2)
   21 CONTINUE
      R1=ID(35)*SF
      R2=ID(38)*SF
      WRITE(IDEV,111) ID(33),ID(34),R1,ID(36),ID(37),R2
  111 FORMAT(/'  ORIGIN  LATITUDE:',I8,' DEG',I6,' MIN',F9.2,' SEC'
     X       /9X,      'LONGITUDE:',I8,' DEG',I6,' MIN',F9.2,' SEC')
      WRITE(IDEV,112)
  112 FORMAT(/'  CARTESIAN COORDINATE SYSTEM SPECIFICATIONS...'
     X/3X'AXIS'11X'MINIMUM    '5X'MAXIMUM     '5X'DELTA ',
     X7X,'NO. OF PTS.')
      K=160
C        CALCULATE KILOMETERS FROM METERS FOR Z-AXIS
      CKM=1.0
      DO 25 I=1,3
C        MARK BRADFORD PATCH TO ACCOUNT FOR ID(68).NE.100
      IF(I.EQ.3) CKM=FLOAT(ID(68))/1000.
      R1=ID(K)*SF*CKM
      R2=ID(K+1)*SF*CKM
      R3=ID(K+3)*0.001
      WRITE(IDEV,114) AXNAM(I),R1,LABAXS(I,1),R2,LABAXS(I,1),
     X                R3,LABAXS(I,1),ID(K+2)
  114 FORMAT(5X,A1,6X,F10.2,1X,A3,3X,F10.2,1X,A3,4X,F8.2,1X,A3,3X,I5)
      K=K+5
   25 CONTINUE
      L1=ID(164)
      L2=ID(169)
      L3=ID(174)
      R1=ID(40)*CF
      XOR=ID(41)*SF
      YOR=ID(42)*SF
      WRITE(IDEV,115) AXNAM(L1),AXNAM(L2),AXNAM(L3),R1,XOR,YOR
  115 FORMAT(/3X,'AXIS ORDER IS   ',3A3,
     X    /3X,'ANGLE OF THE X-AXIS RELATIVE TO NORTH: ',F9.2,4X,'DEG.',
     X    /3X,'(X,Y)  AXIS ARE SPECIFIED RELATIVE TO:  (',
     X                F7.2,',',F7.2,')')
      IF(ID(173).LT.0) THEN
         WRITE(IDEV,117)
  117    FORMAT(3X,'ALL FIELDS ARE ASSUMED TO BE AT THE SURFACE.')
      END IF
      RETURN
      END