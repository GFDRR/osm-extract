import click
import json
import time
import os

actions="""
    var result="%s";
    document.write(result);
"""
extentions = ['sql.zip', 'pbf', 'shp.zip', 'json', 'kml']

def sizeof_fmt(num, suffix='B'):
    for unit in ['','K','M','G','T','P','E','Z']:
        if abs(num) < 1024.0:
            return "%3.1f%s%s" % (num, unit, suffix)
        num /= 1024.0
    return "%.1f%s%s" % (num, 'Yi', suffix)

@click.command()
@click.option('--names', help='Filenames.')
def stats(names):
    """Simple program that generates stats for OSM exports"""
    names = names.split(" ")
    data = {}

    out = "<ul>"
    for table in sorted(names):
        
        out = out + "<li><span class='name'>%s</span> " % table.title().replace("_", " ")
        files = {}
        for extention in extentions:
            filename = "%s.%s" % (table, extention)
            size = os.path.getsize(filename)
            date = time.ctime(os.path.getmtime(filename))
            download = 'data/%s' % filename
            files[extention] = ('data/%s' % filename, size, date)
            out = out + "<div class='box'>|    <a href='%s'>%s</a> <span class='size'>%s</span></div>" % (download, extention.upper(), sizeof_fmt(size))
        
        out = out + "|    %s</li>" % date
    out= out + "</ul>"
    
    click.echo(actions % out)

if __name__ == '__main__':
    stats()
