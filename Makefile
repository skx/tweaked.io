
#
# Rebuild the site.
#
build: clean
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
	rsync -vazr output/ s-tweaked@www.steve.org.uk:htdocs/