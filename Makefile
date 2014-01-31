
#
# A rule for compressing the CSS
#
%.css : %.in
	@test -e /usr/share/pyshared/slimmer/slimmer.py || echo "apt-get install python-slimmer"
	@python /usr/share/pyshared/slimmer/slimmer.py $< css --output=$@

#
# Rebuild the site.
#
build: clean input/css/style.css
	templer --force

#
# Clean the site.
#
clean:
	rm -rf output

serve: build
	templer --serve=4433

#
# Upload the site
#
upload: build
	rsync -vazr --delete output/ s-tweaked@www.steve.org.uk:htdocs/