#!/bin/sh

VERSION=4.6.0
PREFIX="${HOME}/sw"
QTDIR="qt-everywhere-opensource-src-${VERSION}"
echo "Removing old build..."
rm -fr ${QTDIR}

tarball="${QTDIR}.tar"

echo "Extracting..."
# Do they have a bzip'd or a gzip'd tarball?
if test -f ${tarball}.bz2 ; then
  tar jxf ${tarball}.bz2
elif test -f ${tarball}.gz ; then
  tar zxf ${tarball}.gz
else
  echo "${tarball}.gz not found; Downloading Qt..."
  curl -kLO http://get.qt.nokia.com/qt/source/${tarball}.gz
  tar zxf ${tarball}.gz
fi
pushd ${QTDIR} || exit 1
echo "yes" | \
./configure \
        -prefix ${HOME}/sw \
        -arch x86_64 \
        -buildkey "imagevis3d" \
        -fast \
        -stl \
        -release \
        -opensource \
        -opengl \
        -qt-libjpeg \
        -qt-libtiff \
        -qt-gif \
        -no-sql-sqlite \
        -no-sql-sqlite2 \
        -no-xmlpatterns \
        -no-phonon \
        -no-phonon-backend \
        -no-webkit \
        -no-svg \
        -no-scripttools \
        -no-nis \
        -no-gtkstyle \
        -no-nas-sound \
        -no-xinerama \
        -no-dbus \
        -no-cups \
        -no-openssl \
        -no-qt3support \
        -make libs \
        -make tools \
        -cocoa

if test $? -ne 0; then
        echo "configure failed"
        exit 1
fi

nice make -j6 || exit 1

rm -fr ${PREFIX}/bin/qmake ${PREFIX}/lib/libQt* ${PREFIX}/lib/Qt*
rm -fr ${PREFIX}/include/Qt*

nice make install || exit 1

popd
