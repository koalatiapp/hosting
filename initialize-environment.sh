#!/usr/bin/env bash

#############################
##### Utility functions #####
#############################

# Generates a HS256 JWT.
# 1st argument: JSON payload
# 2nd argument: secret
generate_jwt() {
  header='{ "alg": "HS256", "typ": "JWT" }'

  header_base64=$(printf %s "$header" | json | base64_urlencode)
  payload_base64=$(printf %s "$1" | json | base64_urlencode)
  signed_content="${header_base64}.${payload_base64}"
  signature=$(printf %s "$signed_content" | openssl dgst -binary -sha256 -hmac "$2" | base64_urlencode)

  printf %s "${signed_content}.${signature}"
}

json() {
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | jq -c .
}

base64_urlencode() { sed 's/Cg$//' <<< `openssl enc -base64 -A | tr '+/' '-_' | tr -d '='`; }

# Generates a random password/secret.
# Accepts a length as its first argument (defaults to 32).
generate_secret() { 
	length="${1:-32}"
	LC_ALL=C tr -dc 'A-Za-z0-9*+,:<>_{}~' </dev/urandom | head -c $length ; echo 
}

# Updates the env file to set a value
# 1st argument: variable name
# 2nd argument: value
set_env_value() {
  # MacOS's sed requires an empty parameter on -i, but others OS don't
  if [[ "$OSTYPE" == "darwin"* ]]; then
	  sed -i '' -e "s/^$1=.*$/$1=$2/" .env
  else
    sed -i -e "s/^$1=.*$/$1=$2/" .env
  fi
}


#################################
##### INITIALIZATION SCRIPT #####
#################################

if [ -f ".env" ]; then
    echo "The .env file already exists. Remove it or rename it to start a fresh install."
	exit 1
fi

if [ ! -f ".env.example" ]; then
    echo "The .env.example file is missing. If you deleted it accidentally, you can get it back from Koalati's self-hosting template on GitHub."
	exit 1
fi

echo "Enter the desired host name for your Koalati installation."
echo "Ex.: \"koalati.mydomain.com\", \"localhost\", etc."
read -p "Hostname > " hostname
hostname=`sed "s/https\{0,1\}:\/\///" <<< $hostname`
hostname=`sed "s/\/.*//" <<< $hostname`
echo "$hostname"

# Generate the real .env file
cp ".env.example" ".env"

# Replace "localhost" instances with hostname
set_env_value "SERVER_NAME" "$hostname, caddy:80"
set_env_value "BASE_URL" "https:\/\/$hostname"
set_env_value "MERCURE_PUBLIC_URL" "https:\/\/$hostname\/.well-known\/mercure"

echo "✅ Your .env file has been created."

# Generate passwords / secrets
set_env_value "APP_SECRET" `generate_secret 64`
set_env_value "REDIS_PASSWORD" `generate_secret 64`
set_env_value "MYSQL_PASSWORD" `generate_secret 64`
set_env_value "MERCURE_JWT_SECRET" `generate_secret 64`

# Generate tools-service authentication secrets & JWT
tools_api_jwt_secret=`generate_secret`
tools_api_auth_access_token=`generate_secret`
set_env_value "TOOLS_API_JWT_SECRET" "$tools_api_jwt_secret"
set_env_value "TOOLS_API_AUTH_ACCESS_TOKEN" "$tools_api_auth_access_token"
set_env_value "TOOLS_API_WORKER_BEARER_TOKEN" `generate_jwt "{ \"access_token\": \"$tools_api_auth_access_token\" }" "$tools_api_jwt_secret"`

echo "✅ Your secrets have been randomly generated and saved in the .env file."
echo ""
echo "🟨 Please define your SMTP configuration in the MAILER_DSN variable within the .env file."
echo "   This will allow your Koalati instance to send emails, which is required for some core features."
echo "   Refer to Symfony's documentation for more information: https://symfony.com/doc/current/mailer.html#transport-setup"
echo "   You'll also want to add a 'FROM' address in the MAILER_FROM_ADDRESS variable."