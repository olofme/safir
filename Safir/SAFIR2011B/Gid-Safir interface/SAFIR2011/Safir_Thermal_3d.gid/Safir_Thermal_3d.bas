InputFile created with GiD-SAFIR2011_OLI Interface
*GenData(Title_1)
*GenData(Title_2)

*format "%5i"
     NNODE *npoin
      NDIM    3
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
  TEMPERAT
*format "%10.1f"
      TETA *GenData(TETA)
*format "%10.1f"
  TINITIAL *GenData(TINITIAL)
  MAKE.TEM
*if((strcmp(Gendata(Renumber),"RENUMGEO")==0))
 RENUMGEO 1
*else
*Gendata(Renumber)
*endif
      NMAT *nmats
  ELEMENTS
*format "%5i"
     SOLID *nelem
        NG    2
*format "%5i"
  END_ELEM
     NODES
*loop nodes
*format "%6i%10.4f%10.4f%10.4f"
      NODE*NodesNum *NodesCoord(1,real) *NodesCoord(2,real) *NodesCoord(3,real)
*end nodes
  NODELINE   0.  0.
     YC_ZC   0.  0.
 FIXATIONS
   END_FIX
NODOFSOLID
*set elems(hexahedra)
*loop elems
*format "%6i%6i%6i%6i%6i"
      ELEM *ElemsNum *ElemsConec(1) *ElemsConec(2) *ElemsConec(3) *ElemsConec(4) *\
*format "%6i%6i%6i%6i%6i"
*ElemsConec(5) *ElemsConec(6) *ElemsConec(7) *ElemsConec(8) *ElemsMat     0.
*end elems
  FRONTIER
*Set Elems(hexahedra)
*Set Cond Frontier_constraints *elems *CanRepeat
*loop elems *OnlyInCond
*if(CondNumEntities(int)>0)
*# *ElemsNum *GlobalNodes(1,int) *GlobalNodes(2,int) *GlobalNodes(3,int) *GlobalNodes(4,int) 
*if((GlobalNodes(1,int)==ElemsConec(1,int))&&(GlobalNodes(2,int)==ElemsConec(4,int))&&(GlobalNodes(3,int)==ElemsConec(8,int))&&(GlobalNodes(4,int)==ElemsConec(5,int)))
*if(strcmp(cond(Temperature_curve),"USER")==0)
*ElemsNum *cond(File_name_of_USER-Temp.curve) *\
*else
*format "   F %5i"
*ElemsNum *cond(Temperature_curve) *\
*endif
*else
*format "   F %5i"
*ElemsNum NO *\
*endif
*if((GlobalNodes(1,int)==ElemsConec(3,int))&&(GlobalNodes(2,int)==ElemsConec(7,int))&&(GlobalNodes(3,int)==ElemsConec(8,int))&&(GlobalNodes(4,int)==ElemsConec(4,int)))
*if(strcmp(cond(Temperature_curve),"USER")==0)
*cond(File_name_of_USER-Temp.curve) *\
*else
*cond(Temperature_curve) *\
*endif
*else
NO *\
*endif
*if((GlobalNodes(1,int)==ElemsConec(2,int))&&(GlobalNodes(2,int)==ElemsConec(6,int))&&(GlobalNodes(3,int)==ElemsConec(7,int))&&(GlobalNodes(4,int)==ElemsConec(3,int)))
*if(strcmp(cond(Temperature_curve),"USER")==0)
*cond(File_name_of_USER-Temp.curve) *\
*else
*cond(Temperature_curve) *\
*endif
*else
NO *\
*endif
*if((GlobalNodes(1,int)==ElemsConec(1,int))&&(GlobalNodes(2,int)==ElemsConec(5,int))&&(GlobalNodes(3,int)==ElemsConec(6,int))&&(GlobalNodes(4,int)==ElemsConec(2,int)))
*if(strcmp(cond(Temperature_curve),"USER")==0)
*cond(File_name_of_USER-Temp.curve) *\
*else
*cond(Temperature_curve) *\
*endif
*else
NO *\
*endif
*if((GlobalNodes(1,int)==ElemsConec(1,int))&&(GlobalNodes(2,int)==ElemsConec(2,int))&&(GlobalNodes(3,int)==ElemsConec(3,int))&&(GlobalNodes(4,int)==ElemsConec(4,int)))
*if(strcmp(cond(Temperature_curve),"USER")==0)
*cond(File_name_of_USER-Temp.curve) *\
*else
*cond(Temperature_curve) *\
*endif
*else
NO *\
*endif
*if((GlobalNodes(1,int)==ElemsConec(5,int))&&(GlobalNodes(2,int)==ElemsConec(8,int))&&(GlobalNodes(3,int)==ElemsConec(7,int))&&(GlobalNodes(4,int)==ElemsConec(6,int)))
*if(strcmp(cond(Temperature_curve),"USER")==0)
*cond(File_name_of_USER-Temp.curve) 
*else
*cond(Temperature_curve) 
*endif
*else
NO 
*endif
*endif
*end elems
 END_FRONT
  SYMMETRY
   END_SYM
 PRECISION     1.E-3
 MATERIALS
*loop materials
*MatProp(1)
*if((strcmp(MatProp(1),"STEELEC3")==0))
*format "%10.2f%10.2f%10.2f"
          *MatProp(2) *MatProp(3) *MatProp(4)
*elseif((strcmp(MatProp(1),"STEELEC3DC")==0))
*format "%10.2f%10.2f%10.2f"
          *MatProp(2) *MatProp(3) *MatProp(4)
*elseif((strcmp(MatProp(1),"STEELEC2")==0))
*format "%10.2f%10.2f%10.2f"
          *MatProp(2) *MatProp(3) *MatProp(4)
*elseif((strcmp(MatProp(1),"PSTEELA16")==0))
*format "%10.2f%10.2f%10.2f"
          *MatProp(2) *MatProp(3) *MatProp(4)
*elseif((strcmp(matProp(1),"SILCONC_EN")==0))
          *MatProp(2) *MatProp(3) *MatProp(4) *MatProp(5) *MatProp(6) *MatProp(7)
*elseif((strcmp(matProp(1),"CALCONC_EN")==0))
          *MatProp(2) *MatProp(3) *MatProp(4) *MatProp(5) *MatProp(6) *MatProp(7)
*elseif((strcmp(matProp(1),"INSULATION")==0))
          *MatProp(2) *MatProp(3) *MatProp(4) *MatProp(5) *MatProp(6) *MatProp(7) *MatProp(8)
*elseif((strcmp(matProp(1),"X_GYPSUM")==0))
          *MatProp(2) *MatProp(3) *MatProp(4)
*elseif((strcmp(matProp(0),"C_GYPSUM")==0))
          *MatProp(2) *MatProp(3) *MatProp(4)
*else
*messagebox -MateralType not supported-
*endif
*end materials
      TIME
*format "%10.0f%10.0f"
*GenData(TIMESTEP) *GenData(UPTIME)
  END_TIME
IMPRESSION
 TIMEPRINT 
*format "%10.0f%10.0f"
*GenData(TIMEPRINT) *GenData(UPTIME)
END_TIMEPR
