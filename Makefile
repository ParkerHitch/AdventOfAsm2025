CC=clang
DAYFLAGS=-lc -g

.PHONY: day%
day%: ./build/day%
	./build/$@ ./input/$@.txt

.PHONY: day%.py
day%.py:
	python3 ./python/$@

# disable deleting the day object files
.SECONDARY:

build/day%: days/day%.s | build
	$(CC) $(DAYFLAGS) $< -o $@

build:
	mkdir build

.PHONY: clean
clean:
	rm -rf build
