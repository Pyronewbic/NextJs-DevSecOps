# NextJs Repo + Pipelines

NextJs has been all the hype as of late - Most folks set up environment-specific pipelines as well as store K8s Configuration under parent environment folders, which leads to bloated code processes that do not conform to best practices. 

## Simplifying the process

A repository, Helm Charts, Kubernetes cluster and multi-branch pipelines are an excellent way to tackle this problem statement - allowing you to work with a minified approach to fast-paced deployment strategies.

## Stack Used

- Jenkins: This OSS CI/CD tool helps reducing dependence on a cloud provider's Build and Release tools (eg: AWS CodeDeploy, Azure DevOps), and lets you migrate providers if needed with very less overhead work required.
- Node: (LTS), NextJS
- Docker: Image Build tool.
- Helm: This templating tool helps managing releases, and negates the need for Environment-specific folders with Kubernetes configuration.
- A Kubernetes cluster: Feel free to use kind/minikube to provision one locally, or use provision one on the respective cloud provider.

## Setup Process

- Cluster NA/NS Creation
    - Setup Namespaces and Service accounts for your environments.
    - Attach correct RBAC policies to the service accounts
- EFK setup (Logging and Monitoring)
    - Create n Persistent Volumes for Elasticsearch to use as part of it's stateful volume claim.
    - Apply the files under ./pipelines/Kubernetes/Normal/EFK/elastic to set up ES.
    - Setup fluentd as a daemonset to forward container logs to elasticsearch.
    - Install Kibana to visualize logs - hit 'Discover' and add logstash* as an index.
- Ingress Nginx
    - Apply ./pipelines/Kubernetes/Normal/Ingress-Nginx/deploy-tls-termination.yaml if you're using AWS, otherwise install it via helm and make changes for your provider - you need to expose the service using an external loadbalancer.
    - Create ExternalNames for your frontend services.
    - Apply the ingress to take care of DNS/Routing to services in different namespaces. 
- Jenkins
    - Create a multibranch pipeline with the repository details, and include the path to the JENKINSFILE.
    - Setup any other credentials that might be needed (eg: Artifactory/Dockerhub/ECR etc)
    - Wait for the branches to be registered post-scan, and trigger a build on the required branch.
## To-Do

- [x] Pre and Post Deployment Checks
- [ ] Docker-compose file with mounts for easy local development (supports hot reloads)
- [ ] Include Dynamic Sonarqube runs/Quality Gate checks
- [ ] Impliment a SAST tool to scan Static code
- [ ] Use a SCA tool to scan OSS dependencies
- [ ] Include Image scanning for vulnerabilities
- [ ] Impliment a DAST tool to run on the deployed Front-end.
