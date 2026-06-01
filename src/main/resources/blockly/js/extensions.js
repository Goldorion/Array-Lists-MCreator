/**
 * Extension to determine which output type the blockly block in the "value" input_value field has.
 * If the given block has multiple output types, the extension will choose to use the first one.
 *
 * Usage:
 * - Add a field_input field to your procedure block and either name it "output_type" or change it in the code below
 *   You can add it anywhere in the translation, as the extension will automatically hide the field for the user
 * - Create an input_value field named "value" or change the name in the code below
 * - With field$output_type (default) you can compare the string
 *
 * Code References:
 * - arraylist_add_value.json
 * - arraylist_add_value.java.ftl (in any version directory)
 */

Blockly.Extensions.register("get_output_type",
    function () {
        const block = this;

        block.getField("output_type").setVisible(false);
        block.setOnChange(
            function (changeEvent) {
                if (!block.workspace || block.isInFlyout) {
                    return;
                }

                if ((changeEvent.type !== Blockly.Events.BLOCK_CHANGE || changeEvent.element !== 'field') &&
                    changeEvent.type !== Blockly.Events.BLOCK_MOVE) {
                    return;
                }

                const input = block.getInput("value");
                if (!input || !input.connection) {
                    return;
                }

                const target = input.connection.targetBlock();
                let type = "null";
                if (target && target.outputConnection) {
                    const check = target.outputConnection.check_;

                    if (Array.isArray(check)) {
                        type = check[0];
                    } else if (typeof check === "string") {
                        type = check;
                    } else {
                        type = "Any";
                    }
                }

                block.getField("output_type").setValue(type);
            }
        );
    }
);