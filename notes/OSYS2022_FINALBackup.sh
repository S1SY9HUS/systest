#!/bin/bash


# TAKES INPUT ON TECH SUPPORT EMPLOYEE ID # AND DESCRIPTION OF CLIENT ISSUE
# AND NOTIFIES USER OF TESTS BEING RUN, LOGS BEING SENT. PROMPTS USER TO ENTER PASSWORD FOR scp
# FILE TRANSFER WHICH WILL OCCUR AFTER TESTS ARE RUN
function log_info() {
	echo -ne "\n\nIT SUPPORT LOG: ${log_date}\n\n"
	echo -e "Please enter your ID number: "
	read tech_ID
	echo -e "\n"
	echo -e "Please enter a short description of the issue: "
	read issue_desc
	echo -e "\n"
	echo -e "Tests are being run ... please wait"
	sleep 4
	echo -e "Test log will be sent to home/techsupport/support_logs/$(hostname) on your device. Please enter your password below:\n"
}

# FORMATS AND OUTPUTS VARIOUS STATS ON SYSTEM FOR TROUBLESHOOTING PURPOSES
function stats() {
	log_date=$(date "+%m%d%y") 

	echo -ne "\nDate: $(date "+%A %B %d %T %y")\nDevice Name: $(hostname)\nDevice IP Address: $(hostname -I)\nTech ID: ${tech_ID}\nIssue Description: ${issue_desc}\n\n---TESTS---\n\nCPU usage and I/O Stats:\n$(iostat -m )\n\nSystem uptime:\n $(uptime)\n\nTop 5 Processes Running:\n$(ps aux --sort -%mem | head -6)\n\nNetwork Interfaces:\n$(ip a)\n\nRouting Table:\n$(ip r)\n\nPing Attempt:\n$(ping -c 4 google.com)\n\nNetwork Socket Stats:\n$(ss -s)\n\nSystem Memory Stats:\n$(free -h)\n\nSystem Disk space:\n$(df -h)" >> "/home/zaz/support_logs/ticket_${log_date}.log"
	
}

# ASKS USER WHEN THEY WOULD LIKE TO REBOOT AND GIVES OPTION TO RESCHEDULE
function reboot() {
	echo -ne "\n\nSYSTEM REBOOT IN PROGRESS\n\nThe system needs to be restarted in order to complete your support request. Would you like to reboot now or schedule it for a later date (Rebooting is mandatory)?\n\n
	$(colour_blue '   1 ') Reboot Now
	$(colour_blue '   2 ') Reschedule Reboot
	$(colour_blue '\n\n   Choose an Option: ') "

    read reboot_option

    case $reboot_option in 
        1) 	
			echo -e "\nSystem will reboot immediately\n"
			shutdown -r now
			clear
			exit 0
			;;
		2) 	
			schedule_reboot
			;;
		*) 
			input_error
			;;
    esac
}

# PROMPTS USER TO CHOOSE A TIME TO SCHEDULE A REBOOT FOR THE SYSTEM IF CASE 2 OF REBOOT() IS TRIGGERED
function schedule_reboot() {
	echo -ne "\n\nWhen would you like to schedule your system reboot?\n\n
	$(colour_blue '   1 ') In 1 minute
	$(colour_blue '   2 ') In 1 hour
	$(colour_blue '   3 ') EOD (5pm)
	$(colour_blue '   4 ') Tonight (8pm)
	$(colour_blue '   5 ') Tomorrow morning (6am) 
	$(colour_blue '\n\n   Choose an Option: ') "
	
	read reboot_time

    case $reboot_time in 
	    1) 	
			shutdown -r +60
			clear
			echo -e "\n\nSystem will reboot in 1 hour"
			exit 0
			;;
    	2) 	
			shutdown -r +60
			clear
			echo -e "\n\nSystem will reboot in 1 hour"
			exit 0
			;;
        3) 	
			shutdown -r 17:00
			clear
			echo -e "\n\nSystem will reboot at 5pm"
			exit 0
			;;
		4) 
			shutdown -r 20:00
			clear
			echo -e "\n\nSystem will reboot tonight at 8pm"
			exit 0
			;;
		5) 
			shutdown -r 06:00
			clear
			echo -e "\n\nSystem will reboot tomorrow morning at 6am"
			exit 0
			;;
		*) 
			input_error
			;;
	esac
}

# WHEN INCORRECT USER INPUT IS SENT, PRINTS TEXT TO TERMINAL SHOWING ERROR MESSAGE 
function input_error() {

	echo -e "$(colour_red '\n\n---------------ERROR-------------')" 
        echo -e "$(colour_red 'Invalid Entry - Please Try Again')"
	echo -e "$(colour_red '------------------------------\n\n')"
        sleep 3
	clear

}

# --------------------------------------------------------
# ** VARIABLES & FUNCTIONS: COLOURS FOR MENU OPTIONS, ERROR MESSAGES**

# red: VARIABLE WHICH DEFINES THE COLOUR FOR ERROR MESSAGES
# [\e[31m]: REPRESENTS ANSI ESCAPE SEQUENCE FOR SETTING TEXT COLOUR TO RED
red='\e[31m'

# blue: VARIABLE WHICH DEFINES THE COLOUR FOR MENU MESSAGES
# [\e[34m]: REPRESENTS ANSI ESCAPE SEQUENCE FOR SETTING TEXT COLOUR TO BLUE
blue='\e[34m'

# clear: VARIABLE WHICH DEFINES DEFAULT TEXT COLOUR
# [\e[0m]: REPRESENTS ANSI ESCAPE SEQUENCE FOR RESETTING TEXT COLOUR TO DEFAULT
clear='\e[0m'


# SETS THE COLOUR FOR TEXT SPECIFIED TO RED, THEN RESETS TEXT COLOUR TO DEFAULT
function colour_red() {
        echo -ne $red$1$clear
}


# SETS THE COLOUR FOR TEXT SPECIFIED TO BLUE, THEN RESETS TEXT COLOUR TO DEFAULT
function colour_blue() {
        echo -ne $blue$1$clear
}


log_info
stats 
scp "/home/zaz/support_logs/ticket_${log_date}.log" techsupport@192.168.208.160:/home/techsupport/support_logs/OSYS2022-UB/
reboot


