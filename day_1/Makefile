.PHONY: a b

a:
	@ghc -no-keep-hi-files -no-keep-o-files a.hs && ./a < input.txt
	rm -f ./a

b:
	@ghc -no-keep-hi-files -no-keep-o-files b.hs && ./b < input.txt
	rm -f ./b
