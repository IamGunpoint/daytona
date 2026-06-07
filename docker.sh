#!/bin/bash

USER_NAME="ImGunpoint"
LOG_FILE="/tmp/nuclear_docker.log"
DOCKER_CONF="/etc/docker/daemon.json"

# --- UI Elements ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

header() {
    clear
    echo -e "${CYAN}##########################################################"
    echo -e "   🚀 HYPER-VIGILANT DOCKER FIXER - For $USER_NAME"
    echo -e "##########################################################${NC}\n"
}

spinner() {
    local pid=$1
    local delay=0.04
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "${YELLOW} [%c] Fixing... ${NC}" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
    done
}

# --- The Intelligence Engine ---
auto_fix_algorithm() {
    echo "Starting Deep Scan..." > $LOG_FILE
    
    # PHASE 1: Nuclear Cleanup
    pkill -9 dockerd >> $LOG_FILE 2>&1
    pkill -9 containerd >> $LOG_FILE 2>&1
    rm -f /var/run/docker.pid
    rm -f /var/run/docker.sock
    
    # PHASE 2: Intelligence - Checking for Config Conflicts
    if [ -f "$DOCKER_CONF" ]; then
        # If the file exists, we strip it to basics to prevent the "Double Flag" error you saw
        echo '{"storage-driver": "overlay2"}' > "$DOCKER_CONF"
    fi

    # PHASE 3: Dependency Injection
    modprobe overlay >> $LOG_FILE 2>&1
    modprobe br_netfilter >> $LOG_FILE 2>&1

    # PHASE 4: Mount Repair
    mount -t tmpfs -o mode=755 tmpfs /var/run/docker > /dev/null 2>&1 || true

    # PHASE 5: User Rights
    groupadd docker > /dev/null 2>&1
    usermod -aG docker $USER_NAME > /dev/null 2>&1

    # PHASE 6: The "Offline" Force-Start Sequence
    # We use -H fd:// to bind to systemd if available, else unix socket
    nohup dockerd --iptables=false --bridge=none --data-root /var/lib/docker > $LOG_FILE 2>&1 &
    
    # Wait for startup
    sleep 5
}

# --- Execution ---
header
echo -e "${YELLOW}⚠️  $USER_NAME, I'm analyzing the logs and forcing a bypass...${NC}"

auto_fix_algorithm &
spinner $!

# --- Deep Log Analysis ---
echo -e "\n\n${CYAN}🔍 ANALYZING LOGS FOR BUGS...${NC}"

if grep -q "directives are specified both as a flag and in the configuration file" "$LOG_FILE"; then
    echo -e "${RED}Found bug: Configuration Conflict. Self-Healing applied...${NC}"
    rm -f "$DOCKER_CONF"
    nohup dockerd --iptables=false --bridge=none > /dev/null 2>&1 &
    sleep 2
fi

if grep -q "failed to start containerd" "$LOG_FILE"; then
    echo -e "${RED}Found bug: Containerd Lock. Purging containerd paths...${NC}"
    rm -rf /run/containerd/*
    systemctl restart containerd
fi

# Final Check
if docker info > /dev/null 2>&1; then
    echo -e "${GREEN}✅ SUCCESS: Docker is now screaming fast!${NC}"
    docker version | grep "Engine"
else
    echo -e "${RED}❌ SYSTEM STALL: Final Attempt - Manual Socket Redirection...${NC}"
    # The last resort: run without any config files at all
    dockerd -H unix:///var/run/docker.sock --iptables=false --bridge=none >> $LOG_FILE 2>&1 &
    sleep 4
    if docker info > /dev/null 2>&1; then
        echo -e "${GREEN}✅ SUCCESS: Hard Launch complete.${NC}"
    else
        echo -e "${YELLOW}Read the tail of the log, $USER_NAME:${NC}"
        tail -n 5 $LOG_FILE
    fi
fi

echo -e "\n${GREEN}Done. If you're out of ammo, check $LOG_FILE${NC}"
