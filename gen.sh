#!/bin/bash
set -x

cd `dirname $0`

# Clear out build
rm -vrf docs

# Copy static files
mkdir -p docs
cp -vrf ./static docs/static

# Generate pages
find pages/ -name '*.html' | while read page; do
    output=`realpath --relative-to $PWD/pages $page`
    output_dir=`dirname $output`
    mkdir -p docs/$output_dir
    extra_headers=''
    extra_footers=''
    if [[ "$page" = *"blog"* ]]; then
         extra_headers="$extra_headers components/blog-header.html"
	 extra_footers="$extra_footers components/blog-footer.html"
    fi
    cat components/header.html $extra_headers $page $extra_footers components/footer.html > docs/$output
done

# Build the blog index
mkdir -p docs/blog
cat components/header.html > docs/blog/index.html
cat components/blog-header.html >> docs/blog/index.html
page=$(find pages/blog/ -name '*.html' | sort -hr | head -n1)
if [[ "$page" != "" ]]; then
    base=`basename $page .html`
    awk '/<!--summary-->/,/<!--\/summary-->/' $page >> docs/blog/index.html
    echo "<p><a href=\"/blog/${base}\">Read more...</a></p>" >> docs/blog/index.html
    echo "<div class=\"hr\"></div><strong class=\"magenta\">Articles</strong><br />" >> docs/blog/index.html
    echo "<ul>" >> docs/blog/index.html
    find pages/blog/ -name '*.html' | sort -hr | while read page; do
        base=`basename $page .html`
        echo "<li><a href=\"/blog/${base}\">${base}</a></li>" >> docs/blog/index.html
    done
    echo "</ul>" >> docs/blog/index.html
fi
cat components/blog-footer.html >> docs/blog/index.html
cat components/footer.html >> docs/blog/index.html
