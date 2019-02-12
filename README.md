# New structure of Global Trigger firmware on MP7

Top hierarchy module of ugt firmware, which is embedded in the MP7 firmware framework, is *[mp7_payload.vhd](firmware/hdl/mp7_payload.vhd)* and contains three main parts:

* [Frame](doc/frame.md) of GlobalTrigger Logic
* Global Trigger Logic ([GTL](doc/gtl.md)) version 2.x.y for new structure of GTL logic with 3 stages: 
  * conversions and calculations
  * comparisons
  * conditions and algos
* Final Decision Logic ([FDL](doc/fdl.md))

Inserted possibility to simulate gtl_fdl_wrapper logic with Vivado simulator by scripts:
* make a Vivado project with "python makeProject.py ..."
* prepare Vivado project for simulation and synthesis with "python prepareProjectSimSynth.py ..."
* simulate gtl_fdl_wrapper logic of the project with "python startSim.py ..."
