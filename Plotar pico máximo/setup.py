from PyQt5 import QtWidgets, uic, QtGui
from pyqtgraph import PlotWidget, plot
import pyqtgraph as pg
import sys  # We need sys so that we can pass argv to QApplication
import os
import pandas as pd


class MainWindow(QtWidgets.QMainWindow):

    def __init__(self, *args, **kwargs):
        super(MainWindow, self).__init__(*args, **kwargs)

        #Load the UI Page
        uic.loadUi('ihm_css.ui', self)

        self.button = self.findChild(QtWidgets.QPushButton, 'bt_importar')  # Find the button
        self.button.clicked.connect(self.plot)

        self.label_max = self.findChild(QtWidgets.QLabel, 'label_max')
        self.label_min = self.findChild(QtWidgets.QLabel, 'label_min')

        self.barra_carregar = self.findChild(QtWidgets.QProgressBar, 'progressBar')

        self.barra_carregar.hide()

    def plot(self):

        fname = QtWidgets.QFileDialog.getOpenFileNames(self, 'Selecionar arquivo', 'C:/')

        x = []
        fs = len(fname[0]) #100%
        cont = 0
        self.barra_carregar.setValue(0)
        self.barra_carregar.show()
        for i in fname[0]:
            cont = cont + 1
            data = pd.read_csv(i, sep=",", header=None)
            x.append(max(data.iloc[1, 0:5999]))
            self.barra_carregar.setValue(int((cont*100)/fs))

        self.barra_carregar.hide()
        self.graphWidget.clear()
        self.graphWidget.plot(x, pen=None, symbol='x')


def main():
    app = QtWidgets.QApplication(sys.argv)
    main = MainWindow()
    main.show()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
