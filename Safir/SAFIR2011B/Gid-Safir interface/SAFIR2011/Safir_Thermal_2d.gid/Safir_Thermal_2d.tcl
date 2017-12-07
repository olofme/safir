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

    global ProblemTypePath
    set ProblemTypePath $dir
    set ProgramName Safir_Thermal_2D

    GidChangeDataLabel "Interval" ""
    GidChangeDataLabel "Local axes" ""

    #set NumMenus 7
    #set MenuNames {Files View Geometry Utilities Data Meshing Calculate Cross_Section \
	    Help}
    
    #set MenuEntries(8) $MenuEntries(7)
    #set MenuCommands(8) $MenuCommands(7)
    #set MenuAcceler(8) $MenuAcceler(7)
    
    #set MenuEntries(7) { "Cross-Sections" }
    CreateMenu "Cross-Section" "PRE"
    InsertMenuOption "Cross-Section" "I-Profile" 0 "Iprofile" "PRE"
    set MenuAcceler(7) { "" }
    CreateTopMenus

    GidChangeDataLabel "Interval" ""
    #RemoveMenuOption "Data" "Interval" "PRE"

    global GidPriv
    set GidPriv(ProgName) $ProgramName
    ChangeWindowTitle

    UpdateMenus

}

proc Iprofile { } {

    global ParamsIprof 

    global ProfNam
    global ProfTyp
 
    set w .gid.iprofil

    set ParamsIprof(h) ""
    set ParamsIprof(b) ""
    set ParamsIprof(ts) ""
    set ParamsIprof(tg) "" 
    set ParamsIprof(r) ""
    set ParamsIprof(drawFillet) 0         
    set ParamsIprof(drawSlab) 0         
    set ParamsIprof(slabW) ""
    set ParamsIprof(slabH) ""

    InitWindow $w "Create I - Profile" ParametricWindowGeom   
 
    frame $w.frmProfType 

    label $w.frmProfType.lType -text "Type"

    set ProfTyp "HE"

    ComboBox $w.frmProfType.listOfType -editable 0 -width 15 -textvariable ProfTyp \
      -values { "IPE" "HE" "HL" "HD" "HP" "W" "USER" } \
      -modifycmd { updateProfList  $ProfTyp }

    label $w.frmProfType.lProf -text "Profile"
    label $w.frmProfType.eProf -relief sunken -width 20 -textvariable ProfNam -font FixedFont
    listbox $w.frmProfType.listOfProf -width 20 -relief raised -borderwidth 2 -selectmode single \
          -yscrollcommand " $w.frmProfType.scrollProfList set " -font FixedFont

    scrollbar $w.frmProfType.scrollProfList -command "$w.frmProfType.listOfProf yview"

    frame $w.frmEquations
 
    label $w.frmEquations.lh -text "Height(h)"
    label $w.frmEquations.lhu -text "mm"
    entry $w.frmEquations.eh -relief sunken -width 10 -textvariable ParamsIprof(h)
    label $w.frmEquations.lb -text "Width(b)"
    label $w.frmEquations.lbu -text "mm"
    entry $w.frmEquations.eb -relief sunken -width 10 -textvariable ParamsIprof(b)
    label $w.frmEquations.lts -text "Web(tw)"
    label $w.frmEquations.ltsu -text "mm"
    entry $w.frmEquations.ets -relief sunken -width 10 -textvariable ParamsIprof(ts)
    label $w.frmEquations.ltg -text "Flange(tf)"
    label $w.frmEquations.ltgu -text "mm"
    entry $w.frmEquations.etg -relief sunken -width 10 -textvariable ParamsIprof(tg)
    label $w.frmEquations.lr -text "Radius(r)"
    label $w.frmEquations.lru -text "mm"
    entry $w.frmEquations.er -relief sunken -width 10 -textvariable ParamsIprof(r)

    label $w.frmEquations.lexactShape -text "exact shape"
    checkbutton $w.frmEquations.exactShape -variable ParamsIprof(drawFillet)

    label $w.frmEquations.lConcreteSlab -text "Concrete Slab"
    checkbutton $w.frmEquations.concreteSlab -variable ParamsIprof(drawSlab) -command {
          set w .gid.iprofil
         if { $ParamsIprof(drawSlab) == 1} {
            $w.frmEquations.eSlabWidth configure -state normal
            $w.frmEquations.eSlabHight configure -state normal  
         } else {
            $w.frmEquations.eSlabWidth configure -state disabled
            $w.frmEquations.eSlabHight configure -state disabled 
            set ParamsIprof(slabW)  ""
            set ParamsIprof(slabH)  ""
         }
    }
    label $w.frmEquations.lSlabWidth -text "Slab Width"
    label $w.frmEquations.lSlabWidthu -text "mm"
    entry $w.frmEquations.eSlabWidth -relief sunken -width 10 -textvariable ParamsIprof(slabW) -state disabled
    label $w.frmEquations.lSlabHight -text "Slab Height"
    label $w.frmEquations.lSlabHightu -text "mm"
    entry $w.frmEquations.eSlabHight -relief sunken -width 10 -textvariable ParamsIprof(slabH) -state disabled

    set def_back [$w cget -background]
    frame $w.frmButtons -bg [CCColorActivo $def_back]
    button $w.frmButtons.btnApply -text "Apply" \
	    -command "DrawIprofile $w" \
	    -underline 0 -width 6
    button $w.frmButtons.btnclose -text "Close" \
	    -command "destroy $w" \
	    -underline 0 -width 6

    grid $w.frmProfType  -padx 5 -pady 5 -sticky ew 

    grid $w.frmProfType.lType $w.frmProfType.listOfType -sticky e
    grid $w.frmProfType.lProf $w.frmProfType.eProf -sticky e
    grid $w.frmProfType.scrollProfList $w.frmProfType.listOfProf -sticky ens
  
    grid $w.frmEquations -padx 5 -pady 5 -sticky ew    
    grid $w.frmEquations.lh $w.frmEquations.eh $w.frmEquations.lhu -sticky e
    grid $w.frmEquations.lb $w.frmEquations.eb $w.frmEquations.lbu -sticky e
    grid $w.frmEquations.lts $w.frmEquations.ets $w.frmEquations.ltsu -sticky e
    grid $w.frmEquations.ltg $w.frmEquations.etg $w.frmEquations.ltgu -sticky e
    grid $w.frmEquations.lr $w.frmEquations.er $w.frmEquations.lru -sticky e
    grid $w.frmEquations.lexactShape $w.frmEquations.exactShape -sticky e
    grid $w.frmEquations.lConcreteSlab $w.frmEquations.concreteSlab -sticky e
    grid $w.frmEquations.lSlabWidth $w.frmEquations.eSlabWidth $w.frmEquations.lSlabWidthu -sticky e
    grid $w.frmEquations.lSlabHight $w.frmEquations.eSlabHight $w.frmEquations.lSlabHightu -sticky e
 
    grid $w.frmButtons -sticky ews -columnspan 7
    grid $w.frmButtons.btnApply $w.frmButtons.btnclose -padx 5 -pady 6

    grid columnconf $w "0" -weight 1
    grid rowconfigure $w "3" -weight 1
    
    focus $w.frmButtons.btnApply
    
    bind $w <Alt-c> "tkButtonInvoke $w.frmButtons.btnclose"
    bind $w <Escape> "tkButtonInvoke $w.frmButtons.btnclose"

    bind $w.frmProfType.listOfProf <<ListboxSelect>> { updateProf [selection get] }

    set ProfNam  ""
    set ParamsIprof(slabW) ""
    set ParamsIprof(slabH) ""

    updateProfList  "HE"

    #wm minsize $w 140 175
}

proc updateProf { selectedProf } {

   global ProfNam
   global ParamsIprof 

   set w .gid.iprofil

   set ProfNam [string range $selectedProf 0 20]

   set profData [string range $selectedProf 21 end]
   scan $profData "%s %s %s %s %s" w1 w2 w3 w4 w5

   set ParamsIprof(h) $w1
   set ParamsIprof(b) $w2
   set ParamsIprof(ts) $w3
   set ParamsIprof(tg) $w4
   set ParamsIprof(r) $w5

}

proc updateProfList  { type } {

       variable path
       global ProblemTypePath

       global ProfNam
       global ProfTyp
       global ParamsIprof 

       set w .gid.iprofil

       $w.frmProfType.listOfProf delete 0 end

       set ProfNam  ""
       set ParamsIprof(h) ""
       set ParamsIprof(b) ""
       set ParamsIprof(ts) ""
       set ParamsIprof(tg) "" 
       set ParamsIprof(r) ""

       if { $type == "USER" } {

            $w.frmEquations.eh configure -state normal
            $w.frmEquations.eb configure -state normal
            $w.frmEquations.ets configure -state normal
            $w.frmEquations.etg configure -state normal
            $w.frmEquations.er configure -state normal

 	    return
       }

       $w.frmEquations.eh configure -state disabled
       $w.frmEquations.eb configure -state disabled
       $w.frmEquations.ets configure -state disabled
       $w.frmEquations.etg configure -state disabled
       $w.frmEquations.er configure -state disabled

       #set wdir "c:\\Programme\\GiD\\Gid 8.0.9\\problemtypes\\SAFIR2007_test\\Safir_Thermal_2d.gid"
       set wdir $ProblemTypePath

       set f [open $wdir\\prof.txt ]

       set listProf { }
       while { [ gets $f line ] >= 0 } {
           scan $line "%s" kw0
           if { $kw0 == $type} {
    	      set profNam [string range $line 0 20]
              $w.frmProfType.listOfProf insert end $line
           }
       }

       close $f
}
 
proc DrawIprofile { w } {

    global ParamsIprof

    set scal 0.001
    set h [expr $ParamsIprof(h) * $scal]
    set b [expr $ParamsIprof(b) * $scal]
    set ts [expr $ParamsIprof(ts) * $scal]
    set tg [expr $ParamsIprof(tg) * $scal]

    set exactS $ParamsIprof(drawFillet)
    set drawS $ParamsIprof(drawSlab)

    #set slabW [expr $ParamsIprof(slabW) * $scal]
    #set slabH [expr $ParamsIprof(slabH) * $scal]

    if { $exactS == 1 } {
    	set r [expr $ParamsIprof(r) * $scal]
    } else {
    	set r [ expr $ParamsIprof(r)*0.665*$scal ] 
    }

    set x0 0.0
    set y0 0.0

    set hh [expr $h*0.5]
    set bh [expr $b*0.5]
    set tsh [expr $ts*0.5]
    set dc [expr sqrt([expr $r*$r*0.5])]

    set x1 [expr $x0 - $bh]
    set y1 [expr $y0 - $hh]

    set x2 [expr $x0 + $bh]
    set y2 [expr $y0 - $hh]

    set x3 [expr $x2]
    set y3 [expr $y2 + $tg]

    set x4 [expr $x0 + $tsh + $r]
    set y4 [expr $y3]

    set x5 [expr $x0 + $tsh]
    set y5 [expr $y4 + $r]  

    set c1x [expr $x4 - $dc]
    set c1y [expr $y5 - $dc]

    set x6 [expr $x5]
    set y6 [expr $y0 + $hh - $tg - $r]

    set x7 [expr $x5 + $r]
    set y7 [expr $y6 + $r]

    set c2x [expr $x7 - $dc]
    set c2y [expr $y6 + $dc]

    set x8 [expr $x0 + $bh]
    set y8 [expr $y0 + $hh - $tg]

    set x9 [expr $x8]
    set y9 [expr $y0 + $hh]

    set x10 [expr $x0 - $x9]
    set y10 [expr $y9]

    set x11 [expr $x0 - $x8]
    set y11 [expr $y8]

    set x12 [expr $x0 - $x7]
    set y12 [expr $y7]

    set x13 [expr $x0 - $x6]
    set y13 [expr $y6]
 
    set c3x [expr $x0 - $c2x]
    set c3y [expr $c2y]

    set x14 [expr $x0 - $x5]
    set y14 [expr $y5]

    set x15 [expr $x0 - $x4]
    set y15 [expr $y4]

    set c4x [expr $x0 - $c1x]
    set c4y [expr $c1y]

    set x16 [expr $x0 - $x3]
    set y16 [expr $y3]
       

    set oldvalue [GiD_Info variables CreateAlwaysNewPoint]
    GiD_Process escape escape escape Utilities Variables CreateAlwaysNewPoint  1

    GiD_Process escape escape escape escape
    GiD_Process geometry create line \
    $x1,$y1,0.0 \
    $x2,$y2,0.0 \
    $x3,$y3,0.0 \
    $x4,$y4,0.0 \
    escape escape escape escape

    if { $exactS == 1 } {
   	 .central.s process geometry create arc \
    	$x4,$y4,0.0 \
    	$c1x,$c1y,0.0 \
    	$x5,$y5,0.0 \
   	 escape escape escape escape
    } else {
       GiD_Process geometry create line \
        $x4,$y4,0.0 \
        $x5,$y5,0.0 \
        escape escape escape escape
    }

   GiD_Process geometry create line \
    $x5,$y5,0.0 \
    $x6,$y6,0.0 \
    escape escape escape escape

    if { $exactS == 1 } {
       GiD_Process geometry create arc \
        $x6,$y6,0.0 \
        $c2x,$c2y,0.0 \
        $x7,$y7,0.0 \
        escape escape escape escape
    } else {
       GiD_Process geometry create line \
        $x6,$y6,0.0 \
        $x7,$y7,0.0 \
        escape escape escape escape
    }

    GiD_Process geometry create line \
    $x7,$y7,0.0 \
    $x8,$y8,0.0 \
    $x9,$y9,0.0 \
    $x10,$y10,0.0 \
    $x11,$y11,0.0 \
    $x12,$y12,0.0 \
    escape escape escape escape

    if { $exactS == 1 } {
        GiD_Process geometry create arc \
         $x12,$y12,0.0 \
         $c3x,$c3y,0.0 \
         $x13,$y13,0.0 \
         escape escape escape escape
    } else {
       GiD_Process geometry create line \
        $x12,$y12,0.0 \
        $x13,$y13,0.0 \
        escape escape escape escape
    }

   GiD_Process geometry create line \
    $x13,$y13,0.0 \
    $x14,$y14,0.0 \
    escape escape escape escape

    if { $exactS == 1 } {
        GiD_Process geometry create arc \
        $x14,$y14,0.0 \
        $c4x,$c4y,0.0 \
        $x15,$y15,0.0 \
        escape escape escape escape
    } else {
       GiD_Process geometry create line \
        $x14,$y14,0.0 \
        $x15,$y15,0.0 \
        escape escape escape escape
    }

   GiD_Process geometry create line \
    $x15,$y15,0.0 \
    $x16,$y16,0.0 \
    $x1,$y1,0.0 \
    escape escape escape escape


    if { $drawS == 1 } {

       set sW [expr $ParamsIprof(slabW) * $scal]
       set sH [expr $ParamsIprof(slabH) * $scal] 

       set dsx [ expr $sW*0.5 - $b*0.5 ]

       set sl1x [ expr $x9 + $dsx ]
       set sl1y $y9

       set sl2x $sl1x
       set sl2y [ expr $sl1y + $sH ]

       set sl3x [ expr $x10 - $dsx ]
       set sl3y [ expr $y10 + $sH ]

       set sl4x $sl3x
       set sl4y [ expr $sl3y - $sH ]

       GiD_Process geometry create line \
        $x9,$y9,0.0 \
        $sl1x,$sl1y,0.0 \
        $sl2x,$sl2y,0.0 \
        $sl3x,$sl3y,0.0 \
        $sl4x,$sl4y,0.0 \
        $x10,$y10,0.0 \
    	escape escape escape escape
    }


    GiD_Process escape
    GiD_Process escape escape escape Utilities Variables \
 		CreateAlwaysNewPoint $oldvalue
    GiD_Process escape escape escape
 
    GiD_Process Utilities Collapse Points 1:
    GiD_Process escape escape escape

    GiD_Process zoom frame escape escape escape escape

    if { $exactS == 0 } {

       GiD_Process Geometry Create NurbsSurface 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 \
       escape escape escape escape

       GiD_Process Meshing Structured Lines 12 1 9 escape 5 3 7 11 15 escape \
       escape escape escape escape
       
     if { $drawS == 1 } {
     
       GiD_Process Geometry Create NurbsSurface 9 17 18 19 20 21 \
       escape escape escape escape

       GiD_Process Meshing ElemType Quadrilateral 2 Escape \
       escape escape escape escape

       GiD_Process Meshing Structured Surfaces 2 escape 12 21 escape 12 9 escape 12 17 escape \
       5 18 escape \
       escape escape escape escape
       }
       
   } else {
   
     if { $drawS == 1 } {

       GiD_Process Geometry Create NurbsSurface 1 2 25 8 9 10 29 16 \
       escape escape escape escape
      
       GiD_Process Geometry Create NurbsSurface 9 17 18 19 20 21 \
       escape escape escape escape

       GiD_Process Meshing ElemType Quadrilateral 2 Escape \
       escape escape escape escape

       GiD_Process Meshing Structured Surfaces 2 escape 12 21 escape 12 9 escape 12 17 escape \
       5 18 escape \
       escape escape escape escape

    } else {
       GiD_Process Geometry Create NurbsSurface 1 2 20 8 9 10 24 16 \
       escape escape escape escape


   }

    }

    destroy $w
}

 
proc EndGIDProject {} {
}

proc GetDirName {} {
set txt [ .central.s info Project ]
return [ file tail [ lindex $txt 1] ]

}

proc WriteMaterialData {matNam Num} {
#
# gibt den Wert des Num-ten Materialparameters zurück 
# Num entspricht der MaterialProperty Nummer, wie im .mat file
#
	set matWerte [ GiD_Info materials $matNam ]
        set i [expr $Num * 2]
        set wert [lindex $matWerte $i]
        return $wert
}
