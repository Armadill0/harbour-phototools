# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-phototools

CONFIG += sailfishapp

SOURCES += src/harbour-phototools.cpp

OTHER_FILES += qml/harbour-phototools.qml \
    qml/pages/CoverPage.qml \
    rpm/harbour-phototools.changes.in \
    rpm/harbour-phototools.spec \
    rpm/harbour-phototools.yaml \
    harbour-phototools.desktop \
    qml/pages/DepthOfFieldPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/CameraSetupPage.qml \
    qml/pages/LandingPage.qml \
    qml/localdb.js

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-phototools.ts

# App version
DEFINES += APP_VERSION=\"\\\"$${VERSION}\\\"\"
