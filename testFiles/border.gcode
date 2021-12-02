Width: 30 Length: 30
; Source: Custom Written
; This is a small snipet of gcode for testing basic functionality.
; It calls M200, M201, M202, and G01 commands in all directions.
M200
G01 Z0.0000
M201
G01 X0.0000 Y0.0000
G01 X30.0000 Y0.0000
G01 X30.0000 Y30.0000
G01 X0.0000 Y30.0000
G01 X0.0000 Y0.0000
G01 X0.5000 Y7.8750
G01 X7.3750 Y7.8750
G01 X7.3750 Y14.7500
G01 X0.5000 Y14.7500
G01 X0.5000 Y7.8750
M202
