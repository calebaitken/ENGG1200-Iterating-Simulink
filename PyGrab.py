import shutil
import tempfile
import urllib.request
import csv
import os

def download_data(airfoil_name):
    url = ("http://airfoiltools.com/polar/csv?polar=xf-" + airfoil_name + "-100000")
    alpha = []
    cl = []
    cd = []
    with urllib.request.urlopen(url) as response:
        with tempfile.NamedTemporaryFile(delete=False) as tmp_file:
            shutil.copyfileobj(response, tmp_file)

    with open(tmp_file.name, newline='') as csvfile:
        airfoil_data = csv.reader(csvfile)
        for i, row in enumerate(airfoil_data):
            if i >= 11:
                alpha.append(row[0])
                cl.append(row[1])
                cd.append(row[2])
    with open(('Airfoil Data/' + airfoil_name + '.csv'), "w+", newline='') as csvfile:
        airfoil_writer = csv.writer(csvfile)
        for i, data in enumerate(alpha):
            airfoil_writer.writerow([alpha[i], cl[i], cd[i]])


if __name__=='__main__':
    for file in os.listdir('Airfoil Name CSVs'):
        with open(('Airfoil Name CSVs/' + file), 'r', newline='') as csvfile:
            names_reader = csv.reader(csvfile)
            for row in names_reader:
                try:
                    download_data(row[0])
                except IOError:
                    print("Failed to download: " + row[0])