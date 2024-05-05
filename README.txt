//SWAYAM MISHRA
//2022CSB1134
A Compiler U Can Understand

Compile & Run:
->	Enter the following commands to compile the compiler
	-	lex cucu.l
	-	yacc -d cucu.y
	-	gcc y.tab.c -o cucu
	-	./cucu <samplename>.cu

Limitations:
->	Conditional and Loop statments needs to have statements in curly brackets, to handle dangling else.
->	else if construct not allowed.
->	No for loops
->	Increment and decrement operators not allowed.
->	Bitwise operators are not allowed.
->	Modulo Operator not supported
->	Only 2 data types i.e. "int" and "char*" are supported.
->      A function should not contain empty parameters or no parameter profile.
->	Outside of an function only following things are allowed:
	-	Variable Declaration/Definition
	-	Function Declaration/Definition
->	Function cannot be defined inside a function.

Output:
->      If above points are fulfilled then a successfully compiled message will be displayed on terminal, else failed message will be displayed.
->	The compiler will run on the file and generate 2 output files Lexer.txt and Parser.txt.
->	Lexer.txt contains the token information.
->	Parser.txt contains the	structural information the the compiler extracted from the file.
