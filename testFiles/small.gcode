Width: 30 Length: 30
; This is a small snipet of gcode for testing basic functionality.
; It calls M200, M201, M202, and G01 commands in all directions.
M200
G01 Z0.0000
M201
G01 X0.0000 Y0.0000
G01 X13.0000 Y0.0000
G01 X13.0000 Y13.0000
G01 X0.0000 Y13.0000
G01 X0.0000 Y0.0000
G01 X9.8750 Y3.6250
G01 X12.5000 Y3.6250
G01 X12.5000 Y6.2500
G01 X9.8750 Y6.2500
G01 X9.8750 Y3.6250
M202