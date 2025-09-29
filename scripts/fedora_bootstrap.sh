#!/bin/bash
#
# Fedora Server Bootstrap Script
# Professional FHS-compliant system initialization
# Author: ch1ch0 
# Date: $(date +%Y-%m-%d)
# Purpose: World-class server environment setup following Linux best practices
#

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

# Check if running as root for system-level tasks
check_root() {
    if [[ $EUID -eq 0 ]]; then
        warn "Running as root. Some operations will be system-wide."
    else
        log "Running as non-root user: $(whoami)"
    fi
}

# System update and essential packages
system_update() {
    log "Updating system packages..."
    
    if [[ $EUID -eq 0 ]]; then
        dnf update -y
        dnf install -y \
            curl \
            wget \
            git \
            vim \
            htop \
            tree \
            unzip \
            tar \
            rsync \
            firewalld \
            fail2ban \
            zsh \
            tmux \
            openssh-server \
            bind-utils \
            net-tools \
            policycoreutils-python-utils
    else
        log "System updates require root. Run: sudo dnf update -y"
    fi
}

# Create FHS-compliant directory structure for services
create_fhs_structure() {
    log "Creating FHS-compliant directory structure..."
    
    # Service-specific directories under /srv (FHS compliant)
    sudo mkdir -p /srv/{forgejo,nextcloud,mastodon}
    sudo mkdir -p /srv/git/repositories
    
    # Configuration directories under /etc
    sudo mkdir -p /etc/{forgejo,nextcloud,mastodon}
    
    # Variable data under /var
    sudo mkdir -p /var/lib/{forgejo,nextcloud,mastodon}
    sudo mkdir -p /var/log/{forgejo,nextcloud,mastodon}
    
    # Local installations under /usr/local
    sudo mkdir -p /usr/local/{bin,lib,share}
    
    # Optional software under /opt
    sudo mkdir -p /opt/{forgejo,nextcloud,mastodon}
    
    # Scripts and automation
    sudo mkdir -p /usr/local/bin/admin-scripts
    
    log "FHS directory structure created successfully"
}

# Configure SSH security (generate new keys, disable root login)
configure_ssh_security() {
    log "Configuring SSH security..."
    
    # Generate new SSH keys for current user (replacing any exposed keys)
    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
        log "Generating new SSH ed25519 key pair..."
        ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f ~/.ssh/id_ed25519 -N ""
        log "New SSH key generated at ~/.ssh/id_ed25519"
    else
        warn "SSH key already exists. Remove ~/.ssh/id_ed25519* to regenerate."
    fi
    
    # SSH daemon configuration (requires root)
    if [[ $EUID -eq 0 ]]; then
        # Backup original config
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
        
        # Apply security hardening
        sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
        sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
        sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
        
        systemctl restart sshd
        systemctl enable sshd
        log "SSH hardening completed"
    else
        log "SSH daemon config requires root access"
    fi
}

# Configure firewall
configure_firewall() {
    log "Configuring firewall..."
    
    if [[ $EUID -eq 0 ]]; then
        systemctl start firewalld
        systemctl enable firewalld
        
        # Allow SSH
        firewall-cmd --permanent --add-service=ssh
        
        # Allow HTTP/HTTPS for web services
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        
        firewall-cmd --reload
        log "Firewall configured successfully"
    else
        log "Firewall configuration requires root access"
    fi
}

# User environment setup
setup_user_environment() {
    log "Setting up user environment for $(whoami)..."
    
    # Install Oh My Zsh if not present
    if [[ ! -d ~/.oh-my-zsh ]]; then
        log "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Change default shell to zsh
    if [[ $SHELL != *"zsh" ]]; then
        log "Changing default shell to zsh..."
        chsh -s $(which zsh)
    fi
    
    # Create user directories
    mkdir -p ~/scripts ~/projects ~/logs
    mkdir -p ~/.config
    
    log "User environment setup completed"
}

# Set appropriate ownership and permissions (FHS compliant)
set_permissions() {
    log "Setting FHS-compliant permissions..."
    
    if [[ $EUID -eq 0 ]]; then
        # Service directories
        chown -R root:root /srv/
        chmod -R 755 /srv/
        
        # Configuration directories
        chown -R root:root /etc/{forgejo,nextcloud,mastodon} 2>/dev/null || true
        chmod -R 644 /etc/{forgejo,nextcloud,mastodon} 2>/dev/null || true
        
        # Variable data directories
        chown -R root:root /var/lib/{forgejo,nextcloud,mastodon} 2>/dev/null || true
        chown -R root:root /var/log/{forgejo,nextcloud,mastodon} 2>/dev/null || true
        
        log "Permissions set according to FHS standards"
    else
        log "Setting system permissions requires root access"
    fi
}

# Create admin user setup
setup_admin_user() {
    log "Configuring admin user privileges..."
    
    # Add users to appropriate groups
    if [[ $EUID -eq 0 ]]; then
        # Add admin user to wheel group for sudo
        usermod -aG wheel admin 2>/dev/null || log "User 'admin' not found"
        
        # Add ch1ch0 to necessary groups
        usermod -aG wheel ch1ch0 2>/dev/null || log "User 'ch1ch0' not found"
        
        log "User privileges configured"
    else
        log "User privilege configuration requires root access"
    fi
}

# Generate system documentation
generate_documentation() {
    log "Generating system documentation..."
    
    cat > ~/SYSTEM_SETUP.md << 'EOF'
# Fedora Server Setup Documentation

## System Overview
- **OS**: Fedora Server
- **Users**: admin, ch1ch0
- **SSH**: Key-based authentication only
- **Firewall**: firewalld enabled
- **Directory Structure**: FHS compliant

## Directory Structure
```
/srv/                    # Service data (FHS compliant)
├── forgejo/            # Git service data
├── nextcloud/          # Cloud storage data
├── mastodon/           # Social media service data
└── git/repositories/   # Git repositories

/etc/                   # Configuration files
├── forgejo/           # Forgejo configuration
├── nextcloud/         # Nextcloud configuration
└── mastodon/          # Mastodon configuration

/var/lib/              # Variable service data
├── forgejo/           # Forgejo runtime data
├── nextcloud/         # Nextcloud runtime data
└── mastodon/          # Mastodon runtime data

/var/log/              # Service logs
├── forgejo/           # Forgejo logs
├── nextcloud/         # Nextcloud logs
└── mastodon/          # Mastodon logs

/opt/                  # Optional software installations
├── forgejo/           # Forgejo binaries
├── nextcloud/         # Nextcloud installation
└── mastodon/          # Mastodon installation
```

## Security Configuration
- SSH root login: DISABLED
- SSH password auth: DISABLED
- SSH key auth: ENABLED
- Firewall: ENABLED (SSH, HTTP, HTTPS allowed)

## Next Steps
1. Deploy Forgejo Git service
2. Deploy Nextcloud file sharing
3. Deploy Mastodon social media service
4. Configure backup strategies
5. Set up monitoring

## Important Files
- SSH Config: /etc/ssh/sshd_config
- User SSH Keys: ~/.ssh/
- Service Configs: /etc/{service-name}/
- Service Data: /srv/{service-name}/

EOF
    
    log "Documentation generated at ~/SYSTEM_SETUP.md"
}

# Main execution
main() {
    log "Starting Fedora Server Bootstrap Process"
    log "Current user: $(whoami)"
    log "System: $(uname -a)"
    
    check_root
    system_update
    create_fhs_structure
    configure_ssh_security
    configure_firewall
    setup_user_environment
    set_permissions
    setup_admin_user
    generate_documentation
    
    log "Bootstrap completed successfully!"
    log "Please review ~/SYSTEM_SETUP.md for next steps"
    log "Reboot recommended to apply all changes"
}

# Execute main function
main "$@"
