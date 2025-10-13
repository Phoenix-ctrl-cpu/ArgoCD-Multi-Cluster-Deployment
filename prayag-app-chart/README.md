# Prayag App Helm Chart

This Helm chart deploys the prayag-new1 application across different environments (dev, uat, main).

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- kubectl configured to access your cluster

## Chart Structure

```
prayag-app-chart/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default values
├── values-dev.yaml         # Development environment values
├── values-uat.yaml         # UAT environment values
├── values-main.yaml        # Production environment values
├── templates/
│   ├── _helpers.tpl        # Template helpers
│   ├── deployment.yaml     # Deployment template
│   ├── service.yaml        # Service template
│   ├── hpa.yaml           # Horizontal Pod Autoscaler template
│   └── ingress.yaml       # Ingress template
└── README.md              # This file
```

## Installation

### 1. Add the chart to your Helm repository (if using a repository)

```bash
helm repo add prayag-app ./prayag-app-chart
helm repo update
```

### 2. Install for Development Environment

```bash
# Install with dev values
helm install prayag-app-dev ./prayag-app-chart -f values-dev.yaml

# Or install with custom values
helm install prayag-app-dev ./prayag-app-chart \
  --set environment=dev \
  --set replicaCount=2 \
  --set image.tag=1.0.0-7-dev
```

### 3. Install for UAT Environment

```bash
# Install with UAT values
helm install prayag-app-uat ./prayag-app-chart -f values-uat.yaml

# Or install with custom values
helm install prayag-app-uat ./prayag-app-chart \
  --set environment=uat \
  --set replicaCount=3 \
  --set image.tag=1.0.0-7-uat \
  --set ingress.enabled=true
```

### 4. Install for Production (Main) Environment

```bash
# Install with production values
helm install prayag-app-prod ./prayag-app-chart -f values-main.yaml

# Or install with custom values
helm install prayag-app-prod ./prayag-app-chart \
  --set environment=main \
  --set replicaCount=4 \
  --set image.tag=1.0.0-7 \
  --set ingress.enabled=true \
  --set autoscaling.enabled=true
```

## Upgrading

### Upgrade Development Environment

```bash
helm upgrade prayag-app-dev ./prayag-app-chart -f values-dev.yaml
```

### Upgrade UAT Environment

```bash
helm upgrade prayag-app-uat ./prayag-app-chart -f values-uat.yaml
```

### Upgrade Production Environment

```bash
helm upgrade prayag-app-prod ./prayag-app-chart -f values-main.yaml
```

## Uninstalling

```bash
# Uninstall development
helm uninstall prayag-app-dev

# Uninstall UAT
helm uninstall prayag-app-uat

# Uninstall production
helm uninstall prayag-app-prod
```

## Configuration

### Key Configuration Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `4` |
| `image.repository` | Image repository | `prayag8tiwari/prayag-new1-pipeline` |
| `image.tag` | Image tag | `1.0.0-7` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `8080` |
| `ingress.enabled` | Enable ingress | `false` |
| `resources.limits.memory` | Memory limit | `256Mi` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `autoscaling.enabled` | Enable HPA | `false` |

### Environment-Specific Values

#### Development (dev)
- Replicas: 2
- Resources: Lower limits
- No ingress
- Image tag: `1.0.0-7-dev`

#### UAT
- Replicas: 3
- Resources: Medium limits
- Ingress enabled
- Image tag: `1.0.0-7-uat`

#### Production (main)
- Replicas: 4
- Resources: Higher limits
- Ingress enabled with TLS
- Autoscaling enabled
- Image tag: `1.0.0-7`

## Monitoring and Troubleshooting

### Check Deployment Status

```bash
# Check all resources
kubectl get all -l app.kubernetes.io/name=prayag-app

# Check deployment status
kubectl get deployment prayag-app-dev
kubectl describe deployment prayag-app-dev

# Check pods
kubectl get pods -l app.kubernetes.io/name=prayag-app
kubectl logs -l app.kubernetes.io/name=prayag-app
```

### Check Service

```bash
kubectl get service prayag-app-dev
kubectl describe service prayag-app-dev
```

### Check Ingress (if enabled)

```bash
kubectl get ingress prayag-app-dev
kubectl describe ingress prayag-app-dev
```

## Customization

You can customize the deployment by:

1. **Modifying values files**: Edit `values-{env}.yaml` files
2. **Using --set flags**: Override specific values during installation
3. **Creating custom values files**: Create new values files for specific configurations

### Example: Custom Values

```yaml
# custom-values.yaml
replicaCount: 6
image:
  tag: "1.0.0-8"
resources:
  limits:
    memory: "1Gi"
    cpu: "2000m"
```

```bash
helm install prayag-app-custom ./prayag-app-chart -f custom-values.yaml
```

## CI/CD Integration

### Jenkins Pipeline Example

```groovy
pipeline {
    agent any
    stages {
        stage('Deploy to Dev') {
            steps {
                sh 'helm upgrade --install prayag-app-dev ./prayag-app-chart -f values-dev.yaml'
            }
        }
        stage('Deploy to UAT') {
            when { branch 'uat' }
            steps {
                sh 'helm upgrade --install prayag-app-uat ./prayag-app-chart -f values-uat.yaml'
            }
        }
        stage('Deploy to Production') {
            when { branch 'main' }
            steps {
                sh 'helm upgrade --install prayag-app-prod ./prayag-app-chart -f values-main.yaml'
            }
        }
    }
}
```

## Security Considerations

- Use specific image tags instead of `latest`
- Configure resource limits and requests
- Use non-root containers
- Enable network policies if needed
- Use secrets for sensitive data
- Regular security updates

## Support

For issues and questions, please contact the maintainer or create an issue in the repository.