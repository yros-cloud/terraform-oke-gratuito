# terraform-oke-gratuito

O OKE (Oracle Kubernetes Engine) não é totalmente elegível ao Always Free, mas você pode usá-lo gratuitamente dentro dos limites do Always Free, desde que use:

✅ Componentes Always Free que permitem usar o OKE sem custo:
Recurso	Always Free	Limite
Control Plane do OKE	✅ Sim	1 cluster gratuito por tenancy
Compute (Nodes)	✅ Sim	Até 4 OCPUs e 24 GB RAM com VM.Standard.A1.Flex (ARM)
Load Balancer	✅ Sim	1 LB com até 10 Mbps
Block Volume (Storage)	✅ Sim	2 × 200 GB
Network + NAT Gateway	✅ Sim	Gratuitos até 10 TB egress/mês
Kubeconfig / API Access	✅ Sim	Incluído sem custo

❗️O que não é Always Free:
Nodes fora dos limites de Always Free (ex: mais de 4 OCPUs, uso de shapes x86 que não sejam E2.1.Micro)

Múltiplos clusters OKE

Storage adicional, beyond 400 GB

Mais de 1 Load Balancer

Egress > 10 TB/mês

💡 Como usar o OKE sem custos (Always Free)
✅ Criar 1 cluster OKE gerenciado

✅ Usar até 4 OCPUs com VM.Standard.A1.Flex para os worker nodes

Exemplo: 2 nodes com 2 OCPUs e 12 GB cada

✅ Usar apenas 1 Load Balancer (por exemplo, para Ingress)

✅ Armazenar volumes no limite de 2 × 200 GB

✅ Controlar o egress (tráfego de saída da rede) até 10 TB/mês

📌 Observação:
Você não paga pelo cluster em si, apenas pelo que está rodando (compute, storage, LB), e todos esses componentes têm versões Always Free.

🧠 Dica prática
Use o seguinte combo para um OKE gratuito:

VM.Standard.A1.Flex com 1 OCPU e 6 GB RAM por node

Até 2 nodes (para sobrar margem)

1 Load Balancer com NGINX Ingress

Volumes padrão de 50 GB

Evitar nodes x86 (E3/E4) que geram cobrança
