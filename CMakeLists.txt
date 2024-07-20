cmake_minimum_required(VERSION 3.16)

project(QmlCtrl VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Qml Network Bluetooth Charts Graphs Gui)

qt_standard_project_setup(REQUIRES 6.5)

set(CMAKE_AUTORCC ON)

qt_add_executable(appQmlCtrl
    main.cpp
)

qt_add_qml_module(appQmlCtrl
    URI QmlCtrl
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES Resources.qrc LoginScreen.qml ReadingsGraph.qml hkr_big.png hkr_small.jpeg beer.png
        SOURCES enose.h enose.cpp
        SOURCES authhandler.h authhandler.cpp
        RESOURCES eNose.txt
        SOURCES
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQmlCtrl PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQmlCtrl
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appQmlCtrl
    PRIVATE Qt6::Quick Qt6::Qml Qt6::Network Qt6::Bluetooth Qt6::Charts Qt6::Graphs Qt6::Gui
)

include(GNUInstallDirs)
install(TARGETS appQmlCtrl
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
