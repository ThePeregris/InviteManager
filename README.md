# 🛡️ Grupinho - Gestor de Grupo Avançado

O **Grupinho** é a ferramenta de gestão de raids para o **Turtle WoW (1.12.1)**. Desenhado para líderes que precisam de precisão cirúrgica no "recall" do grupo e organização visual de prontidão.  

---

## ⚡ Quickstart (Início Rápido)

1. **Abrir:** Digita `/grupinho` no chat.  
2. **Preparar:** Clica em **Capturar** para listar o teu grupo atual ou cola os nomes na caixa.
3. **Ajustar:** Desliza o **Slider** para definir o tempo de convite (ex: 45s).
4. **Executar:** Clica em **Refresh Estratégico** para refazer o grupo com contagem automática.
5. **Verificar:** Clica em **Pedir Ready Check** e observa quem fica **Verde** na lista lateral.

---

## 🚀 Comandos de Acesso

Para mostrar ou esconder a central de comando:  

`/grupinho`

---

## 🛠️ Explicação dos Botões e Controlos

### 🎚️ Configurações de Ambiente

* **Checkbutton [Usar Grito]:** * *Marcado:* A contagem regressiva será feita via `/yell` (público).
* *Desmarcado:* A contagem será enviada apenas para o chat da **Raid** ou **Grupo** (privado).


* **Slider de Tempo (30s - 55s):** * Define o momento exato do convite (). Toda a contagem sonora e de chat ajusta-se automaticamente a este valor.

### 📋 Gestão de Nomes

* **Capturar:** Copia os nomes de todos os membros da raid/party atual para a lista.
* **Limpar:** Apaga todos os nomes e reseta o status de prontidão.
* **Formar Grupo:** Envia convites imediatos para a lista e converte para Raid se houver mais de 5 pessoas.

### ⏳ O Ciclo de Refresh (Exemplo com 47s)

Ao clicar em **Refresh Estratégico**, o ciclo inicia:

1. **Saída:** Tu sais do grupo atual.
2. **T - 2s:** Som de *Ready Check* para te alertar.
3. **Tempo T:** Envio automático de convites + Grito "6".
4. **T + 1s a 5s:** Contagem regressiva visual no chat.
5. **T + 6s:** Grito final "AVANTE!" + Emote de investida.

### 🚂 Ready Check (Visual & Sonoro)

* **Pedir Ready Check:** Limpa os status e pede ao grupo para usar o comando `/train`.
* **Painel Lateral de Status:** * `[..] Nome` (Vermelho): Jogador ainda não confirmou.
* `[OK] Nome` (Verde): Jogador já fez o som do comboio.

* **Meu OK:** Faz o teu personagem executar o emote `/train` para confirmares a tua parte.

---

## 📂 Instalação Técnica

Para o funcionamento correto, a estrutura deve ser rigorosa:

1. **Pasta:** `World of Warcraft/Interface/AddOns/Grupinho/`
2. **Ficheiro `Grupinho.toc`:** * Deve conter a linha: `## SavedVariables: Grupinho_Config`
3. **Ficheiro `Grupinho.lua`:** * O código fonte revisado.

> [!CAUTION]
> **Atenção:** Se mudares o nome da pasta, deves mudar o nome dos ficheiros `.toc` e `.lua` para serem idênticos, caso contrário o WoW não carregará o addon.

---

## 💾 Persistência de Dados

O addon utiliza a memória do servidor para guardar:
* A posição exata da janela no teu ecrã.
* O tempo definido no Slider.
* A tua preferência de Grito (/y).

---