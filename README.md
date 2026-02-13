# 🏢 AWS Multi-Account Enterprise Architecture with Terraform

---

## 📌 Sobre o Projeto

Este projeto implementa uma arquitetura multi-account na AWS simulando um ambiente corporativo real, com foco em:

- Governança
- Segurança
- Isolamento de ambientes
- Controle centralizado
- Padronização via Infrastructure as Code

A estrutura utiliza AWS Organizations e Terraform para provisionamento automatizado e controle de políticas.

---

# 🏗️ Arquitetura Organizacional

## Estrutura de Contas

```
Root
│
├── Security Account
├── Shared Services Account
├── Production Account
├── Staging Account
└── Development Account
```

---

## 📂 Descrição das Contas

### 🔐 Security Account
Responsável por:

- AWS CloudTrail centralizado
- AWS Config
- GuardDuty
- Logs agregados
- Auditoria

---

### 🧩 Shared Services Account
Responsável por:

- CI/CD pipelines
- Artifact repositories
- Container registry (ECR)
- Monitoring centralizado
- IAM Identity Center (SSO)

---

### 🚀 Production Account
- Aplicações críticas
- EKS cluster
- RDS
- Recursos altamente restritos

---

### 🧪 Staging Account
- Ambiente pré-produção
- Testes integrados

---

### 👨‍💻 Development Account
- Ambiente de desenvolvimento
- Acesso mais flexível
- Workloads não críticos

---

# 🌐 Arquitetura de Rede

## Componentes

- VPC por conta
- Subnets públicas e privadas
- Transit Gateway
- VPC Peering (se necessário)
- Network segmentation

Comunicação controlada entre contas via:

- Transit Gateway
- Security Groups
- NACLs

---

# 🔐 Governança e Segurança

## AWS Organizations

- Criação automática de contas via Terraform
- Service Control Policies (SCP)
- Restrição de serviços por ambiente

Exemplo:

- Dev não pode criar recursos fora de região definida
- Produção não permite instâncias sem tag obrigatória

---

## Centralização de Logs

- CloudTrail multi-account
- Logs enviados para Security Account
- S3 com retenção e versionamento
- Monitoramento com CloudWatch

---

# ⚙️ Provisionamento com Terraform

## Estrutura do Repositório

```
terraform-aws-enterprise/
│
├── organizations/
│   ├── accounts.tf
│   ├── scp.tf
│
├── networking/
│   ├── transit-gateway.tf
│   ├── vpc.tf
│
├── security/
│   ├── cloudtrail.tf
│   ├── config.tf
│
├── environments/
│   ├── dev/
│   ├── staging/
│   ├── prod/
│
└── backend/
    ├── s3.tf
    ├── dynamodb.tf
```

---

## Backend Remoto

- S3 para state remoto
- DynamoDB para lock
- Versionamento habilitado

---

# 📊 Benefícios da Arquitetura

✔ Isolamento de ambientes  
✔ Redução de risco operacional  
✔ Governança centralizada  
✔ Segurança reforçada  
✔ Escalabilidade organizacional  

---

# 📈 Métricas Avaliadas

- Separação de custos por conta
- Controle de acesso por ambiente
- Auditoria de ações administrativas
- Compliance via AWS Config

---

# 🧠 Decisões Técnicas

- Multi-account ao invés de multi-VPC única
- Separação de segurança em conta dedicada
- Uso de SCP para governança rígida
- Terraform para padronização
- Backend remoto para consistência de state

---

# 🔄 Evoluções Futuras

- Implementação de AWS Control Tower
- Implementação de Landing Zone automatizada
- Cross-account IAM roles
- Multi-region expansion
- CI/CD centralizado aplicando Terraform em todas as contas

---

# 📚 Aprendizados Aplicados

- AWS Organizations
- Governança corporativa
- Arquitetura enterprise
- Segurança multi-account
- Network segmentation avançada
- State management em Terraform

---

# 🎯 Foco do Projeto

Cloud Architect  
Cloud Engineer Sênior  
Platform Engineer  
DevSecOps  

---

> Este projeto demonstra implementação de arquitetura multi-account enterprise na AWS, aplicando princípios reais de governança, segurança e escalabilidade organizacional.
