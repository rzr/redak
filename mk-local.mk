#! /usr/bin/make -f
#ident "$Id: $"
#* @author: rzr@gna.org - rev: $Author: rzr$
#* Copyright: See README file that comes with this distribution
#*****************************************************************************
default: help

package?=redak
#version?=0.0.0
version?=0.7.1


#TODO: upgrade with yours
#qtcreator?=/usr/local/opt/QtSDK/QtCreator/bin/qtcreator
qtcreator?=qtcreator

setup:mk-local.mk
	@echo "include $<" > Makefile
	zypper install qt-creator

help:
	@echo "edit"


edit: clean
	${qtcreator} *.pro

rule/android/edit: clean
	/usr/local/opt/necessitas/QtCreator/bin/necessitas \
	*.pro

#TODO
rule/android/configure:
	/usr/local/opt/android-sdk-linux/tools/android  update project -t android-7 -p android


clean:
	rm -rf  ../${package}-build-* *.o moc_*.cpp *~ Makefile
	-cat 'debian/clean' | while read t ; do rm -rv "$${t}" ; done


distclean: clean
	cat debian/clean.txt | while read t ; do rm -rfv "$${t}" ; done
	rm -rvf *.user *.zip *.sis *~ *.so *.tmp
	rm -rvf obj ./android/bin android/assets/qml/${package} android/libs/armeabi
	chmod -Rv a+rX .
	chmod -Rv u+rwX .
	find . -iname "*~" -exec rm -v '{}' \;
	find . -iname "*.class" -exec rm -v '{}' \;
	find . -iname "*.apk" -exec rm -v '{}' \;
	chmod o-rx src/*.cpp src/*.h *.pro *.png *.svg *.spec *.txt
	chmod o-rx COPYING
	rm -fv *.pkg
	rm -fv *.autosave


rule/perm:
	sudo chown -Rv ${USER} .
	chmod -Rv u+rwX .


dist: distclean COPYING release rule/local/release


ruke/diff:
	git diff --ignore-space-at-eol


rule/diff/common: qml/${package}/meego qml/${package}/common
	meld $^


COPYING: /usr/share/common-licenses/GPL-3
	cp -a $< $@


debian/diff: debian qtc_packaging/debian_harmattan
	meld $^


diff: qml/${package}/meego qml/${package}/symbian
	meld $^


install:
	-ls ../${package}*/*.sis
	-ls ../${package}-build-remote/${package}_qt-4_7_4_symbianBelle.sis
	ln -fs $(pwd)/../*/*.sis ~/public_html/pub/file/

deploy:
	find ${CURDIR}-build-remote/ -type f -iname "*.sis" \
	| while read t ; do ln -fs $${t} ~/public_html/pub/file/ ; done

all:
	qmake-qt4
	make CXXFLAGS=-fPIC


run: qml/${package}/common/main.qml all
	qmlviewer -maximized -P ${CURDIR}/ $<


run/py: ${package}.py
	${<D}/${<F}


test:distclean all run clean


debuild:distclean
	fakeroot ./debian/rules binary
	dpkg --contents ../*.deb


dep/desktop:
	${sudo} apt-get install \
	  libqt4-declarative-folderlistmodel libqt4-dev


dep/harmattan:
	${sudo} apt-get install \
	  applauncherd-dev pkg-config make

#%: rule/local/%


release: distclean rule/local/release


rule/version:
#	echo '${version}' | tee -a VERSION.txt
	sed -e "s/^var g_version.*/var g_version = \"${version}\" ;/g" -i "qml/${package}/common/script.js"
	sed -e "s/^var g_version.*/var g_version = \"${version}\" ;/g" -i "platform/bb/assets/script.js"
	sed -e "s/^[ ]*VERSION.*/VERSION=${version}/g" -i ${package}.pro
	sed -e "s/^Version:.*/Version: ${version}/g" -i ${package}.spec
	echo "# TODO: check debian/changelog *.changes *.pkg"
	dch -i


check/release:
	@echo "# check version in script.js debian/changelog "
	grep -r -i 'g_version' qml/${package}/common/script.js
	grep 'Version:' ${package}.spec


rule/local/%:
	echo "todo: $@"


${package}64.png: ${package}.svg  mk-local.mk
	convert -resize 64x64  $< $@


${package}90.png: ${package}.svg  mk-local.mk
	convert -resize 90x90  $< $@
	mv ${package}90.png platform/bb/icon.png


convert/%: ${package}.svg  mk-local.mk
	convert -resize ${@F}x${@F}  $< tmp-${@F}.png


icon.txt.tmp: ${package}.svg  mk-local.mk
	convert -resize 26x26  $< tmp.png
	base64 < tmp.png | tr -d '\n' > $@
	wc $@
	rm -f tmp.png


# custom rules

rule/build/platform/symbian: qml
	grep -re "import Qt.labs.folderlistmodel 1.1" qml | grep -ve '[^:]*://' || echo "ok" 
	@echo "todo: deploy ovi wizard"


rule/install/platform/symbian: qml
	grep DEPLOY_TARGET bld.inf 
	md5sum *.sis | tee -a README.txt
	@echo "todo: upload: ${package}_installer_unsigned.sis"
	@echo "todo: https://publish.nokia.com/download_items/show/475539#item"


rule/diff/platform/bb: platform/bb
	meld . $<
	meld qml/${package}/meego/ $</assets/
	meld qml/${package}/cascades/ $</assets/
	meld qml/${package}/common/ qml/${package}/cascades/


rule/install/platform/bb: ${package}.svg  mk-local.mk
	find  platform/bb/ -iname "*.bar"
#	platform/bb/arm/o.le-v7-g/${package}.bar
#	platform/bb/arm/o.le-v7/${package}-0_7_1_0.bar
	convert -resize 480x480  $< doc/${package}-480.png
#	convert  screenshot.png   -gravity center   -extent 1920x1186 ${package}.jpg
#	convert  screenshot.png   -gravity center   -resize 90x90\! icon.png
#	convert  screenshot.png   -gravity center   -resize 480x480\! icon.jpg
	convert  screenshot.png   -gravity center   -resize 480x480\! doc/logo.png



rule/clean/platform/bb: platform/bb
	rm -rfv $</x86
	rm -rfv $</arm


-include ~/bin/mk-local.mk
