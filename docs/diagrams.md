# 2021 Matlab 3D Metal Printer Software Diagrams #

This document uses [Markdown](https://www.markdownguide.org/basic-syntax/) with [Mermaid-js](https://mermaid-js.github.io/mermaid/#/) diagrams to render diagrams for our project. 

## Complete Block Diagram
```mermaid
flowchart TB
    linkStyle default interpolate linear
    
    user("User inputs parameters");

    user --config.json--> slicer;

    subgraph slicer
        direction TB;
        slicer_ctrl["slicer_ctrl \n Parse config.json"];
        gen_cube["gen_cube \n Algorithmically arranges voxel into cube"];
        gen_voxel["gen_voxel \n Generates infill G-code"];
        gen_voxel_90["gen_voxel_90 \n Generates infill G-code rotated"];
        insert_defect["insert_defect \n Inserts simulated defect G-code"];

        slicer_ctrl --> gen_cube;
        gen_cube --- gen_voxel & gen_voxel_90 & insert_defect;
    end

    subgraph printCtrl
        direction LR;
        
        subgraph compiler
            c["compile.m \n Translate G-Code to device cmds"];
            cm["/motor/ \n"];
            cl["/laser/ \n"];

            c --- cl & cm;
        end

        subgraph sender
            s["sendCMDs.m \n Parses .toml \n Sends commands to hardware"];
            sm["/motor/ \n"];
            sl["/laser/ \n"];

            s --> sl & sm;
        end
    end

    slicer --.gcode--> compiler;
    compiler --.toml--> sender;

    subgraph hardware
        direction TB;
        hw1{{"Motor \n TWIN"}};
        hw2{{"Motor \n SOLO"}};
        hw3{{"Laser"}};
        hw4{{"FuncGen"}};
    end

    sm --Serial--> hw1 & hw2;
    sl --Ethernet TCP--> hw3;
    s --USB VISA--> hw4;
```

## Detailed Printer Control Block Diagram ##
```mermaid
flowchart TB
    linkStyle default interpolate linear
    slicer["Slicer"];

    subgraph printCtrl
        direction LR
        
        subgraph compiler
            c["compile.m \n Translate G-Code to device cmds"];
            cm["/motor/ \n"];
            cl["/laser/ \n"];

            c --- cl & cm;
        end

        subgraph utils     
            cfg["CONFIG.m \n User configures ports and addresses \n ''Global Variables''"];
        end

        subgraph sender
            s["sendCMDs.m \n Parses .toml \n Sends commands to hardware"];
            sm["/motor/ \n"];
            sl["/laser/ \n"];

            s --> sl & sm;

            subgraph toolboxes
                pc3["Instrument Control \n Matlab Add-On"];
                pc2["matlab-toml-forked \n Matlab Add-On"];
            end
        end
    end

    slicer --.gcode--> compiler;
    compiler --.toml--> sender;

    subgraph hardware
        direction TB
        hw1{{"Motor \n TWIN"}};
        hw2{{"Motor \n SOLO"}};
        hw3{{"Laser"}};
        hw4{{"FuncGen"}};
    end

    sm --Serial--> hw1 & hw2;
    sl --Ethernet TCP--> hw3;
    s --USB VISA--> hw4;
``` 

## Hardware Diagram ##
```mermaid
flowchart LR
        subgraph chamber["Inside Presurized Chamber"]
            subgraph axi["Twin VXM Motor Controllers"]
                ax1{{"x-axis"}};
                ax2{{"y-axis"}};
                ax3{{"laser-height"}};
                ax4{{"roller"}}
            end
            subgraph pbed["Solo VXM Motor Controller"]
                pbed1{{"supply-bed"}};
                pbed2{{"print-bed"}};
            end
            subgraph laser["Melt Laser Control"]
                ch1{{"IR Camera"}};
                ch2{{"Barometer"}};
                ch3{{"QCS Beam Delivery System"}};
            end
        end

        subgraph PC Ports
            usbserial(["USB to Serial"]);
            ethernet(["Ethernet"]);
            usbb(["USB to USB-B"]);
        end

        lcs[("Laser Box")];
        
        %% Placing this in a subgraph can screw up formatting
        fg{{"Function Generator"}};
        ox{{"Room Oxygen Sensor"}};
        Arduino{{"Arduino"}};

        ch2 -.-> Arduino;
        ox -.-> Arduino;
        lcs <-.-> ch3;
        ch1 -.-> bncvga{{"BNC-to-VGA\n Adapter"}} -.-> m{{"Monitor"}};
        usbb -.-> fg & Arduino;
        fg -.-> lcs;
        usbserial -.-> axi;
        usbserial -.-> pbed;
        ethernet -.-> lcs;
```