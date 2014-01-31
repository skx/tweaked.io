#
# Makefile for rebuilding the http://tweaked.io/ website.
#
# Mostly this just involves using the templer tool:
#
#   http://github.com/skx/templer/
#
# But we also use the python slimmer tool to compress our CSS file.
#
#
# Targets
# -------
#
#       make clean  - Remove the generated output.
#
#       make build  - Rebuild the site.
#
#       make serve  - Build the site and serve it on http://localhost:4433/
#
#
# Steve
# --



#
# A rule for generating the CSS
#
%.css : %.in
	@test -e /usr/share/pyshared/slimmer/slimmer.py || echo "apt-get install python-slimmer"
	@python /usr/share/pyshared/slimmer/slimmer.py $< css --output=$@


#
# Rebuild the site:
#  1. Clean the site, so we're good.
#  2. Generate the CSS.
#
build: clean input/css/style.css
	templer --force

#
# Clean the site.
#
clean:
	rm -rf output

#
# Build the site and serve it locally.
#
serve: build
	templer --serve=4433


#
# Upload the site to the live location.
#
upload: build
	rsync -vazr --delete output/ s-tweaked@www.steve.org.uk:htdocs/