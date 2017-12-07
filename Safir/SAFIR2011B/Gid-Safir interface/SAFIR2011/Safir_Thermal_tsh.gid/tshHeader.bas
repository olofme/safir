*GenData(Title_1)
*GenData(Title_2)

*set var n2(int)=npoin/2
*loop nodes
*if(LoopVar == 1)
*set var YU=NodesCoord(2)
*endif
*if(LoopVar == n2)
*set var YO=NodesCoord(2)
*endif
*end nodes
*set var thick=YO - YU
*format "%9.3f"
 THICKNESS*thick
  MATERIAL    1
    REBARS    *GenData(Rebars)
*if(GenData(Rebars,int) > 0 )
  MATERIAL    *GenData(Rebar1_MATERIAL)
   SECTION    *GenData(Rebar1_SECTION)
     LEVEL    *GenData(Rebar1_LEVEL)
     ANGLE    *GenData(Rebar1_ANGLE)
*endif
*if(GenData(Rebars,int) > 1 )
  MATERIAL    *GenData(Rebar2_MATERIAL)
   SECTION    *GenData(Rebar2_SECTION)
     LEVEL    *GenData(Rebar2_LEVEL)
     ANGLE    *GenData(Rebar2_ANGLE)
*endif
*if(GenData(Rebars,int) > 2 )
  MATERIAL    *GenData(Rebar3_MATERIAL)
   SECTION    *GenData(Rebar3_SECTION)
     LEVEL    *GenData(Rebar3_LEVEL)
     ANGLE    *GenData(Rebar3_ANGLE)
*endif
*if(GenData(Rebars,int) > 3 )
  MATERIAL    *GenData(Rebar4_MATERIAL)
   SECTION    *GenData(Rebar4_SECTION)
     LEVEL    *GenData(Rebar4_LEVEL)
     ANGLE    *GenData(Rebar4_ANGLE)
*endif


