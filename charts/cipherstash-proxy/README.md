# CipherStash Proxy Helm Chart

A Helm chart for deploying CipherStash Proxy - a transparent encryption proxy for PostgreSQL databases.

## Overview

CipherStash Proxy enables transparent encryption and searchable encryption capabilities for PostgreSQL databases without requiring application code changes. This Helm chart deploys the proxy in a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.2.0+
- A PostgreSQL database accessible from the cluster
- CipherStash workspace credentials

## Installation

[Helm](https://helm.sh) must be installed to use the charts. Please refer to Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```bash
helm repo add cipherstash https://cipherstash.github.io/helm-charts
```

If you had already added this repo earlier, run `helm repo update` to retrieve the latest versions of the packages. You can then run `helm search repo cipherstash` to see the charts.

To install the cipherstash-proxy chart:

```bash
helm install my-cipherstash-proxy cipherstash/cipherstash-proxy
```

To uninstall the chart:

```bash
helm uninstall my-cipherstash-proxy
```

## Configuration

Create an account on [CipherStash](https://cipherstash.com) and get your workspace credentials from the [CipherStash Dashboard](https://dashboard.cipherstash.com).

### Required Configuration

The following values must be configured for the proxy to work:

```bash
helm install my-cipherstash-proxy cipherstash/cipherstash-proxy \
  --set database.host=postgres.example.com \
  --set database.name=myapp \
  --set database.username=myuser \
  --set database.password=mypass \
  --set cipherstash.workspaceCrn="your-workspace-crn" \
  --set cipherstash.clientId="your-client-id" \
  --set cipherstash.clientKey="your-client-key" \
  --set cipherstash.clientAccessKey="your-access-key"
```

| Parameter | Description | Default |
|-----------|-------------|---------|
| `database.host` | PostgreSQL database host | `replace_with_postgres_host` |
| `database.name` | PostgreSQL database name | `replace_with_postgres_database` |
| `database.port` | PostgreSQL database port | `replace_with_postgres_port` |
| `database.username` | PostgreSQL username | `replace_with_postgres_username` |
| `database.password` | PostgreSQL password | `replace_with_postgres_password` |
| `cipherstash.workspaceCrn` | CipherStash workspace CRN | `replace_with_cipherstash_workspace_crn` |
| `cipherstash.clientId` | CipherStash client ID | `replace_with_cipherstash_client_id` |
| `cipherstash.clientKey` | CipherStash client key | `replace_with_cipherstash_client_key` |
| `cipherstash.clientAccessKey` | CipherStash access key | `replace_with_cipherstash_access_key` |

**Note**: For production environments, it's recommended to use Kubernetes secrets for sensitive values instead of plain text. See the [Secrets Configuration](#secrets-configuration) section below.

### Secrets Configuration

For enhanced security, sensitive values (database password, CipherStash client key, and client access key) can be stored in Kubernetes secrets instead of plain text in values.yaml.

#### Option 1: Chart-Managed Secrets (Recommended)

The chart can create and manage secrets for you:

```yaml
secrets:
  create: true
  # Provide sensitive values here instead of in the main configuration
  databasePassword: "your-secure-database-password"
  cipherstashClientKey: "your-cipherstash-client-key"
  cipherstashClientAccessKey: "your-cipherstash-access-key"
  
  # Optional: Override configuration values with secrets
  # If not provided, values from database.* and cipherstash.* will be used
  databaseHost: "postgres.example.com"
  databaseName: "myapp"
  databasePort: "5432"
  databaseUsername: "app_user"
  cipherstashWorkspaceCrn: "crn:cipherstash:workspace:..."
  cipherstashClientId: "client_abc123"

# These values will be used as fallbacks when secrets.create is true
# but the corresponding secret value is not provided
database:
  host: "postgres.example.com"
  name: "myapp"
  port: "5432"
  username: "app_user"
  password: ""  # Not used when secrets.create is true
cipherstash:
  workspaceCrn: "crn:cipherstash:workspace:..."
  clientId: "client_abc123"
  clientKey: ""  # Not used when secrets.create is true
  clientAccessKey: ""  # Not used when secrets.create is true
```

#### Option 2: External Secrets

Use existing secrets created outside of the chart. This option supports external secrets for all configuration values:

```yaml
secrets:
  create: false
  external:
    # Database configuration secrets
    databaseHostSecret:
      name: "my-database-config-secret"
      key: "host"
    databaseNameSecret:
      name: "my-database-config-secret"
      key: "name"
    databasePortSecret:
      name: "my-database-config-secret"
      key: "port"
    databaseUsernameSecret:
      name: "my-database-config-secret"
      key: "username"
    databasePasswordSecret:
      name: "my-database-secret"
      key: "password"
    
    # CipherStash configuration secrets
    cipherstashWorkspaceCrnSecret:
      name: "my-cipherstash-config-secret"
      key: "workspace-crn"
    cipherstashClientIdSecret:
      name: "my-cipherstash-config-secret"
      key: "client-id"
    cipherstashClientKeySecret:
      name: "my-cipherstash-secret"
      key: "client-key"
    cipherstashClientAccessKeySecret:
      name: "my-cipherstash-secret"
      key: "client-access-key"
```

#### Option 3: Plain Text (Development Only)

For development environments, you can disable secrets:

```yaml
secrets:
  create: false
  # external secrets not configured
database:
  password: "dev-password"
cipherstash:
  clientKey: "dev-client-key"
  clientAccessKey: "dev-access-key"
```

| Parameter | Description | Default |
|-----------|-------------|---------|
| `secrets.create` | Whether to create secrets for sensitive values | `true` |
| `secrets.databaseHost` | Database host (when create=true) | `""` |
| `secrets.databaseName` | Database name (when create=true) | `""` |
| `secrets.databasePort` | Database port (when create=true) | `""` |
| `secrets.databaseUsername` | Database username (when create=true) | `""` |
| `secrets.databasePassword` | Database password (when create=true) | `""` |
| `secrets.cipherstashWorkspaceCrn` | CipherStash workspace CRN (when create=true) | `""` |
| `secrets.cipherstashClientId` | CipherStash client ID (when create=true) | `""` |
| `secrets.cipherstashClientKey` | CipherStash client key (when create=true) | `""` |
| `secrets.cipherstashClientAccessKey` | CipherStash client access key (when create=true) | `""` |
| `secrets.external.*.name` | Name of existing secret (when create=false) | `""` |
| `secrets.external.*.key` | Key within the secret (when create=false) | varies |

### Common Configuration Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of proxy replicas | `1` |
| `image.repository` | Proxy image repository | `cipherstash/proxy` |
| `image.tag` | Proxy image tag | `2.1.2` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Proxy service port | `6432` |
| `service.targetPort` | Proxy container port | `6432` |
| `resources.limits.cpu` | CPU limit | `1` |
| `resources.limits.memory` | Memory limit | `2Gi` |
| `resources.requests.cpu` | CPU request | `100m` |
| `resources.requests.memory` | Memory request | `256Mi` |

### Metrics and Monitoring

| Parameter | Description | Default |
|-----------|-------------|---------|
| `metricsService.enabled` | Enable metrics service | `true` |
| `metricsService.type` | Metrics service type | `ClusterIP` |
| `metricsService.port` | Metrics service port | `9930` |
| `metricsService.targetPort` | Metrics container port | `9930` |
| `metricsService.annotations` | Metrics service annotations | `{"prometheus.io/scrape": "true", "prometheus.io/port": "9930", "prometheus.io/path": "/metrics"}` |
| `prometheus.enabled` | Enable Prometheus metrics | `true` |

### Autoscaling

| Parameter | Description | Default |
|-----------|-------------|---------|
| `autoscaling.enabled` | Enable HPA | `false` |
| `autoscaling.minReplicas` | Minimum replicas | `1` |
| `autoscaling.maxReplicas` | Maximum replicas | `100` |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization | `80` |

### Database Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `database.withTlsVerification` | Enable TLS verification between Proxy and database | `false` |
| `database.installAwsRdsCertBundle` | Install AWS RDS certificate bundle (recommended for AWS) | `false` |

### Logging Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `logging.level` | Log level (error \| warn \| info \| debug \| trace) | `info` |
| `logging.format` | Log format (pretty \| text \| structured) | `""` |
| `logging.ansiEnabled` | Enable ANSI (colored) output | `""` |

### TLS Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `tls.requireTls` | Enforce TLS connections from Client to Proxy | `false` |
| `tls.certificate.path` | Path to the Public Certificate .crt file | `""` |
| `tls.certificate.pem` | The Public Certificate PEM as a string | `""` |
| `tls.privateKey.path` | Path to the Private Key file | `""` |
| `tls.privateKey.pem` | The Private Key PEM as a string | `""` |

### Ingress

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress hosts configuration | `[{"host": "chart-example.local", "paths": [{"path": "/", "pathType": "Prefix"}]}]` |
| `ingress.tls` | Ingress TLS configuration | `[]` |

### Service Account

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Whether to create a service account | `true` |
| `serviceAccount.name` | Name of the service account to use | `""` |
| `serviceAccount.annotations` | Annotations to add to the service account | `{}` |

### Pod Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podAnnotations` | Annotations to add to pods | `{}` |
| `podSecurityContext` | Pod security context | `{}` |
| `securityContext` | Container security context | `{}` |

### Deployment Strategy

| Parameter | Description | Default |
|-----------|-------------|---------|
| `strategy.type` | Deployment strategy type | `RollingUpdate` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum unavailable pods during update | `25%` |
| `strategy.rollingUpdate.maxSurge` | Maximum surge pods during update | `25%` |

### Health Checks

| Parameter | Description | Default |
|-----------|-------------|---------|
| `probes.liveness.enabled` | Enable liveness probe | `true` |
| `probes.liveness.initialDelaySeconds` | Initial delay for liveness probe | `30` |
| `probes.liveness.periodSeconds` | Period for liveness probe | `10` |
| `probes.liveness.timeoutSeconds` | Timeout for liveness probe | `5` |
| `probes.liveness.failureThreshold` | Failure threshold for liveness probe | `3` |
| `probes.readiness.enabled` | Enable readiness probe | `true` |
| `probes.readiness.initialDelaySeconds` | Initial delay for readiness probe | `5` |
| `probes.readiness.periodSeconds` | Period for readiness probe | `5` |
| `probes.readiness.timeoutSeconds` | Timeout for readiness probe | `3` |
| `probes.readiness.failureThreshold` | Failure threshold for readiness probe | `3` |

### Namespace Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `namespace.create` | Whether to create a namespace | `false` |
| `namespace.name` | Name of the namespace to create | `cipherstash` |

### Advanced Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `imagePullSecrets` | Image pull secrets | `[]` |
| `nameOverride` | Override chart name | `""` |
| `fullnameOverride` | Override full chart name | `""` |
| `nodeSelector` | Node selector for pod assignment | `{}` |
| `tolerations` | Tolerations for pod assignment | `[]` |
| `affinity` | Affinity for pod assignment | `{}` |

## Examples

### Basic Installation with Secrets (Recommended)

```yaml
# values-production.yaml
# You can provide configuration values directly or via secrets
database:
  host: "postgres.production.com"  # Or leave empty and use secrets.databaseHost
  name: "myapp"  # Or leave empty and use secrets.databaseName
  port: "5432"  # Or leave empty and use secrets.databasePort
  username: "app_user"  # Or leave empty and use secrets.databaseUsername
  # password provided via secrets

cipherstash:
  workspaceCrn: "crn:cipherstash:workspace:us-east-1:12345:workspace/my-workspace"  # Or leave empty and use secrets.cipherstashWorkspaceCrn
  clientId: "client_abc123"  # Or leave empty and use secrets.cipherstashClientId
  # clientKey and clientAccessKey provided via secrets

secrets:
  create: true
  # Optional: Override configuration values with secrets
  # databaseHost: "postgres.production.com"
  # databaseName: "myapp"
  # databasePort: "5432"
  # databaseUsername: "app_user"
  # cipherstashWorkspaceCrn: "crn:cipherstash:workspace:us-east-1:12345:workspace/my-workspace"
  # cipherstashClientId: "client_abc123"
  
  # Required sensitive values
  databasePassword: "secure_database_password"
  cipherstashClientKey: "your_actual_client_key"
  cipherstashClientAccessKey: "your_actual_access_key"

resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 200m
    memory: 256Mi
```

### Installation with External Secrets

```yaml
# values-external-secrets.yaml
# Note: When using external secrets, you can leave these values empty
# as they will be read from the specified secrets
database:
  host: ""  # Will be read from secret
  name: ""  # Will be read from secret
  port: ""  # Will be read from secret
  username: ""  # Will be read from secret

cipherstash:
  workspaceCrn: ""  # Will be read from secret
  clientId: ""  # Will be read from secret

secrets:
  create: false
  external:
    # Database configuration secrets
    databaseHostSecret:
      name: "database-config"
      key: "host"
    databaseNameSecret:
      name: "database-config"
      key: "name"
    databasePortSecret:
      name: "database-config"
      key: "port"
    databaseUsernameSecret:
      name: "database-config"
      key: "username"
    databasePasswordSecret:
      name: "database-credentials"
      key: "password"
    
    # CipherStash configuration secrets
    cipherstashWorkspaceCrnSecret:
      name: "cipherstash-config"
      key: "workspace-crn"
    cipherstashClientIdSecret:
      name: "cipherstash-config"
      key: "client-id"
    cipherstashClientKeySecret:
      name: "cipherstash-credentials"
      key: "client-key"
    cipherstashClientAccessKeySecret:
      name: "cipherstash-credentials"
      key: "client-access-key"
```

```bash
# Create your secrets first
kubectl create secret generic database-config \
  --from-literal=host=postgres.production.com \
  --from-literal=name=myapp \
  --from-literal=port=5432 \
  --from-literal=username=app_user

kubectl create secret generic database-credentials \
  --from-literal=password=your_db_password

kubectl create secret generic cipherstash-config \
  --from-literal=workspace-crn=crn:cipherstash:workspace:us-east-1:12345:workspace/my-workspace \
  --from-literal=client-id=client_abc123

kubectl create secret generic cipherstash-credentials \
  --from-literal=client-key=your_client_key \
  --from-literal=client-access-key=your_access_key

# Then install the chart
helm install cipherstash-proxy cipherstash/cipherstash-proxy -f values-external-secrets.yaml
```

### High Availability Setup

```yaml
# values-ha.yaml
replicaCount: 3

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70

affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: app.kubernetes.io/name
            operator: In
            values:
            - cipherstash-proxy
        topologyKey: kubernetes.io/hostname
```

### TLS Configuration Example

```yaml
# values-tls.yaml
tls:
  requireTls: true
  certificate:
    # Option 1: Path to certificate file
    path: "/etc/tls/cert.crt"
    # Option 2: Certificate as PEM string
    # pem: |
    #   -----BEGIN CERTIFICATE-----
    #   ...
    #   -----END CERTIFICATE-----
  privateKey:
    # Option 1: Path to private key file
    path: "/etc/tls/key.pem"
    # Option 2: Private key as PEM string
    # pem: |
    #   -----BEGIN PRIVATE KEY-----
    #   ...
    #   -----END PRIVATE KEY-----

# Mount TLS certificates as volumes
volumes:
  - name: tls-certs
    secret:
      secretName: proxy-tls-certs

volumeMounts:
  - name: tls-certs
    mountPath: /etc/tls
    readOnly: true
```

### AWS RDS Configuration Example

```yaml
# values-aws-rds.yaml
database:
  withTlsVerification: true
  installAwsRdsCertBundle: true  # Recommended for AWS RDS

# Ensure proper resource allocation for certificate operations
resources:
  limits:
    cpu: 1000m
    memory: 2Gi
  requests:
    cpu: 200m
    memory: 512Mi
```

## Using the Proxy

After installation, update your application's database connection to point to the proxy:

- **Host**: `<release-name>-cipherstash-proxy.<namespace>.svc.cluster.local`
- **Port**: `6432` (or your configured service port)
- **Database, Username, Password**: Use the same credentials as your original database

## Monitoring

If metrics are enabled, Prometheus metrics are available at:
`http://<release-name>-cipherstash-proxy-metrics.<namespace>.svc.cluster.local:9930/metrics`

## Troubleshooting

### Check Proxy Logs

```bash
kubectl logs -l app.kubernetes.io/name=cipherstash-proxy -f
```

### Test Database Connectivity

```bash
kubectl exec -it deployment/<release-name>-cipherstash-proxy -- /bin/sh
# Inside the container, test connectivity to your database
```

### Verify Configuration

```bash
kubectl describe deployment <release-name>-cipherstash-proxy
```

### Troubleshooting External Secrets

If you're using external secrets and the proxy fails to start, check:

1. **Secret Existence**: Ensure all referenced secrets exist
```bash
kubectl get secrets -n <namespace>
```

2. **Secret Keys**: Verify all required keys are present in the secrets
```bash
kubectl describe secret <secret-name> -n <namespace>
```

3. **Secret Values**: Check that secret values are properly base64 encoded
```bash
kubectl get secret <secret-name> -n <namespace> -o yaml
```

4. **Configuration Validation**: Verify your values.yaml has the correct secret references
```bash
helm template <release-name> . --values values.yaml --dry-run
```

### Common Issues

- **"secret not found"**: Ensure the secret name and namespace are correct
- **"key not found"**: Verify the secret key names match your configuration
- **"invalid base64"**: Check that secret values are properly encoded
- **"permission denied"**: Ensure the service account has access to the secrets

## Upgrading

```bash
helm upgrade my-cipherstash-proxy cipherstash/cipherstash-proxy
```

## Uninstalling

```bash
helm uninstall my-cipherstash-proxy
```

## Values Reference

For a complete list of configurable values, see `values.yaml` in the chart directory.

## Support

For support with CipherStash Proxy, visit [CipherStash Documentation](https://docs.cipherstash.com) or contact support@cipherstash.com.

## Version Compatibility

This chart is compatible with:
- Kubernetes 1.16+
- Helm 3.2.0+
- CipherStash Proxy 2.1.2+

## Changelog

### Version 0.1.2
- Added support for external secrets for all configuration values
- Enhanced secret management with chart-managed and external secret options
- Added comprehensive documentation for all configuration options
- Improved troubleshooting guides for external secrets 