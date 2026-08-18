# Lab-2-Linux-Banking

## Technical Implementation

### SSH Hardening
SSH key-based authentication was configured between the server and clients, with password authentication disabled in sshd_config. SSH key pairs were generated on the client and the public key was deployed to the server, with access validated during testing.

### Networking
Static networking was configured to ensure all VMs (server and clients) could reliably reach each other.

### Identity & Access Management (Least Privilege)
Three Linux groups were created ( finance-team, it-admin, readonly-auditor), with users mapped to each following the principle of least privilege. Dedicated data folders were created per group, with ownership (chown) and permissions (chmod) matched to each role's actual access needs. 

### SCRIPTING 
Two Bash scripts were written and tested to automate user creation and group assignment. These were kept as two separate scripts intentionally, so account creation and access assignment remain distinct actions requiring separate review.

### File Sharing & Web Services
Samba was installed and configured to share role-specific folders over the network, enforcing group-based access ('valid users = @groupname') consistent with the Linux permission model. Apache was installed and configured to host a placeholder internal intranet page. Access controls were validated end-to-end from a Windows client by logging in as different users per role and confirming permissions matched the intended least-privilege design, including read-only enforcement for the auditor role. Test files were added to each shared folder with matching ownership and permissions to confirm behavior.

### Audit Logging (auditd)
'auditd' was installed and configured with watch rules on sensitive paths, including /data/finance, /data/systemconfig, /data/audit-logs, /etc/passwd, /etc/group, and /etc/ssh/sshd_config.

### Database - PostgreSQL
PostgreSQL was installed, selected over MySQL for its stricter data-integrity model and native support for fine-grained access control, better suited to a regulated banking context. A relational schema was designed and created, consisting of 'customers' and transactions' tables linked via a foreign key (transactions.customer_id --> customers.customer_id). Test data was inserted and validated in 'customers'. Role-based database access was implemented, mapped to real banking roles: 'bank_admin' (full superuser access), 'database_admin' (structural and data management access), 'teller' (read access plus limited write for balance updates and new transactions), and 'auditor' (read-only access across all tables). PostgreSQL logging was configured to write to dedicated, date-stamped log files, enabling real-time query monitoring per day.

### Automation & Monitoring
A disk usage report script was written , monitoring the three sensitive data folders with tiered alerts based on disk usage percentage. A log cleanup script was also written , handling two different log retention patterns: PostgreSQL's naturally date-stamped logs, compressed directly once older than 30 days, and auditd's single continuously-written log, which is split into a dated snapshot, compressed, and reset, since it cannot be aged by file-modification time alone. All compressed archives are centralized in /data/bank_archives, with no automatic deletion — old archives are flagged for manual review only. Both scripts were scheduled via cron, running monthly with full output and error logging:

0 4 1 * * /data/disk_report.sh >> /var/log/disk_report_cron.log 2>&1
0 5 1 * * /data/log_cleanup.sh >> /var/log/log_cleanup_cron.log 2>&1

### Web Application & Backup
A functional internal banking login page was built using PHP + html , and Apache, connecting to PostgreSQL through a dedicated role ('web_login') . A daily automated database backup was implemented using 'pg_dump', scheduled via 'cron' with success/failure logging.
