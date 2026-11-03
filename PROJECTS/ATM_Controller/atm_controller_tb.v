
`timescale 1ns/1ps

module atm_machine_tb;

    reg clk;
    reg reset;
    reg card_inserted;
    reg pin_correct;
    reg amount_selected;
    reg balance_available;
    reg cash_collected;

    wire card_reader;
    wire pin_check;
    wire cash_dispense;
    wire receipt_print;
    wire transaction_done;

    // Device Under Test
    atm_machine uut (
        .clk(clk),
        .reset(reset),
        .card_inserted(card_inserted),
        .pin_correct(pin_correct),
        .amount_selected(amount_selected),
        .balance_available(balance_available),
        .cash_collected(cash_collected),
        .card_reader(card_reader),
        .pin_check(pin_check),
        .cash_dispense(cash_dispense),
        .receipt_print(receipt_print),
        .transaction_done(transaction_done)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin

        // Initialize inputs
        clk = 1'b0;
        reset = 1'b1;
        card_inserted = 1'b0;
        pin_correct = 1'b0;
        amount_selected = 1'b0;
        balance_available = 1'b0;
        cash_collected = 1'b0;

        // Reset
        #12;
        reset = 1'b0;

        // Insert ATM card
        @(negedge clk);
        card_inserted = 1'b1;
        @(negedge clk);
        card_inserted = 1'b0;

        // Enter correct PIN
        @(negedge clk);
        pin_correct = 1'b1;
        @(negedge clk);
        pin_correct = 1'b0;

        // Select withdrawal amount
        @(negedge clk);
        amount_selected = 1'b1;
        @(negedge clk);
        amount_selected = 1'b0;

        // Check account balance
        @(negedge clk);
        balance_available = 1'b1;
        @(negedge clk);
        balance_available = 1'b0;

        // Collect cash
        repeat (2) @(negedge clk);
        cash_collected = 1'b1;
        @(negedge clk);
        cash_collected = 1'b0;

        // Check transaction completion
        @(negedge clk);
        if (transaction_done === 1'b1)
            $display("TEST PASSED: ATM Transaction Completed!");
        else
            $display("TEST FAILED: Transaction not completed.");

        #10;
        $finish;

    end

    // Display state and outputs
    initial begin
        $monitor(
            "Time=%0t | State=%b | Card=%b | PIN=%b | Cash=%b | Receipt=%b | Done=%b",
            $time, uut.state, card_reader, pin_check,
            cash_dispense, receipt_print, transaction_done
        );
    end

endmodule
