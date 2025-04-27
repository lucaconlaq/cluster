# An exemplary GKE setup with Terraform ⚓

This project automates the deployment of a Kubernetes infrastructure on Google Cloud Platform (GCP) using Terraform. It includes the setup of a GKE cluster, DNS management with Google DNS, and the deployment of critical services such as cert-manager, ExternalDNS, and nginx-ingress using Helm.

## Prerequisites

- **Google Cloud Platform account**: Ensure you have access to a Google Cloud account with billing enabled.
- **Terraform, Helm, and Google Cloud CLI installed**: Make sure you have the latest versions of Terraform, Helm, and the `gcloud` CLI installed on your local machine.
- **Customizable DNS**: Access to a DNS service where you can customize NS (Name Server) records to point to Google Cloud DNS.

You can install everything using [Mise](https://github.com/jdx/mise).

```
mise install
```

## Getting Started

1. **Set up GCP credentials**: Ensure your GCP credentials are configured by running `gcloud auth application-default login`.

2. **Update Terraform Variables**: Modify the variables.tf file or create a terraform.tfvars file to set your project-specific values such as project_id, region, dns_name, etc. Ensure the values reflect your GCP project and infrastructure requirements.

3. **Initialize Terraform**: Run `terraform init` to initialize the Terraform workspace, which will download the required providers and initialize the backend.

4. **Apply the configuration**: Deploy the infrastructure with `terraform apply`. Confirm the action by typing `yes` when prompted.

5. **Update NS records at your registrar**: After the deployment, Terraform will output the NS (Name Server) records for your managed DNS zone. Log in to your domain registrar's control panel and update the NS records for your domain to point to these Google Cloud DNS name servers. This step is crucial for directing your domain's traffic to your new infrastructure.

## Usage

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: salut
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt
  namespace: salut
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: your-email@foo.bar # add your email
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
      - http01:
          ingress:
            ingressClassName: nginx
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: salut
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: web
          image: gcr.io/google-samples/hello-app:1.0
          ports:
            - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: salut
spec:
  type: ClusterIP
  selector:
    app: web
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: salut
  annotations:
    cert-manager.io/issuer: "letsencrypt"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - foo.bar # your domain
      secretName: salut-tls
  rules:
    - host: foo.bar # your domain
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web-service

                port:
                  number: 8080
```

This setup allows for the automatic assignment of a DNS record and HTTPS certificate when deploying an image on the cluster using the provided Kubernetes manifests.

## Components

- **GKE Cluster**: A Google Kubernetes Engine cluster configured with a default node pool.
- **Google DNS**: A managed DNS zone for handling domain name resolution.
- **Cert-Manager**: Deployed via Helm, manages certificates within the Kubernetes cluster.
- **ExternalDNS**: Syncs services and ingress resources with the DNS provider to make them discoverable.
- **Nginx Ingress**: An Ingress controller for Kubernetes providing HTTP and HTTPS routing.

## Contributing

Contributions are welcome! Please feel free to submit a pull request.

## License

This project is open-sourced under the MIT License. See the LICENSE file for more details.
