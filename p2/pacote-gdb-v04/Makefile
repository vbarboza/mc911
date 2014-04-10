#
# pacote v04
# 
# Como compilar:
# $ make
#
# Como executar o compilador:
# $ make run
#
# Como gerar bytecode:
# $ make bytecode 
#
# Como executar o bytecode:
# $ lli teste.bc
#

SOURCES = $(wildcard src/**/*.java)
CLASSES = $(SOURCES:.java=.class)
current_dir = $(shell pwd)

all: $(CLASSES)

%.class: %.java
	javac -classpath src:lib/projeto2.jar $<

run:
	java -classpath src:lib/projeto2.jar main/Main test/teste.java teste.s

bytecode:
	llvm-as teste.s -o teste.bc

exec:
	lli $(current_dir)/teste.bc

clean:
	rm -f src/llvm/*.class src/llvmast/*.class