# PocketBase Railway Template

Open-source backend solution for your next SaaS or mobile app, all bundled into a single file.

## Features

- **All-in-one Solution**: Manage your entire backend with a single, self-contained file
- **Easy to Use**: Simple setup for both beginners and experienced developers
- **Railway Optimized**: Configured for seamless deployment on Railway with persistent volumes

## Testing persistant volume storage

- Tested volume attached has persistent storage after restarting/redeploying of service or container
  

## Manual Deployment

### Prerequisites
- Railway account (free tier works)
- GitHub repository

### Steps

1. **Clone & Connect**:
   ```bash
   git clone https://github.com/arkarn2020/pocketbase.git
   railway login
   railway link
   ```

2. **Create Volume**:
   ```bash
   railway volume add
   ```
   - Mount Path: `/pb_data`
   - Size: `500MB`
   - Name: `pocketbase-volume`

3. **Deploy**:
   ```bash
   railway up
   railway logs
   ```

## Configuration

### Dockerfile ✅
- Alpine Linux (lightweight)
- PocketBase v0.29.2
- Non-root user for security
- Automatic volume permission fixing

### railway.json ✅
```json
{
  "$schema": "https://railway.com/railway.json",
  "build": { "builder": "DOCKERFILE" },
  "deploy": {
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  },
  "volumes": [
    {
      "mountPath": "/pb_data",
      "size": "500MB"
    }
  ]
}
```
## Troubleshooting

### Common Issues

**Volume Permission Errors**
- Fixed automatically by Dockerfile

**Out of Memory Errors**  
- Usually volume mounting issue, not actual memory
- Restart: `railway service update`

**Volume Size Limits**
- Free plan: 500MB max
- Upgrade plan for larger volumes

### Debugging
```bash
railway volume list    # Check volume status
railway logs --follow  # View logs
railway service update # Restart service
```

## Railway Plans

### Free Plan
- ✅ 500MB max volume
- ✅ 512MB RAM limit  
- ✅ $5 monthly credit
- ✅ Perfect for development

### Recommended Upgrades
When scaling:
- 1GB+ volumes for larger databases
- More RAM for better performance
- Higher CPU limits for concurrent users

## Production Optimizations

### When Upgrading Railway Plan

Add resource limits to `railway.json`:
```json
{
  "resources": {
    "memory": "512MB",
    "cpu": "500m"
  },
  "volumes": [
    {
      "mountPath": "/pb_data",
      "size": "1GB"
    }
  ]
}
```

### Environment Variables (Optional)

Set in Railway dashboard or add to `railway.json`:
```json
{
  "environment": {
    "PB_ADMIN_EMAIL": "your-admin@email.com",
    "PB_DEBUG": "false"
  }
}
```

## Accessing Your PocketBase

1. **Get your Railway URL**:
   ```bash
   railway status
   ```

2. **Access Admin Panel**:
   - Visit: `https://your-app.railway.app/_/`
   - Create admin account on first visit
   - Login with your credentials

3. **API Endpoints**:
   - Base URL: `https://your-app.railway.app/`
   - API Docs: `https://your-app.railway.app/_/`
   - Health Check: `https://your-app.railway.app/_/`

## File Structure

```
pocketbase/
├── Dockerfile              # Container configuration
├── railway.json            # Railway deployment config
├── README.md               # This file
```



