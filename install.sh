#!/bin/bash
# Farben für Ausgaben
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. Prüfen, ob Taktische-Zeichen vorhanden ist
if [ ! -d "kats/pictograms" ]; then
    if [ ! -d "Taktische-Zeichen" ]; then
        echo -e "${GREEN}Das Verzeichnis _ROH/Taktische-Zeichen existiert nicht.${NC}"
        read -p "Soll das Repository 'Taktische-Zeichen' von GitHub geklont werden? [j/N] " clone_tz
        if [[ "$clone_tz" =~ ^([jJ]|[yY])$ ]]; then
            git clone https://github.com/jonas-koeritz/Taktische-Zeichen.git Taktische-Zeichen
            echo -e "${GREEN}Taktische-Zeichen wurde geklont.${NC}"
        else
            echo -e "${RED}Taktische-Zeichen wurde nicht geklont. Bitte manuell bereitstellen!${NC}"
        fi
    else
        echo -e "${GREEN}Taktische-Zeichen ist bereits vorhanden.${NC}"
    fi
    if [ -d "Taktische-Zeichen" ]; then
        echo -e "${RED}Taktische-Zeichen ist nicht vorhanden. Abbruch!${NC}"
        echo -e "${GREEN} Erstelle Taktische-Zeichen für die Pictoramme ${NC}"
        cd Taktische-Zeichen
        rm Makefile
        ln -s ../config/Makefile.Taktisch-Zeichen Makefile
        make svg
        cd ..
        mkdir -p kats/pictograms
        mv Taktische-Zeichen/build/svg/* kats/pictograms/
    else
        echo -e "${GREEN} Pictogramme müssen manuell erstellt werden ${NC}"
    fi
else
    echo -e "${GREEN} Pictogramme schon vorhanden ${NC}"
fi

# 2. .env anlegen, falls nicht vorhanden
if [ ! -f ".env" ]; then
	echo -e "${GREEN}Erstelle .env Datei...${NC}"
	# Werte abfragen
	read -p "Domain (ALLOWED_HOSTS, TRAEFIK_HOST, SITE_URL) [z.B. example.de]: " DOMAIN
	read -p "SECRET_KEY (beliebiger sicherer Wert): " SECRET_KEY
	read -p "OPENROUTESERVICE_APIKEY (oder 'changeme'): " OPENROUTESERVICE_APIKEY
	read -p "Dürfen anonyme Nutzer Karten anlegen? (UMAP_ALLOW_ANONYMOUS) [False]: " UMAP_ALLOW_ANONYMOUS
	UMAP_ALLOW_ANONYMOUS=${UMAP_ALLOW_ANONYMOUS:-False}
	read -p "Debug-Modus aktivieren? (DEBUG) [0]: " DEBUG
	DEBUG=${DEBUG:-0}

	# .env schreiben
	cat > .env <<EOF
# =============================
# Docker Compose Environment Variables
# =============================

# =============================
# uMap Anwendung
# =============================
ALLOWED_HOSTS=$DOMAIN
SECRET_KEY=$SECRET_KEY
OPENROUTESERVICE_APIKEY="$OPENROUTESERVICE_APIKEY"
SITE_URL=https://$DOMAIN/
UMAP_ALLOW_ANONYMOUS=$UMAP_ALLOW_ANONYMOUS
DEBUG=$DEBUG

# =============================
# Traefik (Reverse Proxy)
# =============================
TRAEFIK_HOST=$DOMAIN
EOF
	echo -e "${GREEN}.env wurde erstellt.${NC}"
else
	echo -e "${GREEN}.env ist bereits vorhanden.${NC}"
fi

# 3. Abfragen für umap.conf
read -p "Name für UMAP_HOST_INFOS (name) [THW OV]: " UMAP_NAME
UMAP_NAME=${UMAP_NAME:-THW OV}
read -p "URL für UMAP_HOST_INFOS (url) [https://www.thw.de/]: " UMAP_URL
UMAP_URL=${UMAP_URL:-https://www.thw.de/}
read -p "Kontakt für UMAP_HOST_INFOS (contact) [changeme@example.de]: " UMAP_CONTACT
UMAP_CONTACT=${UMAP_CONTACT:-changeme@example.de}

echo -e "${GREEN}Prüfe auf config/umap.conf...${NC}"
if [ ! -f "config/umap.conf" ]; then
    echo -e "${GREEN}Erstelle config/umap.conf aus Beispiel...${NC}"
    cp config/umap.conf.example config/umap.conf
    # Werte ersetzen
    sed -i "s|\("name": \).*|\1\"$UMAP_NAME\",|" config/umap.conf
    sed -i "s|\("url": \).*|\1\"$UMAP_URL\",|" config/umap.conf
    sed -i "s|\("contact": \).*|\1\"$UMAP_CONTACT\"|" config/umap.conf
else
    echo -e "${GREEN}config/umap.conf ist bereits vorhanden.${NC}"
fi

echo -e "${GREEN} docker wird gestartet${NC}"
docker compose up -d   --remove-orphans
echo -e "${GREEN} Erstelle Superuser für uMap...${NC}"
docker compose exec app umap createsuperuser