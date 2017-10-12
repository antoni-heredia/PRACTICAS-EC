
BIN = bin
SRC = src

all: $(BIN)/suma32bits $(BIN)/suma64bits $(BIN)/suma64bitsSigno

$(BIN)/suma32bits: $(SRC)/suma32bits.s
	gcc -m32 $(SRC)/suma32bits.s -o $(BIN)/suma32bits

$(BIN)/suma64bits: $(SRC)/suma64bits.s
	gcc -m32 suma64bits.s -o $(BIN)/suma64bits

$(BIN)/suma64bitsSigno: $(SRC)/suma64bitsSigno.s
	gcc -m32 $(SRC)/suma64bitsSigno.s -o $(BIN)/suma64bitsSigno
