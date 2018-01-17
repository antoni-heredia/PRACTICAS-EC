
BIN = bin
SRC = src

all: $(BIN)/suma32bits $(BIN)/suma64uns $(BIN)/suma64sgn $(BIN)/media

$(BIN)/suma32bits: $(SRC)/suma32bits.s
	gcc -m32 $(SRC)/suma32bits.s -o $(BIN)/suma32bits

$(BIN)/suma64uns: $(SRC)/suma64uns.s
	gcc -m32 $(SRC)/suma64uns.s -o $(BIN)/suma64uns

$(BIN)/suma64sgn: $(SRC)/suma64sgn.s
	gcc -m32 $(SRC)/suma64sgn.s -o $(BIN)/suma64sgn

$(BIN)/media: $(SRC)/media.s
	gcc -m32 $(SRC)/media.s -o $(BIN)/media
