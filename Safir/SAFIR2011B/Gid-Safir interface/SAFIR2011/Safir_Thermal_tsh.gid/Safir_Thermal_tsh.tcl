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
    global NumMenus MenuNames MenuEntries MenuCommands MenuAcceler
    global ProgramName
    set ProgramName Safir_Thermal_tsh

    GidChangeDataLabel "Interval" ""
    GidChangeDataLabel "Local axes" ""

    #set NumMenus 7
    #set MenuNames {Files View Geometry Utilities Data Meshing Calculate Shell_Section \
    #	    Help}
    
    #set MenuEntries(8) $MenuEntries(7)
    #set MenuCommands(8) $MenuCommands(7)
    #set MenuAcceler(8) $MenuAcceler(7)
    
    #set MenuEntries(7) { "Shell - Section" }
    #set MenuCommands(7) { {-np- SSection} }
    #set MenuAcceler(7) { "" }
    #CreateTopMenus

    GidChangeDataLabel "Interval" ""
    #RemoveMenuOption "Data" "Interval" "PRE"

    global GidPriv
    set GidPriv(ProgName) $ProgramName
    ChangeWindowTitle

    UpdateMenus

    set nNodes [ GiD_Info Mesh MaxNumNodes ]
    
    if { $nNodes < 1 } {

    	SSection
 
    }
}

proc SSection { } {

    global ParamsShell
    set w .gid.shellSection

    set ParamsShell(t) ""
    set ParamsShell(n) ""
 
    InitWindow $w "Create Shell-Section" ParametricWindowGeom
    frame $w.frmEquations
    label $w.frmEquations.lt -text "Shell_Thickness(t) in meter"
    entry $w.frmEquations.et -width 6 -relief sunken -width 5 -textvariable ParamsShell(t)
    label $w.frmEquations.ln -text "Number_of_Elements(n)"
    entry $w.frmEquations.en -width 6 -relief sunken -width 5 -textvariable ParamsShell(n)

    set def_back [$w cget -background]
    frame $w.frmButtons -bg [CCColorActivo $def_back]
    button $w.frmButtons.btnApply -text "Apply" \
	    -command "DrawShellSection $w" \
	    -underline 0 -width 6
    button $w.frmButtons.btnclose -text "Close" \
	    -command "destroy $w" \
	    -underline 0 -width 6
    grid $w.frmEquations -padx 5 -pady 5 -sticky ew    
    grid $w.frmEquations.lt $w.frmEquations.et -sticky e
    grid $w.frmEquations.ln $w.frmEquations.en -sticky e
 
    grid $w.frmButtons -sticky ews -columnspan 7
    grid $w.frmButtons.btnApply $w.frmButtons.btnclose -padx 5 -pady 6
    grid columnconf $w "0" -weight 1
    grid rowconfigure $w "3" -weight 1
    
    focus $w.frmButtons.btnApply
    
    bind $w <Alt-c> "tkButtonInvoke $w.frmButtons.btnclose"
    bind $w <Escape> "tkButtonInvoke $w.frmButtons.btnclose"

    #wm minsize $w 140 175
}
 
proc DrawShellSection { w } {

    global ParamsShell

    set t $ParamsShell(t)
    set n $ParamsShell(n)

    set x1 0.0
    set y1 [expr $t*0.5]

    set x2 [expr $t*1.25]
    set y2 [expr -$t*0.5]


    set oldvalue [ GiD_Info variables CreateAlwaysNewPoint]
    GiD_Process process escape escape escape Utilities Variables CreateAlwaysNewPoint  1

    GiD_Process escape escape escape escape
    GiD_Process geometry create object rectangle \
    $x1,$y1,0.0 \
    $x2,$y2,0.0 \
    escape escape escape escape escape

    GiD_Process Meshing ElemType Quadrilateral 1 Escape \
     escape escape escape 

    GiD_Process Meshing Structured Surfaces 1 escape 1 1 escape $n 2 escape \
     escape escape escape escape

    GiD_Process Meshing Generate MESHVIEW escape escape escape escape        
  
    GiD_Process  View Label All escape escape escape escape
 
    GiD_Process zoom frame escape escape escape escape

    destroy $w
}


proc EndGIDProject {} {
}

proc GetDirName {} {
set txt [ GiD_Process info Project ]
return [ file tail [ lindex $txt 1] ]

}
