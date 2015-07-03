/*
  Copyright (C) 2015 Thomas Amler
  Contact: Thomas Amler <armadillo [at] penguinfriends.org>
  All rights reserved.

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QTranslator>
#include <QLocale>
#include <QScopedPointer>
#include <QGuiApplication>
#include <QtGui>
#include <QtQml>
#include <QProcess>
#include <QQuickView>


int main(int argc, char *argv[])
{
    QProcess appinfo;
    QString appversion;
    QString appname = "harbour-phototools";

    QCoreApplication::setOrganizationName(appname);
    QCoreApplication::setApplicationName(appname);

    // read app version from rpm database on startup
    appinfo.start("/bin/rpm", QStringList() << "-qa" << "--queryformat" << "%{version}" << appname);
    appinfo.waitForFinished(-1);
    if (appinfo.bytesAvailable() > 0) {
        appversion = appinfo.readAll();
    }

    QGuiApplication* app = SailfishApp::application(argc, argv);

    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    QTranslator defaultTranslator;
    defaultTranslator.load("en_US", SailfishApp::pathTo(QString("localization")).toLocalFile());
    app->installTranslator(&defaultTranslator);

    QTranslator translator;
    translator.load(QLocale::system().name(), SailfishApp::pathTo(QString("localization")).toLocalFile());
    app->installTranslator(&translator);

    QQuickView* view = SailfishApp::createView();
    view->rootContext()->setContextProperty("version", appversion);
    view->setSource(SailfishApp::pathTo("qml/harbour-phototools.qml"));
    view->show();

    return app->exec();
}

