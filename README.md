# lore
Infrastructure &amp; Pipelines

This is how I would holistically investigate the current state, identify key bottlenecks,and define the strategic opportunities for automation across the data platform lifecycle.
<br>
1. Map out current infrastructure, including but not limited to:<br>
Network, Applications, Endpoints, Ports, Security, Dependencies, Current Deployment methods<br>
2. Talk with Developers and current infrastructure people to get a better understanding of how things are currently implemented<br>
3. Talk with supervisors and understand KPI's and other measurements for success<br>
4. Create a visual diagram and pass it to corresponding teams for review to see if anything is missed or incorrect.<br>
<br>
My proposal for future-state architecture principles for a unified CI/CD framework, detailing its conceptual design, key components (e.g., version control, CI servers, artifact repositories, deployment tools), and how it would support multi-cloud deployments and microservices. 
<br>
1. Create a diagram of proposed new infrastructure and interdependencies. and discuss with corresponding stakeholders.<br>
2. Port code over to Github if not already there.<br>
3. Setup dev enviromnment using terraform with public/private subnets, nat gateways, igw, eks cluster for each cloud provider. see attached sample for aws. <br>
4. Containerize applications using jenkins by building containers, pushing to JFROG artifactory, enable JFrog Xray SCA for vulernability scanning and deploying to eks cluster using blue/green deployment. see attached jenkins file to build and deploy to eks cluster<br>
5. setup private circuit between different cloud providers<br>
6. setup internal DNS servers to host internal name resolution so the outside world cannot see internal network structure<br>
7. use terraform vault to store secrets and endpoint urls.<br>
8. Setup promethus/grafana to aggregate stats for cluster and plan resources depending on load , latency measurements. <br>
9. Setup elastic search for log aggregation and create logins for developers<br>
<br>
<br>
This is a high-level phased approach for implementing and rolling out this framework across different data teams.
<br>
Inside EKS cluster create namespaces for each data team. after containerization and deploying to each data teams namespace they can test to make sure everything is correct.<br>
Then we can deploy to qa for qa dept to test. after that staging for a final review and then production<br>
<br>
live
├── aws
│   ├── terragrunt.hcl          # ← AWS‑only root (backend + aws provider)
│   └── {dev,qa,staging,prod}
│       ├── envcommon.hcl
│       ├── networking/terragrunt.hcl
│       └── eks/terragrunt.hcl
└── gcp
    ├── terragrunt.hcl          # ← GCP‑only root (backend + google provider)
    └── {dev,qa,staging,prod}
        ├── envcommon.hcl
        ├── networking/terragrunt.hcl
        └── gke/terragrunt.hcl
