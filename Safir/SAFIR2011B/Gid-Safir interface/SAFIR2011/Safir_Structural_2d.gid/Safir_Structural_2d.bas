InputFile created with GiD-SAFIR2011_OLI Interface
*GenData(Title_1)
*GenData(Title_2)

*#---------------------------------------------------------------
*if(IsQuadratic)
*MessageBox error: Quadratic elements are not permitted.
*endif
*#---------------------------------------------------------------
*# Count number of oblique supports
*#---------------------------------------------------------------
*set Cond Oblique_Support *nodes
*set var noblique(int)=CondNumEntities
*#---------------------------------------------------------------
*# Count number of disconnected degrees of freedom (same - command )
*#---------------------------------------------------------------
*set Cond Point_disconnect_degrees *nodes
*set var noSame(int)=CondNumEntities
*#---------------------------------------------------------------
*Set Cond TRUSS_Cross_Section *elems
*set var ntruss(int)=CondNumEntities
*Set Cond BEAM_Cross_Section *elems
*set var nbeams(int)=CondNumEntities
*set var nbt(int) = nbeams(int) + ntruss(int)
*#if(nelem(Linear)!=nbt)
*#MessageBox Error: Not all linear entities have a BEAM or TRUSS property !
*#endif
*#----------------------------------------------------------------
*# Note: all beam and truss elements must be linear ( elements with 2 nodes)
*# for beam elements the 3rd (middle) node is created in this skript !!
*#----------------------------------------------------------------
*set var Nd3 = npoin(int)
*set var Ndmax(int) = npoin(int) + nbeams(int) + noblique(int) + noSame(int)
*#----------------------------------------------------------------
*format "%5i"
     NNODE*Ndmax
      NDIM    2
*format "%4i"
*if((nbeams(int) > 0) && (ntruss(int) > 0))
   NDDLMAX    3
EVERY_NODE    2
*Set Cond BEAM_Cross_Section *elems
*loop elems *OnlyInCond
*format "      FROM %4i   TO %4i STEP    1 NDDL    3"
*ElemsConec(1,int) *ElemsConec(1,int)
*format "      FROM %4i   TO %4i STEP    1 NDDL    3"
*ElemsConec(2,int) *ElemsConec(2,int)
*end elems
*elseif(nbeams(int) > 0) && (ntruss(int) == 0)
   NDDLMAX    3
EVERY_NODE    3
*elseif(ntruss(int) > 0) && (nbeams(int) == 0)
   NDDLMAX    2
EVERY_NODE    2
*endif
*Set Cond BEAM_Cross_Section *elems
*loop elems *OnlyInCond
*#-- create node Nr for middle node of beams ------------------------------
*set var Nd3=Operation(ND3(int)+1)
*format "      FROM %6i   TO %6i STEP    1 NDDL    1"
*Nd3 *Nd3
*end elems
*#--------------------------------------------------------------------------
*# for 2. point of oblique supports set NDDL = 0
*#--------------------------------------------------------------------------
*if(noblique > 0)
*set Cond Oblique_Support *nodes
*loop nodes *OnlyInCond
*set var Nd3=Operation(ND3(int)+1)
*format "      FROM %6i   TO %6i STEP    1 NDDL    0"
*Nd3 *Nd3
*end nodes
*endif
*#--------------------------------------------------------------------------
*# For SAME-Points
*#--------------------------------------------------------------------------
*if(noSame > 0)
*set Cond Point_disconnect_degrees *nodes
*loop nodes *OnlyInCond
*set var Nd3=Operation(ND3(int)+1)
*format "      FROM %6i   TO %6i STEP    1 NDDL    3"
*Nd3 *Nd3
*end nodes
*endif
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
*if(strcmp(GenData(Mode),"STATIC_PURE_NR")==0)
    STATIC   PURE_NR
*elseif(strcmp(GenData(Mode),"STATIC_APPR_NR")==0)
    STATIC   APPR_NR
*elseif(strcmp(GenData(Mode),"DYNAMIC_PURE_NR")==0)
   DYNAMIC   PURE_NR
*elseif(strcmp(GenData(Mode),"DYNAMIC_APPR_NR")==0)
   DYNAMIC   APPR_NR
*elseif(strcmp(GenData(Mode),"STATICCOLD_PURE_NR")==0)
STATICCOLD   PURE_NR
*elseif(strcmp(GenData(Mode),"STATICCOLD_APPR_NR")==0)
STATICCOLD   APPR_NR
*else
*Gendata(Mode)
*endif
*format "%4i"
*#     NLOAD *Gendata(NLOAD_(Number_of_load_vectors))
     NLOAD    1
*format "%4i"
   OBLIQUE *noblique 
*if(strcmp(GenData(Convergence),"COMEBACK")==0)
  COMEBACK  *GenData(TimestepMin)
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
*format "%4i%5i"
      BEAM *nbeams *Gendata(NGEOBEAM)
        NG *Gendata(NG)
*format "%6i"
    NFIBER *Gendata(NFIBERBEAM)
*endif
*if(ntruss>0)
*format "%4i%5i"
     TRUSS *ntruss *Gendata(NGEOTRUSS)
*endif
  END_ELEM
     NODES
*loop nodes
*format "%6i%10.4f%10.4f"
      NODE*NodesNum*NodesCoord(1,real)*NodesCoord(2,real)
*end nodes
*#-------------------------------------------------------
*# create middle node for beams
*#-------------------------------------------------------
*set var Nd3(int) = npoin(int)
*Set Cond BEAM_Cross_Section *elems
*loop elems *OnlyInCond
*set var Nd3=ND3+1
*set var X3 = ((NodesCoord(1,1) + NodesCoord(2,1))*0.5)
*set var Y3 = ((NodesCoord(1,2) + NodesCoord(2,2))*0.5)
*format "%6i%10.4f%10.4f"
      NODE*Nd3*X3*Y3
*end elems
*#------------------------------------------------------
*# create extra nodes for oblique supports
*#------------------------------------------------------
*if(noblique>0)
*set Cond Oblique_Support *nodes
*loop nodes *OnlyInCond
*set var Nd3=ND3+1
*set var X3 = (NodesCoord(1,real) + Cond(Delta-X,real))
*set var Y3 = (NodesCoord(2,real) + Cond(Delta-Y,real))
*format "%6i%10.4f%10.4f"
      NODE*Nd3*X3*Y3
*end nodes
*endif
*#------------------------------------------------------
*# create extra nodes for same nodes ( disconnected degrees )
*#------------------------------------------------------
*if(noSame>0)
*set Cond Point_disconnect_degrees *nodes
*set var Nd3Same = ND3
*loop nodes *OnlyInCond
*set var Nd3=ND3+1
*format "%6i%10.4f%10.4f"
      NODE*Nd3*NodesCoord(1,real)*NodesCoord(2,real)
*end nodes
*endif
*#--------------------------------------------------------------------
*# Constraints for supports
*#--------------------------------------------------------------------
 FIXATIONS
*Set Cond Point-Constraints *nodes
*loop nodes *OnlyInCond
*if(strcmp(cond(1),"-GLOBAL-")!=0)
*MessageBox error: This version of GiD-Safir supports only -GLOBAL- point constraints !
*endif
*if(cond(2,int)==1)
*format "%5i"
     BLOCK*NodesNum   F0*\
*else
*format "%5i"
     BLOCK*NodesNum   NO*\
*endif
*if(cond(3,int)==1)
   F0*\
*else
   NO*\
*endif
*if(cond(4,int)==1)
   F0
*else
   NO
*endif
*end nodes
*#-----------------------------------------------------------------------
*# Create SAME command for disconnect
*#-----------------------------------------------------------------------
*if(noSame>0)
*set Cond Point_disconnect_degrees *nodes
*set var Nd = ND3Same
*loop nodes *OnlyInCond
*set var Nd=ND+1
*format "%10i%10i"
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
  *cond(1)
*end nodes
*endif
   END_FIX
*# ----------------------------------------------------------------------
*# Beam elements
*#-----------------------------------------------------------------------
*if(nbeams(int)>0)
 NODOFBEAM
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
 TRANSLATE    4 *cond(Mat3_Global_Nr)
*endif
*if(cond(Number_of_materials,int)>4)
*format "%4i"
 TRANSLATE    5 *cond(Mat3_Global_Nr)
*endif
*# END_TRANS
*end elems
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
*#----------------------------------------------------------------------
*# output .tem file name for all beams
*#----------------------------------------------------------------------
*set elems(ALL)
*set var Nd3(int) = npoin(int)
*Set cond BEAM_Cross_Section *elems
*loop elems *OnlyInCond
*set var Nd3 = Nd3 + 1
*set var Nd1 = ElemsConec(1,int)
*set var Nd2 = ElemsConec(2,int)
*format "     ELEM%6i%6i%6i%6i"
*ElemsNum*Nd1*Nd3*Nd2 *cond(File-Name)
*end elems
*endif
*#------------------------------------------------------------------------
*# TRUSS elemets
*#------------------------------------------------------------------------
*if(ntruss(int)>0)
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
*ElemsNum*ElemsConec(1,int)*ElemsConec(2,int) *cond(1) *cond(2) *cond(4)
*end elems
*endif
*#--------------------------------------------------------------------------
*# INCLINE 
*#--------------------------------------------------------------------------
*if(noblique > 0)
*set Cond Oblique_Support *nodes
*set var Nd = npoin(int) + nbeams
*loop nodes *OnlyInCond
*set var Nd=Nd+1
*format "%4i%4i"
    INCLIN *NodesNum *Nd
*end nodes
END_INCLIN
*endif
*#----------------------------------------------------------------------------
*# Loads
*#----------------------------------------------------------------------------
PRECISION *Gendata(PRECISION)
     LOADS
*Set cond Point-Load *nodes *CanRepeat
*if(strcmp(GenData(LOAD_FUNCTION),"User_Defined")==0)
  FUNCTION        *GenData(Filename.fct)
*else
  FUNCTION        *GenData(LOAD_FUNCTION)
*endif
*loop nodes *OnlyInCond 
*format "  NODELOAD %4i%10.2e%10.2e%10.2e"
*NodesNum*cond(1)*cond(2)*cond(3)
*end nodes
*Set cond Beam-Load *elems *CanRepeat
*loop elems *OnlyInCond 
*format " DISTRBEAM %4i%10.2e%10.2e"
*ElemsNum*cond(1)*cond(2)       0.0
*end elems
  END_LOAD
*#-----------------------------------------------------------------------------
*# Masses for DYNAMIC - Calculation 
*#-----------------------------------------------------------------------------
*if((strcmp(GenData(Mode),"DYNAMIC_PURE_NR")==0) || (strcmp(GenData(Mode),"DYNAMIC_APPR_NR")==0))
      MASS
*Set cond Mass_on_Node *nodes
*loop nodes *OnlyInCond 
*format "    M_NODE %4i%10.2e%10.2e"
*NodesNum *cond(Mass_1) *cond(Mass_2)
*end nodes
*set elems(ALL)
*Set cond Mass_on_Beam *elems
*loop elems *OnlyInCond 
*format "    M_BEAM %4i%10.2e"
*ElemsNum *cond(Distributed-Beam-Mass)
*end elems
  END_MASS
*endif
*#-----------------------------------------------------------------------------
*# Materials
*#-----------------------------------------------------------------------------
 MATERIALS
*if(Gendata(Number_of_materials,INT)>0)
*GenData(Material1)
*if(strcmp(Gendata(Material1),"STEELEC3")==0 || strcmp(Gendata(Material1),"STEELEC3DC")==0 || strcmp(Gendata(Material1),"STEELEC2")==0 || strcmp(Gendata(Material2),"PSTEELA16")==0)
*format "%10.2e%10.2e%10.2e"
         *Gendata(Mat1_E-Modulus) *Gendata(Mat1_Poisson_ratio) *Gendata(Mat1_Yield_strength)  1200.  0.
*elseif(strcmp(Gendata(Material1),"SILCONC_EN")==0 || strcmp(Gendata(Material1),"CALCONC_EN")==0 )
*format "%10.2e%10.2e%10.2e"
          *Gendata(Mat1_Poisson_ratio) *Gendata(Mat1_Compressive_strength) *Gendata(Mat1_Tension_strength)   0.0
*elseif(strcmp(Gendata(Material1),"ELASTIC")==0 )
*format "%10.2e%10.2e"
           *Gendata(Mat1_E-Modulus) *Gendata(Mat1_Poisson_ratio)
*elseif(strcmp(Gendata(Material1),"WOODEC5")==0)
*format "%10.2e%10.2e%10.2e%10.2e"
          *Gendata(Mat2_E-Modulus) *Gendata(Mat2_Poisson_ratio) *Gendata(Mat2_Compressive_strength) *Gendata(Mat2_Tension_strength)
*else
    
*endif
*endif
*if(Gendata(Number_of_materials,INT)>1)
*GenData(Material2)
*if(strcmp(Gendata(Material2),"STEELEC3")==0 || strcmp(Gendata(Material2),"STEELEC3DC")==0 || strcmp(Gendata(Material2),"STEELEC2")==0 || strcmp(Gendata(Material2),"PSTEELA16")==0)
*format "%10.2e%10.2e%10.2e"
         *Gendata(Mat2_E-Modulus) *Gendata(Mat2_Poisson_ratio) *Gendata(Mat2_Yield_strength) 1200.  0.
*elseif(strcmp(Gendata(Material2),"SILCONC_EN")==0 || strcmp(Gendata(Material2),"CALCONC_EN")==0 )
*format "%10.2e%10.2e%10.2e"
          *Gendata(Mat2_Poisson_ratio) *Gendata(Mat2_Compressive_strength) *Gendata(Mat2_Tension_strength)   0.0
*elseif(strcmp(Gendata(Material2),"ELASTIC")==0 )
*format "%10.2e%10.2e"
           *Gendata(Mat2_E-Modulus) *Gendata(Mat2_Poisson_ratio)
*elseif(strcmp(Gendata(Material2),"WOODEC5")==0)
*format "%10.2e%10.2e%10.2e%10.2e"
          *Gendata(Mat2_E-Modulus) *Gendata(Mat2_Poisson_ratio) *Gendata(Mat2_Compressive_strength) *Gendata(Mat2_Tension_strength)
*else
   
*endif
*endif
*if(Gendata(Number_of_materials,INT)>2)
*GenData(Material3)
*if(strcmp(Gendata(Material3),"STEELEC3")==0 || strcmp(Gendata(Material3),"STEELEC3DC")==0 || strcmp(Gendata(Material3),"STEELEC2")==0 || strcmp(Gendata(Material3),"PSTEELA16")==0)
*format "%10.2e%10.2e%10.2e"
         *Gendata(Mat3_E-Modulus) *Gendata(Mat3_Poisson_ratio) *Gendata(Mat3_Yield_strength)  1200.  0.
*elseif(strcmp(Gendata(Material3),"SILCONC_EN")==0 || strcmp(Gendata(Material3),"CALCONC_EN")==0 )
*format "%10.2e%10.2e%10.2e"
          *Gendata(Mat3_Poisson_ratio) *Gendata(Mat3_Compressive_strength) *Gendata(Mat3_Tension_strength)   0.0
*elseif(strcmp(Gendata(Material3),"ELASTIC")==0 )
*format "%10.2e%10.2e"
           *Gendata(Mat3_E-Modulus) *Gendata(Mat3_Poisson_ratio)
*elseif(strcmp(Gendata(Material3),"WOODEC5")==0)
*format "%10.2e%10.2e%10.2e%10.2e"
          *Gendata(Mat2_E-Modulus) *Gendata(Mat2_Poisson_ratio) *Gendata(Mat2_Compressive_strength) *Gendata(Mat2_Tension_strength)
*else
   
*endif
*endif
*if(Gendata(Number_of_materials,INT)>3)
*GenData(Material4)
*if(strcmp(Gendata(Material4),"STEELEC3")==0 || strcmp(Gendata(Material4),"STEELEC3DC")==0 || strcmp(Gendata(Material4),"STEELEC2")==0 || strcmp(Gendata(Material4),"PSTEELA16")==0)
*format "%10.2e%10.2e%10.2e"
         *Gendata(Mat4_E-Modulus) *Gendata(Mat4_Poisson_ratio) *Gendata(Mat4_Yield_strength)  1200.  0.
*elseif(strcmp(Gendata(Material4),"SILCONC_EN")==0 || strcmp(Gendata(Material4),"CALCONC_EN")==0 )
*format "%10.2e%10.2e%10.2e"
          *Gendata(Mat4_Poisson_ratio) *Gendata(Mat4_Compressive_strength) *Gendata(Mat4_Tension_strength)   0.0
*elseif(strcmp(Gendata(Material4),"ELASTIC")==0 )
*format "%10.2e%10.2e"
           *Gendata(Mat4_E-Modulus) *Gendata(Mat4_Poisson_ratio)
*elseif(strcmp(Gendata(Material4),"WOODEC5")==0)
*format "%10.2e%10.2e%10.2e%10.2e"
          *Gendata(Mat2_E-Modulus) *Gendata(Mat2_Poisson_ratio) *Gendata(Mat2_Compressive_strength) *Gendata(Mat2_Tension_strength)
*else
   
*endif
*endif
*if(Gendata(Number_of_materials,INT)>4)
*GenData(Material5)
*if(strcmp(Gendata(Material5),"STEELEC3")==0 || strcmp(Gendata(Material5),"STEELEC3DC")==0 || strcmp(Gendata(Material5),"STEELEC2")==0 || strcmp(Gendata(Material5),"PSTEELA16")==0)
*format "%10.2e%10.2e%10.2e"
         *Gendata(Mat5_E-Modulus) *Gendata(Mat5_Poisson_ratio) *Gendata(Mat5_Yield_strength)  1200.   0.
*elseif(strcmp(Gendata(Material5),"SILCONC_EN")==0 || strcmp(Gendata(Material5),"CALCONC_EN")==0 )
*format "%10.2e%10.2e%10.2e"
          *Gendata(Mat5_Poisson_ratio) *Gendata(Mat5_Compressive_strength) *Gendata(Mat5_Tension_strength)   0.0
*elseif(strcmp(Gendata(Material5),"ELASTIC")==0 )
*format "%10.2e%10.2e"
           *Gendata(Mat5_E-Modulus) *Gendata(Mat5_Poisson_ratio)
*elseif(strcmp(Gendata(Material5),"WOODEC5")==0)
*format "%10.2e%10.2e%10.2e%10.2e"
          *Gendata(Mat2_E-Modulus) *Gendata(Mat2_Poisson_ratio) *Gendata(Mat2_Compressive_strength) *Gendata(Mat2_Tension_strength)
*else
   
*endif
*endif
      TIME
*if((strcmp(GenData(Mode),"DYNAMIC_PURE_NR")==0) || (strcmp(GenData(Mode),"DYNAMIC_APPR_NR")==0))
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

