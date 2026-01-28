# FGA - Formação de Grupos Avançada

O **FGA** é um utilitário de gestão de grupos e raids desenvolvido especificamente para o **Turtle WoW (Client 1.12.1)**. Ele automatiza convites, ciclos de reconvite (Refresh) e verificações de prontidão com uma interface visual simples e intuitiva.

## 🚀 Como Abrir

Para mostrar ou esconder a central de comando, utiliza um dos seguintes comandos no chat:

`/fga`  ou  `/apf`

---

## 🛠️ Funcionalidades do Painel

### 1. Lista de Alvos (EditBox & Painel Lateral)

No topo da janela, existe uma caixa de texto onde podes inserir os nomes dos jogadores.

* **Formato:** Aceita nomes separados por espaços, vírgulas ou ponto e vírgula.
* **Painel Lateral:** À direita, verás uma lista formatada em tempo real que mostra quem são os "alvos" atuais e a contagem total de jogadores.

### 2. Botão: Capturar

Lê instantaneamente todos os membros da tua **Party** ou **Raid** atual.

* Os nomes são inseridos automaticamente na caixa de texto.
* O addon ignora o teu próprio nome para evitar erros de convite.

### 3. Botão: Limpar

Esvazia a lista de nomes e limpa o painel lateral de uma só vez.

### 4. Botão: Formar Grupo

Inicia o processo de convite em massa baseado na lista de nomes.

* **Auto-Raid:** Se a lista contiver mais de 5 nomes, o addon converte o grupo para Raid automaticamente.

### 5. Botão: Refresh Estratégico (53s)

Esta é a funcionalidade avançada para líderes de raid. Ao clicar, o addon executa um ciclo automatizado:

* **Início:** Tu sais do grupo atual imediatamente.
* **45 Segundos:** Um som de *Ready Check* (Ding) avisa-te que o ciclo está quase a terminar.
* **47 Segundos:** Os convites são enviados e o addon grita no chat (`/yell`) "Reconvidando em: 6...".
* **Contagem:** O addon faz uma contagem decrescente no chat de 5 até 1.
* **53 Segundos:** O teu personagem grita "AVANTE!" e executa o emote `/charge`.

### 6. Botão: Ready Check (Train Edition)

Uma forma divertida e visual de saber quem está pronto.

* O addon pede ao grupo para usar o comando `/train`.
* Sempre que um membro do grupo fizer o som do comboio, aparecerá uma confirmação verde **[OK]** no teu chat privado.

---

## 📂 Instalação Técnica

Para que o addon funcione corretamente no Turtle WoW, a estrutura de pastas deve ser:

1. Caminho: `World of Warcraft/Interface/AddOns/FGA/`
2. Ficheiros necessários:
* `FGA.toc` (Contém a linha `## SavedVariables: FGA_Config`)
* `FGA.lua` (O código fonte do programa)



> [!IMPORTANT]
> Se a janela não aparecer, certifica-te de que ativaste a opção **"Load out of date AddOns"** no menu de AddOns na seleção de personagens.

---

## 💾 Memória de Posição

O FGA lembra-se de onde o deixaste. Podes arrastar a janela para qualquer canto do ecrã e, após um `/reload` ou *Logout*, ela aparecerá exatamente no mesmo sítio. Para fechar, basta clicar no **X** vermelho no canto superior.

---

**Comandante Bannion**, o manual está pronto para os teus oficiais! Precisas que eu adicione uma secção de "Resolução de Problemas" ou queres que eu crie um ícone pequeno que fique sempre no ecrã para abrir o painel sem precisar de digitar o comando?
