#!/usr/bin/env node

const { execSync } = require('child_process');

function getVpnStatus() {
  try {
    const status = execSync('expressvpn status 2>/dev/null', { encoding: 'utf-8' });
    
    if (status.includes('Connected')) {
      const locationMatch = status.match(/Connected to (.+)/);
      const location = locationMatch ? locationMatch[1].trim() : 'Unknown Location';
      
      return {
        text: 'Connected',
        tooltip: `Connected to ${location}`,
        class: 'connected',
        alt: 'connected'
      };
    } else if (status.includes('Not connected')) {
      return {
        text: 'Disconnected',
        tooltip: 'VPN Disconnected',
        class: 'disconnected',
        alt: 'disconnected'
      };
    } else {
      return {
        text: '?',
        tooltip: 'VPN status unknown'
      };
    }
  } catch (error) {
    return {
      text: '',
      tooltip: 'VPN status unknown'
    };
  }
}

console.log(JSON.stringify(getVpnStatus()));
