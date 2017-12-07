Input-File for SAFIR2007
*GenData(Title_1)
*GenData(Title_2)

*format "%5i"
     NNODE *npoin
      NDIM    2
   NDDLMAX    1
*format "%5i"
      FROM    1   TO *npoin STEP    1 NDDL    1
  END_NDDL
  *if(strcmp(Gendata(SOLVER),"CHOLESKY")==0)
    SOLVER  *GenData(SOLVER)
*format "%10.1f"
*else
*format "%10.0f%10.0f"  
    NCORES  *GenData(NCORES)
*endif
   TORSION
*if(strcmp(Gendata(SOLVER),"CHOLESKY")==0)
*if(strcmp(Gendata(Renumber),"RENUMGEO")==0)
 RENUMGEO 1
*else
*Gendata(Renumber)
*endif
*else
 NORENUM
*endif
      NMAT *nmats
  ELEMENTS
*format "%6i"
     SOLID *nelem
        NG    2
*format "%6i"
     NVOID *GenData(NVOID)
*if(GenData(NVOID,int)>0)
*format "%6i"
FRTIERVOID   100
*endif
  END_ELEM
     NODES
*loop nodes
*format "%6i%10.4f%10.4f"
      NODE*NodesNum *NodesCoord(2,real) *NodesCoord(1,real)
*end nodes
*format "%16.4f%10.4f
  NODELINE*GenData(Global_center_(Yo)) *GenData(Global_center_(Zo))
*format "%16.4f%10.4f
     YC_ZC*GenData(Center_of_torsion(Yc)) *GenData(Center_of_torsion(Zc))
 FIXATIONS
   END_FIX
NODOFSOLID
*loop elems
*if(ElemsNnode(int)==4)
*format "%6i%6i%6i%6i%6i%6i"
      ELEM *ElemsNum *ElemsConec *ElemsMat     0.
*else
*format "%6i%6i%6i%6i%6i"
      ELEM *ElemsNum *ElemsConec    0 *ElemsMat     0.
*endif
*end elems
  SYMMETRY
   END_SYM
 PRECISION     1.E-3
 MATERIALS
*loop materials
*if((strcmp(MatProp(1),"STEELEC3")==0))
*MatProp(1)
          *MatProp(5) *MatProp(6) *MatProp(7) 1200. 0.
*elseif((strcmp(MatProp(1),"STEELEC3DC")==0))   
*MatProp(1)
          *MatProp(5) *MatProp(6) *MatProp(7) 1200. 0.
*elseif((strcmp(MatProp(1),"STEELEC2")==0))
*MatProp(1)
          *MatProp(5) *MatProp(6) *MatProp(7) 1200. 0.
*elseif((strcmp(MatProp(1),"PSTEELA16")==0))
*MatProp(1)
          *MatProp(5) *MatProp(6) *MatProp(7) 1200. 0.
*elseif((strcmp(matProp(1),"SILCONC_EN")==0))
*MatProp(1)
          *MatProp(8) *MatProp(9) *MatProp(10) 0.0
*elseif((strcmp(matProp(1),"CALCONC_EN")==0))
*MatProp(1)
          *MatProp(8) *MatProp(9) *MatProp(10) 0.0
*elseif((strcmp(matProp(1),"INSULATION")==0))
*MatProp(1)
          0.0 0.0 0.0
*elseif((strcmp(matProp(1),"X_GYPSUM")==0))
*MatProp(1)
          0.0 0.0 0.0
*elseif((strcmp(matProp(1),"C_GYPSUM")==0))
*MatProp(1)
          0.0 0.0 0.0
*elseif((strcmp(matProp(1),"WOODEC5")==0))
*MatProp(1)
         *MatProp(11) *MatProp(12) *MatProp(13) *MatProp(14)
*elseif((strcmp(MatProp(1),"USER1")==0))
*MatProp(1)
         *MatProp(13) *MatProp(14) *MatProp(15) *MatProp(16)
*else
*WarningBox -Materal not supported-
*endif
*end materials
IMPRESSION
 TIMEPRINT 
*format "%10.0f%10.0f"
*GenData(TIMEPRINT) *GenData(UPTIME)
END_TIMEPR
