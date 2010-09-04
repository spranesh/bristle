all: bristle remove-unwanted

bristle: bristle.hs
	ghc --make bristle.hs

install: bristle bristle-compile
	cp bristle bristle-compile /usr/bin
	chmod 755 /usr/bin/bristle /usr/bin/bristle-compile
	chmod +x /usr/bin/bristle /usr/bin/bristle-compile

install-home: bristle bristle-compile
	mkdir -p ~/bin
	cp bristle bristle-compile ~/bin
	chmod 755 ~/bin/bristle ~/bin/bristle-compile
	chmod +x ~/bin/bristle ~/bin/bristle-compile

remove-unwanted:
	rm -f *.hi
	rm -f *.o

clean:
	rm -f bristle

