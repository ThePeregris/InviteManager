# 📜 Changelog - Addon Grupinho

v11.0: Correção de API (UninviteByName), reorganização tática da UI, padronização de botões (170x30) e inclusão da assinatura de autor.

v10.0: Implementação do Slider dinâmico (30-55s) e Checkbutton de Grito.

v9.0: Renomeação para "Grupinho" e comando /grupinho.

v1.0 - v8.0: Evolução de macros básicas para interface visual com memória de posição e rastreio de prontidão.

## 📜 Details

### Versão 1.0 - O Nascimento (Fase de Macros)

* **Funcionalidade:** Implementação básica de comandos de chat (`/gm`).
* **Comandos:** Funções para convite, refresh de 47 segundos e ready check via texto.
* **Arquitetura:** Script puramente lógico sem interface visual.

### Versão 2.0 - Interface Visual (GUI)

* **Funcionalidade:** Criação da primeira janela arrastável.
* **Inovação:** Substituição de nomes "hardcoded" no código por uma **EditBox** (caixa de texto) dinâmica.
* **Didática:** Introdução de templates de botões padrão do WoW.

### Versão 3.0 - Protocolo de Emotes

* **Funcionalidade:** Customização do Ready Check.
* **Ação:** O addon passou a detetar o emote `/train` como sinal de confirmação.
* **Técnico:** Implementação do evento `CHAT_MSG_TEXT_EMOTE`.

### Versão 4.0 - Gestão de Inteligência

* **Botão Capturar:** Adicionada a lógica para ler automaticamente os membros da Party/Raid atual.
* **Botão Limpar:** Atalho para resetar a lista de nomes rapidamente.
* **Filtro:** Implementação de proteção para o addon não convidar o próprio líder.

### Versão 5.0 - Alerta de Batalha

* **Sonoro:** Adição do som "ReadyCheck" (Ding) aos 45 segundos do cronómetro.
* **Visual:** Implementação do emote `/charge` para sinalizar o fim do refresh.

### Versão 6.0 - O Comandante (Contagem Regressiva)

* **Grito de Guerra:** Adição da contagem regressiva via `/yell` do segundo 47 ao 53.
* **Sincronização:** Lógica de passos (`steps`) para evitar spam de mensagens no mesmo segundo.

### Versão 7.0 - Otimização de Engine (Fix 1.12.1)

* **Correção:** Substituição do método `SetSize` (inexistente em 1.12.1) por `SetWidth` e `SetHeight`.
* **Renomeação:** Mudança temporária dos comandos para `/fga` e `/apf` para evitar conflitos de sistema.

### Versão 8.0 - Memória e Painel Lateral

* **Persistência:** Implementação de `SavedVariables` no ficheiro `.toc` para guardar a posição da janela após logout.
* **Rastreio Visual:** Criação do **Painel Lateral** para listar nomes em tempo real.
* **Status Dinâmico:** Nomes passam de Vermelho para Verde [OK] ao confirmarem prontidão.

### Versão 9.0 - Branding: Addon Grupinho

* **Identidade:** Renomeação oficial para **Grupinho** e comando definitivo `/grupinho`.
* **UX:** Adição de botão de fechar (X) e inicialização automática visível.
* **Instruções:** Inclusão de um guia rápido de utilização dentro da própria interface.

### Versão 10.0 (Final) - Protocolo de Guerra (ThePeregris Edition)

* **Ajuste Dinâmico:** Implementação do **Slider** para regular o tempo de reconvite (30s a 55s).
* **Sigilo Tático:** Adição do Checkbutton **Contagem Gritada** para alternar entre `/yell` e chat privado de Raid/Grupo.
* **Poder de RESET:** Novo botão para expulsão em massa e reset total de cronómetros.
* **Simetria:** Padronização de todos os botões para 170x30.

---

### **Versão 11.0 - Protocolo ThePeregris (Ajustes Finais & Estabilidade)**

* **Correção Crítica de API:** Substituição da função global `UninviteUnit` por **`UninviteByName`**, eliminando o erro de *nil value* no botão **RESET** e garantindo a compatibilidade com o motor do WoW de 2006.
* **Reorganização Tática da UI:** Reestruturação completa do layout para seguir o fluxo lógico de comando:
1. **Input/Gestão:** Campo de nomes e botões de limpeza no topo.
2. **Formação:** Botão de convite imediato.
3. **Verificação:** Sistema de Ready Check visual.
4. **Execução:** Início do protocolo de reconvite.
5. **Ajuste:** Slider de temporizador centralizado.
6. **Finalização:** Botão "READY!", Checkbox de silêncio e RESET na base.

---