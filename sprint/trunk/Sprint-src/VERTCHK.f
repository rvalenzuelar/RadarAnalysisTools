      SUBROUTINE VERTCHK(IFIELD,TFIELD,NFLINP,NTHRSH,IBUF,NDBMXH)
C
C     SUBROUTINE TO CHECK IF THE USER HAS REQUESTED INTERPOLATION OF
C     DBMXVUFL. IF SO, FIND THE LOCATION OF DBMXH, WHICH WILL BE
C     NEEDED FOR THE UNFOLDING.
C
      INCLUDE 'SPRINT.INC'
c-----PARAMETER (MAXFLD=16)
c-----PARAMETER (MAXIN=8500)

      CHARACTER*8 IFIELD(MAXFLD),NAMFLD,TFIELD(2,MAXFLD)
      DIMENSION IBUF(MAXIN)

      IYES=0
      DO I=1,NFLINP
         IF (IFIELD(I).EQ.'DBMXV') THEN
            IYES=1
         END IF
      END DO

      DO I=1,NTHRSH
         IF (TFIELD(2,I).EQ.'DBMXV') THEN
            IYES=1
         END IF
      END DO

      NDBMXH=0
      IF (IYES.EQ.1) THEN
         DO I=1,IBUF(68)
            IF (I.LE.6) THEN
               IFLDPTR=69+(I-1)
            ELSE
               IFLDPTR=161+(I-7)
            END IF
            CALL GETNAME(IBUF(IFLDPTR),NAMFLD)
            IF (NAMFLD.EQ.'DBMXH') THEN
               NDBMXH=I
            END IF
         END DO
         IF (NDBMXH.LT.1 .OR. NDBMXH.GT.IBUF(68)) THEN
            WRITE(*,20)NDBMXH
 20         FORMAT(/,5X,'+++ERROR LOCATING DBMXH FIELD FOR UNFOLDING',
     X            ' OF DBMXV FIELD+++')
            STOP
         END IF
      END IF


      RETURN

      END
