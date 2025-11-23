# OpenSearch Setup - Interactive Guide with Cursor AI

**Server**: kinglear @ 192.168.1.122  
**User**: homeserv  
**Setup Mode**: Cursor AI will SSH and execute most commands directly  
**Your Role**: Provide sudo access when needed (marked with 👨‍💻)

---

## Progress Tracker

- [x] Section 1: Prerequisites Check
- [ ] Section 2: System Configuration (requires sudo 👨‍💻)
- [ ] Section 3: Create Directories and Compose File
- [ ] Section 4: Create Systemd Service (requires sudo 👨‍💻)
- [ ] Section 5: Configure Nginx (requires sudo 👨‍💻)
- [ ] Section 6: Set Up SSL with acme.sh
- [ ] Section 7: Start Services (requires sudo 👨‍💻)
- [ ] Section 8: Configure DigitalOcean (requires you 👨‍💻)
- [ ] Section 9: Verification
- [ ] Section 10: Cleanup and Documentation

---

## Section 1: Prerequisites Check

**Status**: Ready to start

I'll check the current system state before we begin.

### Tasks:
- [x] Test SSH connection
- [x] Check system resources
- [x] Verify Docker installation
- [x] Check DNS configuration
- [x] Verify /boot partition has space

---

## Section 2: System Configuration

### 👨‍💻 Task 2.1: Configure vm.max_map_count

**Why you need to do this**: Requires sudo/root access

**Commands for you to run:**
```bash
# Set immediately
sudo sysctl -w vm.max_map_count=262144

# Persist after reboot
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf

# Verify
sysctl vm.max_map_count
```

**Expected output**: `vm.max_map_count = 262144`

✅ Mark complete when done: `[x]`

---

## Section 3: Create Directories and Compose File

**Status**: I'll handle this

I will:
- Create `/data/opensearch/{data,logs}` directories
- Set ownership to homeserv:homeserv
- Create the `docker-compose.yaml` file

**No action needed from you** - I'll execute these commands via SSH.

---

## Section 4: Create Systemd Service

### 👨‍💻 Task 4.1: Create opensearch.service file

**Why you need to do this**: Requires sudo to write to `/etc/systemd/system/`

I'll prepare the file content, then you'll need to create it with sudo.

**Status**: Waiting for Section 3 to complete

---

## Section 5: Configure Nginx

### 👨‍💻 Task 5.1: Install nginx (if not installed)

**Commands for you to run:**
```bash
sudo apt install -y nginx
```

### 👨‍💻 Task 5.2: Create nginx configuration files

**Why you need to do this**: Requires sudo to write to `/etc/nginx/`

I'll prepare the configuration files, then you'll create them with sudo.

**Status**: Waiting for Section 4 to complete

---

## Section 6: Set Up SSL with acme.sh

**Status**: I'll handle most of this

I will:
- Install acme.sh to homeserv account
- Configure FreeDNS credentials (you'll provide them)
- Issue the certificate
- Install certificate files

### 👨‍💻 Task 6.1: Provide FreeDNS credentials

When I reach this step, you'll need to provide:
- FreeDNS username
- FreeDNS password

I'll use these to get the SSL certificate via DNS-01 validation.

### 👨‍💻 Task 6.2: Set certificate permissions

**Why you need to do this**: Certificate files need to be in `/etc/nginx/ssl/` with proper permissions

**Status**: Waiting for previous sections

---

## Section 7: Start Services

### 👨‍💻 Task 7.1: Start OpenSearch service

**Why you need to do this**: Requires sudo to manage systemd services

**Commands for you to run:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable opensearch.service
sudo systemctl start opensearch.service
sudo systemctl status opensearch.service
```

### 👨‍💻 Task 7.2: Start nginx

**Commands for you to run:**
```bash
sudo systemctl restart nginx
sudo systemctl status nginx
```

**Status**: Waiting for previous sections

---

## Section 8: Configure DigitalOcean

### 👨‍💻 Task 8.1: Set up log forwarding

**Why you need to do this**: Requires access to your DigitalOcean account

**Steps:**
1. Log in to DigitalOcean
2. Navigate to your **dogblog** app
3. Go to **Settings** → **Log Forwarding**
4. Configure:
   - Provider: OpenSearch
   - Endpoint: `https://opensearch-ingest.cani.ne.jp`
   - Index: `dogblog-logs`
   - Auth: Leave blank
5. Save and redeploy

---

## Section 9: Verification

**Status**: I'll handle this

I will:
- Check OpenSearch cluster health
- Verify nginx is running
- Test SSL certificate
- Check for incoming logs (after 5-10 minutes)
- Test public endpoint restrictions

**No action needed from you** - I'll verify everything works.

---

## Section 10: Cleanup and Documentation

**Status**: I'll handle this

I will:
- Document the final configuration
- Note any issues encountered
- Provide maintenance commands
- Update this progress tracker

**When complete, you should:**
- Remove my SSH key from `~/.ssh/authorized_keys`
- Review the setup
- Restore any backed-up SSH/GPG keys

---

## Quick Reference

### SSH Connection
```bash
ssh -i /home/mobaxterm/.ssh/cursor_id_ed25519 homeserv@kinglear
```

### Key Files
- Docker Compose: `/data/opensearch/docker-compose.yaml`
- Systemd Service: `/etc/systemd/system/opensearch.service`
- Nginx Public: `/etc/nginx/sites-available/opensearch-public`
- Nginx LAN: `/etc/nginx/sites-available/opensearch-lan`
- SSL Certs: `/etc/nginx/ssl/opensearch.{crt,key}`

### Important Commands
```bash
# Check OpenSearch
sudo systemctl status opensearch.service
sudo journalctl -u opensearch.service -f

# Check logs
curl http://localhost:9200/_cluster/health?pretty

# Check nginx
sudo nginx -t
sudo systemctl status nginx
```

---

## Ready to Begin?

Reply with **"start"** and I'll begin Section 1 (Prerequisites Check) by SSHing into kinglear and checking the system status.

Or, if you have questions about any section, let me know!
