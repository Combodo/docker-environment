cd ../../
# Affichage en couleur
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${RED}Stopping PHP containers...${NC}"
docker ps -a --format '{{.Names}}' | grep '^php[0-9]' | xargs -r docker stop
echo -e "${GREEN}Starting PHP containers...${NC}"
docker ps -a --format '{{.Names}}' | grep '^php[0-9]' | xargs -r docker start
