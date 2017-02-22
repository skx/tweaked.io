
%.css : %.in
		python /usr/share/pyshared/slimmer/slimmer.py $< css --output=$@

default: s.css c.css
	@echo "OK"

clean:
	rm *.css || true
