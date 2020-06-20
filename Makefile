.PHONY: test testv clean

test: test-suite-data
	prove -lr t

testv: test-suite-data
	prove -lrv t

clean:
	rm -rf test-suite-data

test-suite-data:
	git clone https://github.com/yaml/yaml-test-suite \
		--depth 1 -b data-2020-02-11 $@
