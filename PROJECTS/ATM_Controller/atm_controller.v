
module atm_machine (
    input wire clk,
    input wire reset,
    input wire card_inserted,
    input wire pin_correct,
    input wire amount_selected,
    input wire balance_available,
    input wire cash_collected,

    output reg card_reader,
    output reg pin_check,
    output reg cash_dispense,
    output reg receipt_print,
    output reg transaction_done
);

    // Moore FSM state encoding
    parameter IDLE     = 3'b000,
              CARD     = 3'b001,
              PIN      = 3'b010,
              AMOUNT   = 3'b011,
              CHECK    = 3'b100,
              DISPENSE = 3'b101,
              DONE     = 3'b110;

    reg [2:0] state, next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = state;

        case (state)

            IDLE:
                if (card_inserted)
                    next_state = CARD;

            CARD:
                next_state = PIN;

            PIN:
                if (pin_correct)
                    next_state = AMOUNT;
                else
                    next_state = IDLE;

            AMOUNT:
                if (amount_selected)
                    next_state = CHECK;

            CHECK:
                if (balance_available)
                    next_state = DISPENSE;
                else
                    next_state = IDLE;

            DISPENSE:
                if (cash_collected)
                    next_state = DONE;

            DONE:
                next_state = IDLE;

            default:
                next_state = IDLE;

        endcase
    end

    // Moore output logic
    always @(*) begin
        card_reader      = 1'b0;
        pin_check        = 1'b0;
        cash_dispense    = 1'b0;
        receipt_print    = 1'b0;
        transaction_done = 1'b0;

        case (state)

            CARD:
                card_reader = 1'b1;

            PIN:
                pin_check = 1'b1;

            DISPENSE:
                cash_dispense = 1'b1;

            DONE: begin
                receipt_print = 1'b1;
                transaction_done = 1'b1;
            end

            default: ;

        endcase
    end

endmodule
