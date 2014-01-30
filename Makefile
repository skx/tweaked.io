
#
# Rebuild the site.
#
build:
	templer --force

#
# Clean the site.
#
clean:
	rm -rf output

#
# Upload the site
#
upload: build
	rsync -vazr output/ s-tweaked@www.steve.org.uk:htdocs/