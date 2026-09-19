# 📁 Organizador Inteligente de Arquivos — LEG3NDY Edition

> **Utilitário universal, seguro e reversível para organização automática de arquivos e pastas no Windows, com interface de terminal interativa inspirada no consagrado [MAS (Microsoft Activation Scripts)](https://github.com/massgrave/Microsoft-Activation-Scripts).**

---

## ✨ Destaques & Diferenciais

* ⚡ **Navegação Instantânea por Tecla Única**: Pressione `1`, `2`, `3`, `5` ou `0` e o comando executa no mesmo milissegundo, sem precisar apertar `Enter`.
* 🛡️ **Proteção Anti-Sobrescrita Garantida**: Nunca substitui arquivos existentes. Se houver conflito de nomes, renomeia automaticamente adicionando contador (ex: `relatorio (1).pdf`).
* 🧠 **Diagnóstico Inteligente de Subpastas**:
  * **Drivers & Softwares**: Pastas contendo instaladores, executáveis ou drivers (`.inf`, `.sys`, `.dll`, `setup.exe`) são marcadas como protegidas para evitar quebra.
  * **Projetos de Código**: Detecta instantaneamente projetos (`package.json`, `.git`, `Cargo.toml`) e ignora pastas pesadas como `node_modules` para nunca travar o terminal.
  * **Coleções Temáticas**: Pastas onde a maioria dos arquivos é do mesmo tipo (fotos do WhatsApp, vídeos, músicas) recebem a recomendação de mover a pasta inteira mantendo o contexto.
  * **Pastas Vazias**: Identifica diretórios com 0 arquivos para remoção limpa e segura.
* ⏪ **Histórico e Reversão (Undo Completo)**: Toda movimentação é registrada em um banco de auditoria oculto (`.organizador_historico.json`). Se você mudar de ideia, a opção `[5]` restaura tudo ao local original.
* 🎯 **Auto-Preservação Dinâmica**: O launcher `Organizador-LEG3NDY.cmd` detecta a si mesmo em tempo de execução. Mesmo que você o renomeie para qualquer outro nome, ele **nunca** será movido para dentro de subpastas.
* 🌐 **Universal**: Funciona em Downloads, Área de Trabalho, Pen drives, HDs externos ou qualquer pasta do seu computador.
* 📦 **Zero Dependências**: Feito em Python puro utilizando apenas a biblioteca padrão (`os`, `shutil`, `json`, `datetime`). Não precisa instalar nada via `pip`.

---

## 🖥️ Interface Interativa (Estilo MAS)

```text
==============================================================================
                  ORGANIZADOR INTELIGENTE DE ARQUIVOS
                            LEG3NDY Edition
==============================================================================
  Pasta Ativa:      C:\Users\Usuario\Downloads
  Arquivos Soltos:  119 arquivos soltos (3.36 GB)
  Subpastas:        13 diretórios existentes
------------------------------------------------------------------------------
  [1]  Simular Organização dos Arquivos Soltos (Ver lista sem mover)
  [2]  Organizar Arquivos Soltos Agora (Executar movimentação)
------------------------------------------------------------------------------
  [3]  Diagnóstico Inteligente de Subpastas (Heurística de Software/Fotos)
  [4]  Gerenciar Subpastas Selecionadas (Mover pasta inteira / Limpar)
------------------------------------------------------------------------------
  [5]  Desfazer Última Organização (Undo / Rollback)
  [6]  Alterar Pasta de Trabalho
------------------------------------------------------------------------------
  [0]  Sair
==============================================================================
  Escolha uma opção:
```

---

## 🚀 Como Usar

### Opção 1: Via Duplo Clique (Recomendado)
1. Baixe ou clone este repositório.
2. Dê duplo clique no arquivo **`Organizador-LEG3NDY.cmd`**.
3. Escolha a opção desejada pelo teclado.

> 💡 **Dica de Portabilidade:** Você pode copiar o arquivo `Organizador-LEG3NDY.cmd` para **qualquer pasta** do seu computador (ex: Área de Trabalho, HD externo, Pen drive). Ao abri-lo lá, ele automaticamente reconhece aquela pasta como a pasta ativa!

### Opção 2: Pelo Terminal / Linha de Comando
Você também pode chamar o script Python diretamente, passando opcionalmente o caminho da pasta como argumento:

```bash
# Executa na pasta padrão (ou pasta atual)
python organizador.py

# Ou especifica diretamente a pasta que deseja organizar
python organizador.py "D:\MinhasFotos"
```

---

## 📁 Categorias Pré-configuradas

| Categoria | Pasta de Destino | Extensões Suportadas |
| :--- | :--- | :--- |
| 🖼️ **Imagens** | `Imagens/` | `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`, `.svg`, `.ico`, `.bmp`, `.tiff`, `.heic`, `.psd`, `.ai`, `.raw` |
| 📄 **Documentos** | `Documentos/` | `.pdf`, `.docx`, `.doc`, `.xlsx`, `.xls`, `.pptx`, `.ppt`, `.txt`, `.md`, `.csv`, `.epub`, `.odt`, `.rtf` |
| ⚙️ **Instaladores** | `Instaladores/` | `.exe`, `.msi`, `.iso`, `.dmg`, `.pkg`, `.deb`, `.rpm` |
| 📦 **Compactados** | `Compactados/` | `.zip`, `.rar`, `.7z`, `.tar`, `.gz`, `.bz2`, `.xz`, `.tgz` |
| 🎬 **Vídeos** | `Vídeos/` | `.mp4`, `.mkv`, `.avi`, `.mov`, `.wmv`, `.webm`, `.flv`, `.m4v` |
| 🎵 **Áudio** | `Áudio/` | `.mp3`, `.wav`, `.ogg`, `.flac`, `.aac`, `.m4a`, `.wma`, `.opus` |
| 💻 **Código e Dev** | `Código e Dev/` | `.json`, `.py`, `.js`, `.ts`, `.html`, `.css`, `.sql`, `.pem`, `.key`, `.yaml`, `.yml`, `.sh`, `.bat`, `.cmd`, `.xml`, `.cpp`, `.c`, `.java`, `.rs`, `.go` |
| 📁 **Outros** | `Outros/` | `.mcworld`, `.torrent` e demais formatos não mapeados |

---

## ⚙️ Customização Fácil (`config.json`)

Se você desejar adicionar novas extensões ou alterar nomes de pastas, basta editar o arquivo **`config.json`** na pasta do projeto:

```json
{
  "categorias": {
    "Documentos": {
      "pasta": "Documentos",
      "exts": [".pdf", ".docx", ".epub", ".mobi"]
    }
  }
}
```

O organizador carrega essas configurações automaticamente na inicialização sem que você precise alterar o código fonte!

---

## 📂 Estrutura do Repositório

```text
organizador-arquivos/
├── Organizador-LEG3NDY.cmd    # Launcher executável no Windows (Estilo MAS)
├── organizador.py             # Motor autônomo completo em Python
├── config.json                # Configuração personalizável de extensões
├── .gitignore                 # Arquivos ignorados pelo Git
└── README.md                  # Documentação oficial
```

---

## 📜 Licença

Distribuído sob a licença **MIT**. Sinta-se livre para usar, modificar e distribuir. Criado com orgulho pela **LEG3NDY Tech**.
