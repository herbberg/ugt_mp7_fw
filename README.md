# ugt firmware with gtl_v2.x.y

Top of hierarchy of ugt firmware, which is embedded in the MP7 firmware framework, is *mp7_payload.vhd (firmware/hdl)* and contains three main parts:

* Frame
* GTL version 2.x.y for new structure of GTL logic with 3 stages: 
  * conversions and calculations
  * comparisons
  * conditions and algos
* FDL
