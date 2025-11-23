# Redirect HTTP to HTTPS
server {
	listen 80;
	server_name opensearch-ingest.cani.ne.jp;
	return 301 https://$server_name$request_uri;
}

# HTTPS endpoint for log ingestion from DigitalOcean
server {
	listen 443 ssl http2;
	server_name opensearch-ingest.cani.ne.jp;

	# SSL configuration
	ssl_certificate /root/letsencrypt/live/opensearch-ingest.cani.ne.jp/fullchain.crt;
	ssl_certificate_key /root/letsencrypt/live/opensearch-ingest.cani.ne.jp/key.key;
	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_ciphers HIGH:!aNULL:!MD5;
	ssl_prefer_server_ciphers on;

	# Increase timeouts for bulk operations
	proxy_connect_timeout 300s;
	proxy_send_timeout 300s;
	proxy_read_timeout 300s;
	send_timeout 300s;

	# Increase buffer sizes for large log payloads
	client_max_body_size 100M;
	client_body_buffer_size 128k;

	# Only allow specific log ingestion endpoints
	location ~ ^/(_bulk|_doc|[^/]+/_doc|[^/]+/_bulk).*$ {
		proxy_pass http://127.0.0.1:9200;
		proxy_http_version 1.1;
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
		proxy_set_header Connection "Keep-Alive";
		proxy_set_header Proxy-Connection "Keep-Alive";
	}

	# Block all other endpoints for security
	location / {
		return 403;
	}

	# Health check endpoint (optional)
	location = /health {
		access_log off;
		proxy_pass http://127.0.0.1:9200/_cluster/health;
		proxy_http_version 1.1;
		proxy_set_header Connection "";
	}
}
