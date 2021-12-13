Width: 30 Length: 30
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