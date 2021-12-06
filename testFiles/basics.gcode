Width: 30 Length: 30
; Source: Custom Written
; Simple file that tests device functionality
;
; Homing function that resets motor positions to defined zero.
M200
; Layer change function moves beds to zero 
; (beds shouldn't move because homing function was already called.)
G01 Z0.0000
; Motor move to 0,0
; (again, shouldn't move)
G01 X0.0000 Y0.0000
; Move 30mm +x direction
G01 X30.0000 Y0.0000
; Move 30mm -x back to origin
G01 X0.0000 Y0.0000
; Move 30mm +y direction (not vertical)
G01 X0.0000 Y30.0000
; Move 30mm -y direction back to origin
G01 X0.0000 Y0.0000
; Move to 30,30 (may move diagonally)
G01 X30.0000 Y30.0000
; Return to origin (may move diagonally)
G01 X0.0000 Y0.0000
; Pilot laser on, then move, then off.
M201
G01 X30.0000 Y0.0000
M202
; Test other diagonals
G01 X0.0000 Y30.0000
G01 X30.0000 Y0.0000
; Function Generator on, then move, then off.
M301
G01 X0.0000 Y0.0000
M302
