# IP Configuration Guide

## Quick IP Address Change

To change the backend server IP address for your mobile app testing:

### 1. Update Constants File
Edit `lib/utils/constants.dart`:

```dart
class AppConstants {
  // Change this IP address to your current backend server IP
  static const String baseIpAddress = '10.230.37.240'; // <-- Change this line
  static const String basePort = '8000';
  static const String baseUrl = 'http://$baseIpAddress:$basePort';
  // ... rest of the file
}
```

### 2. Common IP Configurations

**For USB Debugging with Mobile Device:**
- Find your computer's IP address on the local network
- Use that IP address (e.g., `192.168.1.100`, `10.230.37.240`)

**For Local Development:**
- Use `127.0.0.1` or `localhost` (only works on emulator)

**For WiFi Network:**
- Use your computer's WiFi IP address
- Both mobile device and computer must be on same WiFi network

### 3. How to Find Your Computer's IP Address

**Windows:**
```cmd
ipconfig
```
Look for "IPv4 Address" under your active network adapter.

**macOS/Linux:**
```bash
ifconfig
```
Look for "inet" address under your active network interface.

**Alternative (all platforms):**
```bash
hostname -I
```

### 4. Test Connection

1. Open the app
2. Go to Settings
3. Tap "Test Server Connection"
4. Check if connection is successful

### 5. Backend Server Setup

Make sure your Django backend is running and accessible:

```bash
# In your backend directory
python manage.py runserver 0.0.0.0:8000
```

The `0.0.0.0` makes the server accessible from other devices on the network.

### 6. Firewall Settings

Ensure your computer's firewall allows connections on port 8000:

**Windows:**
- Windows Defender Firewall → Allow an app → Add port 8000

**macOS:**
- System Preferences → Security & Privacy → Firewall → Options → Add port 8000

**Linux:**
```bash
sudo ufw allow 8000
```

### 7. Network Troubleshooting

If connection fails:

1. **Check IP Address:** Verify the IP in constants.dart matches your computer's IP
2. **Check Port:** Ensure backend is running on port 8000
3. **Check Network:** Both devices must be on same network
4. **Check Firewall:** Ensure port 8000 is open
5. **Test Backend:** Visit `http://YOUR_IP:8000` in mobile browser

### 8. Quick Reference

Current configuration:
- **IP Address:** `10.230.37.240`
- **Port:** `8000`
- **Full URL:** `http://10.230.37.240:8000`

**File to edit:** `lib/utils/constants.dart`
**Line to change:** `static const String baseIpAddress = '10.230.37.240';`

---

**Note:** Remember to restart the Flutter app after changing the IP address for changes to take effect.