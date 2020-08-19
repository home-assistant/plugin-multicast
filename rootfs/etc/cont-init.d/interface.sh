#!/usr/bin/with-contenv bashio
# ==============================================================================
# Detect active interface for mdns repeater
# ==============================================================================
interface=$(awk '{for (i=1; i<=NF; i++) if ($i~/dev/) print $(i+1)}' <<< "$(ip route get 8.8.8.8)")

echo "${interface}" > /var/run/s6/container_environment/ACTIVE_INTERFACE
