
SRC = ./src
BLD = ./build

build : myml

myml : bis lex.yy.c ${SRC}/Table_des_symboles.c ${SRC}/Table_des_chaines.c ${SRC}/Attribut.c ${SRC}/PCode.c
	gcc -o ${BLD}/myml ${BLD}/lex.yy.c ${BLD}/y.tab.c ${SRC}/Table_des_symboles.c ${SRC}/Table_des_chaines.c ${SRC}/Attribut.c ${SRC}/PCode.c
	@ mv ${BLD}/myml ./

bis : ${SRC}/myml.y
	mkdir -p -m 600 ${BLD}
	bison -y -d -v ${SRC}/myml.y
	@ mv y.tab.h ${BLD}
	@ mv y.tab.c ${BLD}

lex.yy.c :	${SRC}/myml.l bis
	flex ${SRC}/myml.l
	@ mv lex.yy.c ${BLD}
	@ mv y.output ${BLD}

test : myml
	for n in 1 2 3 4 5 6; do \
		./myml test$$n.ml ; \
	done

run : test
	for n in 1 2 3 4 5 6; do \
		gcc -o test$$n test$$n.c ${SRC}/PCode.c; \
	done

	@ for n in 1 2 3 4 5 6; do \
		./test$$n ; \
	done

clean :	
	rm -rf ./build/ myml *.p *.fp *.c test*


