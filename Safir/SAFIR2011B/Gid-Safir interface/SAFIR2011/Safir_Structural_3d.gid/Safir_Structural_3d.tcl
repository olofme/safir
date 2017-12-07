#comet.tcl  -*- TCL -*-
#---------------------------------------------------------------------------
#This file is written in TCL lenguage 
#For more information about TCL look at: http://www.sunlabs.com/research/tcl/
#
#At least two procs must be in this file:
#
#    InitGIDProject dir - Will be called whenever a project is begun to be used.
#           where dir is the project's directory
#    EndGIDProject - Will be called whenever a project ends to be used.
#
#For more information about GID internals, check the program scripts.
#---------------------------------------------------------------------------



proc InitGIDProject { dir } {

    global ProgramName
    set ProgramName Safir_Structural_3D

    GidChangeDataLabel "Materials" ""
    GidChangeDataLabel "Conditions" ""
    GidChangeDataLabel "Problem Data" ""
    GidChangeDataLabel "Interval" ""
    RemoveMenuOption "Data" "Materials" "PRE"
    GidAddUserDataOptions Constraints "GidOpenConditions Constraints" 2
    GidAddUserDataOptions "---" "" 3
    GidAddUserDataOptions Connections "GidOpenConditions Connections" 4
    GidAddUserDataOptions "---" "" 5
    GidAddUserDataOptions Loads "GidOpenConditions Loads" 6
    GidAddUserDataOptions "---" "" 7
    GidAddUserDataOptions "Properties" "GidOpenConditions Properties" 8
    GidAddUserDataOptions "---" "" 9
    GidAddUserDataOptions "Mass" "GidOpenConditions {Mass for Dynamic Calculation}" 10
    GidAddUserDataOptions "---" "" 11
    GidAddUserDataOptions "Problem Data" "GidOpenProblemData General" 12
    GidAddUserDataOptions "---" "" 13
    GidAddUserDataOptions "Material" "GidOpenProblemData Material" 14
    GidAddUserDataOptions "---" "" 15
    GidAddUserDataOptions "---" "" 17

    global GidPriv
    set GidPriv(ProgName) $ProgramName
    ChangeWindowTitle

    UpdateMenus
}

proc WriteMaterialData {num} {

  return [ .central.s info gendata]

}

namespace eval DisconnectConditions {
    variable Identifier
}

proc DisconnectConditions::ComunicateWithGiD { op args } {
    variable Identifier
    switch $op {
	"INIT" {
	    set PARENT [lindex $args 0]
	    upvar      [lindex $args 1] ROW 
	    set GDN [lindex $args 2]
  	    set STRUCT [lindex $args 3]

	    global $GDN
	    upvar \#0 $GDN GidData

	    set cndname [lindex [split $STRUCT ,] 1]
	    switch $cndname {
		Point_disconnect_degrees - Line_disconnect_degrees {
		    set Identifier $GidData($STRUCT,VALUE,2)
		}
		Line_disconnect_Id - Surface_disconnect_Id {
		    set Identifier $GidData($STRUCT,VALUE,1)
		}
		default {
		    if { ![info exists Identifier] } {
			set Identifier Id1
		    }
		}
	    }

	    set l [label $PARENT.l$ROW -text "Identifier:"]
	    set c [ComboBox $PARENT.c$ROW \
		    -textvariable DisconnectConditions::Identifier \
		    -values {Id1 Id2 Id3 Id4 Id5 Id6 Id7 Id8 Id9}]
	    
	    grid $l -row $ROW -column 0 -sticky e
	    grid $c -row $ROW -column 1 -sticky w -pady 3

	    if { [info exists $GDN\($STRUCT,HELP,0\)] } {
		GidHelp "$l $c" [subst $GidData($STRUCT,HELP,0)]
	    }
	    return ""
	}
	"SYNC" {
	    set GDN [lindex $args 0]
  	    set STRUCT [lindex $args 1]

	    set Identifier [string trim $Identifier]
            set ll [string length $Identifier]
	    regsub -all " \t"  $Identifier {} Identifier
	    if { $ll > 4 || ![regexp {^[a-zA-Z0-9]} $Identifier] } {
		return [list ERROR \
			"Identifier must be a name with max 4 characters that begins with a letter or number"]
	    }
	    DWLocalSetValue $GDN $STRUCT Identifier $Identifier
	    return ""
	}
    }
}
