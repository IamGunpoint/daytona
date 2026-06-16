#!/bin/bash  
  
# Clear terminal for clean dashboard view  
clear  
  
# ==========================================  
# 🌟 PREMIUM COLOR CODES & FX  
# ==========================================  
RED='\033[1;31m'  
GREEN='\033[1;32m'  
YELLOW='\033[1;33m'  
BLUE='\033[1;34m'  
PURPLE='\033[1;35m'  
CYAN='\033[1;36m'  
WHITE='\033[1;37m'  
GRAY='\033[0;90m'  
NC='\033[0m' # No Color  
  
# FUNCTION: TYPING EFFECT ANIMATION  
type_effect() {  
    local text="$1"  
    local delay="$2"  
    for (( i=0; i<${#text}; i++ )); do  
        echo -n "${text:$i:1}"  
        sleep "$delay"  
    done  
    echo ""  
}  
  
# FUNCTION: CYBERPUNK PROGRESS BAR  
loading_bar() {  
    local title="$1"  
    local delay="${2:-0.05}"  
    local steps=20  
    echo -ne "  ${CYAN}⚡ $title ${NC}\n"  
    echo -ne "  ${GRAY}["  
    for ((i=0; i<steps; i++)); do  
        echo -ne " "  
    done  
    echo -ne "] 0%${NC}"  
    
    for ((i=1; i<=steps; i++)); do  
        sleep "$delay"  
        echo -ne "\r  ${GRAY}["  
        for ((j=0; j<i; j++)); do  
            echo -ne "${GREEN}█"  
        done  
        for ((j=i; j<steps; j++)); do  
            echo -ne " "  
        done  
        local pct=$(( i * 100 / steps ))  
        echo -ne "${GRAY}] ${YELLOW}${pct}%${NC}"  
    done  
    echo -e " ${GREEN}✔ COMPLETE${NC}\n"  
}  
  
# FUNCTION: HIGH-TECH SPINNER LOADER  
show_spinner() {  
    local pid="$1"  
    local message="$2"  
    local spin="-\|/"  
    local i=0  
    # Hide cursor  
    tput civis 2>/dev/null  
    while kill -0 "$pid" 2>/dev/null; do  
        i=$(( (i+1) % 4 ))  
        printf "\r  ${CYAN}[%c]${NC} ${WHITE}%s...${NC}" "${spin:$i:1}" "$message"  
        sleep 0.1  
    done  
    # Overwrite line with success  
    printf "\r  ${GREEN}[✔]${NC} ${WHITE}%s... SUCCESS!${NC}\n" "$message"  
    # Restore cursor  
    tput cnorm 2>/dev/null  
}  
  
# AUTOMATED ROOT/SUDO PRIVILEGE CHECK  
if [ "$(id -u)" -eq 0 ]; then  
    SUDO_CMD=""  
else  
    SUDO_CMD="sudo"  
fi  
  
# FUNCTION: GET HOST SYSTEM SPECIFICATIONS  
get_host_specs() {  
    HOST_RAM="Unknown"  
    HOST_CPU="Unknown"  
    HOST_ARCH=$(uname -m)  
    HOST_OS=$(uname -s)  
  
    if [ -f /proc/meminfo ]; then  
        local ram_kb  
        ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')  
        if [ ! -z "$ram_kb" ]; then  
            HOST_RAM="$((ram_kb / 1024 / 1024)) GB"  
        fi  
    fi  
  
    if command -v nproc >/dev/null 2>&1; then  
        HOST_CPU="$(nproc) Cores"  
    elif [ -f /proc/cpuinfo ]; then  
        HOST_CPU="$(grep -c ^processor /proc/cpuinfo) Cores"  
    fi  
}  
  
# VALIDATION HELPER FOR NUMERIC VALUES  
validate_number() {  
    local val="$1"  
    local default_val="$2"  
    if [[ "$val" =~ ^[0-9]+$ ]]; then  
        echo "$val"  
    else  
        echo "$default_val"  
    fi  
}  
  
# DYNAMIC UTILITIES FOR BORDER LAYOUTS  
print_line() {  
    local label="$1"  
    local value="$2"  
    local plain_text="  $label : $value"  
    local text_len=${#plain_text}  
    local pad=$(( 57 - text_len ))  
    local padding=""  
    for ((i=0; i<pad; i++)); do  
        padding+=" "  
    done  
    echo -e "  ${PURPLE}│${NC}  ${YELLOW}${label}${NC} : ${CYAN}${value}${NC}${padding} ${PURPLE}│${NC}"  
}  
  
print_menu_option() {  
    local num="$1"  
    local text="$2"  
    local plain_text="  [$num] $text"  
    local text_len=${#plain_text}  
    local pad=$(( 57 - text_len ))  
    local padding=""  
    for ((i=0; i<pad; i++)); do  
        padding+=" "  
    done  
    echo -e "  ${PURPLE}│${NC}  ${CYAN}[${num}]${NC} ${WHITE}${text}${NC}${padding} ${PURPLE}│${NC}"  
}  
  
# DRAW CYBERPUNK ASCII LOGO  
draw_banner() {  
    echo -e "${PURPLE}  ╭──────────────────────────────────────────────────────────╮${NC}"  
    echo -e "${PURPLE}  │${CYAN}    ___ __  __  ___ _   _ _  _ ___  ___  ___ _  _ _____    ${PURPLE}│${NC}"  
    echo -e "${PURPLE}  │${CYAN}   |_ _|  \/  |/ __| | | | \| | _ \/ _ \|_ _| \| |_   _|   ${PURPLE}│${NC}"  
    echo -e "${PURPLE}  │${CYAN}    | || |\/| | (_ | |_| | .\` |  _/ (_) || || .\` | | |     ${PURPLE}│${NC}"  
    echo -e "${PURPLE}  │${CYAN}   |___|_|  |_|\___|\___/|_|\_|_|  \___/|___|_|\_| |_|     ${PURPLE}│${NC}"  
    echo -e "${PURPLE}  ├──────────────────────────────────────────────────────────┤${NC}"  
    echo -e "${PURPLE}  │${WHITE}           » PREMIUM CLOUD VPS ORCHESTRATOR «             ${PURPLE}│${NC}"  
    echo -e "${PURPLE}  │${WHITE}                    » VERSION 3.0.0 «                     ${PURPLE}│${NC}"  
    echo -e "${PURPLE}  ╰──────────────────────────────────────────────────────────╯${NC}"  
}  
  
# DASHBOARD SPEC STATUS PANEL  
draw_dashboard_header() {  
    clear  
    get_host_specs  
      
    local img_status="Off-Line (Not Created)"  
    if [ -f "/home/daytona/ubuntu22.qcow2" ]; then  
        img_status="Ready (Cached)"  
    fi  
  
    draw_banner  
    echo -e "  ${PURPLE}╭──────────────────────────────────────────────────────────╮${NC}"  
    echo -e "  ${PURPLE}│${WHITE} 🛠️  HOST DIAGNOSTICS & SYSTEM STATUS                     ${PURPLE}│${NC}"  
    echo -e "  ${PURPLE}├──────────────────────────────────────────────────────────┤${NC}"  
    print_line "Host OS Platform" "${HOST_OS} (${HOST_ARCH})"  
    print_line "Host Total RAM  " "${HOST_RAM}"  
    print_line "Host CPU Cores  " "${HOST_CPU}"  
    print_line "QEMU Image Cache" "${img_status}"  
      
    if [ -f ".vps_env" ]; then  
        source .vps_env  
        print_line "Configured VM RAM" "${RAM_GB:-32} GB"  
        print_line "Configured Cores " "${CPU_CORES:-4} Cores"  
        print_line "Active Port Svc  " "Host ${TCP_HOST_PORT:-2222} ➔ VM ${TCP_GUEST_PORT:-22}"  
    else  
        print_line "Active Profile   " "None (Defaults will be configured)"  
    fi  
    echo -e "  ${PURPLE}╰──────────────────────────────────────────────────────────╯${NC}"  
}  
  
# INSTALL DEPENDENCY WRAPPER  
install_packages() {  
    if command -v qemu-system-x86_64 >/dev/null 2>&1 && command -v cloud-localds >/dev/null 2>&1 && command -v wget >/dev/null 2>&1 && command -v curl >/dev/null 2>&1; then  
        echo -e "  ${GREEN}✔ Core virtualization components already satisfied.${NC}"  
        return  
    fi  
  
    echo -e "  ${YELLOW}⚡ Syncing system package indexes...${NC}"  
    $SUDO_CMD apt-get update -y > /dev/null 2>&1 &  
    show_spinner $! "Updating repositories"  
  
    echo -e "  ${YELLOW}⚡ Installing virtualization suites (QEMU, CloudUtils, wget)...${NC}"  
    $SUDO_CMD apt-get install -y qemu-system-x86 qemu-utils wget cloud-image-utils curl > /dev/null 2>&1 &  
    show_spinner $! "Installing system dependencies"  
}  
  
# ==========================================  
# MAIN INTERACTIVE LIST MENU  
# ==========================================  
show_menu() {  
    draw_dashboard_header  
    echo ""  
    echo -e "  ${YELLOW}👉 SELECT AN ACTION TO PROCEED:${NC}"  
    echo -e "  ${PURPLE}╭──────────────────────────────────────────────────────────╮${NC}"  
    print_menu_option 1 "Create & Boot New Ubuntu VPS Instance"  
    print_menu_option 2 "Restart Existing VPS Instance"  
    print_menu_option 3 "Configure TCP Port Forward Rules"  
    print_menu_option 4 "Remove/Clean VPS Cache Files & Reset"  
    print_menu_option 5 "Exit Dashboard"  
    echo -e "  ${PURPLE}╰──────────────────────────────────────────────────────────╯${NC}"  
    echo ""  
    echo -ne "  ${WHITE}🔹 Enter Choice [1-5]: ${NC}"  
    read CHOICE  
      
    case $CHOICE in  
        1) create_vps ;;  
        2) restart_vps ;;  
        3) configure_tcp ;;  
        4) clean_vps ;;  
        5) clear; echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;  
        *) echo -e "  ${RED}❌ Invalid Choice! Please select 1-5.${NC}"; sleep 1.5; show_menu ;;  
    esac  
}  
  
# STEP 1: CONFIGURE STORAGE & DOWNLOAD CLOUD ARCHITECTURE  
create_vps() {  
    clear  
    draw_banner  
    echo ""  
    echo -e "  ${YELLOW}⚙️  CONFIGURE YOUR VIRTUAL MACHINE SPECIFICATIONS${NC}"  
    echo -e "  ${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"  
    echo ""  
      
    echo -ne "  ${BLUE}🔹 Enter RAM Size in GB (e.g. 4, 8, 16, 32) [Default: 8]: ${NC}"  
    read RAM_GB  
    RAM_GB=$(validate_number "$RAM_GB" "8")  
  
    echo -ne "  ${BLUE}🔹 Enter CPU Cores (e.g. 2, 4, 8) [Default: 4]: ${NC}"  
    read CPU_CORES  
    CPU_CORES=$(validate_number "$CPU_CORES" "4")  
  
    echo -ne "  ${BLUE}🔹 Enter Disk Space to ADD in GB (e.g. 10, 20) [Default: 10]: ${NC}"  
    read DISK_ADD  
    DISK_ADD=$(validate_number "$DISK_ADD" "10")  
  
    echo -ne "  ${BLUE}🔹 Create Username [Default: ubuntu]: ${NC}"  
    read USER_NAME  
    USER_NAME=${USER_NAME:-ubuntu}  
  
    echo -ne "  ${BLUE}🔹 Create Password [Default: 1234]: ${NC}"  
    read USER_PASS  
    USER_PASS=${USER_PASS:-1234}  
      
    TCP_HOST_PORT=${TCP_HOST_PORT:-2222}  
    TCP_GUEST_PORT=22  
  
    echo ""  
    echo -e "  ${YELLOW}⏳ Preparing background core system components...${NC}"  
    echo ""  
      
    install_packages  
      
    $SUDO_CMD mkdir -p /home/daytona > /dev/null 2>&1  
    $SUDO_CMD chmod 777 /home/daytona > /dev/null 2>&1  
      
    if [ ! -f "/home/daytona/ubuntu22.qcow2" ]; then  
        echo -e "  ${YELLOW}📥 Downloading Ubuntu 22.04 Cloud Image (Jammy Server)...${NC}"  
        echo -e "  ${GRAY}This might take a minute depending on your connection speed.${NC}"  
        echo ""  
        $SUDO_CMD wget -q --show-progress https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img -O /home/daytona/ubuntu22.qcow2  
        $SUDO_CMD chmod 666 /home/daytona/ubuntu22.qcow2  
    else  
        echo -e "  ${GREEN}✔ Existing Ubuntu Image Cache Detected at /home/daytona/.${NC}"  
    fi  
      
    echo ""  
    loading_bar "Generating Cloud-Init Matrix File" 0.05  
  
    # Using printf block instead of EOF here-doc to prevent indentation/formatting issues  
    printf "%s\n" \
        "#cloud-config" \
        "ssh_pwauth: True" \
        "chpasswd:" \
        "  list: |" \
        "    ${USER_NAME}:${USER_PASS}" \
        "  expire: False" > user-data  
  
    cloud-localds seed.img user-data > /dev/null 2>&1  
    
    loading_bar "Expanding Server Hard Disk Space Allocation" 0.05  
    $SUDO_CMD qemu-img resize /home/daytona/ubuntu22.qcow2 +${DISK_ADD}G > /dev/null 2>&1  
      
    save_env  
    boot_qemu  
}  
  
# STEP 2: NETWORK CONTROL MODIFIER  
configure_tcp() {  
    clear  
    draw_banner  
    echo ""  
    echo -e "  ${YELLOW}🔄⚙️  MANAGE CUSTOM TCP PORT FORWARDING RULES${NC}"  
    echo -e "  ${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"  
    echo ""  
    if [ -f ".vps_env" ]; then  
        source .vps_env  
    fi  
    echo -e "  Current Target Host Port  : ${CYAN}${TCP_HOST_PORT:-2222}${NC}"  
    echo -e "  Current Guest VM Port     : ${CYAN}${TCP_GUEST_PORT:-22}${NC}"  
    echo ""  
    echo -ne "  ${BLUE}🔹 Enter NEW External Host Port (Default: 2222): ${NC}"  
    read NEW_HOST_PORT  
    TCP_HOST_PORT=$(validate_number "$NEW_HOST_PORT" "2222")  
      
    echo -ne "  ${BLUE}🔹 Enter Internal Guest Port (Default SSH: 22): ${NC}"  
    read NEW_GUEST_PORT  
    TCP_GUEST_PORT=$(validate_number "$NEW_GUEST_PORT" "22")  
      
    save_env  
    echo ""  
    echo -e "  ${GREEN}✔ TCP Rules Modified and Synced Successfully!${NC}"  
    sleep 2  
    show_menu  
}  
  
save_env() {  
    echo "RAM_GB=${RAM_GB:-8}" > .vps_env  
    echo "CPU_CORES=${CPU_CORES:-4}" >> .vps_env  
    echo "USER_NAME=${USER_NAME:-ubuntu}" >> .vps_env  
    echo "USER_PASS=${USER_PASS:-1234}" >> .vps_env  
    echo "TCP_HOST_PORT=${TCP_HOST_PORT:-2222}" >> .vps_env  
    echo "TCP_GUEST_PORT=${TCP_GUEST_PORT:-22}" >> .vps_env  
}  
  
# HUD BORDER ALIGNMENT FUNCTIONS FOR BOOT SCREEN  
print_hud_line() {  
    local label="$1"  
    local value="$2"  
    local color_lbl="$3"  
    local color_val="$4"  
    local plain_text=" » $label : $value"  
    local text_len=${#plain_text}  
    local pad=$(( 54 - text_len ))  
    local padding=""  
    for ((i=0; i<pad; i++)); do  
        padding+=" "  
    done  
    echo -e "  ${GREEN}║${NC} ${color_lbl}» ${label}${NC} : ${color_val}${value}${NC}${padding} ${GREEN}║${NC}"  
}  
  
print_hud_center() {  
    local text="$1"  
    local color="$2"  
    local text_len=${#text}  
    local pad=$(( (54 - text_len) / 2 ))  
    local pad_extra=$(( (54 - text_len) % 2 ))  
    local padding_left=""  
    local padding_right=""  
    for ((i=0; i<pad; i++)); do  
        padding_left+=" "  
        padding_right+=" "  
    done  
    for ((i=0; i<pad_extra; i++)); do  
        padding_right+=" "  
    done  
    echo -e "  ${GREEN}║${NC} ${padding_left}${color}${text}${NC}${padding_right} ${GREEN}║${NC}"  
}  
  
# STEP 3: POPOUT LINK AND RUN THE MASTER EXECUTION COMMAND  
boot_qemu() {  
    if [ -f ".vps_env" ]; then  
        source .vps_env  
    fi  
  
    TCP_HOST_PORT=${TCP_HOST_PORT:-2222}  
    TCP_GUEST_PORT=${TCP_GUEST_PORT:-22}  
    RAM_VALUE="${RAM_GB:-8}G"  
  
    clear  
    draw_banner  
    echo ""  
    echo -e "  ${GREEN}🚀 INITIALIZING VIRTUAL MACHINE SECURE PORTS...${NC}"  
    echo ""  
      
    # Run the exact specified hook sequence  
    sshx_log=$(mktemp)  
    curl -sSf https://sshx.io/get | sh -s run > "$sshx_log" 2>&1 &  
      
    # Dynamic progress bar for exact 5-second sleep timing while tunnel initializes  
    loading_bar "Establishing Secure SSHX Tunnel Proxy" 0.25  
      
    SSHX_URL=$(grep -o 'https://sshx.io/s/[a-zA-Z0-9]*' "$sshx_log" | head -n 1)  
    rm -f "$sshx_log"  
  
    clear  
    echo -e "  ${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"  
    print_hud_center "🚀 IMGUNPOINT VM INSTANCE IS BOOTING" "${WHITE}"  
    echo -e "  ${GREEN}╠══════════════════════════════════════════════════════════╣${NC}"  
    print_hud_line "Username     " "${USER_NAME:-ubuntu}" "${WHITE}" "${CYAN}"  
    print_hud_line "Password     " "${USER_PASS:-1234}" "${WHITE}" "${CYAN}"  
    print_hud_line "RAM Allocated" "${RAM_VALUE}" "${WHITE}" "${CYAN}"  
    print_hud_line "CPU Cores    " "${CPU_CORES:-4}" "${WHITE}" "${CYAN}"  
    print_hud_line "Port Mapping " "Host ${TCP_HOST_PORT} ➔ VM ${TCP_GUEST_PORT}" "${WHITE}" "${YELLOW}"  
    print_hud_line "SSH Connect  " "ssh ${USER_NAME:-ubuntu}@localhost -p ${TCP_HOST_PORT}" "${WHITE}" "${YELLOW}"  
    echo -e "  ${GREEN}╠══════════════════════════════════════════════════════════╣${NC}"  
    if [ ! -z "$SSHX_URL" ]; then  
        print_hud_center "🔥 POPOUT LIVE ACCESS WEB LINK" "${YELLOW}"  
        print_hud_center "$SSHX_URL" "${GREEN}"  
    else  
        print_hud_center "⚠️ Tunnel proxy loading slow. Connection local only." "${RED}"  
    fi  
    echo -e "  ${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"  
    echo ""  
      
    echo -e "  ${YELLOW}💡 PRO-TIP: To safely exit/detach QEMU at any point, press:${NC}"  
    echo -e "              ${WHITE}Ctrl+A${NC} then ${WHITE}X${NC} inside this terminal."  
    echo ""  
    echo -e "  ${CYAN}🚀 Launching QEMU System Engine Console...${NC}"  
    echo -e "  ${GRAY}----------------------------------------------------------${NC}"  
    echo ""  
      
    # 🚀 EXECUTING INTEGRATED CORE NETDEV NETWORK COMMAND STRUCTURE  
    # Using safe array declaration to guarantee no trailing spaces can break command execution  
    local qemu_args=(  
        -hda /home/daytona/ubuntu22.qcow2  
        -m "$RAM_VALUE"  
        -smp "${CPU_CORES:-4}"  
        -drive file=seed.img,format=raw  
        -nographic  
        -netdev "user,id=net0,hostfwd=tcp::${TCP_HOST_PORT}-:${TCP_GUEST_PORT}"  
        -device e1000,netdev=net0  
    )  
      
    qemu-system-x86_64 "${qemu_args[@]}"  
}  
  
# RESTART PIPELINE  
restart_vps() {  
    clear  
    draw_banner  
    echo ""  
    if [ -f "/home/daytona/ubuntu22.qcow2" ] && [ -f "seed.img" ]; then  
        echo -e "  ${GREEN}🔄 Detected existing virtual machine instance config.${NC}"  
        loading_bar "Warm Booting QEMU Server Engine" 0.08  
        boot_qemu  
    else  
        echo -e "  ${RED}❌ No active configuration blocks found!${NC}"  
        echo -e "  ${GRAY}Please build a new module first using Option [1].${NC}"  
        echo ""  
        echo -ne "  Press Enter to return to main menu..."  
        read  
        show_menu  
    fi  
}  
  
# CLEAN PIPELINE  
clean_vps() {  
    clear  
    draw_banner  
    echo ""  
    echo -e "  ${RED}⚠️ WARNING: This will permanently purge your VM disk image & config!${NC}"  
    echo -ne "  Are you absolutely sure you want to clean? (y/N): "  
    read CONFIRM  
    if [[ "$CONFIRM" =~ ^[yY](es)?$ ]]; then  
        echo ""  
        loading_bar "Wiping VM Images and Storage Components" 0.08  
        $SUDO_CMD rm -rf user-data seed.img /home/daytona/ubuntu22.qcow2 .vps_env  
        pkill sshx > /dev/null 2>&1  
        pkill sh > /dev/null 2>&1  
        echo -e "  ${GREEN}✔ Workspace successfully wiped clean!${NC}"  
    else  
        echo -e "  ${YELLOW}✔ Clean operation aborted.${NC}"  
    fi  
    sleep 2  
    show_menu  
}  
  
# EXECUTE TRIGGER  
show_menu  
