<!-- Project Logo -->
# Powder Bed Metal Printer Project 2021
<!-- Table of contents -->

## About
![Printer Internals Image](./docs/images/XYZRender.JPG)

This repo contains the code for a 2021 Senior Design Project at Iowa State University.

The main objective is to create a 3D Printer system that uses metal powder to create small cubes.

### Built With
* [Matlab 2020b]()
* [Arduino Programming Language]()

## Getting Started

### Prerequisites

* Matlab 2020b or later
* Arduino IDE
* R4GUI.exe

## Setup

Place startup.m into the folder of your local Matlab installation. This should prompt Matlab to automatically add the necessary files to the path.

### Laser

Turn on the laser's mains power switch.

Plug in the ethernet cable.

To run the application with the pilot laser:

- Ensure the interlock is unplugged
- Ensure the key is in the off position

To run the application with the high power laser:
- Plug in the camera power supply, adapter power supply, and monitor
- Seal the chamber
- Plug in the interlock
- Open the R4GUI Software
- Turn the key to the on position

In the R4GUI.exe software, configure the laser to communicate through ethernet:

    `Comms > Ethernet > Find`

Note the IP address, then select the laser to continue.

Press `Pause` in the R4GUI software to disable command cycling.



See docs for more details.


### Motors

- Switch on all 3 VXM motors
- Double check the 


## Deliverables

- [X] Re-write Slicer C# Application in Matlab
    - [x] User-Defined Voxel Count
    - [x] User-Defined Defect Creation
- [x] Re-write Printer Control Application in Matlab
    - [x] Communication with Sintering Laser through Matlab
- ~~Ability to print 3cm cubes~~ Deliverable removed


## Contact

## Acknowledgements
