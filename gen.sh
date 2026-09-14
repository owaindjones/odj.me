#!/bin/bash
set -x

cd `dirname $0`

# Clear out build
rm -vrf build

# Copy static files
mkdir -p build
cp -vrf ./static build/static

# Generate pages
find pages/ -name '*.html' | while read page; do
    output=`realpath --relative-to $PWD/pages $page`
    output_dir=`dirname $output`
    mkdir -p build/$output_dir
    extra_headers=''
    extra_footers=''
    if [[ "$page" = *"blog"* ]]; then
         extra_headers="$extra_headers components/blog-header.html"
	 extra_footers="$extra_footers components/blog-footer.html"
    fi
    cat components/header.html $extra_headers $page $extra_footers components/footer.html > build/$output
done

# Build the blog index
mkdir -p build/blog
cat components/header.html > build/blog/index.html
cat components/blog-header.html >> build/blog/index.html
page=$(find pages/blog/ -name '*.html' | sort -hr | head -n1)
if [[ "$page" != "" ]]; then
    base=`basename $page .html`
    awk '/<!--summary-->/,/<!--\/summary-->/' $page >> build/blog/index.html
    echo "<p><a href=\"/blog/${base}\">Read more...</a></p>" >> build/blog/index.html
    echo "<div class=\"hr\"></div><strong class=\"magenta\">Articles</strong><br />" >> build/blog/index.html
    echo "<ul>" >> build/blog/index.html
    find pages/blog/ -name '*.html' | sort -hr | while read page; do
        base=`basename $page .html`
        echo "<li><a href=\"/blog/${base}\">${base}</a></li>" >> build/blog/index.html
    done
    echo "</ul>" >> build/blog/index.html
fi
cat components/blog-footer.html >> build/blog/index.html
cat components/footer.html >> build/blog/index.html
