*#if((strcmp(GenData(Type_of_calculation),"MAKE.TEM")==0)&&(strcmp(GenData(Auto_run_torsion),"yes")==0))
*if(strcmp(GenData(Auto_run_torsion),"yes")==0)
AUTOTOR 
*endif
*if(strcmp(GenData(Split_Tem_File),"yes")==0)
Split_Tem_File
*endif
InputFile created with GiD-SAFIR2011_OLI Interface
*GenData(Title_1)
*GenData(Title_2)

*format "%5i"
     NNODE *npoin
      NDIM    2
   NDDLMAX    1
*format "%5i"
      FROM    1   TO *npoin STEP    1 NDDL    1
  END_NDDL
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
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
*endif
*GenData(Type_of_calculation)
*if(strcmp(GenData(Type_of_calculation),"MAKE.TEMHA")==0)
*GenData(Filename.IN)
BEAM_TYPE *GenData(IELEMTYPE)
*endif
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
*format "%5i"
     SOLID *nelem
        NG    2
*format "%5i"
     NVOID *GenData(NVOID)
*if(GenData(NVOID,int)>0)
*#format "%5i"
*#FRTIERVOID *GenData(NFRONTIERVOID)
FRTIERVOID  0
*endif
  END_ELEM
     NODES
*loop nodes
*format "%6i%10.4f%10.4f"
      NODE *NodesNum *NodesCoord(2,real) *NodesCoord(1,real)
*end nodes
*format "%16.4f%10.4f
  NODELINE*GenData(Global_center_(Yo)) *GenData(Global_center_(Zo))
*format "%16.4f%10.4f
     YC_ZC*GenData(Center_of_torsion(Yc)) *GenData(Center_of_torsion(Zc))
 FIXATIONS
*Set Cond Line_Temperature *nodes
*add Cond Point_Temperature *nodes
*loop nodes *OnlyInCond
     BLOCK *NodesNum *cond(Temperature_curve)
*end nodes
   END_FIX
NODOFSOLID
*#set elems(quadrilateral)
*loop elems
*if(ElemsNnode(int)==4)
*format "%6i%6i%6i%6i%6i%6i"
      ELEM  *ElemsNum  *ElemsConec  *ElemsMat     0.
*#end elems
*#set elems(triangle)
*#loop elems
*else
*format "%6i%6i%6i%6i%6i%6i"
      ELEM  *ElemsNum  *ElemsConec    0  *ElemsMat     0.
*endif
*end elems
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
  FRONTIER
*Set Elems(triangle)
*Set Cond Frontier_constraints *elems *CanRepeat
*loop elems *OnlyInCond
*if(CondNumEntities(int)>0)
*if((GlobalNodes(1,int)== ElemsConec(1,int))&&(GlobalNodes(2,int)== ElemsConec(2,int)))
*if(strcmp(cond(Temperature_curve),"USER")==0)
*format "   F %5i"
*ElemsNum *cond(File_name_of_USER-Temp.curve) *\
*else
*format "   F %5i"
*ElemsNum *cond(Temperature_curve) *\
*endif
*else
*format "   F %5i"
*ElemsNum NO *\
*endif
*if((GlobalNodes(1,int)== ElemsConec(2,int))&&(GlobalNodes(2,int)== ElemsConec(3,int)))
*if(strcmp(cond(Temperature_curve),"USER")==0)
*cond(File_name_of_USER-Temp.curve) *\
*else
*cond(Temperature_curve) *\
*endif
*else
NO *\
*endif
*if((GlobalNodes(1,int)== ElemsConec(3,int))&&(GlobalNodes(2,int)== ElemsConec(1,int)))
*if(strcmp(cond(Temperature_curve),"USER")==0)
*cond(File_name_of_USER-Temp.curve) NO
*else
*cond(Temperature_curve) NO
*endif
*else
NO NO 
*endif
*endif
*end elems
*Set Elems(quadrilateral)
*Set Cond Frontier_constraints *elems *CanRepeat
*loop elems *OnlyInCond
*if(CondNumEntities(int)>0)
*if((GlobalNodes(1,int)== ElemsConec(1,int))&&(GlobalNodes(2,int)== ElemsConec(2,int)))
*if(strcmp(cond(Temperature_curve),"USER")==0)
*format "   F %5i"
*ElemsNum *cond(File_name_of_USER-Temp.curve) *\
*else
*format "   F %5i"
*ElemsNum *cond(Temperature_curve) *\
*endif
*else
*format "   F %5i"
*ElemsNum NO *\
*endif
*if((GlobalNodes(1,int)== ElemsConec(2,int))&&(GlobalNodes(2,int)== ElemsConec(3,int)))
*if(strcmp(cond(Temperature_curve),"USER")==0)
*cond(File_name_of_USER-Temp.curve) *\
*else
*cond(Temperature_curve) *\
*endif
*else
NO *\
*endif
*if((GlobalNodes(1,int)== ElemsConec(3,int))&&(GlobalNodes(2,int)== ElemsConec(4,int)))
*if(strcmp(cond(Temperature_curve),"USER")==0)
*cond(File_name_of_USER-Temp.curve) *\
*else
*cond(Temperature_curve) *\
*endif
*else
NO *\
*endif
*if((GlobalNodes(1,int)== ElemsConec(4,int))&&(GlobalNodes(2,int)== ElemsConec(1,int)))
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
*# -------------------------------------------------------------------------------------
*# Ouput Lines for Flux frontier constraint
*# -------------------------------------------------------------------------------------
*Set Elems(triangle)
*Set Cond Flux_constraints *elems *CanRepeat
*loop elems *OnlyInCond
*if(CondNumEntities(int)>0)
*if((GlobalNodes(1,int)== ElemsConec(1,int))&&(GlobalNodes(2,int)== ElemsConec(2,int)))
FLUX *ElemsNum *cond(File_name_of_USER-Flux.curve) *\
*else
FLUX *ElemsNum NO *\
*endif
*if((GlobalNodes(1,int)== ElemsConec(2,int))&&(GlobalNodes(2,int)== ElemsConec(3,int)))
*cond(File_name_of_USER-Flux.curve) *\
*else
NO *\
*endif
*if((GlobalNodes(1,int)== ElemsConec(3,int))&&(GlobalNodes(2,int)== ElemsConec(1,int)))
*cond(File_name_of_USER-Flux.curve) NO
*else
NO NO 
*endif
*endif
*end elems
*Set Elems(quadrilateral)
*Set Cond Flux_constraints *elems *CanRepeat
*loop elems *OnlyInCond
*if(CondNumEntities(int)>0)
*if((GlobalNodes(1,int)== ElemsConec(1,int))&&(GlobalNodes(2,int)== ElemsConec(2,int)))
FLUX *ElemsNum *cond(File_name_of_USER-Flux.curve) *\
*else
FLUX *ElemsNum NO *\
*endif
*if((GlobalNodes(1,int)== ElemsConec(2,int))&&(GlobalNodes(2,int)== ElemsConec(3,int)))
*cond(File_name_of_USER-Flux.curve) *\
*else
NO *\
*endif
*if((GlobalNodes(1,int)== ElemsConec(3,int))&&(GlobalNodes(2,int)== ElemsConec(4,int)))
*cond(File_name_of_USER-Flux.curve) *\
*else
NO *\
*endif
*if((GlobalNodes(1,int)== ElemsConec(4,int))&&(GlobalNodes(2,int)== ElemsConec(1,int)))
*cond(File_name_of_USER-Flux.curve)
*else
NO
*endif
*endif
*end elems
 END_FRONT
*# -------------------------------------------------------------------------------------
*# Ouput Lines for VOID frontier constraint
*# -------------------------------------------------------------------------------------
*for(i=1;i<=GenData(NVOID,INT);i=i+1)
      VOID
*Set Elems(triangle)
*Set Cond Void_constraints *elems *CanRepeat
*loop elems *OnlyInCond
*if(Cond(VoidNr,int)==i)
*if((GlobalNodes(1,int)== ElemsConec(1,int))&&(GlobalNodes(2,int)== ElemsConec(2,int)))
*format "      ELEM %6i   1"
*ElemsNum
*endif
*if((GlobalNodes(1,int)== ElemsConec(2,int))&&(GlobalNodes(2,int)== ElemsConec(3,int)))
*format "      ELEM %6i   2"
*ElemsNum
*endif
*if((GlobalNodes(1,int)== ElemsConec(3,int))&&(GlobalNodes(2,int)== ElemsConec(1,int)))
*format "      ELEM %6i   3"
*ElemsNum
*endif
*endif
*end elems
*Set Elems(quadrilateral)
*Set Cond Void_constraints *elems *CanRepeat
*loop elems *OnlyInCond
*if(Cond(VoidNr,int)==i)
*if((GlobalNodes(1,int)== ElemsConec(1,int))&&(GlobalNodes(2,int)== ElemsConec(2,int)))
*format "      ELEM %6i   1"
*ElemsNum
*endif
*if((GlobalNodes(1,int)== ElemsConec(2,int))&&(GlobalNodes(2,int)== ElemsConec(3,int)))
*format "      ELEM %6i   2"
*ElemsNum
*endif
*if((GlobalNodes(1,int)== ElemsConec(3,int))&&(GlobalNodes(2,int)== ElemsConec(4,int)))
*format "      ELEM %6i   3"
*ElemsNum
*endif
*if((GlobalNodes(1,int)== ElemsConec(4,int))&&(GlobalNodes(2,int)== ElemsConec(1,int)))
*format "      ELEM %6i   4"
*ElemsNum
*endif
*endif
*end elems
  END_VOID
*endfor
*end
  SYMMETRY
   END_SYM
 PRECISION     1.E-3
 MATERIALS
*loop materials
*if((strcmp(MatProp(1),"STEELEC3")==0))
*MatProp(1)
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
*format "%10.2f%10.2f%10.2f"
          *MatProp(2) *MatProp(3) *MatProp(4)
*else
          *MatProp(5) *MatProp(6) *MatProp(7) 1200. 0.
*endif
*elseif((strcmp(MatProp(1),"STEELEC3DC")==0))
*MatProp(1)
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
*format "%10.2f%10.2f%10.2f"
          *MatProp(2) *MatProp(3) *MatProp(4)
*else
          *MatProp(5) *MatProp(6) *MatProp(7) 1200. 0.
*endif
*elseif((strcmp(MatProp(1),"STEELEC2")==0))
*MatProp(1)
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
*format "%10.2f%10.2f%10.2f"
          *MatProp(2) *MatProp(3) *MatProp(4)
*else
          *MatProp(5) *MatProp(6) *MatProp(7) 1200. 0.
*endif
*elseif((strcmp(MatProp(1),"PSTEELA16")==0))
*MatProp(1)
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
*format "%10.2f%10.2f%10.2f"
          *MatProp(2) *MatProp(3) *MatProp(4)
*else
          *MatProp(5) *MatProp(6) *MatProp(7) 1200. 0.
*endif
*elseif((strcmp(matProp(1),"SILCONC_EN")==0))
*MatProp(1)
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
          *MatProp(2) *MatProp(3) *MatProp(4) *MatProp(5) *MatProp(6) *MatProp(7)
*else
          *MatProp(8) *MatProp(9) *MatProp(10) 0.0
*endif
*elseif((strcmp(matProp(1),"CALCONC_EN")==0))
*MatProp(1)
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
          *MatProp(2) *MatProp(3) *MatProp(4) *MatProp(5) *MatProp(6) *MatProp(7)
*else
          *MatProp(8) *MatProp(9) *MatProp(10) 0.0
*endif
*elseif((strcmp(matProp(1),"INSULATION")==0))
*MatProp(1)
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
          *MatProp(2) *MatProp(3) *MatProp(4) *MatProp(5) *MatProp(6) *MatProp(7) *MatProp(8)
*else
          0.0 0.0 0.0
*endif
*elseif((strcmp(matProp(1),"X_GYPSUM")==0))
*MatProp(1)
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
          *MatProp(2) *MatProp(3) *MatProp(4)
*else
          0.0 0.0 0.0
*endif
*elseif((strcmp(matProp(1),"C_GYPSUM")==0))
*MatProp(1)
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
          *MatProp(2) *MatProp(3) *MatProp(4)
*else
          0.0 0.0 0.0
*endif
*elseif((strcmp(matProp(1),"WOODEC5")==0))
*MatProp(1) 
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
          *MatProp(2) *MatProp(3) *MatProp(4) *MatProp(5) *MatProp(6) *MatProp(7) *MatProp(8) *MatProp(9) *MatProp(10)
*else
          *MatProp(11) *MatProp(12) *MatProp(13) *MatProp(14)
*endif
*elseif((strcmp(matProp(1),"USER1")==0))
*MatProp(1) *MatProp(11)
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
          *MatProp(2) *MatProp(3) *MatProp(4) *MatProp(5) *MatProp(6) *MatProp(7) *MatProp(8) *MatProp(9) *MatProp(10)
User_Mat_File *MatProp(12)
*else
          *MatProp(12) *MatProp(14) *MatProp(15) *MatProp(16)
*endif
*else
*MatProp(0) -Material not supported-
*WarningBox -MateralType not supported-
*endif
*end materials
*if(strcmp(GenData(Type_of_calculation),"TORSION")!=0)
      TIME
*format "%10.0f%10.0f"
*GenData(TIMESTEP) *GenData(UPTIME)
  END_TIME
*endif
IMPRESSION
 TIMEPRINT 
*format "%10.0f%10.0f"
*GenData(TIMEPRINT) *GenData(UPTIME)
END_TIMEPR
