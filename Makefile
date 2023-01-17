configure: pasta_base link_config
	@printf "\nConfigurado com sucesso\n\n"

link_config:
	ln -s /opt/proximo-ep-gui/proximo-ep-gui.sh /usr/local/bin/proximo-ep-gui.sh
	ln -s /opt/proximo-ep-gui/proximo-ep-gui.desktop /usr/share/applications/proximo-ep-gui.desktop	

pasta_base: proximo-ep-gui
	cp -vr proximo-ep-gui /opt/proximo-ep-gui
	chmod 755 /opt/proximo-ep-gui/proximo-ep-gui.sh

uninstall:
	rm /usr/share/applications/proximo-ep-gui.desktop
	rm /usr/local/bin/proximo-ep-gui.sh
	rm -rf /opt/proximo-ep-gui