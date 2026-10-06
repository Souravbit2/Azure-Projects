
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Azure Calculator</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .calculator {
            background-color: #ffffff;
            border-radius: 1.5rem; /* More rounded corners */
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
            width: 100%;
            max-width: 320px; /* Slightly wider for better button spacing */
        }
        .display {
            background-color: #e2e8f0; /* Light gray background for display */
            color: #1a202c; /* Dark text for display */
            font-size: 2.5rem; /* Larger font size */
            text-align: right;
            padding: 1rem;
            border-radius: 0.75rem; /* Rounded corners for display */
            margin-bottom: 1rem;
            height: 60px; /* Fixed height for display */
            display: flex;
            align-items: center;
            justify-content: flex-end;
            overflow-x: auto; /* Allow horizontal scrolling for long numbers */
            white-space: nowrap; /* Prevent wrapping */
        }
        .buttons {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 0.75rem; /* Increased gap between buttons */
        }
        .btn {
            background-color: #cbd5e0; /* Default button color */
            color: #2d3748; /* Dark text for buttons */
            font-size: 1.5rem; /* Larger font size for buttons */
            padding: 1rem 0.5rem; /* Adjusted padding */
            border-radius: 0.75rem; /* Rounded corners for buttons */
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            border: none;
            outline: none;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* Subtle button shadow */
        }
        .btn:hover {
            background-color: #a0aec0; /* Darker on hover */
            transform: translateY(-2px); /* Slight lift effect */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15); /* Enhanced shadow on hover */
        }
        .btn-operator {
            background-color: #4299e1; /* Blue for operators */
            color: #ffffff; /* White text for operators */
        }
        .btn-operator:hover {
            background-color: #3182ce; /* Darker blue on hover */
        }
        .btn-equals {
            background-color: #38a169; /* Green for equals */
            color: #ffffff;
            grid-column: span 2; /* Make equals button span two columns */
        }
        .btn-equals:hover {
            background-color: #2f855a; /* Darker green on hover */
        }
        .btn-clear {
            background-color: #e53e3e; /* Red for clear */
            color: #ffffff;
        }
        .btn-clear:hover {
            background-color: #c53030; /* Darker red on hover */
        }
    </style>
</head>
<body>
    <div class="calculator">
        <div id="display" class="display">0</div>
        <div class="buttons">
            <button class="btn btn-clear" onclick="clearDisplay()">C</button>
            <button class="btn btn-operator" onclick="appendValue('/')">/</button>
            <button class="btn btn-operator" onclick="appendValue('*')">*</button>
            <button class="btn btn-operator" onclick="deleteLast()">DEL</button>
            <button class="btn" onclick="appendValue('7')">7</button>
            <button class="btn" onclick="appendValue('8')">8</button>
            <button class="btn" onclick="appendValue('9')">9</button>
            <button class="btn btn-operator" onclick="appendValue('-')">-</button>
            <button class="btn" onclick="appendValue('4')">4</button>
            <button class="btn" onclick="appendValue('5')">5</button>
            <button class="btn" onclick="appendValue('6')">6</button>
            <button class="btn btn-operator" onclick="appendValue('+')">+</button>
            <button class="btn" onclick="appendValue('1')">1</button>
            <button class="btn" onclick="appendValue('2')">2</button>
            <button class="btn" onclick="appendValue('3')">3</button>
            <button class="btn btn-equals" onclick="calculateResult()">=</button>
            <button class="btn" onclick="appendValue('0')">0</button>
            <button class="btn" onclick="appendValue('.')">.</button>
        </div>
    </div>
    <script>
        // Get the display element
        const display = document.getElementById('display');
        // Variable to store the current input/result
        let currentInput = '0';
        // Variable to store the previous input
        let previousInput = '';
        // Variable to store the operator
        let operator = null;
        // Flag to indicate if a calculation has just been performed
        let calculated = false;
        /**
         * Appends a value (number or operator) to the display.
         * @param {string} value The value to append.
         */
        function appendValue(value) {
            // If a calculation was just performed and a number is pressed, start a new calculation
            if (calculated && !isNaN(value)) {
                currentInput = value;
                calculated = false;
            } else if (calculated && isNaN(value) && value !== '.') { // If operator is pressed after calculation, continue with result
                calculated = false;
                // Do nothing, currentInput already holds the result
            }
            else if (currentInput === '0' && value !== '.') {
                currentInput = value;
            } else if (value === '.' && currentInput.includes('.')) {
                // Do nothing if decimal already exists
                return;
            } else {
                currentInput += value;
            }
            updateDisplay();
        }
        /**
         * Clears the display and resets all variables.
         */
        function clearDisplay() {
            currentInput = '0';
            previousInput = '';
            operator = null;
            calculated = false;
            updateDisplay();
        }
        /**
         * Deletes the last character from the display.
         */
        function deleteLast() {
            if (currentInput.length > 1) {
                currentInput = currentInput.slice(0, -1);
            } else {
                currentInput = '0';
            }
            updateDisplay();
        }
        /**
         * Performs the calculation based on the stored operator and numbers.
         */
        function calculateResult() {
            if (operator === null || previousInput === '') {
                return; // Nothing to calculate
            }
            let result;
            const prev = parseFloat(previousInput);
            const current = parseFloat(currentInput);
            if (isNaN(prev) || isNaN(current)) {
                display.textContent = 'Error';
                currentInput = '0';
                previousInput = '';
                operator = null;
                calculated = false;
                return;
            }
            switch (operator) {
                case '+':
                    result = prev + current;
                    break;
                case '-':
                    result = prev - current;
                    break;
                case '*':
                    result = prev * current;
                    break;
                case '/':
                    if (current === 0) {
                        display.textContent = 'Error: Div by 0';
                        currentInput = '0';
                        previousInput = '';
                        operator = null;
                        calculated = false;
                        return;
                    }
                    result = prev / current;
                    break;
                default:
                    return;
            }
            currentInput = result.toString();
            previousInput = '';
            operator = null;
            calculated = true; // Set flag after calculation
            updateDisplay();
        }
        /**
         * Updates the display with the current input.
         */
        function updateDisplay() {
            display.textContent = currentInput;
        }
        // Initial display update
        updateDisplay();
        // Event listener for keyboard input (optional but good for usability)
        document.addEventListener('keydown', (e) => {
            const key = e.key;
            if (key >= '0' && key <= '9') {
                appendValue(key);
            } else if (key === '.') {
                appendValue('.');
            } else if (key === '+' || key === '-' || key === '*' || key === '/') {
                // If an operator is pressed, store the current input as previous and set the operator
                if (currentInput !== '0' && !isNaN(currentInput)) { // Only store if currentInput is a valid number
                    previousInput = currentInput;
                    currentInput = '0'; // Reset current input for the next number
                    operator = key;
                    calculated = false; // Reset calculated flag
                }
            } else if (key === 'Enter' || key === '=') {
                calculateResult();
            } else if (key === 'Backspace') {
                deleteLast();
            } else if (key === 'Escape') { // 'Esc' key for clear
                clearDisplay();
            }
        });
        // Add click listeners for operators to handle the logic of storing previous input
        document.querySelectorAll('.btn-operator').forEach(button => {
            button.addEventListener('click', () => {
                const op = button.textContent;
                if (currentInput !== '0' && !isNaN(currentInput)) { // Only store if currentInput is a valid number
                    previousInput = currentInput;
                    currentInput = '0'; // Reset current input for the next number
                    operator = op;
                    calculated = false; // Reset calculated flag
                }
            });
        });
    </script>
</body>
</html>
