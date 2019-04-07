# netfpgaModDefenseARP
## Beginner NetFPGA building Security ARP Spoofing


- Copyright (C) 2019
- Author: Quoc Bao
- UserName_Github: L0wBat7erY
- Ho Chi Minh City University of Technology

Library: <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${NF_ROOT}/lib/hw/std/pcores/nf10_switch_port_lookup_v1_10_a/
> cam.v                   (cam_mod.v)
> ethernet_parser.v       (ethernet_parser_mod.v)
> mac_cam_lut.v           (mac_cam_lut_mod.v)
> run.py
> nf10_switch_output_port_lookup.v
> output_port_lookup.v
> small_fifo.v
> fallthrough_small_fifo_v2.v
> ethernet_parser.v


command: 
> source ${NF_ROOT}/bashrc_addon_NetFPGA_10G


**bashrc_addon_NetFPGA_10G:**
```
source /opt/Xilinx/13.4/ISE_DS/settings64.sh
export NF_ROOT=<dir_to_path>/NetFPGA-10G-live
export NF_DESIGN_DIR=${NF_ROOT}/projects/reference_switch
export NF_WORK_DIR=/tmp/${USER}
export PYTHONPATH=${NF_ROOT}/lib/python:${NF_DESIGN_DIR}/lib/Python:${NF_ROOT}/tools/scripts:
export LD_LIBRARY_PATH=${NF_ROOT}/lib/java/NetFPGAFrontEnd/bin:${LD_LIBRARY_PATH}
```


**Run isim --gui**<br />
command: 
> source compile


**compile:**
```
${NF_ROOT}/tools/bin/nf_test.py sim --major loopback --minor minsize --isim --gui
```

Read modify file in Git for project: <br />
https://github.com/L0wBat7erY/netfpgaModDefenseARP