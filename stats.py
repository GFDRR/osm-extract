import click
import json

actions="""

function makeList(data){
  var result = "<ul>";
  for (var key in data) {
    if (data.hasOwnProperty(key)) {
      result += "<li><span class='name'>" + key + " </span>|<a href='data/" + data[key] + ".shp.zip'> .shp</a> | <a href='data/" + data[key] + ".sql.zip'>.sql</a> | <a href='data/" + data[key] + ".pbf'>.pbf</a> | </li>"
    }
  }
  result += "</ul>"
  return result
}

document.write(makeList(data.list));
"""

@click.command()
@click.option('--names', help='Filenames.')
def stats(names):
    """Simple program that generates stats for OSM exports"""
    output='var data = {"list": %s}'
    names = names.split(" ")
    data=dict(zip([x.title().replace('_',' ') for x in names], names))
    click.echo(output % json.dumps(data))
    click.echo(actions)

if __name__ == '__main__':
    stats()
