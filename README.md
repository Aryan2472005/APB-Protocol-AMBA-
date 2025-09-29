# APB-Protocol
<img width="1893" height="917" alt="Screenshot 2025-09-05 041845" src="https://github.com/user-attachments/assets/a5b0dae6-49cb-45e6-9f4d-d1776f55dc01" />

🔑 Key Features
1. APB Master FSM
   * Implements IDLE, SETUP, and ENABLE phases.
   * Generates PSELx, PWRITE, PENABLE, PWDATA, and PADDR.
   * Handles PREADY handshake from slaves.
   * Supports both read and write transactions.
   * Error detection (PSLVERR) for invalid setups or invalid addresses.

2. APB Slave (Memory-mapped device)
    * Implements a simple 64-byte memory array (mem1[63:0]).
    * Stores write data (PWDATA) at the address provided by the master.
    * Returns stored data during read transactions.
    * Uses registered read/write logic to ensure stability.
    * Generates PREADY signal to indicate transaction completion.

3. Top-Level Integration
    * Supports two slaves (extendable to more).
    * Address bit [8] is used to select between slave1 and slave2.
    * Multiplexes PRDATA and PREADY signals from active slave to the master.

READ WRITE FUNCTION OF SLAVE 1.
<img width="1552" height="717" alt="slave 1 write" src="https://github.com/user-attachments/assets/fbd57d1c-b97e-4c03-9714-1fa1a59662a5" />
<img width="1568" height="577" alt="read_slave1" src="https://github.com/user-attachments/assets/31bf6502-b47d-4233-bc13-147d85892be6" />

READ WRITE FUNCTION OF SLAVE 2.
<img width="1512" height="627" alt="write_slave2" src="https://github.com/user-attachments/assets/480f946a-732f-4c7b-a58b-118ec88ed45f" />
<img width="1560" height="552" alt="read_slave2" src="https://github.com/user-attachments/assets/4aa91b08-57c5-4dd6-bfbd-ba20683ac6f1" />

