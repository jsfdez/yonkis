TEMPLATE = app

QT += qml quick widgets

LIBS += -L"C:/OpenSSL-Win32/lib" -llibeay32

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

QMAKE_CXXFLAGS = -std=c++11

# Default rules for deployment.
include(deployment.pri)


