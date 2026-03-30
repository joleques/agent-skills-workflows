# Log de Entrevista — Automação

**Data:** 2026-03-26
**Entrevistado:** Usuário

---

## Sessão 1

### Pergunta 1
**P:** Qual o título do produto/sistema?
**R:** Automação

### Pergunta 2
**P:** O que é esse produto em uma frase?
**R:** Produto responsável pela integração entre APIs, utilizando para isso triggers para inicialização e conectores tanto de busca para enriquecer o de-para quanto de saída para transformar o dado conforme a API do cliente.

### Pergunta 3
**P:** Quem são os usuários finais desse produto? São desenvolvedores? Equipes de operação? Clientes finais configurando integrações?
**R:** Equipes de operações configurando integrações, aqui na empresa chamamos de Time de Soluções, são eles que configuram as Automação para os clientes finais.

### Pergunta 4
**P:** Qual problema específico ele resolve?
**R:** Automação resolve alguns problemas entre eles a automatização de processos complexos dentro da plataforma que devem ser transparentes ao cliente, um exemplo são nos clientes de logística, quando o cliente cria um local de atendimento via API na plataforma, automaticamente é criada uma tarefa de entrega para aquele local de atendimento. Outro exemplo, quando essa tarefa é realizada em campo (entregue o produto), o Cliente necessita que esses dados sejam integrados as APIs dele. Ela também pode ser usada para montar fluxos de negócio encadeados uma vez que de acordo com o retorno da API do cliente, sucesso ou erro ela consegue disparar uma outra Automação.

### Pergunta 5
**P:** Existe algum produto similar ou referência de mercado?
**R:** O que mais se aproxima é o Zapier.

### Pergunta 6
**P:** Quando a Automação foi criada? E qual a fase atual? (MVP, produção estável, legado em evolução?)
**R:** MVP das Automações foi lançado em 2019, hoje eu diria que está em produção estável.

### Pergunta 7
**P:** A Automação é um módulo dentro de uma plataforma maior? Se sim, qual é essa plataforma?
**R:** Sim, dentro da plataforma umov.me.

### Pergunta 8
**P:** Os "clientes finais" que o Time de Soluções configura — são empresas externas que contratam a plataforma? Ou departamentos internos?
**R:** É um departamento interno.

### Pergunta 9
**P:** Quais são as entidades principais da Automação?
**R:** Eventos (onde consta as informações da trigger o momento que executou), Ação a entidade de agregação de Contexto (contexto que automação foi disparada), Condição (quais as condições para seguirmos a automação) autorização (regras de auth nas APIs do cliente), Configurações Avançadas (onde fazemos configurações que geralmente estão fora do escopo das Automação mas são necessárias para alguns processos), URL destino da integração, o mapa de campos onde o cliente configura o 'de' e com ele já configura a estratégia de montagem do 'de' que pode ser CONTEXT_FIELD (busca no contexto da Automação), SEARCH_CONNECTOR (busca em conector de busca) entre outros. Obs: Essa estrutura de dado é um dos pontos fortes da Automação pois praticamente todos os atributos podem ser configurados dessa forma, ou seja, são desse tipo. Assim o usuário consegue atribuir valor de forma muito dinâmica às Automações, quando digo todos atributos estou falando de todas entidades. Essas acho que são as principais.

### Pergunta 10
**P:** O que é um "trigger" exatamente? Quais tipos existem?
**R:** São os eventos disparados pela plataforma que acionam a Automação, existe também um webhook para disparo das Automações, a parte de agendamento/cron temos mas aí é outro produto chamando o webhook, chamamos isso de eventos Agendados.

### Pergunta 11
**P:** O que são os "conectores de busca" e "conectores de saída"? Qual a diferença entre eles? Existem outros tipos de conectores?
**R:** Conectores de busca: sempre que precisamos de um dado para realizar a transformação do dado (de-para) que está fora do contexto da Automação, é necessário configurar um conector de busca pois ele padroniza como o dado chega na Automação, assim podemos buscar dados em diversas APIs JSON, XML, GraphQL mas para automação o dado sempre chega de uma forma padronizada para ela trabalhar, ele é usado na primeira etapa onde estamos buscando os dados para iniciar a transformação. Conectores de saída é nome de negócio para os 'templates' é o de-para, é ele que usamos para transformar os dados descobertos na primeira etapa no formato da API do cliente.

### Pergunta 12
**P:** Sobre a entidade "Condição" — como funciona? O usuário define regras tipo "se campo X = valor Y, então prossiga"? Pode dar um exemplo concreto?
**R:** Sim, só que ele usa a estrutura padrão para validar isso, exemplo ele pode buscar uma informação na API do cliente exemplo os status do produto e usando o SEARCH_CONNECTOR validar se o produto tá como disponível.

### Pergunta 13
**P:** Qual o fluxo completo de execução de uma Automação? Do momento que o trigger dispara até a chamada na API do cliente — quais etapas acontecem na ordem?
**R:** trigger/evento (chamamos a trigger de evento) -> Etapa 1 é quando o Alfred captura o evento e valida se para esse evento existe uma ação a ser disparada, ele também é responsável pelo start do monitor de controle do ciclo de vida de uma Automação -> Etapa 2 é onde descobrimos o dado nessa parte analisamos tudo que foi configurado nas Automações para entender de onde as informações vem (CONTEXT_FIELD e SEARCH_CONNECTOR entre outros) com as informações na mão montamos o 'de' -> Etapa 3 é a parte de transformação do dado na Automação o usuário configurou o conector de saída (entityReference) com essa informação pegamos o template e aplicamos o 'de' da etapa anterior -> Etapa 4 com base em métricas coletadas em processos paralelos ao eixo principal é entendido se essa Automação que está rodando é um processo que API destino está classificada como lenta ou rápida, de acordo com essa classificação colocamos ela na fila destino -> Etapa 5 é onde executamos a entrega de fato da Automação. Todas essas etapas são monitoradas por aplicações que gerenciam os nossos processos de resiliência e monitoramento, o que detalhei acima é o fluxo principal das Automações o que chamamos de pipeline das Automações.

### Pergunta 14
**P:** Sobre o encadeamento — quando uma Automação dispara outra com base no retorno (sucesso/erro), como isso é configurado? É na mesma Automação ou é uma configuração separada?
**R:** Na parte de configurações avançadas de uma automação é possível configurar quais ações serão executadas quando der sucesso e quando der erro, ou seja é na mesma Automação.

### Pergunta 15
**P:** O que é o "Alfred"? É um serviço/aplicação? Um worker? Ele é parte do produto Automação ou é um sistema separado?
**R:** Automação é composta por diversos serviços, aproximadamente 16, e o Alfred é um deles é a porta de entrada das Automações, é por onde todos os eventos entram, ou por fila que ele consome ou pelo webhook disponibilizado por ele.

### Pergunta 16
**P:** Quais são os estados possíveis de uma execução de Automação?
**R:** Hoje quando inicializamos a Automação é START, depois ele passa para PROCESSING que é quando ela está sendo executada, se durante o processamento ela entrou em algum fluxo de reprocessamento (quando o dado não está pronto na base, ou algum erro reprocessável na API do cliente 408, 429, 502, 503, 504) ela passa para REPROCESSING e quando finaliza é o FINISH.

### Pergunta 17
**P:** Sobre a classificação "lenta/rápida" na Etapa 4 — como essa métrica é coletada? Quem classifica a API destino? É automático ou configurado manualmente?
**R:** Existe um outro serviço chamado de Sentinel que monitora tudo que passa pela Automação (ciclo de vida inclusive), quando a automação é entregue ao cliente então o tempo de resposta da API é analisado pelo Sentinel que faz uma média das últimas 20 entregas se não me engano e se for acima de 10s se não me engano ele classifica como lenta, para retornar a ser rápida ele é mais criterioso ele tem que ser abaixo de 10 por mais vezes. Mas isso é configurado com env no Sentinel não lembro de cabeça. Por que existe isso? Para automações muito lentas não atrapalharem quem está rápido.

### Pergunta 18
**P:** Dos ~16 serviços, quais são os principais além de Alfred e Sentinel? Pode listar os que lembrar com uma frase sobre o que cada um faz?
**R:** Analyzer o que descobre os dados, Bumblebee o que transforma o dado, Gerson o que distribui o dado conforme a Automação (Lenta, rápida, ou Circuit Breaker), Jaminho o que entrega o dado, Osiris o que reprocessa dados de acordo com as políticas de reprocessamento, Quiron o que controla o circuit breaker quando APIs dos clientes estão com problemas. Alfred, Analyzer, Bumblebee, Gerson, Jaminho é o pipeline principal também chamado de core das Automações. Já Sentinel, Quiron, Osiris são os serviços que cuidam de monitoramento e resiliência. E tem a parte de configuração que é feita pelo Automation Management responsável pela gestão das automações, o Connector API responsável pela gestão dos conectores de saída e o Zico que distribui informações dos conectores de saída entre os serviços que necessitam dessas informações (Management e Bumblebee).

### Pergunta 19
**P:** Sobre o reprocessamento — quando uma Automação entra em REPROCESSING, quantas tentativas são feitas? Existe um limite? O que acontece se esgotar as tentativas?
**R:** São realizadas 3 tentativas uma 1min, a segunda 5min depois e a terceira 15min depois se der erro em todas a Automação é marcada com erro, geramos uma DLQ para reprocessamento manual futuramente, e a partir desse momento ela fica com o ciclo de vida aberto pois não finalizamos a entrega então a cada 30min passa o reprocessamento automático e tenta reprocessar novamente durante 4 dias ou até API do cliente se restabelecer.

### Pergunta 20
**P:** Existem regras de negócio que impeçam a execução de uma Automação além da "Condição"?
**R:** Ação ou evento inativos.

### Pergunta 21
**P:** Qual a stack tecnológica? Linguagem(ns), framework(s), banco(s) de dados, cloud?
**R:** Golang, Java e NodeJS.

### Pergunta 22
**P:** Como os serviços se comunicam entre si? Qual broker de mensageria? Os serviços do pipeline se comunicam exclusivamente por fila ou tem HTTP entre eles também?
**R:** O pipeline se comunica via Redis Stream, alguns fluxos por SQS, outros por HTTP e gRPC.

### Pergunta 23
**P:** Onde roda? Como é o pipeline de CI/CD?
**R:** AWS com Kubernetes, o CI/CD é automatizado com Jenkins.

### Pergunta 24
**P:** Quais bancos de dados são usados? Cada serviço tem seu banco ou compartilham?
**R:** MongoDB. Cada serviço tem o seu.

### Pergunta 25
**P:** Dos 11 serviços que listou, consegue dizer qual linguagem cada um usa? Ou pelo menos a divisão geral?
**R:** N/I — Usuário não detalhou a distribuição por serviço, informou apenas as 3 linguagens: Golang, Java e NodeJS.

### Pergunta 26
**P:** Qual o papel do Redis além de Stream? Vocês usam Redis para cache, armazenamento temporário, locks?
**R:** Além do Stream usamos como cache e locks.

### Pergunta 27
**P:** Além do pipeline principal, existem funcionalidades "extras" na Automação? (dashboard, relatórios, API de consulta de status, painel de configuração?)
**R:** Temos API de reprocessamento manual, API para consulta de relatórios/report, dashboard de monitoramento no Kibana.

### Pergunta 28
**P:** Como o Time de Soluções configura as Automações? Existe uma UI/painel web? Ou é via API/JSON direto?
**R:** Via API/JSON direto.

### Pergunta 29
**P:** Existem processos batch ou agendados dentro da Automação em si? (além do reprocessamento do Osiris)
**R:** Não.

### Pergunta 30
**P:** Quais foram as decisões arquiteturais mais importantes? (ex: por que Redis Stream em vez de Kafka? Por que separar em tantos microsserviços?)
**R:** Redis Stream em detrimento ao Kafka foi por causa do custo e o Redis entregou exatamente o que precisávamos, a quantidade de microsserviços tem relação de como pensamos software, a aplicação está dividida em contextos delimitados de negócio (core, monitoramento, configuração) e dentro de cada contexto por responsabilidade única onde cada serviço é responsável por uma necessidade de negócio.

### Pergunta 31
**P:** Existem dívidas técnicas conhecidas? O que precisa ser melhorado/refatorado?
**R:** N/I — Usuário não soube responder de bate pronto.

### Pergunta 32
**P:** Existe um schema/modelo de dados documentado? Swagger das APIs (Automation Management, Connector API)?
**R:** Não tenho, mas poderia te passar o serviço para você analisar.

### Pergunta 33
**P:** O contexto da Automação (o "de") — é um JSON padronizado? Qual a estrutura geral dele?
**R:** O "de" pode ser olhado em fieldMappings do exemplo básico de configuração da automação: documentacao/automacao/contexto/exemplo-resumido.json. (Usuário forneceu arquivo de exemplo com a estrutura JSON contendo context, entityReference, entityReferenceId, url, action, fieldMappings com originStrategy.)

### Pergunta 34
**P:** Além do Kibana, usam alguma outra ferramenta de observabilidade?
**R:** Grafana, mas aí mais para o time técnico.

### Pergunta 35
**P:** Existem SLAs ou SLOs definidos para a Automação?
**R:** Não temos... mas trabalhamos com um número internamente 32s.

### Pergunta 36
**P:** No JSON, o campo context: "HISTORY" — quais são os valores possíveis de context?
**R:** HISTORY (para histórico), TASK (para tarefas), LOCAL (para local atendimento) e ANY (para qualquer, quando usa esse aí o SEARCH_CONNECTOR se faz necessário para buscar os dados)... contextos que não são ANY então a Automação consegue buscar usando CONTEXT_FIELD porque está dentro do contexto dela.

### Pergunta 37
**P:** O action: "PARTIAL_UPDATE" — quais actions existem?
**R:** INSERT, UPDATE além de PARTIAL_UPDATE. Se não passar nada o INSERT é o padrão.

### Pergunta 38
**P:** O originStrategy: "FIELD" — quais são TODOS os originStrategy possíveis?
**R:** FIELD não usamos mais, o que usamos basicamente é CONTEXT_FIELD, CONSTANT, SEARCH_CONNECTOR, OBJECT_LIST_FROM_FIELDS (para listas).

---

## Sessão 2 (Aprofundamento — Revisão 1)

### Pergunta 39
**P:** Qual a relação entre Evento e Ação? Um Evento pode ter múltiplas Ações? A Ação pertence a qual entidade mãe?
**R:** Um evento pode ter diversas ações, depois de a ação ser criada ela não tem entidade mãe.

### Pergunta 40
**P:** Quais tipos de autenticação a Automação suporta para APIs de clientes?
**R:** Basic, OAuth2, Bearer Token.

### Pergunta 41
**P:** Como o conector de busca é configurado? Existe uma API/CRUD? É gerida por qual serviço?
**R:** Sim, mas não pertence às Automações é um produto paralelo. Nas automações só dizemos o alias do conector e os filtros dele. (Usuário anexou imagem com exemplo de configuração mostrando searchConnector com identifier, filters usando originStrategy CONSTANT e CONTEXT_FIELD, connector_modifier e datasourceId.)

### Pergunta 42
**P:** Dos serviços listados, qual linguagem cada um usa?
**R:** Alfred (Java), Analyzer (Java), Bumblebee (NodeJS), Gerson (Golang), Jaminho (Java), Sentinel (Java), Quiron (Golang), Osiris (Golang), Automation Management (Java), Connector API (NodeJS), Zico (NodeJS).

### Pergunta 43
**P:** Quais critérios o Quiron usa para abrir o circuit breaker? O que acontece com Automações durante o circuit breaker aberto?
**R:** Ele tem uma política baseada em erros seguidos tomados da API do cliente (408, 429, 502, 503 e 504) quando atinge o limite de erros ele fica alguns minutos aberto e tudo que chega ele guarda em uma contenção, e x tempo é feito um check quando voltar ele pega tudo que está na contenção e entrega para o cliente de forma devagar para não derrubar o cliente novamente.

### Pergunta 44
**P:** Poderia mostrar um exemplo de template/conector de saída?
**R:** documentacao/automacao/contexto/exemplo-para.json (Usuário forneceu template Handlebars real com campos como alternativeIdentifier, taskType, serviceLocal, agent, team, datas, customFields, taskActivities, taskItems — usando helpers como format, formatDate, hasAny, pipeToArray, #each, #unless @last.)

### Pergunta 45
**P:** O motor de templates é Handlebars?
**R:** Sim.
