# Global Trigger firmware with gtl_v2.x.y

Top hierarchy module of ugt firmware, which is embedded in the MP7 firmware framework, is *mp7_payload.vhd (firmware/hdl)* and contains three main parts:

* Frame
* Global Trigger Logic [GTL](doc/gtl.md) version 2.x.y for new structure of GTL logic with 3 stages: 
  * conversions and calculations
  * comparisons
  * conditions and algos
* Final Decision Logic [FDL](doc/fdl.md)
