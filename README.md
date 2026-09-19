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

O Organizador LEG3NDY conta com mapeamento exaustivo para mais de 150 extensões comuns, organizando seus arquivos em destinos específicos sem poluição (pastas vazias **nunca** são criadas se não houver arquivos correspondentes):

| Categoria | Pasta de Destino | Extensões Suportadas |
| :--- | :--- | :--- |
| 🖼️ **Imagens** | `Imagens/` | `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`, `.svg`, `.ico`, `.bmp`, `.tiff`, `.tif`, `.heic`, `.heif`, `.raw`, `.cr2`, `.nef`, `.arw` |
| 🎬 **Vídeos** | `Vídeos/` | `.mp4`, `.mkv`, `.avi`, `.mov`, `.wmv`, `.webm`, `.flv`, `.m4v`, `.mpg`, `.mpeg`, `.3gp`, `.m2ts` |
| 🎵 **Áudio** | `Áudio/` | `.mp3`, `.wav`, `.ogg`, `.flac`, `.aac`, `.m4a`, `.wma`, `.opus`, `.aiff`, `.alac`, `.mid`, `.midi` |
| 📄 **Documentos** | `Documentos/` | `.pdf`, `.docx`, `.doc`, `.txt`, `.md`, `.rtf`, `.odt`, `.pages`, `.tex` |
| 📊 **Planilhas** | `Planilhas/` | `.xlsx`, `.xls`, `.csv`, `.tsv`, `.ods`, `.numbers`, `.xlsm`, `.xlsb` |
| 📽️ **Apresentações** | `Apresentações/` | `.pptx`, `.ppt`, `.pps`, `.ppsx`, `.odp`, `.potx` |
| 📚 **Livros e E-books** | `Livros_e_Ebooks/` | `.epub`, `.mobi`, `.azw`, `.azw3`, `.cbr`, `.cbz`, `.djvu`, `.fb2`, `.ibooks` |
| 🎨 **Design e 3D** | `Design_e_3D/` | `.psd`, `.ai`, `.eps`, `.xd`, `.fig`, `.sketch`, `.blend`, `.obj`, `.fbx`, `.stl`, `.step`, `.stp`, `.dwg`, `.dxf`, `.dae`, `.ply`, `.max`, `.c4d` |
| 🔤 **Fontes** | `Fontes/` | `.ttf`, `.otf`, `.woff`, `.woff2`, `.eot`, `.fon` |
| 🎛️ **Presets e Projetos** | `Presets_e_Projetos/` | `.cube`, `.xmp`, `.lrtemplate`, `.aep`, `.prproj`, `.drp`, `.flp`, `.als`, `.cpr`, `.fst`, `.sf2`, `.ffx` |
| ⚙️ **Instaladores** | `Instaladores/` | `.exe`, `.msi`, `.dmg`, `.pkg`, `.deb`, `.rpm`, `.appimage` |
| 📱 **Mobile e APKs** | `Mobile_e_APKs/` | `.apk`, `.xapk`, `.apks`, `.ipa`, `.aab` |
| 💽 **Imagens de Disco** | `Imagens_Disco/` | `.iso`, `.img`, `.vhd`, `.vhdx`, `.vmdk`, `.vdi`, `.bin`, `.cue`, `.nrg`, `.mdf` |
| 📦 **Compactados** | `Compactados/` | `.zip`, `.rar`, `.7z`, `.tar`, `.gz`, `.bz2`, `.xz`, `.tgz`, `.zst`, `.lzma`, `.cab` |
| 💻 **Código e Dev** | `Código e Dev/` | `.json`, `.py`, `.js`, `.ts`, `.jsx`, `.tsx`, `.html`, `.htm`, `.css`, `.scss`, `.sass`, `.less`, `.yaml`, `.yml`, `.xml`, `.sh`, `.bash`, `.bat`, `.cmd`, `.ps1`, `.c`, `.cpp`, `.h`, `.hpp`, `.cs`, `.java`, `.rs`, `.go`, `.php`, `.rb`, `.swift`, `.kt`, `.lua`, `.vue`, `.dart` |
| 💾 **Backups e Bancos** | `Backups_e_Bancos/` | `.bak`, `.backup`, `.dump`, `.sql`, `.db`, `.sqlite`, `.sqlite3`, `.db3`, `.mdb`, `.accdb`, `.gho` |
| 🔐 **Chaves e Certificados** | `Chaves_e_Certificados/` | `.pem`, `.key`, `.cer`, `.crt`, `.pfx`, `.p12`, `.der`, `.csr`, `.pub` |
| 🎮 **Jogos e ROMs** | `Jogos_e_ROMs/` | `.rom`, `.nes`, `.sfc`, `.smc`, `.gba`, `.gbc`, `.nds`, `.n64`, `.nsp`, `.xci`, `.chd`, `.rvz`, `.cso`, `.pbp`, `.gcm`, `.cia`, `.3ds`, `.mcworld`, `.mcpack`, `.mctemplate`, `.pak`, `.vpk` |
| 🎬 **Legendas** | `Legendas/` | `.srt`, `.sub`, `.vtt`, `.ass`, `.ssa`, `.idx` |
| 🧲 **Torrents** | `Torrents/` | `.torrent` |
| 🌐 **Atalhos Web** | `Atalhos_Web/` | `.url`, `.webloc`, `.website` |
| 📁 **Outros** | `Outros/` | Demais formatos e extensões não mapeadas |

---

## 🏷️ Entendendo as Tags e Classificações de Subpastas

Ao utilizar o **Diagnóstico de Subpastas [3]** ou **Gerenciar Subpastas [4]**, o organizador analisa profundamente as pastas existentes para entender seu propósito antes de tomar qualquer decisão. Cada pasta recebe uma classificação com selo visual colorido:

| Tag / Badge | Significado | Exemplo Prático | Ação Recomendada pelo Sistema |
| :--- | :--- | :--- | :--- |
| `[PASTA DO ORGANIZADOR]` | Pastas padrão criadas e gerenciadas pelo próprio organizador. | `Imagens/`, `Documentos/`, `Instaladores/` | **Manter intacta.** Serve como destino oficial dos arquivos organizados. Caso esteja com 0 arquivos, o usuário pode removê-la se desejar. |
| `[COLEÇÃO TEMÁTICA]` | Pastas onde $\ge 75\%$ dos arquivos pertencem à mesma categoria. | `fotos_viagem_2024/` (40 fotos), `album_rock/` (12 MP3s), `faturas/` (15 PDFs) | **Mover a pasta inteira** para a categoria correspondente (ex: `Imagens/fotos_viagem_2024/`). Preserva o contexto e o agrupamento original sem espalhar os arquivos. |
| `[DRIVER / SOFTWARE]` | Pastas contendo programas portáteis, drivers descompactados ou projetos de código. | `DRV_Audio_Realtek/` (com `.inf`, `.sys`, `.dll`), `meu-app/` (com `package.json`, `.git`) | **Proteção Ativa (Não desmembrar).** Jamais desmembra os arquivos para não quebrar executáveis e drivers interdependentes. Permite mover a pasta inteira para `Instaladores/` ou mantê-la onde está. |
| `[PASTA VAZIA]` | Pastas que não contêm nenhum arquivo (0 itens e 0 B). | Diretórios residuais de downloads antigos ou zips excluídos. | **Limpeza Segura.** Permite excluir a pasta vazia diretamente pelo menu interativo com segurança. |
| `[MISTA]` | Pastas com múltiplos tipos de arquivos misturados sem predominância evidente. | Pasta `downloads_antigos/` com 2 vídeos, 3 zips e 4 documentos. | **Decisão Manual.** Permite ao usuário escolher entre mover a pasta inteira para a categoria mais próxima ou desmembrar os arquivos internos. |

### 🤔 O que é uma "Coleção Temática" e por que ela existe?

Imagine que você baixou uma pasta chamada `fotos_aniversario` com 50 fotos dentro, ou uma pasta `curso_python` com 20 apostilas em PDF:

* **O problema dos organizadores comuns:** Um script simplório pegaria os 50 arquivos de fotos e os jogaria soltos na pasta `Imagens/`, misturando-os com centenas de outras fotos e **destruindo a pasta temática** que você já tinha organizado e nomeado.
* **A solução inteligente do Organizador LEG3NDY:** O motor detecta que mais de 75% do conteúdo daquela pasta pertence à mesma categoria e a classifica como **`[COLEÇÃO TEMÁTICA]`**. Em vez de desmembrar e espalhar os arquivos, ele sugere **mover a pasta inteira** para dentro de `Imagens/fotos_aniversario/`. Assim, a raiz de seus Downloads fica perfeitamente limpa, enquanto a sua coleção temática permanece intacta, organizada e no lugar certo!

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
