module risc_bne_cpu (
    input clk,
    input reset,
    output [7:0] R0,
    output [7:0] R1,
    output [7:0] R2,
    output [7:0] R3
);

    reg [3:0] PC;
    reg [7:0] IR;

    reg [7:0] reg_file [0:3];

    // Instruction format:
    // [rs1 rs2 target opcode]
    wire [1:0] rs1    = IR[7:6];
    wire [1:0] rs2    = IR[5:4];
    wire [1:0] target = IR[3:2];
    wire [1:0] opcode = IR[1:0];

    parameter ADD = 2'b00;
    parameter SUB = 2'b01;
    parameter BEQ = 2'b10;
    parameter BNE = 2'b11;

    reg [7:0] program [0:15];

    initial begin
        // Setup registers
        reg_file[0] = 3;  // counter
        reg_file[1] = 0;  // zero register
        reg_file[2] = 0;
        reg_file[3] = 0;

        // Program:
        // 0: SUB R0 = R0 - R1 (R1=0 → no change first time)
        // 1: SUB R0 = R0 - 1 (simulate decrement)
        // 2: BNE R0, R1 -> jump to 1
        // 3: ADD dummy

        program[0] = 8'b00_01_00_00; // ADD R0 = R0 + R1
        program[1] = 8'b00_01_01_01; // SUB R0 = R0 - R1
        program[2] = 8'b00_01_01_11; // BNE R0,R1 -> target=1
        program[3] = 8'b00_00_00_00; // End
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 0;
        else begin

            IR <= program[PC];
            PC <= PC + 1;

            case(opcode)

                ADD:
                    reg_file[rs1] <= reg_file[rs1] + reg_file[rs2];

                SUB:
                    reg_file[rs1] <= reg_file[rs1] - 1; // simple decrement

                BEQ:
                    if (reg_file[rs1] == reg_file[rs2])
                        PC <= target;

                BNE:
                    if (reg_file[rs1] != reg_file[rs2])
                        PC <= target;

            endcase
        end
    end

    assign R0 = reg_file[0];
    assign R1 = reg_file[1];
    assign R2 = reg_file[2];
    assign R3 = reg_file[3];

endmodule