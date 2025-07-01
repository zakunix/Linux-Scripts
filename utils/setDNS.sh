#!/bin/bash

iname=""
dns=""
alt=""
ipv="ipv4"
validate="no"
list_interfaces=0
verbose=0
prog_name="$(basename "$0")"
user_dir="$(dirname "$0")"

function usage() {
    echo "Usage: $prog_name -d <dnsIp> [-n <name>] [-a <altIp>] [-6] [-c] [-l] [-v] [-h]"
    echo
    echo "Options:"
    echo "  -d   The preferred DNS server IP address as dotted string, or 'auto' to obtain automatically."
    echo "  -a   Alternative DNS server IP address."
    echo "  -n   Interface name."
    echo "  -c   Validate the settings."
    echo "  -6   Use IPv6 instead of IPv4."
    echo "  -l   List interfaces."
    echo "  -v   Verbose mode."
    echo "  -h   Show this help message."
    exit 0
}

function list_interfaces() {
    echo "List of interfaces:"
    ip -$([ "$ipv" = "ipv6" ] && echo "6" || echo "4") addr show
}

function check_permissions() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root or with sudo."
        exit 1
    fi
}

function check_dns() {
    if [ -n "$iname" ]; then
        nmcli dev show "$iname" | grep 'IP4.DNS'
    else
        nmcli dev show | grep 'IP4.DNS'
    fi
}

function set_dns() {
    if [ -z "$iname" ]; then
        echo "No interface name specified."
        exit 1
    fi

    if [ "$dns" == "auto" ]; then
        nmcli con mod "$iname" ipv4.ignore-auto-dns no
        nmcli con mod "$iname" ipv4.dns ""
    else
        nmcli con mod "$iname" ipv4.dns "$dns"
        nmcli con mod "$iname" ipv4.ignore-auto-dns yes
    fi

    if [ -n "$alt" ]; then
        nmcli con mod "$iname" +ipv4.dns "$alt"
    fi

    nmcli con up "$iname"

    if [ "$validate" == "yes" ] || [ "$verbose" -eq 1 ]; then
        check_dns
    fi
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -d) dns="$2"; shift 2 ;;
        -a) alt="$2"; shift 2 ;;
        -n) iname="$2"; shift 2 ;;
        -c) validate="yes"; shift ;;
        -6) ipv="ipv6"; shift ;;
        -l) list_interfaces=1; shift ;;
        -v) verbose=1; shift ;;
        -h|--help) usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

if [ "$verbose" -eq 1 ]; then
    echo "name=$iname"
    echo "dns=$dns"
    echo "alt=$alt"
    echo "ipv=$ipv"
    echo "validate=$validate"
fi

if [ "$list_interfaces" -eq 1 ]; then
    list_interfaces
    exit 0
fi

check_permissions

if [ -n "$dns" ]; then
    set_dns
else
    check_dns
fi
