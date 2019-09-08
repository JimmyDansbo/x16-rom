layouts="406 407 409 40A 40B 40C 40E 410 414 415 416 41D 807 809 80C"

rm -rf asm
mkdir asm
for layout in $layouts; do
	filename=$(ls klc/${layout}\ *.klc)
	python3 klc_to_asm.py "$filename" > asm/$layout.s
done
