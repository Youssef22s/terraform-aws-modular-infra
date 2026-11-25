#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Terraform AWS Project</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background: radial-gradient(circle at 25% 25%, #3b1d5e 0%, #0f172a 55%, #090d16 100%);
      color: #f8fafc;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      margin: 0;
    }
    .card {
      background: rgba(255, 255, 255, 0.06);
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
      border: 1px solid rgba(255, 255, 255, 0.14);
      padding: 40px;
      border-radius: 20px;
      box-shadow: 0 25px 45px rgba(0, 0, 0, 0.45);
      max-width: 440px;
      width: 90%;
      text-align: center;
    }
    .badge {
      background: rgba(16, 185, 129, 0.15);
      border: 1px solid rgba(52, 211, 153, 0.3);
      color: #34d399;
      padding: 5px 14px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
    }
    h1 {
      font-size: 24px;
      margin: 20px 0 25px;
    }
    .item {
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid rgba(255, 255, 255, 0.08);
      padding: 14px 18px;
      border-radius: 12px;
      margin-bottom: 12px;
      display: flex;
      justify-content: space-between;
      font-size: 14px;
    }
    .item span { color: #cbd5e1; }
    .item strong { font-family: monospace; color: #ffffff; }
  </style>
</head>
<body>
  <div class="card">
    <span class="badge">● Active</span>
    <h1>Deployed Automatically with Terraform!</h1>
    <div class="item">
      <span>Environment</span>
      <strong>${env}</strong>
    </div>
    <div class="item">
      <span>Hostname</span>
      <strong>$(hostname -f)</strong>
    </div>
  </div>
</body>
</html>
EOF