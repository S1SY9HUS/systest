#!/bin/bash




log_date=$(date "+%m%d%y") 

exec 2>&1>& "ticket_${log_date}.log"


# Prints current date
# Prints computer ID

# Displays ticket info menu:
# - Reads tech ID #
# - Reads emp ID #
# - Reads emp name
# - Reads description of reported issue

# Performs test 
# Stores log from test in folder (add variable to filename 
# so current date can be appended to it every time a new log is made)
# Sends log via scp
# Displays reboot menu



function log() {
	echo -ne "\nDate: $(date "+%D")\nDevice Name: $(hostname)\nDevice IP Address: $(hostname -I)\nAssigned to Employee #: ${emp_ID}\nTech ID: ${tech_ID}\n\nIssue Description: ${issue_desc}\n\n"

	# CPU usage and I/O stats for every partition on the system. Outputs stats from time system was booted to now. -m parameter outputs in mb instead of kb
	iostat -m 

	# Amount of time system has been running
	uptime

	# Top 5 processes sorted by memory
	ps aux --sort -%mem | head -6

	# Outputs all info on all interfaces on device
	ip a

	# Outputs system routing table
	ip r

	# Pings website to determine connectivity. -c parameter followed by number specifies num packets to send
	ping -c 4 google.com

	# Outputs stats on network sockets. -s parameter specifies output should be summarized 
	ss -s

	# Outputs amount of free memory on system. -h parameter specifies output in human readable format
	free -h

	# Outputs information on total and available space on file system. -h specifies output in human readable format
	df -h	

	# Outputs hardware-related errors. -l parameter followed by err,crit,alert,emerg restricts the output to those specified levels
	dmesg -l err,crit,alert,emerg

}



function reboot_system() {

	echo -ne "\n\nSYSTEM REBOOT IN PROGRESS\n\n
	The system needs to be restarted in order to complete your support request. Would you like to reboot now or schedule it for a later date (Rebooting is mandatory)?
	$(colour_blue '   1 ') Reboot Now
	$(colour_blue '   2 ') Reschedule Reboot
	$(colour_blue '\n\n   Choose an Option: ') "
	
	read reboot_option

        case $reboot_option in 
                1) 	
			shutdown -r +1
			clear
			echo -e "\n\nSystem will reboot in 1 minute"
			exit 0
			;;
                2) 	
			schedule_reboot
			;;
		esac
}


function schedule_reboot() {
	echo -ne "\n\nWhen would you like to schedule your system reboot?\n\n
	$(colour_blue '   1 ') In 1 Hour
	$(colour_blue '   2 ') EOD (5pm)
	$(colour_blue '   3 ') Tonight (8pm)
	$(colour_blue '   4 ') Tomorrow morning (6am) 
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
			shutdown -r 17:00
			clear
			echo -e "\n\nSystem will reboot at 5pm"
			exit 0
			;;
		3) 
			shutdown -r 20:00
			clear
			echo -e "\n\nSystem will reboot tonight at 8pm"
			exit 0
			;;
		4) 
			shutdown -r 06:00
			clear
			echo -e "\n\nSystem will reboot tomorrow morning at 6am"
			exit 0
			;;
		esac
}


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


# colour_red: FUNCTION WHICH SETS THE COLOUR FOR TEXT SPECIFIED TO RED, THEN RESETS TEXT COLOUR TO DEFAULT
#
function colour_red() {

        echo -ne $red$1$clear

}


# colour_blue: FUNCTION WHICH SETS THE COLOUR FOR TEXT SPECIFIED TO BLUE, THEN RESETS TEXT COLOUR TO DEFAULT
#
function colour_blue() {

        echo -ne $blue$1$clear

}


echo -ne "\n\nIT SUPPORT LOG: ${log_date}\n\n"
read tech_ID
clear
read emp_ID
clear
read issue_desc

log