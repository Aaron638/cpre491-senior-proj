# New Software Flow 2021 #
## Matlab Software Flow ##
```mermaid
flowchart TB

    id1([3cm_cube.stl \n CAD file of a 3cm^3 cube]);
    id2([3cm_cube.gcode \n List of printer actions]);
    id3(["printerActions.txt \n Text file lists ASCII cmd & COM port#"]);
    
    subgraph slicer

        sl0["parse_stl() \n Reads .stl file"];
        sl1["gen_voxel() \n Slice each layer into v voxels"];
        sl2["gen_voxel_90_degrees() \n Slice each layer into v voxels"];
        sl3["gen_cube() \n Write an output gcode file"];
        sl0 -->|"0°"| sl1;
        sl0 -->|"90°"| sl2;
        sl1 & sl2 --> sl3;
    end

    subgraph print_ctrl_parse
        pca["parseGcode() \n gcode --> vxm or laser ASCII cmds"];
        pcb["verifyGcode() \n gcode --> vxm or laser ASCII cmds"];
        pca --> pcb;
    end

    subgraph print_ctrl_action
        pc2["startPrint() \n Sends cmds to hardware serially"];
        pc3["logAction() \n Await echo before sending new cmd"];
        pc2 --> pc3;
        pc3 --> pc2;
    end

    subgraph hardware
        subgraph COM ports
            hw1{{"3-axis motors \n roller"}};
            hw2{{"supply bed motor \n print bed motor"}};
            hw3{{"Laser"}};
            hw4{{"Arduino"}};
        end
    end

    id1 --> slicer --> id2 --> print_ctrl_parse --> id3 --> print_ctrl_action --> hardware;
    
```

## Hardware ##
```mermaid
flowchart LR
        subgraph Inside Presurized Chamber:
            subgraph axi[3-Axis Motors]
                ax1{{x-axis}};
                ax2{{y-axis}};
                ax3{{laser_height}};
                ax4{{roller}}
            end
            subgraph pbed[Bed Motors]
                pbed1{{supply_bed}};
                pbed2{{print_bed}};
            end
            subgraph Melt Laser Control
                ch1{{"IR Camera"}};
                ch2{{"Barometer"}};
                ch3{{"QCS BDS"}};
            end
        end

        lcs[("Laser Enclosure")];
        ox{{"Room Oxygen Sensor"}};
        Arduino{{"Arduino"}};

        subgraph PC Ports
            usb([USB])
            usbserial([USB-to-Serial])
            serial([Serial])
        end

        ch2 -.-> Arduino;
        ox -.-> Arduino;
        lcs <-.-> ch3;
        ch1 -.-> bncvga{{BNC-to-VGA\n Adapter}} -.-> m{{Monitor}};
        
        usb -.-> Arduino;
        usbserial -.-> axi;
         usbserial -.-> pbed;
        serial -.-> lcs;
```

## Printer Control State Diagram ##

```mermaid
stateDiagram-v2
    state startPrint() {
        state1: Get Port# and ASCII Text from \n PrinterActions.txt
        axis: 3-Axis Motors + Roller \n COM Port
        pbed: Supply Bed + Powder Bed \n COM Port
        lasr: Laser Control \n COM Port
        [*] --> state1
        state1 --> axis
        state1 --> pbed
        state1 --> lasr
        state awaitResponse() {
            charState: Wait for ^ char
            [*] --> charState
            charState --> [*]
        }
        axis --> awaitResponse()
        pbed --> awaitResponse()
        lasr --> awaitResponse()
        awaitResponse() --> state1 : ^ Recieved
    }

```

## Simple Software Flow ##
```mermaid
flowchart TB

    id1([.gcode]);
    
    
    subgraph slicer

    end

    subgraph print_ctrl

        pc1["initMotors.m \n Serial port connections are scanned \n and mapped to motor controllers"];

        subgraph compiler
            pc2["compile.m \n Each line of gcode is compiled down into ASCII cmds"];
            pc2 --> bedMove.m;
            pc2 --> moveAxis.m;
            pc2 --> setSpotsize.m;
            pc2 --> sweepRoller.m;
            pc2 --> zeroAxis.m;
            pc2 --> zeroBeds.m;
        end

        pc3(["printerActions.txt \n Text file lists ASCII cmd & COM port#"]);

        pc4["csm.m \n Command Sending Module \n Sends commands to hardware"];
        pc5["lem \n Laser Emitting Module \n Controls Laser \n Comms with sensors \n Matlab and/or Labview?"];
        pc4 <--> pc5;

        pc1 --> compiler --> pc3 --> pc4;

    end

    subgraph hardware
        hw1{{"3-axis motors \n roller"}};
        hw2{{"Supply bed motor \n Print bed motor"}};
        hw3{{"Laser"}};
        hw4{{"Arduino"}};
    end

    slicer --> id1 --> print_ctrl;
    pc4 --> hw1;
    pc4 --> hw2;
    pc5 --> hw3;
    pc5 --> hw4;
    
```

```mermaid
flowchart TB

    id2([3cm_cube.gcode \n List of printer actions]);
    
    subgraph slicer

        sl0["User inputs defect and \n dimension parameters"];
        subgraph gen_cube.m
            sl2["gen_voxel_90_degrees.m \n Slice each layer into v voxels"];
            sl3["gen_cube.m \n Write an output gcode file"];
        end

        sl0 --> gen_cube.m;
    end

    subgraph compiler
        pca["initMotors.m \n Detect hardware on ports"];
        pcb["compile.m \n gcode mapped to vxm or laser ASCII cmd"];
        pca --> pcb;
    end


    id3(["printerActions.txt \n Text file lists ASCII cmd & COM port#"]);

    subgraph csm
        pc2["csm.m \n Command Sending Module"];
        pc3["lcm.m \n Laser Control Module"];
        pc4["mcm.m \n Motor Control Module"];
        pc2 <--> pc3;
        pc2 <--> pc4;
    end

    subgraph hardware
        subgraph COM ports
            hw1{{"3-axis motors \n roller"}};
            hw2{{"supply bed motor \n print bed motor"}};
            hw3{{"Laser"}};
            hw4{{"Arduino"}};
        end
    end

    slicer --> id2 --> compiler --> id3 --> csm --> hardware;

    
```