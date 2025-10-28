#!/usr/bin/env node

const { execSync } = require('child_process');

function toggleVpn() {
  try {
    const status = execSync('expressvpn status 2>/dev/null', { encoding: 'utf-8' });
    
    if (status.includes('Connected')) {
      console.log('Disconnecting ExpressVPN...');
      execSync('expressvpn disconnect', { stdio: 'inherit' });
      
      try {
        execSync('notify-send "ExpressVPN" "Disconnected" -i network-vpn-symbolic -t 2000', { stdio: 'ignore' });
      } catch (e) {
      }
    } else {
      console.log('Connecting ExpressVPN...');
      execSync('expressvpn connect', { stdio: 'inherit' });
      
      try {
        execSync('notify-send "ExpressVPN" "Connected" -i network-vpn-symbolic -t 2000', { stdio: 'ignore' });
      } catch (e) {
      }
    }
    
    try {
      execSync('pkill -RTMIN+10 waybar', { stdio: 'ignore' });
    } catch (e) {
    }
    
  } catch (error) {
    console.error('Error toggling VPN:', error.message);
    process.exit(1);
  }
}

toggleVpn();
