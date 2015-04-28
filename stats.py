import click
import json
import time
import os

actions="""
document.write(result);
"""
extentions = ['sql.zip', 'pbf', 'shp.zip']

@click.command()
@click.option('--names', help='Filenames.')
def stats(names):
    """Simple program that generates stats for OSM exports"""
    output='var data = {"list": %s}'
    names = names.split(" ")
    data = {}

    out = "<ul>"
    for table in names:
        
        out = out + "<li><span class='name'>%s</span> |"
        files = {}
        for extention in extentions:
            filename = "%s.%s" % (table, extention)
            size = os.path.getsize(filename)
            date = time.ctime(os.path.getmtime(filename))
            download = 'data/%s' % filename
            files[extention] = ('data/%s' % filename, size, date)
            out = out + "|<a href='%s'>%s</a> %s %s" % (download, filename, size, date)
        
        data[table.title().replace('_',' ')] = files

	out= out + "</ul>"
	click.echo('var result= "%s"' % out)
click.echo(actions)

if __name__ == '__main__':
    stats()
