InputFile created with GiD-SAFIR2011_OLI Interface
*GenData(Title_1)
*GenData(Title_2)

*#-------------------------------------------------------------------
*# Count number of oblique supports
*#-------------------------------------------------------------------
*set Cond Oblique_Support *nodes
*set var noblique(int)=CondNumEntities
*#-------------------------------------------------------------------
*# Count number of points with disconnected degrees of freedom 
*# (same - command)
*#-------------------------------------------------------------------
*set Cond Line_Disconnect_degrees *nodes
*add Cond Point_Disconnect_degrees *nodes
*set var nSame(int)=CondNumEntities
*#-------------------------------------------------------------------
*# count number beams, truss, shell - elements
*#-------------------------------------------------------------------
*set var nbeams(int)=0
*set var ntruss(int)=0
*set var nshell(int)=0
*Set Cond SHELL_Section_property *elems
*set var nshell(int)=CondNumEntities
*set var nsolid(int)=nelem(Hexahedra)
*set elems(linear)
*Set Cond TRUSS_Cross_Section *elems
*set var ntruss(int)=CondNumEntities
*Set Cond BEAM_Cross_Section *elems
*set var nbeams(int)=CondNumEntities
*set var nbnt = nbeams+ntruss
*#if(nelem(Linear)!=nbnt)
*#MessageBox Error: Not all linear entities have a BEAM or TRUSS property !
*#endif
*if(nelem(Triangle))
*MessageBox error: Triangle Shell-elements are not permitted.
*endif
*if(nelem(Quadrilateral)!=nshell)
*MessageBox Error: Not all quadrilateral entities have a SHELL property !
*endif
*#----------------------------------------------------------------
*set var Nd3 = npoin(int)
*set var Ndmax(int) = Nd3(int) + nbeams(int) + 2*noblique(int) + nSame(int)
*#----------------------------------------------------------------
*format "%6i"
     NNODE*Ndmax
      NDIM    3
*# set var nshell=nelem(Quadrilateral)
*if(nbeams>0)
   NDDLMAX    7
*elseif(nshell>0)
   NDDLMAX    6
*else
   NDDLMAX    3
*endif
*if(nshell>0)
EVERY_NODE    6
*elseif(ntruss>0)
EVERY_NODE    3
*elseif(nsolid>0)
EVERY_NODE    3
*else
EVERY_NODE    7
*endif 
*set elems(Linear)
*Set Cond TRUSS_Cross_Section *elems
*loop elems *OnlyInCond
*if((nbeams(int) > 0) || (nshell(int) > 0))
*format "      FROM %6i   TO %6i STEP    1 NDDL    3"
*ElemsConec(1,int) *ElemsConec(1,int)
*format "      FROM %6i   TO %6i STEP    1 NDDL    3"
*ElemsConec(2,int) *ElemsConec(2,int)
*endif
*end elems
*Set Cond BEAM_Cross_Section *elems
*loop elems *OnlyInCond
*if((ntruss(int) > 0) || (nshell(int) > 0)) 
*format "      FROM %6i   TO %6i STEP    1 NDDL    7"
*ElemsConec(1,int) *ElemsConec(1,int)
*format "      FROM %6i   TO %6i STEP    1 NDDL    7"
*ElemsConec(2,int) *ElemsConec(2,int)
*endif
*#-- create node Nr for middle node of beams ------------------------------
*set var Nd3=Operation(ND3(int)+1)
*format "      FROM %6i   TO %6i STEP    1 NDDL    1"
*Nd3 *Nd3
*end elems
*#--------------------------------------------------------------------------
*# for 2. and 3. point of oblique supports set NDDL = 0
*#--------------------------------------------------------------------------
*if(noblique > 0)
*set Cond Oblique_Support *nodes
*loop nodes *OnlyInCond
*set var Nd3=Operation(ND3(int)+1)
*format "      FROM %6i   TO %6i STEP    1 NDDL    0"
*Nd3 *Nd3
*set var Nd3=Operation(ND3(int)+1)
*format "      FROM %6i   TO %6i STEP    1 NDDL    0"
*Nd3 *Nd3
*end nodes
*endif
*#--------------------------------------------------------------------------
*# For SAME-Points
*#--------------------------------------------------------------------------
*if(nSame > 0)
*set Cond Line_Disconnect_degrees *nodes
*add Cond Point_disconnect_degrees *nodes
*loop nodes *OnlyInCond
*set var Nd3=Operation(ND3(int)+1)
*format "      FROM %6i   TO %6i STEP    1 NDDL    7"
*Nd3 *Nd3
*end nodes
*endif
*#---------------------------------------------------------------------------
  END_NDDL
*#--------------------------------------------------------------------------- 
*# Choice of the Solver procedure
*#---------------------------------------------------------------------------
  *if(strcmp(Gendata(SOLVER),"CHOLESKY")==0)
  SOLVER  *GenData(SOLVER)
*format "%10.1f"
*else
*format "%4i" 
  NCORES *GenData(NCORES)
*endif
*#---------------------------------------------------------------------------
*if(strcmp(GenData(Loads),"STATIC_PURE_NR")==0)
    STATIC   PURE_NR
*elseif(strcmp(GenData(Loads),"STATIC_APPR_NR")==0)
    STATIC   APPR_NR
*elseif(strcmp(GenData(Loads),"DYNAMIC_PURE_NR")==0)
   DYNAMIC   PURE_NR
*elseif(strcmp(GenData(Loads),"DYNAMIC_APPR_NR")==0)
   DYNAMIC   APPR_NR
*elseif(strcmp(GenData(Loads),"STATICCOLD_PURE_NR")==0)
STATICCOLD   PURE_NR
*elseif(strcmp(GenData(Loads),"STATICCOLD_APPR_NR")==0)
STATICCOLD   APPR_NR
*else
*Gendata(loads)
*endif
     NLOAD    1
*format "%4i"
   OBLIQUE *noblique 
*if(strcmp(GenData(Convergence),"COMEBACK")==0)
  COMEBACK *GenData(TIMESTEPMIN)
*else
NOCOMEBACK
*endif
*if(strcmp(Gendata(SOLVER),"CHOLESKY")==0)
*if(strcmp(Gendata(Renumber),"RENUMGEO")==0)
  RENUMGEO  1
*else
*Gendata(Renumber)
*endif
*else
   NORENUM
*endif
*format "%4i"
      NMAT *Gendata(Number_of_materials)
  ELEMENTS
*if(nbeams>0)
*format "%6i%5i"
      BEAM *nbeams *Gendata(NGEOBEAM)
        NG *Gendata(NG)
*format "%6i"
    NFIBER *Gendata(NFIBERBEAM)
*endif
*if(ntruss>0)
*format "%6i%5i"
     TRUSS *ntruss *Gendata(NGEOTRUSS)
*endif
*if(nshell>0)
*format "%6i%5i"
     SHELL *nshell *Gendata(NGEOSHELL)
*format "%4i"
   NGTHICK *Gendata(NGSHELLTHICK)
    NGAREA    2
*format "%4i"
   NREBARS *Gendata(NREBARS) 
*endif
*if(nsolid>0)
*format "%4i"
     SOLID *nsolid
        NG    2
*endif
  END_ELEM
*#-------------------------------------------------------
*# write node coordinates
*#-------------------------------------------------------
     NODES
*loop nodes
*#format "%6i%10.4f%10.4f%10.4f"
*format "%6i%15.9e%15.9e%15.9e"
      NODE*NodesNum *NodesCoord(1,real) *NodesCoord(2,real) *NodesCoord(3,real)
*end nodes
*#-------------------------------------------------------
*# create middle node for beams
*#-------------------------------------------------------
*set var Nd3(int) = npoin(int)
*set elems(linear)
*Set Cond BEAM_Cross_Section *elems
*loop elems *OnlyInCond
*set var Nd3=ND3+1
*set var X3 = ((NodesCoord(1,1) + NodesCoord(2,1))*0.5)
*set var Y3 = ((NodesCoord(1,2) + NodesCoord(2,2))*0.5)
*set var Z3 = ((NodesCoord(1,3) + NodesCoord(2,3))*0.5)
*#format "%6i%10.4f%10.4f%10.4f"
*format "%6i%15.9e%15.9e%15.9e"
      NODE*Nd3 *X3 *Y3 *Z3
*end elems
*#------------------------------------------------------
*# create extra nodes for oblique supports
*#------------------------------------------------------
*if(noblique>0)
*set Cond Oblique_Support *nodes
*loop nodes *OnlyInCond
*set var Nd3=Nd3+1
*set var X3 = (NodesCoord(1,real) + Cond(Point2_Delta-X,real))
*set var Y3 = (NodesCoord(2,real) + Cond(Point2_Delta-Y,real))
*set var Z3 = (NodesCoord(3,real) + Cond(Point2_Delta-Z,real))
*format "%6i%15.9e%15.9e%15.9e"
      NODE*Nd3 *X3 *Y3 *Z3
*set var Nd3=Nd3+1
*set var X3 = (NodesCoord(1,real) + Cond(Point3_Delta-X,real))
*set var Y3 = (NodesCoord(2,real) + Cond(Point3_Delta-Y,real))
*set var Z3 = (NodesCoord(3,real) + Cond(Point3_Delta-Z,real))
*format "%6i%15.9e%15.9e%15.9e"
      NODE*Nd3 *X3 *Y3 *Z3
*end nodes
*endif
*#--------------------------------------------------------------------
*# create extra nodes for same nodes ( disconnected degrees )
*#--------------------------------------------------------------------
*if(nSame>0)
*set var Nd3Same = Nd3
*set Cond Line_disconnect_degrees *nodes
*add Cond Point_disconnect_degrees *nodes
*loop nodes *OnlyInCond
*set var Nd3=Nd3+1
*format "%6i%10.4f%10.4f%10.4f"
      NODE*Nd3*NodesCoord(1,real)*NodesCoord(2,real)*NodesCoord(3,real)
*end nodes
*endif
*#--------------------------------------------------------------------
*# Constraints for supports
*#--------------------------------------------------------------------
 FIXATIONS
*Set Cond Line-Constraints *nodes
*add Cond Point-Constraints *nodes
*loop nodes *OnlyInCond
*if(cond(X-Constraint,int)==1) 
*format "%6i"
     BLOCK*NodesNum   F0*\
*else
*format "%6i"
     BLOCK*NodesNum   NO*\
*endif
*if(cond(Y-Constraint,int)==1) 
   F0*\
*else
   NO*\
*endif
*if(cond(Z-Constraint,int)==1)
   F0*\
*else
   NO*\
*endif
*if(cond(ROTX.Constraint,int)==1)
   F0*\
*else
   NO*\
*endif
*if(cond(ROTY.Constraint,int)==1)
   F0*\
*else
   NO*\
*endif
*if(cond(ROTZ.Constraint,int)==1)
   F0*\ 
*else
   NO*\ 
*endif
   NO
*end nodes
*#-----------------------------------------------------------------------
*# Create SAME command for disconnect
*#-----------------------------------------------------------------------
*if(nSame>0)
*set Cond Line_disconnect_degrees *nodes
*add Cond Point_disconnect_degrees *nodes
*set var Nd = ND3Same
*loop nodes *OnlyInCond
*set var Nd=Nd+1
*format "%6i%5i"
      SAME*Nd*NodesNum*\
*if(cond(2,int)==1)
   NO*\
*else
  YES*\
*endif
*if(cond(3,int)==1)
   NO*\
*else
  YES*\
*endif
*if(cond(4,int)==1)
   NO*\
*else
  YES*\
*endif
*if(cond(5,int)==1)
   NO*\
*else
  YES*\
*endif
*if(cond(6,int)==1)
   NO*\
*else
  YES*\
*endif
*if(cond(7,int)==1)
   NO*\
*else
  YES*\
*endif
*if(cond(Disconnect_warping,int)==1)
   NO*\
*else
  YES*\
*endif
  *cond(1)
*end nodes
*endif
   END_FIX
*#-----------------------------------------------------------------------
*# beam element TRANSLATE cards
*#-----------------------------------------------------------------------
*if(nbeams(int)>0)
 NODOFBEAM
*set elems(linear)
*Set cond BEAM_Cross_Section *elems
*loop elems *OnlyInCond
*cond(File-Name)
*format "%5i"
*cond(Number_of_materials,int)
*format "%4i"
 TRANSLATE    1 *cond(Mat1_Global_Nr)
*if(cond(Number_of_materials,int)>1)
*format "%4i"
 TRANSLATE    2 *cond(Mat2_Global_Nr)
*endif
*if(cond(Number_of_materials,int)>2)
*format "%4i"
 TRANSLATE    3 *cond(Mat3_Global_Nr)
*endif
*if(cond(Number_of_materials,int)>3)
*format "%4i"
 TRANSLATE    4 *cond(Mat4_Global_Nr)
*endif
*if(cond(Number_of_materials,int)>4)
*format "%4i"
 TRANSLATE    5 *cond(Mat5_Global_Nr)
*endif
*end elems
*#----------------------------------------------------------------------
*# Output all Local Axes 
*# ---------------------------------------------------------------------
BEGIN_LOCAL_AXES
*loop localaxes
*format "%5i"
*LocalAxesNum
*format "cen %15.10f   %15.10f   %15.10f"
*localAxesDefCenter
*format "x'= %15.10f %* %* %15.10f %* %* %15.10f %* %*"
*localAxesDef
*format "y'=%* %15.10f %* %* %15.10f %* %* %15.10f %*"
*localAxesDef
*format "z'=%*%* %15.10f %* %* %15.10f %* %* %15.10f"
*localAxesDef
*end localaxes
END_LOCAL_AXES
*#-----------------------------------------------------------------------
*# list beam elements which have a Line_Disconnect_Id, C++ will fix .in
*#-----------------------------------------------------------------------
begin_disconnect_beams
*set elems(ALL)
*Set cond Line_Disconnect_Id *elems
*loop elems *OnlyInCond
*set var Nd1 = ElemsConec(1,int)
*set var Nd2 = ElemsConec(2,int)
*format "     ELEM%6i%6i%6i"
*ElemsNum*Nd1*Nd2 *cond(Identifier)
*end elems
end_disconnect_beams
*#-----------------------------------------------------------------------
*# list shell elements which have a Surface_Disconnect_Id, C++ will fix .in
*#-----------------------------------------------------------------------
begin_disconnect_shell
*set elems(ALL)
*Set cond Surface_Disconnect_Id *elems
*loop elems *OnlyInCond
*set var Nd1 = ElemsConec(1,int)
*set var Nd2 = ElemsConec(2,int)
*set var Nd3 = ElemsConec(3,int)
*set var Nd4 = ElemsConec(4,int)
*format "     ELEM%6i%6i%6i%6i%6i"
*ElemsNum*Nd1*Nd2*Nd3*Nd4 *cond(Identifier)
*end elems
end_disconnect_shell
*# ----------------------------------------------------------------------
*# Beam elements
*#-----------------------------------------------------------------------
*set var Nd3(int) = npoin(int)
*set elems(All)
*set elems(linear)
*Set cond BEAM_Cross_Section *elems
*loop elems *OnlyInCond
*set var Nd3 = Nd3 + 1
*format "     ELEM%6i%6i%6i%6i%6i"
*ElemsNum*ElemsConec(1,int)*Nd3*ElemsConec(2,int) *LocalAxesNum *cond(File-Name)
*end elems
*endif
*#----------------------------------------------------------------------
*# SOLID - elements
*#----------------------------------------------------------------------
*if(nsolid)>0
*set elems(All)
*set elems(Hexahedra)
NODOFSOLID
safir.tem
*loop elems 
*format "     ELEM%5i%5i%5i%5i%5i%5i%5i%5i%5i%5i"
*ElemsNum*ElemsConec*ElemsMat    0
*end elems
   END_SYM
*endif
*#----------------------------------------------------------------------
*# SHELL - elements
*#----------------------------------------------------------------------
*if(nshell(int)>0)
*set elems(All)
*set elems(Quadrilateral)
*Set cond SHELL_Section_property *elems
NODOFSHELL
*loop elems *OnlyInCond
*cond(Shell_Temp_File-Name)
*cond(Number_of_shell_materials,int)
*format "%4i"
 TRANSLATE    1 *cond(Shell_Mat1_Global_Nr)
*if(cond(Number_of_shell_materials,int)>1)
*format "%4i"
 TRANSLATE    2 *cond(Shell_Mat2_Global_Nr)
*endif
*if(cond(Number_of_shell_materials,int)>2)
*format "%4i"
 TRANSLATE    3 *cond(Shell_Mat3_Global_Nr)
 END_TRANS
*endif
*end elems
*#set elems(Quadrilateral)
*loop elems *OnlyInCond
*format "     ELEM%6i%6i%6i%6i%6i"
*ElemsNum*ElemsConec(1,int)*ElemsConec(2,int)*ElemsConec(3,int)*ElemsConec(4,int) *cond(Shell_Temp_File-Name)
*end elems
*endif
*#------------------------------------------------------------------------
*# TRUSS elemets
*#------------------------------------------------------------------------
*if(ntruss(int)>0)
*set elems(All)
*set elems(linear)
NODOFTRUSS
*Set cond TRUSS_Cross_Section *elems
*loop elems *OnlyInCond
*cond(1)*\
*format "%10.4e%9.4e%4i"
           *cond(2) *cond(3) *cond(4)
*end elems
*Set cond TRUSS_Cross_Section *elems
*loop elems *OnlyInCond
*format "      ELEM%6i%6i%6i"
*ElemsNum *ElemsConec(1,int) *ElemsConec(2,int) *cond(1) *cond(2) *cond(4)
*end elems
*endif
*#--------------------------------------------------------------------------
*# INCLINE 
*#--------------------------------------------------------------------------
*if(noblique > 0)
*set Cond Oblique_Support *nodes
*set var Nd2 = npoin(int) + nbeams
*loop nodes *OnlyInCond
*set var Nd2=Nd2+1
*set var Nd3=Nd2+1
*format "%4i%4i%4i"
    INCLIN *NodesNum *Nd2 *Nd3
*set var Nd2=Nd2+1
*end nodes
END_INCLIN
*endif
PRECISION *Gendata(PRECISION) 
*#-----------------------------------------------------------------------
*# Loads
*#-----------------------------------------------------------------------
*set elems(All)
     LOADS
*if(strcmp(GenData(LOAD_FUNCTION),"User_Defined")==0)
  FUNCTION        *GenData(Filename.fct)
*else
  FUNCTION        *GenData(LOAD_FUNCTION)
*endif
*#-----------------------------------------------------------------------
*# Point load
*#-----------------------------------------------------------------------
*Set cond Point-Load *nodes 
*loop nodes *OnlyInCond 
*format "  NODELOAD %6i%10.2e%10.2e%10.2e%10.2e%10.2e%10.2e"
*NodesNum*cond(X-Force)*cond(Y-Force)*cond(Z-Force)*cond(X-Moment)*cond(Y-Moment)*cond(Z-Moment)
*end nodes
*#-----------------------------------------------------------------------
*# Distributed Beam Load
*#-----------------------------------------------------------------------
*if(nbeams(int)>1)
*set elems(Linear)
*Set cond Beam-Load *elems
*loop elems *OnlyInCond 
*if(cond(X_Pressure,real)!=0.||cond(Y_Pressure,real)!=0.||cond(Z_Pressure,real)!=0.)
*format " DISTRBEAM %6i%10.2e%10.2e%10.2e"
*ElemsNum*cond(X_Pressure)*cond(Y_Pressure)*cond(Z_Pressure)
*endif
*end elems
*endif
*#-----------------------------------------------------------------------
*# Distributed Shell load
*#-----------------------------------------------------------------------
*if(nshell(int)>0)
*set elems(Quadrilateral)
*Set cond Global_Shell_Load *elems
*loop elems *OnlyInCond
*if(cond(X_Pressure,real)!=0.||cond(Y_Pressure,real)!=0.||cond(Z_Pressure,real)!=0.)
*format "   DISTRSH %6i%10.2e%10.2e%10.2e"
*ElemsNum*cond(X_Pressure)*cond(Y_Pressure)*cond(Z_Pressure)
*endif
*end elems
*endif
  END_LOAD
*#-------------------------------------------------------------------------
*# Massen für DYNAMIC - Calculation 
*#-------------------------------------------------------------------------
*if((strcmp(GenData(Loads),"DYNAMIC_PURE_NR")==0) || (strcmp(GenData(Loads),"DYNAMIC_APPR_NR")==0))
      MASS
*Set cond Mass_on_Node *nodes
*loop nodes *OnlyInCond 
*format "    M_NODE %6i%10.2e%10.2e%10.2e"
*ElemsNum *cond(Mass_1) *cond(Mass_2) *cond(Mass_3)
*end nodes
*set elems(all)
*Set cond Mass_on_Beam *elems
*loop elems *OnlyInCond 
*format "    M_BEAM %6i%10.2e%10.2e"
*ElemsNum *cond(Distributed-Beam-Mass) *cond(Rotational-Inertia)
*end elems
*Set cond Mass_on_Shell *elems
*loop elems *OnlyInCond 
*format "   M_SHELL %6i%10.2e"
*ElemsNum*cond(Distributed-Shell-Mass)
*end elems
  END_MASS
*endif
*#-----------------------------------------------------------------
*# Materials
*#-----------------------------------------------------------------
 MATERIALS
*if(Gendata(Number_of_materials,INT)>0)
*GenData(Material1)
*if(strcmp(Gendata(Material1),"STEELEC3")==0 || strcmp(Gendata(Material1),"STEELEC3DC")==0 || strcmp(Gendata(Material1),"STEELEC2")==0 || strcmp(Gendata(Material1),"PSTEELA16")==0  || strcmp(Gendata(Material1),"STEELEC32D")==0)
*format "%10.2e%10.2e%10.2e"
         *Gendata(Mat1_E-Modulus) *Gendata(Mat1_Poisson_ratio) *Gendata(Mat1_Yield_strength)  1200.   0.
*elseif(strcmp(Gendata(Material1),"SILCONC_EN")==0 || strcmp(Gendata(Material1),"CALCONC_EN")==0 || strcmp(Gendata(Material1),"SILCONC2D")==0 || strcmp(Gendata(Material1),"CALCONC2D")==0 )
*format "%10.2e%10.2e%10.2e"
          *Gendata(Mat1_Poisson_ratio) *Gendata(Mat1_Compressive_strength) *Gendata(Mat1_Tension_strength)   0.0
*elseif(strcmp(Gendata(Material1),"ELASTIC")==0 )
*format "%10.2e%10.2e"
           *Gendata(Mat1_E-Modulus) *Gendata(Mat1_Poisson_ratio)
*elseif(strcmp(Gendata(Material1),"WOODEC5")==0)
*format "%10.2e%10.2e%10.2e%10.2e"
          *Gendata(Mat1_E-Modulus) *Gendata(Mat1_Poisson_ratio) *Gendata(Mat1_Compressive_strength) *Gendata(Mat1_Tension_strength)
*else
    
*endif
*endif
*if(Gendata(Number_of_materials,INT)>1)
*GenData(Material2)
*if(strcmp(Gendata(Material2),"STEELEC3")==0 || strcmp(Gendata(Material2),"STEELEC3DC")==0 || strcmp(Gendata(Material2),"STEELEC2")==0 || strcmp(Gendata(Material2),"PSTEELA16")==0  || strcmp(Gendata(Material2),"STEELEC32D")==0)
*format "%10.2e%10.2e%10.2e"
         *Gendata(Mat2_E-Modulus) *Gendata(Mat2_Poisson_ratio) *Gendata(Mat2_Yield_strength)   1200.  0.
*elseif(strcmp(Gendata(Material2),"SILCONC_EN")==0 || strcmp(Gendata(Material2),"CALCONC_EN")==0 || strcmp(Gendata(Material2),"SILCONC2D")==0 || strcmp(Gendata(Material2),"CALCONC2D")==0 )
*format "%10.2e%10.2e%10.2e"
          *Gendata(Mat2_Poisson_ratio) *Gendata(Mat2_Compressive_strength) *Gendata(Mat2_Tension_strength)   0.0
*elseif(strcmp(Gendata(Material2),"ELASTIC")==0 )
*format "%10.2e%10.2e"
           *Gendata(Mat2_E-Modulus) *Gendata(Mat2_Poisson_ratio)
*elseif(strcmp(Gendata(Material1),"WOODEC5")==0)
*format "%10.2e%10.2e%10.2e%10.2e"
          *Gendata(Mat2_E-Modulus) *Gendata(Mat2_Poisson_ratio) *Gendata(Mat2_Compressive_strength) *Gendata(Mat2_Tension_strength)
*else
   
*endif
*endif
*if(Gendata(Number_of_materials,INT)>2)
*GenData(Material3)
*if(strcmp(Gendata(Material3),"STEELEC3")==0 || strcmp(Gendata(Material3),"STEELEC3DC")==0 || strcmp(Gendata(Material3),"STEELEC2")==0 || strcmp(Gendata(Material3),"PSTEELA16")==0  || strcmp(Gendata(Material3),"STEELEC32D")==0)
*format "%10.2e%10.2e%10.2e"
         *Gendata(Mat3_E-Modulus) *Gendata(Mat3_Poisson_ratio) *Gendata(Mat3_Yield_strength)  1200.  0.
*elseif(strcmp(Gendata(Material3),"SILCONC_EN")==0 || strcmp(Gendata(Material3),"CALCONC_EN")==0 || strcmp(Gendata(Material3),"SILCONC2D")==0 || strcmp(Gendata(Material3),"CALCONC2D")==0 )
*format "%10.2e%10.2e%10.2e"
          *Gendata(Mat3_Poisson_ratio) *Gendata(Mat3_Compressive_strength) *Gendata(Mat3_Tension_strength)   0.0
*elseif(strcmp(Gendata(Material3),"ELASTIC")==0 )
           *Gendata(Mat3_E-Modulus) *Gendata(Mat3_Poisson_ratio)
*format "%10.2e%10.2e"
*else
   
*endif
*endif
*if(Gendata(Number_of_materials,INT)>3)
*GenData(Material4)
*if(strcmp(Gendata(Material4),"STEELEC3")==0 || strcmp(Gendata(Material4),"STEELEC3DC")==0 || strcmp(Gendata(Material4),"STEELEC2")==0 || strcmp(Gendata(Material4),"PSTEELA16")==0  || strcmp(Gendata(Material4),"STEELEC32D")==0)
*format "%10.2e%10.2e%10.2e"
         *Gendata(Mat4_E-Modulus) *Gendata(Mat4_Poisson_ratio) *Gendata(Mat4_Yield_strength)   1200.  0.
*elseif(strcmp(Gendata(Material4),"SILCONC_EN")==0 || strcmp(Gendata(Material4),"CALCONC_EN")==0 || strcmp(Gendata(Material4),"SILCONC2D")==0 || strcmp(Gendata(Material4),"CALCONC2D")==0 )
*format "%10.2e%10.2e%10.2e"
          *Gendata(Mat4_Poisson_ratio) *Gendata(Mat4_Compressive_strength) *Gendata(Mat4_Tension_strength)   0.0
*elseif(strcmp(Gendata(Material4),"ELASTIC")==0 )
           *Gendata(Mat4_E-Modulus) *Gendata(Mat4_Poisson_ratio)
*format "%10.2e%10.2e"
*else
   
*endif
*endif
*if(Gendata(Number_of_materials,INT)>4)
*GenData(Material5)
*if(strcmp(Gendata(Material5),"STEELEC3")==0 || strcmp(Gendata(Material5),"STEELEC3DC")==0 || strcmp(Gendata(Material5),"STEELEC2")==0 || strcmp(Gendata(Material5),"PSTEELA16")==0  || strcmp(Gendata(Material5),"STEELEC32D")==0)
*format "%10.2e%10.2e%10.2e"
         *Gendata(Mat5_E-Modulus) *Gendata(Mat5_Poisson_ratio) *Gendata(Mat5_Yield_strength)  1200.  0.
*elseif(strcmp(Gendata(Material5),"SILCONC_EN")==0 || strcmp(Gendata(Material5),"CALCONC_EN")==0 || strcmp(Gendata(Material5),"SILCONC2D")==0 || strcmp(Gendata(Material5),"CALCONC2D")==0 )
*format "%10.2e%10.2e%10.2e"
          *Gendata(Mat5_Poisson_ratio) *Gendata(Mat5_Compressive_strength) *Gendata(Mat5_Tension_strength)   0.0
*elseif(strcmp(Gendata(Material5),"ELASTIC")==0 )
           *Gendata(Mat5_E-Modulus) *Gendata(Mat5_Poisson_ratio)
*format "%10.2e%10.2e"
*else
   
*endif
*endif
      TIME
*if((strcmp(GenData(Loads),"DYNAMIC_PURE_NR")==0) || (strcmp(GenData(Loads),"DYNAMIC_APPR_NR")==0))
*format "%10.1f%10.1f%10.1f"
*GenData(TIMESTEP) *GenData(UPTIME) *GenData(TIMESTEPMAX)
*else
*format "%10.1f%10.1f"
*GenData(TIMESTEP) *GenData(UPTIME)
*endif
   ENDTIME
     EPSTH
IMPRESSION
 TIMEPRINT
*format "%10.1f%10.1f"
*GenData(TIMEPRINT) *GenData(UPTIME)
END_TIMEPR
*if(strcmp(Gendata(PRINTDEPL_Print_displacement_variation),"yes")==0)
 PRINTDEPL
*endif
*if(strcmp(Gendata(PRINTTMPRT_Print_temperatures_in_the_fibers),"yes")==0)
PRINTTMPRT
*endif
*if(strcmp(Gendata(PRINTVELAC_Print_velocity_and_acceleration),"yes")==0)
PRINTVELAC
*endif
*if(strcmp(Gendata(PRINTFHE_Print_out_of_balance_forces),"yes")==0)
  PRINTFHE
*endif
*if(strcmp(Gendata(PRINTREACT_Print_reactions),"yes")==0)
PRINTREACT
*endif
*if(strcmp(Gendata(PRINTMN_Print_internal_forces_of_beams),"yes")==0)
   PRINTMN
*endif
*if(strcmp(Gendata(PRINTSHELL_Print_stresses_in_shell_elements),"yes")==0)
PRINTSHELL
*endif
*if(strcmp(Gendata(PRNNXSHELL_Print_membran_forces_in_shell_elements),"yes")==0)
PRNNXSHELL
*endif
*if(strcmp(Gendata(PRNNXSHELL_Print_bending_moments_in_shell_elements),"yes")==0)
PRNMXSHELL
*endif
